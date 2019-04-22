USE zojak;

SET @DEBUG = TRUE;

DELIMITER $$

DROP PROCEDURE IF EXISTS `UpdatePlayerRatings`$$
CREATE PROCEDURE UpdatePlayerRatings (arg_server_name VARCHAR(255))
BEGIN
	IF (SELECT COUNT(*) FROM unique_kill WHERE processed = false > 0) THEN
    BEGIN
		#UPDATE RATING
		-- Declare Player variables --
		DECLARE var_killer_id INT;
		DECLARE var_victim_id INT;
        DECLARE var_record_id INT;
		DECLARE var_timestamp DATETIME;
        
		-- Declare Cursor --        
        DECLARE done INT DEFAULT 0;
		DECLARE kill_log_cursor CURSOR FOR 
			SELECT killer_id, victim_id, id, timestamp FROM unique_kill WHERE processed = false ORDER BY timestamp;
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
		OPEN kill_log_cursor;
		rating_loop: LOOP
			FETCH kill_log_cursor 
			INTO var_killer_id, var_victim_id, var_record_id, var_timestamp;
            IF done = 1 THEN
				LEAVE rating_loop;
			END IF;
			
			SET @killer_rating = (SELECT rating FROM ratings WHERE id = var_killer_id AND server_name = arg_server_name AND season = YEAR(var_timestamp)*12 + MONTH(var_timestamp));
			SET @victim_rating = (SELECT rating FROM ratings WHERE id = var_victim_id AND server_name = arg_server_name AND season = YEAR(var_timestamp)*12 + MONTH(var_timestamp));
			
			#CALL DebugMsg(@DEBUG, (select concat_ws('',"killer_rating:", @killer_rating)));
			#CALL DebugMsg(@DEBUG, (select concat_ws('',"victim_rating:", @victim_rating)));
			
			SET @K = 32;
			
            -- DETERMINE EACH PLAYER'S CHANCE OF WINNING
			SET @killer_win_chance = 1.0 / (1.0 + POW(10, ((@victim_rating - @killer_rating) / 400.0)));
			SET @victim_win_chance = 1.0 / (1.0 + POW(10, ((@killer_rating - @victim_rating) / 400.0)));
			
			#CALL DebugMsg(@DEBUG, (select concat_ws('',"killer_win_chance:", @killer_win_chance)));
			#CALL DebugMsg(@DEBUG, (select concat_ws('',"victim_win_chance:", @victim_win_chance)));
			            
			SET @killer_rating_change = ROUND(@K * (1 - @killer_win_chance), 0);
			SET @victim_rating_change = ROUND(@K * (0 - @victim_win_chance), 0);
			
			#CALL DebugMsg(@DEBUG, (select concat_ws('',"killer_rating_change:", @killer_rating_change)));
			#CALL DebugMsg(@DEBUG, (select concat_ws('',"victim_rating_change:", @victim_rating_change)));
			
			UPDATE		ratings
			SET			rating = @killer_rating + @killer_rating_change
			WHERE		id = var_killer_id 
				AND server_name = arg_server_name
                AND season = YEAR(var_timestamp)*12 + MONTH(var_timestamp);
			
			UPDATE		ratings
			SET			rating = @victim_rating + @victim_rating_change
			WHERE		id = var_victim_id 
				AND server_name = arg_server_name
                AND season = YEAR(var_timestamp)*12 + MONTH(var_timestamp);
            
            UPDATE unique_kill SET processed = TRUE WHERE id = var_record_id;
		END LOOP rating_loop;
		CLOSE kill_log_cursor;
	END;
    END IF;
END$$

DELIMITER ;