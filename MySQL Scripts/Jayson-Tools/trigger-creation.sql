USE jayson_tools;

DELIMITER $$

DROP TRIGGER IF EXISTS `after_discord_bot_interaction_insert`$$
CREATE TRIGGER after_discord_bot_interaction_insert
	AFTER INSERT ON discord_bot_interaction    
	FOR EACH ROW
BEGIN
	SELECT  p.name, dbi.message
	FROM	player p
	JOIN	discord_bot_interaction dbi
		ON	p.object_id = dbi.player_object_id
	INTO 	OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/discord_bot_interaction.txt';
END$$

DELIMITER ;