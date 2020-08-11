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
    -- MIN(DATE(website_sessions.created_at)) as week_start_date,
    utm_source,
    COUNT(DISTINCT website_sessions.website_session_id) as total_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) as mobile_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END)/ COUNT(DISTINCT website_sessions.website_session_id) as percnt_mobile
FROM website_sessions
WHERE
	website_sessions.created_at BETWEEN '2012-08-22' AND '2012-11-30'
    AND utm_campaign = 'nonbrand'
GROUP BY 
	utm_source; 
    