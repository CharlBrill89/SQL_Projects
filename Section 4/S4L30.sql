USE mavenfuzzyfactory;

SELECT 
    min(date(created_at)) as week_start_date 
	, COUNT( DISTINCT CASE WHEN device_type = 'desktop' THEN website_session_id ELSE NULL END) AS dtop_sessions
    , COUNT( DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mob_sessions
	, COUNT( DISTINCT website_session_id ) AS tot_sessions
FROM website_sessions
WHERE
	created_at BETWEEN '2012-04-15' AND '2012-06-09'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'

GROUP BY 
	year(created_at)
    , week(created_at)