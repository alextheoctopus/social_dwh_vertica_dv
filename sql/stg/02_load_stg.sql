-- 1. Загружаем пользователей
COPY stg.people
    FROM '/csv/clean/people.csv'
    DELIMITER ','
    ENCLOSED BY '"'
    SKIP 1
    ABORT ON ERROR;

-- 2. Загружаем группы
COPY stg.groups
    FROM '/csv/clean/groups.csv'
    DELIMITER ','
    ENCLOSED BY '"'
    SKIP 1
    ABORT ON ERROR;

-- 3. Загружаем сообщения
COPY stg.chats
    FROM '/csv/clean/chats.csv'
    DELIMITER ','
    ENCLOSED BY '"'
    SKIP 1
    ABORT ON ERROR;
