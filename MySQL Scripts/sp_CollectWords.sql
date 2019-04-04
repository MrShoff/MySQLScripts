USE postcount;

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_CollectWords`$$
CREATE PROCEDURE sp_CollectWords (IN user_username varchar(255), IN start_date datetime, IN end_date datetime)
BEGIN
	IF user_username IS NULL THEN
		SELECT  UPPER(HTML_UnEncode(MESSAGE_TEXT))
		FROM	post p
		WHERE	postdate >= start_date
				AND	postdate <= end_date
				AND IFNULL(MESSAGE_TEXT,'') != ''
		ORDER BY postdate DESC;
    ELSE
		SELECT  UPPER(HTML_UnEncode(MESSAGE_TEXT))
		FROM	post p
		JOIN	user u 
				ON p.user_id = u.user_id
		WHERE	username = user_username
				AND postdate >= start_date
				AND	postdate <= end_date
				AND IFNULL(MESSAGE_TEXT,'') != ''
		ORDER BY postdate DESC;
    END IF;
END$$

DELIMITER ;