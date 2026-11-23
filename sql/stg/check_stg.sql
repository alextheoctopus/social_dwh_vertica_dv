
SELECT 'people' AS table_name, COUNT(*) AS row_count
FROM stg.people

UNION ALL

SELECT 'groups', COUNT(*)
FROM stg.groups

UNION ALL

SELECT 'chats', COUNT(*)
FROM stg.chats;
