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
    website_sessions.device_type,
    website_sessions.utm_source,
    COUNT(DISTINCT website_sessions.website_session_id) as total_sessions,
    COUNT(DISTINCT orders.order_id) as total_orders,
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) as conv_rate
    -- COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) as mobile_sessions,
    -- COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END)/ COUNT(DISTINCT website_sessions.website_session_id) as percnt_mobile
FROM website_sessions
LEFT JOIN orders
	ON orders.website_session_id = website_sessions.website_session_id

WHERE
	website_sessions.created_at > '2012-08-22'
    AND website_sessions.created_at < '2012-09-18'
    AND utm_campaign = 'nonbrand'
GROUP BY 
	yearweek(website_sessions.created_at); 
    