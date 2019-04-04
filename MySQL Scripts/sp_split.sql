USE postcount;

-- ----------------------------
--  Procedure structure for `sp_split`
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_split`;
delimiter ;;
CREATE PROCEDURE `sp_split`(IN toSplit text, IN splitChar varchar(255), IN target char(255))
BEGIN
	# Temp table variables
	SET @tableName = 'tmpSplit';
	SET @fieldName = 'variable';

	# Dropping table
	SET @sql := CONCAT('DROP TABLE IF EXISTS ', @tableName);
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	# Creating table
	SET @sql := CONCAT('CREATE TEMPORARY TABLE ', @tableName, ' (', @fieldName, ' VARCHAR(1000))');
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	# Preparing toSplit
	SET @vars := toSplit;
	SET @vars := CONCAT("('", REPLACE(REPLACE(@vars, "'", ""), splitChar, "'),('"), "')");

	# Inserting values
	SET @sql := CONCAT('INSERT INTO ', @tableName, ' VALUES ', @vars);
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	# Returning record set, or inserting into optional target
	IF target IS NULL THEN
		SET @sql := CONCAT('SELECT TRIM(`', @fieldName, '`) AS `', @fieldName, '` FROM ', @tableName);
	ELSE
		SET @sql := CONCAT('INSERT INTO ', target, ' SELECT TRIM(`', @fieldName, '`) FROM ', @tableName);
	END IF;

	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
		
END ;;
delimiter ;