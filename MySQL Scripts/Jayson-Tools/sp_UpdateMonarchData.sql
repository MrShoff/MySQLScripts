USE jayson_tools;

DELIMITER $$

DROP PROCEDURE IF EXISTS `UpdateMonarchData`$$
CREATE PROCEDURE UpdateMonarchData ()
BEGIN
	SET SQL_SAFE_UPDATES = 0;
    
	/* INSERT NEW RECORDS */
	INSERT IGNORE INTO monarch (object_id, name, last_updated_date, last_updated_by)
    SELECT	object_id, name, inserted_date, inserted_by
    FROM	monarch_stage;
    
    /* UPDATE CURRENT RECORDS */
    UPDATE	monarch m
    JOIN	monarch_stage s 
		ON m.object_id = s.object_id
    JOIN	(SELECT object_id, MAX(inserted_date) AS max_insert_date FROM monarch_stage GROUP BY object_id) s2 
		ON s.object_id = s2.object_id 
        AND s.inserted_date = s2.max_insert_date
    SET		m.name = IFNULL(s.name, m.name),
            m.last_updated_date = s.inserted_date,
            m.last_updated_by = s.inserted_by,
            s.record_processed = 1
	WHERE	s.inserted_date > m.last_updated_date
			AND m.object_id = s.object_id;
            
	UPDATE	monarch p
    JOIN	monarch_stage s
		ON p.object_id = s.object_id
    SET		s.record_processed = 1
	WHERE	s.inserted_date <= p.last_updated_date;

	/* CLEAR STAGE TABLE */
    DELETE FROM monarch_stage WHERE record_processed = 1;
END$$

DELIMITER ;

/*
CREATE TABLE monarch
(
	object_id			INT PRIMARY KEY,
	name				VARCHAR(255),
	auth_level			INT DEFAULT 0,
    last_updated_date	DATETIME,
    last_updated_by		INT    
);

CREATE TABLE monarch_stage
(
	id					INT AUTO_INCREMENT PRIMARY KEY,
	object_id			INT NOT NULL,
	name				VARCHAR(255),
    inserted_by			INT NOT NULL,
    inserted_date		DATETIME
);
*/

