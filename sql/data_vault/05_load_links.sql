INSERT INTO dv.l_chat_owners (hk_l_owner_id,
                              hk_person_id,
                              hk_group_id,
                              source,
                              load_date)
SELECT DISTINCT MD5(
                        'owner|' || CAST(g.owner_id AS VARCHAR(50))
                            || '|group|' || CAST(g.id AS VARCHAR(50))
                ),
                MD5(CAST(g.owner_id AS VARCHAR(50))),
                MD5(CAST(g.id AS VARCHAR(50))),
                'groups.csv',
                CURRENT_TIMESTAMP
FROM stg.groups g
WHERE g.owner_id IS NOT NULL
  AND g.id IS NOT NULL
  AND NOT EXISTS (SELECT 1
                  FROM dv.l_chat_owners l
                  WHERE l.hk_l_owner_id = MD5(
                          'owner|' || CAST(g.owner_id AS VARCHAR(50))
                              || '|group|' || CAST(g.id AS VARCHAR(50))
                                          ));


INSERT INTO dv.l_person_chat (
    hk_l_person_chat,
    hk_person_id,
    hk_msg_id,
    source,
    load_date
)
SELECT DISTINCT
    MD5(
            'sender|' || CAST(c.msg_from AS VARCHAR(50))
                || '|msg|' || CAST(c.msg_id AS VARCHAR(50))
    ),
    MD5(CAST(c.msg_from AS VARCHAR(50))),
    MD5(CAST(c.msg_id AS VARCHAR(50))),
    'chats.csv',
    CURRENT_TIMESTAMP
FROM stg.chats c
WHERE c.msg_from IS NOT NULL
  AND c.msg_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
    FROM dv.l_person_chat l
    WHERE l.hk_l_person_chat = MD5(
            'sender|' || CAST(c.msg_from AS VARCHAR(50))
                || '|msg|' || CAST(c.msg_id AS VARCHAR(50))
                               )
);


INSERT INTO dv.l_groups (
    hk_l_group_id,
    hk_msg_id,
    hk_group_id,
    source,
    load_date
)
SELECT DISTINCT
    MD5(
            'msg|' || CAST(c.msg_id AS VARCHAR(50))
                || '|group|' || CAST(c.msg_group_id AS VARCHAR(50))
    ),
    MD5(CAST(c.msg_id AS VARCHAR(50))),
    MD5(CAST(c.msg_group_id AS VARCHAR(50))),
    'chats.csv',
    CURRENT_TIMESTAMP
FROM stg.chats c
WHERE c.msg_id IS NOT NULL
  AND c.msg_group_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
    FROM dv.l_groups l
    WHERE l.hk_l_group_id = MD5(
            'msg|' || CAST(c.msg_id AS VARCHAR(50))
                || '|group|' || CAST(c.msg_group_id AS VARCHAR(50))
                            )
);
