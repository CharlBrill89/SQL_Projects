CREATE TEMPORARY TABLE first_pageview
SELECT 
    website_session_id,
    MIN(website_pageview_id) AS first_pv
FROM website_pageviews
WHERE created_at < '2012-06-12'
GROUP BY website_session_id; 

SELECT 
	website_pageviews.pageview_url AS landing_page,
	COUNT(DISTINCT first_pageview.website_session_id ) AS sessions_hitting_this_lander
FROM first_pageview
	LEFT JOIN website_pageviews
		ON first_pageview.first_pv= website_pageviews.website_pageview_id
GROUP BY 
	website_pageviews.pageview_url;