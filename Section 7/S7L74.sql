USE mavenfuzzyfactory;

SELECT 
	YEAR(website_sessions.created_at) as yr,
    MONTH(website_sessions.created_at) as mo,
    COUNT(DISTINCT website_sessions.website_session_id) as sessions
    -- COUNT(DISTINCT orders.order_id) as orders,
    -- COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) as conv_rate
    -- SUM(orders.price_usd)/COUNT(DISTINCT website_sessions.website_session_id) as re_per_session
    -- COUNT(DISTINCT CASE WHEN primary_product_id = 1 THEN order_id ELSE NULL END) AS product_one_orders,
	-- COUNT(DISTINCT CASE WHEN primary_product_id = 2 THEN order_id ELSE NULL END) AS product_two_orders
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE 
	website_sessions.created_at < '2013-04-05'
    AND website_sessions.created_at > '2012-04-01'
GROUP BY
	1, 2