USE jayson_tools;

SELECT		p.name, DATE_ADD(e.timestamp, INTERVAL -5 HOUR) as timestamp, e.message, e.source, e.stack, e.inner_message, e.inner_stack
FROM		error_log e
JOIN		player p
	ON e.user_object_id = p.object_id
ORDER BY	timestamp desc;

SELECT * FROM jayson_tools.player
/* WHERE object_id = 1342196710 */
ORDER BY last_updated_date DESC
;

SELECT * FROM jayson_tools.monarch;

SELECT		COUNT(*) guild_size, m.name
FROM		player p
JOIN		monarch m
	ON p.monarch_id = m.object_id
GROUP BY	m.object_id
ORDER BY	guild_size desc;

/* LANDBLOCK STUFF */
SELECT count(*) as c, landblock_dec, name FROM landblock GROUP BY landblock_dec HAVING c > 1 ORDER BY c desc;

SELECT HEX(landblock_dec) as landblock_hex, name FROM landblock GROUP BY landblock_hex;

INSERT INTO landblock (name, landblock_dec) SELECT (CASE WHEN `Recall Spell Name` = 'N/A' THEN `Chat Command` ELSE `Recall Spell Name` END), `Landblock Dec` FROM landblock_recall GROUP BY `landblock dec`;

INSERT INTO landblock (name, landblock_dec) SELECT `Drop Name`, `Landblock Dec` FROM portal_gems WHERE `landblock dec` != 0 GROUP BY `landblock dec`;

INSERT INTO landblock (name, landblock_dec) SELECT `Dungeon Name`, `Landblock Dec` FROM dungeon_portals WHERE `landblock dec` != 0 GROUP BY `landblock dec`;

INSERT INTO landblock (name, landblock_dec) SELECT `Name`, `Landblock Dec` FROM landscape_portals WHERE `landblock dec` != 0 GROUP BY `landblock dec`;

INSERT INTO landblock (name, landblock_dec) VALUES ('Egg Orchard (inside)', CONV('C801', 16, 10)), ('Egg Orchard (inside)', CONV('C802', 16, 10)), ('Egg Orchard (inside)', CONV('C803', 16, 10)); 

select CONV('53731', 10, 16);

UPDATE	landblock
SET		name = 'Rossu Morta Chapterhouse Recall Orb'
WHERE	id = 3;

SELECT landblock_dec, name FROM landblock GROUP BY landblock_dec LIMIT 99999;
/* END LANDBLOCK STUFF */

SELECT creature_level, last_known_coords, landblock_dec, primary_recall, secondary_recall, m.name as monarch_name FROM player p JOIN monarch m ON p.monarch_id = m.object_id WHERE p.name = 'jayson tatum' @name;