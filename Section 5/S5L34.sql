USE mavenfuzzyfactory;



-- CREATE temporary table first_pageview
SELECT 
	pageview_url,
    COUNT(DISTINCT website_pageview_id) as sessions
FROM website_pageviews
WHERE created_at < '2012-06-09'
GROUP BY pageview_url
ORDER BY sessions DESC; 
/*
SELECT 
	website_pageviews.pageview_url AS landing_page,
	COUNT(DISTINCT first_pageview.website_session_id ) AS sessions_hitting_this_lander
FROM first_pageview
	LEFT JOIN website_pageviews
		ON first_pageview.min_pv_id = website_pageviews.website_pageview_id
GROUP BY 
	website_pageviews.pageview_url
    
    */