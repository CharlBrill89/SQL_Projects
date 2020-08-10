-- Find the first time 'billing-2 was seen
SELECT 
	MIN(created_at) AS first_created_at,
    website_pageviews.website_pageview_id as first_pv_id
FROM website_pageviews
WHERE pageview_url = '/billing-2';
-- 53550

DROP TABLE session_level_made_it_flags_demo;
CREATE temporary table session_level_made_it_flags_demo;
SELECT 
	website_pageviews.website_session_id,
    website_pageviews.pageview_url
    , orders.order_id
FROM website_pageviews
	LEFT JOIN orders
		ON orders.website_session_id = website_pageviews.website_session_id
WHERE 
	website_pageviews.website_pageview_id >= '53550' 
    AND website_pageviews.created_at < '2012-11-12'
	AND website_pageviews.pageview_url IN ('/billing','/billing-2') -- '/lander-1','/products','/the-original-mr-fuzzy','/thank-you-for-your-order')
;
    
DROP TABLE session_level_made_it_flags_demo;
CREATE temporary table session_level_made_it_flags_demo;
SELECT
	billing_version_seen,
	COUNT(DISTINCT website_session_id) as sessions
    , COUNT(DISTINCT order_id) as orders
    , COUNT(DISTINCT order_id)/COUNT(DISTINCT website_session_id) AS billing_to_order_rt
FROM(
SELECT 
	website_pageviews.website_session_id,
    website_pageviews.pageview_url AS billing_version_seen
    , orders.order_id
FROM website_pageviews
	LEFT JOIN orders
		ON orders.website_session_id = website_pageviews.website_session_id
WHERE 
	website_pageviews.website_pageview_id >= '53550' 
    AND website_pageviews.created_at < '2012-11-12'
	AND website_pageviews.pageview_url IN ('/billing','/billing-2') 
) AS billing_sessions_w_orders
GROUP BY 
	billing_version_seen
;

SELECT * from session_level_made_it_flags_demo;

SELECT
	COUNT(DISTINCT website_session_id) as sessions,
	-- COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS to_products,
    -- COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart
    , COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping
    , COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing
    -- , COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM session_level_made_it_flags_demo
WHERE
	website_pageviews.pageview_url = '/billing'
    AND website_pageviews.pageview_url = '/billing-2'
GROUP BY 
	website_pageviews.pageview_url
    ;
