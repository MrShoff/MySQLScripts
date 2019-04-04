USE ac_pvpdeathtracker;

CREATE TABLE death
(
	id					INT AUTO_INCREMENT PRIMARY KEY,
    killer_id			INT,
	victim_id			INT,
    timestamp			DATETIME,
    server_name			VARCHAR(1000),
    death_message		VARCHAR(1000)
);

CREATE TABLE player
(
	object_id 			INT PRIMARY KEY,
	name				VARCHAR(255)
);

INSERT INTO player (object_id, name) SELECT @object_id, @name;

INSERT INTO death (killer_id, victim_id, timestamp, server_name, death_message) SELECT @killer_id, @victim_id, @timestamp, @server_name, @death_message;

SELECT id, COUNT(*) FROM death GROUP BY killer_id, victim_id, server_name, DATE(timestamp), HOUR(timestamp), MINUTE(timestamp), SECOND(timestamp) HAVING count(*) > 1;

SELECT killer_id, victim_id, server_name, DATE(timestamp), HOUR(timestamp), MINUTE(timestamp), SECOND(timestamp) FROM death;