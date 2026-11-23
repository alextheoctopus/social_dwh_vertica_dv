
-- 1. Satellite: характеристики пользователей

CREATE TABLE IF NOT EXISTS dv.s_person_info (
    hk_person_id VARCHAR(32) NOT NULL,
    load_date TIMESTAMP(6) NOT NULL,

    name VARCHAR(200),
    registration_date TIMESTAMP,
    country VARCHAR(100),
    date_of_birthday DATE,
    phone VARCHAR(30),
    email VARCHAR(255),

    hashdiff VARCHAR(32) NOT NULL,
    source VARCHAR(100) NOT NULL,

    CONSTRAINT pk_s_person_info
    PRIMARY KEY (hk_person_id, load_date) ENABLED
    );


-- 2. Satellite: характеристики групп

CREATE TABLE IF NOT EXISTS dv.s_group_info (
    hk_group_id VARCHAR(32) NOT NULL,
    load_date TIMESTAMP(6) NOT NULL,

    title VARCHAR(200),
    status VARCHAR(50),

    hashdiff VARCHAR(32) NOT NULL,
    source VARCHAR(100) NOT NULL,

    CONSTRAINT pk_s_group_info
    PRIMARY KEY (hk_group_id, load_date) ENABLED
    );


-- 3. Satellite: характеристики сообщений

CREATE TABLE IF NOT EXISTS dv.s_chat_info (
    hk_msg_id VARCHAR(32) NOT NULL,
    load_date TIMESTAMP(6) NOT NULL,

    text_msg VARCHAR(2000),
    msg_from INTEGER,
    msg_to INTEGER,
    status VARCHAR(50),

    hashdiff VARCHAR(32) NOT NULL,
    source VARCHAR(100) NOT NULL,

    CONSTRAINT pk_s_chat_info
    PRIMARY KEY (hk_msg_id, load_date) ENABLED
    );
