USE jayson_tools;

DELIMITER $$

DROP PROCEDURE IF EXISTS `GetAuthLevel`$$
CREATE PROCEDURE GetAuthLevel (user_object_id INT, monarch_object_id INT)
BEGIN
	SELECT	IFNULL(GREATEST(p.auth_level, m.auth_level),0)
    FROM	player p
	JOIN	monarch m
			ON p.monarch_id = m.object_id
	WHERE	p.object_id = user_object_id
			AND m.object_id = monarch_object_id;
END$$

DELIMITER ;


