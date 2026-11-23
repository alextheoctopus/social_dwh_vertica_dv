
-- 1. Hub: пользователи
CREATE TABLE IF NOT EXISTS dv.h_people (
    hk_person_id VARCHAR(32) NOT NULL,
    person_id INTEGER NOT NULL,
    source VARCHAR(100) NOT NULL,
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_h_people
    PRIMARY KEY (hk_person_id) ENABLED
    );

-- 2. Hub: группы
CREATE TABLE IF NOT EXISTS dv.h_groups (
    hk_group_id VARCHAR(32) NOT NULL,
    group_id INTEGER NOT NULL,
    created_date TIMESTAMP(6),
    source VARCHAR(100) NOT NULL,
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_h_groups
    PRIMARY KEY (hk_group_id) ENABLED
    );

-- 3. Hub: сообщения
CREATE TABLE IF NOT EXISTS dv.h_chats (
    hk_msg_id VARCHAR(32) NOT NULL,
    msg_id INTEGER NOT NULL,
    msg_time VARCHAR(40),
    source VARCHAR(100) NOT NULL,
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_h_chats
    PRIMARY KEY (hk_msg_id) ENABLED
    );
