USE zojak;

DELIMITER $$

DROP PROCEDURE IF EXISTS `DebugMsg`$$
CREATE PROCEDURE DebugMsg(enabled INTEGER, arg_msg VARCHAR(255))
BEGIN
  IF enabled THEN 
  BEGIN
	INSERT INTO debug (msg, timestamp) VALUES (concat("** ", msg), now());
  END; 
  END IF;
END $$

DELIMITER ;
