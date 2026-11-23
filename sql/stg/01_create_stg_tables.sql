-- Пользователи
CREATE TABLE IF NOT EXISTS stg.people (
    id INTEGER,
    name VARCHAR(200),
    registration_date TIMESTAMP,
    country VARCHAR(100),
    date_of_birthday DATE,
    phone VARCHAR(30),
    email VARCHAR(255)
    );
-- Группы
CREATE TABLE IF NOT EXISTS stg.groups (
    id INTEGER,
    owner_id INTEGER,
    group_name VARCHAR(200),
    created_date TIMESTAMP(6)
    );
-- Сообщения
CREATE TABLE IF NOT EXISTS stg.chats (
    msg_id INTEGER,
    msg_time VARCHAR(40),
    msg_from INTEGER,
    msg_to INTEGER,
    text_message VARCHAR(2000),
    msg_group_id INTEGER
    );