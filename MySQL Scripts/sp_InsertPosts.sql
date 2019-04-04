USE postcount;

DELIMITER $$

DROP PROCEDURE IF EXISTS `InsertPosts`$$
CREATE PROCEDURE InsertPosts ()
BEGIN
	SET @batch_size = 100000;
	SET @record_count = 0;
    SELECT COUNT(*) FROM post_stage INTO @record_count;
	WHILE (@record_count > 0) DO
		DROP TABLE IF EXISTS tmp_post_stage;
		
        SET @queryString = '
		CREATE TEMPORARY TABLE tmp_post_stage
		AS
		SELECT	*
		FROM	post_stage
		LIMIT	? ';
        PREPARE myQuery FROM @queryString;
        EXECUTE myQuery USING @batch_size;

		INSERT INTO post (USER_ID, MESSAGE_TEXT, POSTDATE, THREAD_TITLE, THREAD_URL, THREAD_ID, POST_ID, INSERT_BY)
			SELECT 	USER_ID, MESSAGE_TEXT, POSTDATE, THREAD_TITLE, THREAD_URL, THREAD_ID, POST_ID, INSERT_BY 
			FROM 	post_stage
			WHERE  	post_id NOT IN (SELECT post_id FROM post);
            
		INSERT IGNORE INTO user (user_id, username)
			SELECT	user_id,
					username
			FROM	post_stage
            WHERE	user_id NOT IN (SELECT user_id FROM user);
        
		DELETE	ps
		FROM	post p
		JOIN	post_stage ps
				ON ps.post_id = p.post_id;

		DELETE FROM tmp_post_stage;
        
		SELECT COUNT(*) FROM post_stage INTO @record_count;
    END WHILE;
END$$

DELIMITER ;
