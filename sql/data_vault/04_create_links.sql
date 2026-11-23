
-- 1. Связь владельца и группы
CREATE TABLE IF NOT EXISTS dv.l_chat_owners (
    hk_l_owner_id VARCHAR(32) NOT NULL,
    hk_person_id VARCHAR(32) NOT NULL,
    hk_group_id VARCHAR(32) NOT NULL,
    source VARCHAR(100) NOT NULL,
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_l_chat_owners
    PRIMARY KEY (hk_l_owner_id) ENABLED
    );

-- 2. Связь пользователя и сообщения
CREATE TABLE IF NOT EXISTS dv.l_person_chat (
    hk_l_person_chat VARCHAR(32) NOT NULL,
    hk_person_id VARCHAR(32) NOT NULL,
    hk_msg_id VARCHAR(32) NOT NULL,
    source VARCHAR(100) NOT NULL,
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_l_person_chat
    PRIMARY KEY (hk_l_person_chat) ENABLED
    );

-- 3. Связь сообщения и группы
CREATE TABLE IF NOT EXISTS dv.l_groups (
    hk_l_group_id VARCHAR(32) NOT NULL,
    hk_msg_id VARCHAR(32) NOT NULL,
    hk_group_id VARCHAR(32) NOT NULL,
    source VARCHAR(100) NOT NULL,
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_l_groups
    PRIMARY KEY (hk_l_group_id) ENABLED
    );
