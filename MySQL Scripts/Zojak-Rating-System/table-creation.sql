USE zojak;

-- RAW DATA FROM USERS
CREATE TABLE kill_log
(
	killer_id 			INT NOT NULL,
	victim_id 			INT NOT NULL,
    timestamp			DATETIME DEFAULT NOW(),
    server_name			VARCHAR(255) NOT NULL,
    submitter_id		INT NOT NULL
);

CREATE TABLE player
(
	object_id			INT,
    name				VARCHAR(255) NOT NULL,
    server_name			VARCHAR(255) NOT NULL,
    PRIMARY KEY (object_id, server_name)
);

CREATE TABLE error_log
(
	id					INT AUTO_INCREMENT PRIMARY KEY,
    timestamp			DATETIME,
	user_object_id		INT,
    message				TEXT,
    source				TEXT,
    stack				TEXT,
    inner_message		TEXT,
    inner_stack			TEXT,
    plugin_version_id	INT
);

-- CALCULATED DATA
CREATE TABLE ratings
(
	id				INT,
	rating			INT,
	player_rank		INT,
	wins			INT,
	losses			INT,
    season			INT,
	server_name 	VARCHAR(255),
    PRIMARY KEY (id, server_name, season)
);

CREATE TABLE unique_kill
(
	id					INT AUTO_INCREMENT,	
	killer_id			INT NOT NULL,
    victim_id			INT NOT NULL,
    timestamp			DATETIME NOT NULL,
	server_name			VARCHAR(255) NOT NULL,
    processed			BOOLEAN DEFAULT FALSE,
    PRIMARY KEY(killer_id, victim_id, timestamp, server_name),
    KEY `id` (`id`)
);

-- FOR DEBUGGING PROCS/FUNCS
CREATE TABLE debug
(
	msg				TEXT,
    timestamp		DATETIME
);
