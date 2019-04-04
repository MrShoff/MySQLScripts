USE postcount;

CREATE TABLE post
(
	post_id				INT PRIMARY KEY,
	user_id				INT,
    message_text		TEXT,
    postdate			DATETIME,
    thread_title		VARCHAR(1000),
    thread_url			VARCHAR(4000),
    thread_id			INT,
    insert_by			VARCHAR(255)    
);

CREATE TABLE user
(
	user_id				INT PRIMARY KEY,
    username			VARCHAR(255)	
);

CREATE TABLE thread
(
	thread_id			INT PRIMARY KEY,
    unavailable			BOOLEAN,
    most_recent_post	DATETIME,
    last_scraped		DATETIME,
    started_by			INT
);

CREATE TABLE post_stage
(
	post_id				INT PRIMARY KEY,
	user_id				INT,
    username			VARCHAR(255),
    message_text		TEXT,
    postdate			DATETIME,
    thread_title		VARCHAR(1000),
    thread_url			VARCHAR(4000),
    thread_id			INT,
    insert_by			VARCHAR(255)  
);












