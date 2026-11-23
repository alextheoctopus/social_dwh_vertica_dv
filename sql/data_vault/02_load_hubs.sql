-- h_people собираем ID не только из stg.people, но и из stg.groups и stg.chats. ---э


-- Загрузка Hub: пользователи -
-- в groups.csv указаны владельцы групп,
-- а в chats.csv — отправители и получатели сообщений, которых нет в people.csv
INSERT INTO dv.h_people (
    hk_person_id,
    person_id,
    source,
    load_date
)
SELECT
    MD5(CAST(p.person_id AS VARCHAR(50))),
    p.person_id,
    p.source,
    CURRENT_TIMESTAMP
FROM (
         SELECT
             x.person_id,
             x.source,
             ROW_NUMBER() OVER (
            PARTITION BY x.person_id
            ORDER BY x.priority
        ) AS rn
         FROM (
                  SELECT id AS person_id,
                         'people.csv' AS source,
                         1 AS priority
                  FROM stg.people

                  UNION ALL

                  SELECT owner_id, 'groups.csv', 2
                  FROM stg.groups

                  UNION ALL

                  SELECT msg_from, 'chats.csv', 3
                  FROM stg.chats

                  UNION ALL

                  SELECT msg_to, 'chats.csv', 4
                  FROM stg.chats
              ) x
         WHERE x.person_id IS NOT NULL
     ) p
WHERE p.rn = 1
  AND NOT EXISTS (
    SELECT 1
    FROM dv.h_people h
    WHERE h.person_id = p.person_id
);



-- Загрузка Hub: группы - некоторые сообщения относятся к группам, которых нет в groups.csv
INSERT INTO dv.h_groups (
    hk_group_id,
    group_id,
    created_date,
    source,
    load_date
)
SELECT
    MD5(CAST(g.group_id AS VARCHAR(50))),
    g.group_id,
    g.created_date,
    g.source,
    CURRENT_TIMESTAMP
FROM (
         SELECT
             x.group_id,
             x.created_date,
             x.source,
             ROW_NUMBER() OVER (
            PARTITION BY x.group_id
            ORDER BY x.priority
        ) AS rn
         FROM (
                  SELECT
                      id AS group_id,
                      created_date,
                      'groups.csv' AS source,
                      1 AS priority
                  FROM stg.groups

                  UNION ALL

                  SELECT
                      msg_group_id,
                      CAST(NULL AS TIMESTAMP(6)),
                      'chats.csv',
                      2
                  FROM stg.chats
              ) x
         WHERE x.group_id IS NOT NULL
     ) g
WHERE g.rn = 1
  AND NOT EXISTS (
    SELECT 1
    FROM dv.h_groups h
    WHERE h.group_id = g.group_id
);


-- Загрузка Hub: сообщения -каждое сообщение имеет собственный msg_id в chats.csv
INSERT INTO dv.h_chats (
    hk_msg_id,
    msg_id,
    msg_time,
    source,
    load_date
)
SELECT
    MD5(CAST(c.msg_id AS VARCHAR(50))),
    c.msg_id,
    c.msg_time,
    'chats.csv',
    CURRENT_TIMESTAMP
FROM stg.chats c
WHERE c.msg_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
    FROM dv.h_chats h
    WHERE h.msg_id = c.msg_id
);

