USE jayson_tools;

DELIMITER $$

DROP PROCEDURE IF EXISTS `GetDiscordMessages`$$
CREATE PROCEDURE GetDiscordMessages ()
BEGIN
	/* SELECT NEW RECORDS */
	SELECT     p.name, dbi.message, dbi.interaction_type
	FROM       player p 
	JOIN       discord_bot_interaction dbi 
	   ON p.object_id = dbi.player_object_id 
	WHERE      bot_received = 0 
	ORDER BY	dbi.timestamp;

	/* CLEAR RECEIVED MESSAGES */
    SET SQL_SAFE_UPDATES = 0;
    
    UPDATE		discord_bot_interaction
    SET			bot_received = 1
    WHERE		bot_received = 0;
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
