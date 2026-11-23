
#!/bin/bash

set -euo pipefail

DB_NAME="${VERTICA_DB_NAME:-social_dwh}"
DB_USER="${VERTICA_DB_USER:-dbadmin}"
DB_PASSWORD="${VERTICA_DB_PASSWORD:-vertica123}"
DATA_PATH="${VERTICA_DATA_PATH:-/data}"
CERT_DIR="/opt/vertica/config/https_certs"

# 1. Создаем системного пользователя Vertica
if ! id "$DB_USER" >/dev/null 2>&1; then
    groupadd -g 995 verticadba 2>/dev/null || true
    useradd -u 997 -g 995 -m -s /bin/bash "$DB_USER"
fi

# 2. Подготавливаем каталоги
mkdir -p "$DATA_PATH" /opt/vertica/log /vertica/tmp

chown -R 997:995 \
    "$DATA_PATH" \
    /opt/vertica/log \
    /opt/vertica/config \
    /vertica \
    "/home/$DB_USER"

run_as_admin() {
    su "$DB_USER" -s /bin/bash -c "$1"
}

# 3. Создаем сертификаты для служебного API
if [ ! -f "$CERT_DIR/rootca.pem" ]; then
    run_as_admin "cd '$CERT_DIR' && /opt/vertica/bin/gen_httpstls_json.sh"

    cp "$CERT_DIR/rootca_cert.pem" "$CERT_DIR/rootca.pem"
    cp "$CERT_DIR/nma_cert.pem" "$CERT_DIR/vertica_https.pem"
    cp "$CERT_DIR/nma_key.pem" "$CERT_DIR/vertica_https.key"
    cp "$CERT_DIR/${DB_USER}_cert.pem" "$CERT_DIR/${DB_USER}.pem"
    cp "$CERT_DIR/${DB_USER}_key.pem" "$CERT_DIR/${DB_USER}.key"

    chown -R 997:995 "$CERT_DIR"
fi

# 4. Запускаем Node Management Agent
rm -f /opt/vertica/config/node_management_agent.pid

run_as_admin "nohup /opt/vertica/bin/node_management_agent > /opt/vertica/log/nma.log 2>&1 < /dev/null & disown"

# Ожидаем готовности агента на порту 5554
for attempt in $(seq 1 60); do
    if (echo > /dev/tcp/127.0.0.1/5554) 2>/dev/null; then
        break
    fi
    sleep 1
done

if ! (echo > /dev/tcp/127.0.0.1/5554) 2>/dev/null; then
    cat /opt/vertica/log/nma.log
    exit 1
fi

NODE_IP=$(hostname -i | awk '{print $1}')

# 5. Создаем базу или запускаем существующую
if [ ! -d "$DATA_PATH/$DB_NAME" ]; then
    echo "Creating database: $DB_NAME"

    run_as_admin "/opt/vertica/bin/vcluster create_db \
        --db-name $DB_NAME \
        --hosts $NODE_IP \
        --catalog-path $DATA_PATH \
        --data-path $DATA_PATH \
        --password '$DB_PASSWORD' \
        --skip-package-install \
        --force-cleanup-on-failure \
        --config-param HttpServerConf=$CERT_DIR/httpstls.json"
else
    echo "Starting database: $DB_NAME"

    run_as_admin "/opt/vertica/bin/vcluster start_db \
        --db-name $DB_NAME \
        --hosts $NODE_IP \
        --password '$DB_PASSWORD'"
fi

echo "Vertica database $DB_NAME is ready"

# 6. Корректно останавливаем базу вместе с контейнером
stop_vertica() {
    run_as_admin "/opt/vertica/bin/vcluster stop_db \
        --db-name $DB_NAME \
        --password '$DB_PASSWORD'" || true
}

trap 'stop_vertica; exit 0' SIGTERM SIGINT

tail -f /opt/vertica/log/nma.log &
wait $!
