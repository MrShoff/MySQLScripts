USE zojak;

/* --- FULLY RE-CALCULATE ALL RATINGS
TRUNCATE zojak.debug;
TRUNCATE zojak.ratings;
TRUNCATE zojak.unique_kill;

CALL zojak.GetLatestRatings('GamesDeadArena');
SELECT * FROM debug;
*/

-- PULL ERROR LOG
SELECT		p.name, DATE_ADD(e.timestamp, INTERVAL -5 HOUR) as timestamp, e.message, e.source, e.stack, e.inner_message, e.inner_stack
FROM		error_log e
JOIN		player p
	ON e.user_object_id = p.object_id
ORDER BY	timestamp desc;

-- GET SUBMITTER LIST
SELECT		p.name, MAX(timestamp) last_submission, count(*) count
FROM		kill_log k
JOIN		player p
	ON k.submitter_id = p.object_id
GROUP BY 	k.submitter_id
ORDER BY	last_submission DESC;

-- GET UNIQUE COUNTS
SELECT 		COUNT(*) as fights,
			(SELECT COUNT(DISTINCT killer_id) FROM unique_kill) + (SELECT COUNT(DISTINCT victim_id) FROM unique_kill WHERE victim_id NOT IN (SELECT DISTINCT killer_id FROM unique_kill)) as characters,
			server_name
FROM 		unique_kill
GROUP BY 	server_name;

-- GET PLAY TIMES BY HOUR
SELECT		COUNT(*), HOUR(timestamp), 
			(CASE 
				WHEN dayofweek(timestamp) >= 2 AND dayoftheweek(timestamp) <= 5 
					THEN 'M-Th' 
				WHEN dayofweek(timestamp) == 6
					THEN 'Fri' 
				WHEN dayofweek(timestamp) == 7 
                    THEN 'Sat' 
				WHEN dayofweek(timestamp) == 1 
                    THEN 'Sun' 
				END) 'day'
FROM		unique_kill
GROUP BY	HOUR(timestamp), day
ORDER BY	day, HOUR(timestamp);

-- GET CURRENT RATINGS
CALL GetLatestRatings('GamesDeadArena');
