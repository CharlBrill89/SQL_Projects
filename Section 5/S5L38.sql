-- BUINESS CONTEXT: we want to see landing page perfoemance for a certain time period

-- STEP 1: find the first website_pv
-- STEP 2: LP
-- STEP 3: count PV, identify bounces
-- STEP 4: summarise tool sessions and bounce sessions by LP

-- find the minimum pv is associated with each session

SELECT 
	website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_pv_id
FROM website_pageviews
	INNER JOIN website_sessions
		ON website_sessions.website_session_id = website_pageviews.website_pageview_id
        AND website_sessions.created_at < '2012-06-14' -- BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY
	website_pageviews.website_session_id;

-- STEP 2: Identify landing pages
DROP TABLE first_pv_demo;
CREATE TEMPORARY TABLE first_pv_demo     
SELECT 
	website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_pv_id
FROM website_pageviews
	INNER JOIN website_sessions
		ON website_sessions.website_session_id = website_pageviews.website_pageview_id
        AND website_sessions.created_at < '2012-06-14' -- BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY
	website_pageviews.website_session_id;



SELECT * FROM first_pv_demo;

DROP TABLE sessions_w_home_landing_page;
CREATE TEMPORARY TABLE sessions_w_home_landing_page
SELECT
	first_pv_demo.website_session_id ,
    website_pageviews.pageview_url as lp
FROM first_pv_demo
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = first_pv_demo.min_pv_id
WHERE website_pageviews.pageview_url = '/home';
        
SELECT * FROM sessions_w_home_landing_page;

-- STEP 3: count PV, identify bounces
DROP TABLE bounced_t_only;
CREATE TEMPORARY TABLE bounced_t_only
SELECT 
	sessions_w_home_landing_page.website_session_id,
    sessions_w_home_landing_page.lp,
    COUNT(sessions_w_home_landing_page.website_session_id) as cnt_pv
FROM sessions_w_home_landing_page
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = sessions_w_home_landing_page.website_session_id
GROUP BY
	sessions_w_home_landing_page.website_session_id,
    sessions_w_home_landing_page.lp
HAVING 
	COUNT(website_pageviews.website_pageview_id) = 1; -- the boucers 
    
SELECT lp, count(lp) FROM bounced_t_only GROUP BY lp;

-- STEP 4: summarise tool sessions and bounce sessions by LP
SELECT
	sessions_W_lp.lp,
    sessions_W_lp.website_session_id,
    bounced_t_only.website_session_id as bounced_we_s_id
FROM sessions_W_lp
	LEFT JOIN bounced_t_only
		ON sessions_W_lp.website_session_id = bounced_t_only.website_session_id
ORDER BY 
	sessions_W_lp.website_session_id
    ;

-- FINAL OUTPUT
SELECT
	-- sessions_W_lp.lp,
    count(distinct sessions_W_lp.website_session_id) as sessions,
    count(distinct bounced_t_only.website_session_id) as bounced_sessions,
    count(distinct bounced_t_only.website_session_id)/count(distinct sessions_W_lp.website_session_id) as bounce_rate
FROM sessions_W_lp
	LEFT JOIN bounced_t_only
		ON sessions_W_lp.website_session_id = bounced_t_only.website_session_id
/*GROUP BY 
	sessions_W_lp.lp*/
    ;