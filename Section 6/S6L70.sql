USE mavenfuzzyfactory;



SELECT
	hr,
    ROUND(AVG(sessions),1) as avg_sessions,
    ROUND(AVG(CASE wkday WHEN 0 THEN sessions ELSE NULL END),1) as 'mon',
    ROUND(AVG(CASE wkday WHEN 1 THEN sessions ELSE NULL END),1) as 'tue',
    ROUND(AVG(CASE wkday WHEN 2 THEN sessions ELSE NULL END),1) as 'wed',
    ROUND(AVG(CASE wkday WHEN 3 THEN sessions ELSE NULL END),1) as 'thu',
    ROUND(AVG(CASE wkday WHEN 4 THEN sessions ELSE NULL END),1) as 'fri',
    ROUND(AVG(CASE wkday WHEN 5 THEN sessions ELSE NULL END),1) as 'sat',
    ROUND(AVG(CASE wkday WHEN 6 THEN sessions ELSE NULL END),1) as 'sun'
FROM(
	SELECT
	   DATE(created_at) AS created_date,
	   HOUR(created_at) as hr,
	   WEEKDAY(created_at) as wkday, -- 0 = Mon, 1 = Tue
	   COUNT(DISTINCT website_sessions.website_session_id) as sessions
	FROM website_sessions
	WHERE created_at BETWEEN '2012-09-15'AND '2012-11-15'
		-- created_at > '2012-09-15'AND created_at <= '2012-11-15'
		
	GROUP BY 1,2,3
) as daily_hourly_sessions

GROUP BY 1
ORDER BY 1
;









SELECT
   -- website_session_id,
   -- created_at,
   HOUR(created_at) as hr,
   -- WEEKDAY(created_at) as wkday, -- 0 = Mon, 1 = Tue
   -- count(
	COUNT(DISTINCT website_sessions.website_session_id) as sessions,
   -- avg(count(website_sessions.website_session_id)),
   COUNT(DISTINCT CASE WEEKDAY(created_at) WHEN 0 THEN website_sessions.website_session_id ELSE NULL END) AS 'mon'
   , COUNT(DISTINCT CASE WEEKDAY(created_at) WHEN 1 THEN website_sessions.website_session_id ELSE NULL END) AS 'tue'
   , COUNT(DISTINCT CASE WEEKDAY(created_at) WHEN 2 THEN website_sessions.website_session_id ELSE NULL END) AS 'wed'
   , COUNT(DISTINCT CASE WEEKDAY(created_at) WHEN 3 THEN website_sessions.website_session_id ELSE NULL END) AS 'thu'
   , COUNT(DISTINCT CASE WEEKDAY(created_at) WHEN 4 THEN website_sessions.website_session_id ELSE NULL END) AS 'fri'
   , COUNT(DISTINCT CASE WEEKDAY(created_at) WHEN 5 THEN website_sessions.website_session_id ELSE NULL END) AS 'sat'
   , COUNT(DISTINCT CASE WEEKDAY(created_at) WHEN 6 THEN website_sessions.website_session_id ELSE NULL END) AS 'sun' 
FROM website_sessions
WHERE 
	created_at > '2012-09-15'
    AND created_at <= '2012-11-15'
GROUP BY
	hr
ORDER BY hr ASC;


