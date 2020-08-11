USE mavenfuzzyfactory;

SELECT 
	COUNT(DISTINCT website_sessions.website_session_id)
FROM website_sessions
WHERE website_sessions.created_at BETWEEN '2012-08-22' AND '2012-11-29'
GROUP BY 1;

SELECT
	-- YEAR(website_sessions.created_at) as yr,
    -- MONTH(website_sessions.created_at) as mo,
    -- yearweek(website_sessions.created_at) as yrwk,
    -- yearweek(website_sessions.created_at) as yrwk,
    MIN(DATE(website_sessions.created_at)) as week_start_date,
    COUNT(DISTINCT website_sessions.website_session_id) as total_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END) as gsearch_paid_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END) as bsearch_paid_sessions
FROM website_sessions
	LEFT JOIN orders 
		ON website_sessions.website_session_id = orders.website_session_id
WHERE
	website_sessions.created_at BETWEEN '2012-08-22' AND '2012-11-29'
    AND utm_campaign = 'nonbrand'
GROUP BY 
	yearweek(website_sessions.created_at); 