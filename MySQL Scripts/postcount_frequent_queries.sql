USE postcount;

SELECT		HTML_UnEncode(message_text), p.thread_url
FROM		post p
JOIN		user u
	ON p.user_id = u.user_id
WHERE		u.username = 'TheKingOfTexas'
			##AND p.message_text like '%SAMANTHA%';
            AND p.message_text like '%hell%';
