USE jayson_tools;

SET SQL_SAFE_UPDATES = 0;



SELECT * FROM plugin_version ORDER BY major DESC, minor DESC, build DESC, revision DESC;

INSERT INTO plugin_version (major, minor, build, revision, notes) VALUES (1, 8, 0, 0, 'CPU load fix, spell casting animation fix, PK timer display');

UPDATE		plugin_version pv
SET			pv.notes = 'Added "My Quests" tab'
WHERE		major = 1
		AND minor = 3
        AND	build = 0
        AND revision = 0;
        
UPDATE		plugin_version pv
SET			pv.force_update = 0
WHERE		major = 1
		AND minor = 3
        AND	build = 0
        AND revision = 0;
        
UPDATE		plugin_version pv
SET			pv.current_release = 1
WHERE		major = 1
		AND minor = 8
        AND	build = 0
        AND revision = 0;
        
UPDATE		plugin_version
SET			dll_binary = null
WHERE		id = 2;

UPDATE		plugin_version
SET			current_release = 0;


/*
force_update = 1 means if you're using that version, the plugin will deactivate without an update

CREATE TABLE plugin_version
(
	id					INT AUTO_INCREMENT PRIMARY KEY,
    major				TINYINT,
    minor				TINYINT,
    build				TINYINT,
	revision			TINYINT,
    force_update		TINYINT DEFAULT 0,
    notes				TEXT,
    timestamp			DATETIME DEFAULT NOW(),
    dll_binary			MEDIUMBLOB
);
*/