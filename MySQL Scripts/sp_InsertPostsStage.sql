USE postcount;

DELIMITER $$

DROP PROCEDURE IF EXISTS `InsertPostsStage`$$
CREATE PROCEDURE InsertPostsStage (username varchar(255), user_id int, message_text text, postdate datetime, thread_title varchar(255), thread_url varchar(1000), thread_id int, post_id int, insert_by varchar(255))
BEGIN	
	INSERT INTO post_stage (USERNAME, USER_ID, MESSAGE_TEXT, POSTDATE, THREAD_TITLE, THREAD_URL, THREAD_ID, POST_ID, INSERT_BY)
		SELECT USERNAME, USER_ID, Html_UnEncode(MESSAGE_TEXT), POSTDATE, THREAD_TITLE, THREAD_URL, THREAD_ID, POST_ID, INSERT_BY;
END$$

DELIMITER ;
