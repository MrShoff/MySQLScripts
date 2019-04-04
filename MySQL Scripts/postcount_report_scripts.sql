USE postcount;

# --- SET QUERY VARIABLES ---
SET @start_date = '2018-01-01 00:00:00';
SET @end_date = '2018-12-31 23:59:59';
SET @username = 'TheKingOfTexas';
# --- END QUERY VARIABLES ---

# --- GET SUMMARY STATS ---
SELECT		CONCAT(COUNT(post_id),' posts in ',COUNT(DISTINCT(t.thread_id)),' threads from ',@start_date,' to ',@end_date) 'Summary'
FROM		post p
JOIN		thread t 
	ON p.thread_id = t.thread_id
WHERE		postdate >= @start_date
			AND	postdate < @end_date;
# --- END SUMMARY STATS ---

# --- GET TOP USERS ---
DROP TABLE IF EXISTS tmp_postcount_rating;
CREATE TEMPORARY TABLE IF NOT EXISTS tmp_postcount_rating
AS
SELECT		CONCAT('[MENTION=', u.user_id, ']', username, '[/MENTION]') 'User', 
			COUNT(*) 'Count', 
            username
FROM		post p
JOIN		user u
			ON p.user_id = u.user_id
WHERE		postdate >= @start_date
			AND	postdate < @end_date
GROUP BY	username
ORDER BY	Count DESC
LIMIT		100;

SET @cnt = 0;

#for ranking table
SELECT		'[TR]', 
			CONCAT('[TD]', (@cnt := @cnt + 1),')','[/TD]') 'Rank', 
			CONCAT('[TD]', IF(@cnt<=50, User, Username), '[/TD]') 'User', 
            CONCAT('[TD]', Count, '[/TD]') 'Count',
            '[/TR]'
FROM		tmp_postcount_rating;

#for pie chart
SELECT		count,
			username
FROM		tmp_postcount_rating;
# --- END GET TOP USERS ---

# --- GET TOP THREADS ---
DROP TABLE IF EXISTS tmp_thread_rating;
CREATE TEMPORARY TABLE IF NOT EXISTS tmp_thread_rating
AS
SELECT		CONCAT('[URL=',thread_url,']',thread_title,'[/URL]') 'thread', 
			COUNT(*) 'posts', 
            u.username 'started_by'
FROM		post p
JOIN		thread t 
			ON p.thread_id = t.thread_id
JOIN		user u
			ON t.started_by = u.user_id
WHERE		postdate >= @start_date
			AND	postdate < @end_date
GROUP BY	p.thread_id
ORDER BY	posts DESC
LIMIT		10;

SET @cnt = 0;

SELECT		'[TR]', 
			CONCAT('[TD]',(@cnt := @cnt + 1),')','[/TD]') 'Rank', 
			CONCAT('[TD]',thread,'[/TD]') 'Thread', 
            CONCAT('[TD]',posts,'[/TD]') 'Posts', 
            CONCAT('[TD]',started_by,'[/TD]') 'Started By', 
            '[/TR]'
FROM		tmp_thread_rating;
# --- END GET TOP THREADS ---

/*
# --- CREATE WORD CLOUDS ---
SELECT 	UPPER(MESSAGE_TEXT)#, THREAD_URL
FROM	post p
JOIN	user u 
		ON p.user_id = u.user_id
WHERE	username = @username
		AND postdate >= @start_date
        AND	postdate < @end_date
        AND IFNULL(MESSAGE_TEXT,'') != ''
ORDER BY postdate DESC
LIMIT	2500;
# --- END CREATE WORD CLOUDS ---

# --- GET COUNTS FOR INDIVIDUAL WORDS ---
SELECT	COUNT(*)
FROM	post p
JOIN	user u 
		ON p.user_id = u.user_id
WHERE	username = 'saiaku'
		AND postdate >= @start_date
        AND	postdate < @end_date
		AND UPPER(message_text) LIKE '%XEXY%';
# --- END GET COUNTS FOR INDIVIDUAL WORDS ---

# --- GET HOURLY POSTING HABITS ---
SELECT	count(*) postcount, HOUR(p.postdate) hour, username
FROM	post p
JOIN	user u 
		ON p.user_id = u.user_id
WHERE	postdate >= @start_date
        AND	postdate < @end_date
        AND username = @username
GROUP BY hour, u.username
ORDER BY hour, postcount desc;
# --- END GET HOURLY POSTING HABITS ---

# --- GET POSTS PER HOUR ---
SELECT	COUNT(*)/HOUR(TIMEDIFF(@start_date,@end_date))
FROM	post p
JOIN	user u 
		ON p.user_id = u.user_id
WHERE	username = @username
		AND postdate >= @start_date
        AND	postdate < @end_date;
# --- GET POSTS PER HOUR ---
*/













