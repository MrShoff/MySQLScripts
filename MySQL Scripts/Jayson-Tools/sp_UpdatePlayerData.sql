USE jayson_tools;

DELIMITER $$

DROP PROCEDURE IF EXISTS `UpdatePlayerData`$$
CREATE PROCEDURE UpdatePlayerData ()
BEGIN
	/* INSERT NEW RECORDS */
	INSERT IGNORE INTO player (object_id, monarch_id, name, creature_level, server_name, last_known_coords, last_updated_date, last_updated_by, landblock_dec, primary_recall, secondary_recall, jt_user)
    SELECT	object_id, monarch_id, name, (CASE WHEN creature_level = 0 THEN null ELSE creature_level END), server_name, last_known_coords, inserted_date, inserted_by, 
		(CASE WHEN landblock_dec = 0 THEN null ELSE landblock_dec END), 
		(CASE WHEN primary_recall = '' THEN null ELSE primary_recall END), 
        (CASE WHEN secondary_recall = '' THEN null ELSE secondary_recall END), jt_user
    FROM	player_stage;
    
    /* UPDATE CURRENT RECORDS */
    UPDATE	player p
    JOIN	player_stage s
		ON p.object_id = s.object_id
	JOIN	(SELECT object_id, MAX(inserted_date) AS max_insert_date FROM player_stage GROUP BY object_id) s2 
		ON s.object_id = s2.object_id 
        AND s.inserted_date = s2.max_insert_date
    SET		p.monarch_id = s.monarch_id,
			p.name = s.name,
            p.creature_level = (CASE WHEN IFNULL(s.creature_level,0) > IFNULL(p.creature_level,0) THEN s.creature_level ELSE p.creature_level END),
            p.last_known_coords = IFNULL(s.last_known_coords, p.last_known_coords),
            p.last_updated_date = s.inserted_date,
            p.last_updated_by = s.inserted_by,
            p.landblock_dec = IFNULL(s.landblock_dec, p.primary_recall),
            p.primary_recall = IFNULL(s.primary_recall, p.primary_recall),
            p.secondary_recall = IFNULL(s.secondary_recall, p.primary_recall),
            p.jt_user = (CASE WHEN p.jt_user = 1 THEN 1 ELSE s.jt_user END),
            s.record_processed = 1
	WHERE	s.inserted_date > p.last_updated_date;
    
    UPDATE	player p
    JOIN	player_stage s
		ON p.object_id = s.object_id
    SET		s.record_processed = 1
	WHERE	s.inserted_date <= p.last_updated_date;

	/* CLEAR STAGE TABLE */
    DELETE FROM player_stage WHERE record_processed = 1;
END$$

DELIMITER ;

/*
CREATE TABLE player
(
	object_id 			INT NOT NULL,
	monarch_id 			INT,
	name				VARCHAR(255),
	auth_level			INT DEFAULT 0,
	creature_level		INT,
	last_known_coords	VARCHAR(255),
    last_updated_date	DATETIME,
    last_updated_by		INT
);

CREATE TABLE player_stage
(
	id					INT AUTO_INCREMENT PRIMARY KEY,
	object_id 			INT NOT NULL,
	monarch_id 			INT,
	name				VARCHAR(255),
	creature_level		INT,
	last_known_coords	VARCHAR(255),
    inserted_by			INT NOT NULL,
    inserted_date		DATETIME
);
*/
