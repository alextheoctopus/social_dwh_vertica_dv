
SELECT 'h_people' AS table_name, COUNT(*) AS row_count
FROM dv.h_people

UNION ALL

SELECT 'h_groups', COUNT(*)
FROM dv.h_groups

UNION ALL

SELECT 'h_chats', COUNT(*)
FROM dv.h_chats;
