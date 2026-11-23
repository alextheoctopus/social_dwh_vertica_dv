
-- Satellite: информация о пользователях

INSERT INTO dv.s_person_info (
    hk_person_id,
    load_date,
    name,
    registration_date,
    country,
    date_of_birthday,
    phone,
    email,
    hashdiff,
    source
)
SELECT
    p.hk_person_id,
    CURRENT_TIMESTAMP,
    p.name,
    p.registration_date,
    p.country,
    p.date_of_birthday,
    p.phone,
    p.email,
    p.hashdiff,
    'people.csv'
FROM (
         SELECT DISTINCT
             MD5(CAST(id AS VARCHAR(50))) AS hk_person_id,
             name,
             registration_date,
             country,
             date_of_birthday,
             phone,
             email,

             MD5(
                     COALESCE(name, '<NULL>') || '|' ||
                     COALESCE(CAST(registration_date AS VARCHAR(50)), '<NULL>') || '|' ||
                     COALESCE(country, '<NULL>') || '|' ||
                     COALESCE(CAST(date_of_birthday AS VARCHAR(20)), '<NULL>') || '|' ||
                     COALESCE(phone, '<NULL>') || '|' ||
                     COALESCE(email, '<NULL>')
             ) AS hashdiff

         FROM stg.people
         WHERE id IS NOT NULL
     ) p
         LEFT JOIN (
    SELECT hk_person_id, hashdiff
    FROM (
             SELECT
                 hk_person_id,
                 hashdiff,
                 ROW_NUMBER() OVER (
                PARTITION BY hk_person_id
                ORDER BY load_date DESC
            ) AS rn
             FROM dv.s_person_info
         ) previous_versions
    WHERE rn = 1
) latest
                   ON p.hk_person_id = latest.hk_person_id

WHERE latest.hk_person_id IS NULL
   OR latest.hashdiff <> p.hashdiff;


-- Satellite: информация о группах

INSERT INTO dv.s_group_info (
    hk_group_id,
    load_date,
    title,
    status,
    hashdiff,
    source
)
SELECT
    g.hk_group_id,
    CURRENT_TIMESTAMP,
    g.title,
    NULL,
    g.hashdiff,
    'groups.csv'
FROM (
         SELECT DISTINCT
             MD5(CAST(id AS VARCHAR(50))) AS hk_group_id,
             group_name AS title,

             MD5(
                     COALESCE(group_name, '<NULL>') || '|<NULL>'
             ) AS hashdiff

         FROM stg.groups
         WHERE id IS NOT NULL
     ) g
         LEFT JOIN (
    SELECT hk_group_id, hashdiff
    FROM (
             SELECT
                 hk_group_id,
                 hashdiff,
                 ROW_NUMBER() OVER (
                PARTITION BY hk_group_id
                ORDER BY load_date DESC
            ) AS rn
             FROM dv.s_group_info
         ) previous_versions
    WHERE rn = 1
) latest
                   ON g.hk_group_id = latest.hk_group_id

WHERE latest.hk_group_id IS NULL
   OR latest.hashdiff <> g.hashdiff;



-- Satellite: информация о сообщениях

INSERT INTO dv.s_chat_info (
    hk_msg_id,
    load_date,
    text_msg,
    msg_from,
    msg_to,
    status,
    hashdiff,
    source
)
SELECT
    c.hk_msg_id,
    CURRENT_TIMESTAMP,
    c.text_message,
    c.msg_from,
    c.msg_to,
    NULL,
    c.hashdiff,
    'chats.csv'
FROM (
         SELECT DISTINCT
             MD5(CAST(msg_id AS VARCHAR(50))) AS hk_msg_id,
             text_message,
             msg_from,
             msg_to,

             MD5(
                     COALESCE(text_message, '<NULL>') || '|' ||
                     COALESCE(CAST(msg_from AS VARCHAR(50)), '<NULL>') || '|' ||
                     COALESCE(CAST(msg_to AS VARCHAR(50)), '<NULL>') || '|<NULL>'
             ) AS hashdiff

         FROM stg.chats
         WHERE msg_id IS NOT NULL
     ) c
         LEFT JOIN (
    SELECT hk_msg_id, hashdiff
    FROM (
             SELECT
                 hk_msg_id,
                 hashdiff,
                 ROW_NUMBER() OVER (
                PARTITION BY hk_msg_id
                ORDER BY load_date DESC
            ) AS rn
             FROM dv.s_chat_info
         ) previous_versions
    WHERE rn = 1
) latest
                   ON c.hk_msg_id = latest.hk_msg_id

WHERE latest.hk_msg_id IS NULL
   OR latest.hashdiff <> c.hashdiff;

