-- 1. Staging: исходные данные из CSV
CREATE SCHEMA IF NOT EXISTS stg;

-- 2. Data Vault: Hubs, Links, Satellites
CREATE SCHEMA IF NOT EXISTS dv;

-- 3. Data Marts: аналитические витрины
CREATE SCHEMA IF NOT EXISTS dm;

-- 4. System: мониторинг ETL-процессов
CREATE SCHEMA IF NOT EXISTS sys;
