USE zojak;

SET @DEBUG = TRUE;

DELIMITER $$

DROP PROCEDURE IF EXISTS `GetUniqueCounts`$$
CREATE PROCEDURE GetUniqueCounts (arg_server_name VARCHAR(255))
BEGIN

	SELECT 	COUNT(*) as fights,
		(SELECT COUNT(DISTINCT killer_id) FROM unique_kill) + (SELECT COUNT(DISTINCT victim_id) FROM unique_kill WHERE victim_id NOT IN (SELECT DISTINCT killer_id FROM unique_kill)) as characters
	FROM 	unique_kill
    WHERE 	server_name = arg_server_name;

END$$

DELIMITER ;