USE jayson_tools;

CREATE TABLE player
(
	object_id 			INT PRIMARY KEY,
	monarch_id 			INT,
	name				VARCHAR(255),
	auth_level			INT DEFAULT 0,
	creature_level		SMALLINT,
    server_name			VARCHAR(255),
    jt_user				TINYINT DEFAULT 0,
    server_name			VARCHAR(255),
	last_known_coords	VARCHAR(255),
    landblock_dec		INT,
    primary_recall		TEXT,
    secondary_recall	TEXT,
    last_updated_date	DATETIME,
    last_updated_by		INT
);

CREATE TABLE monarch
(
	object_id			INT PRIMARY KEY,
	name				VARCHAR(255),
	auth_level			INT DEFAULT 0,
    last_updated_date	DATETIME,
    last_updated_by		INT    
);

CREATE TABLE relationship
(
	id					INT AUTO_INCREMENT PRIMARY KEY,
	user_object_id		INT,
    target_object_id	INT,
    target_is_guild		BOOL,
    relationship_type	INT
);

CREATE TABLE landblock
(
	id					INT AUTO_INCREMENT PRIMARY KEY,
    name				TEXT,
	landblock_dec		INT
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

CREATE TABLE event_log
(
	id					INT AUTO_INCREMENT PRIMARY KEY,	
	user_object_id		INT,
    timestamp			DATETIME,
    message				TEXT,
    event_type			INT
);

CREATE TABLE plugin_version
(
	id					INT AUTO_INCREMENT PRIMARY KEY,
    major				TINYINT,
    minor				TINYINT,
    build				TINYINT,
	revision			TINYINT,
    force_update		TINYINT DEFAULT 0,
    current_release		TINYINT,	
    notes				TEXT,
    timestamp			DATETIME DEFAULT NOW(),
    dll_binary			MEDIUMBLOB
);

/* STAGING TABLES */
CREATE TABLE player_stage
(
	id					INT AUTO_INCREMENT PRIMARY KEY,
	object_id 			INT NOT NULL,
	monarch_id 			INT,
	name				VARCHAR(255),
	creature_level		SMALLINT,
    server_name			VARCHAR(255),
	last_known_coords	VARCHAR(255),
	jt_user				TINYINT DEFAULT 0,
    landblock_dec		INT,
    primary_recall		TEXT,
    secondary_recall	TEXT,
    inserted_by			INT NOT NULL,
    inserted_date		DATETIME NOT NULL,
    record_processed	TINYINT,
    UNIQUE KEY `data_from_player` (`object_id`,`inserted_by`)
);

CREATE TABLE monarch_stage
(
	id					INT AUTO_INCREMENT PRIMARY KEY,
	object_id			INT NOT NULL,
	name				VARCHAR(255),
    inserted_by			INT NOT NULL,
    inserted_date		DATETIME NOT NULL,
    record_processed	TINYINT,
    UNIQUE KEY `data_from_player` (`object_id`,`inserted_by`)
);

/* FOR USE WITH DISCORD BOT */
CREATE TABLE discord_bot_interaction
(
	id					INT AUTO_INCREMENT PRIMARY KEY,
    player_object_id	INT NOT NULL,
    message				TEXT,
    interaction_type	TINYINT,
    timestamp			DATETIME,
    bot_received		TINYINT DEFAULT 0
);