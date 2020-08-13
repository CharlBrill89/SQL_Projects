USE mavenfuzzyfactory;

SELECT
    MIN(DATE(website_sessions.created_at)) as week_start_date,
    COUNT(DISTINCT CASE WHEN (device_type = 'desktop' and website_sessions.utm_source = 'gsearch') THEN website_sessions.website_session_id ELSE NULL END) as g_dtop_sessions,
    COUNT(DISTINCT CASE WHEN (device_type = 'desktop' and website_sessions.utm_source = 'bsearch') THEN website_sessions.website_session_id ELSE NULL END) as b_dtop_sessions,
    COUNT(DISTINCT CASE WHEN (device_type = 'desktop' and website_sessions.utm_source = 'bsearch') THEN website_sessions.website_session_id ELSE NULL END)/
		COUNT(DISTINCT CASE WHEN (device_type = 'desktop' and website_sessions.utm_source = 'gsearch') THEN website_sessions.website_session_id ELSE NULL END) as b_pct_of_g_dtop,
	COUNT(DISTINCT CASE WHEN (device_type = 'mobile' and website_sessions.utm_source = 'gsearch') THEN website_sessions.website_session_id ELSE NULL END) as g_dtop_sessions,
    COUNT(DISTINCT CASE WHEN (device_type = 'mobile' and website_sessions.utm_source = 'bsearch') THEN website_sessions.website_session_id ELSE NULL END) as b_dtop_sessions,
    COUNT(DISTINCT CASE WHEN (device_type = 'mobile' and website_sessions.utm_source = 'bsearch') THEN website_sessions.website_session_id ELSE NULL END)/
		COUNT(DISTINCT CASE WHEN (device_type = 'mobile' and website_sessions.utm_source = 'gsearch') THEN website_sessions.website_session_id ELSE NULL END) as b_pct_of_g_dtop
FROM website_sessions
LEFT JOIN orders
	ON orders.website_session_id = website_sessions.website_session_id

WHERE
	website_sessions.created_at > '2012-11-04'
    AND website_sessions.created_at < '2012-12-22'
    AND utm_campaign = 'nonbrand'
GROUP BY 
	yearweek(website_sessions.created_at); 
    