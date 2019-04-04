USE whatsapp;

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_CollectWords`$$
CREATE PROCEDURE sp_CollectWords (IN userUsername VARCHAR(255), IN startDate DATETIME, IN endDate DATETIME, IN groupName VARCHAR(255))
BEGIN
	IF userUsername IS NULL THEN
		SELECT  UPPER(text)
		FROM	message
		WHERE	timestamp >= startDate
				AND	timestamp <= endDate
                AND group_name = groupName
				AND IFNULL(text,'') != ''
		ORDER BY timestamp DESC;
    ELSE
		SELECT  UPPER(text)
		FROM	message 
		WHERE	user = userUsername
				AND timestamp >= startDate
				AND	timestamp <= endDate
                AND group_name = groupName
				AND IFNULL(text,'') != ''
		ORDER BY timestamp DESC;
    END IF;
END$$

DELIMITER ;