-- Step 1: Find the first instance of /lander-1 t set analysis timeframe
-- STEP 2: FInal analysis output

-- Step 1: Find the first instance of /lander-1 t set analysis timeframe
SELECT 
	MIN(created_at) as first_created_at,
    MAX(created_at) as last_used,
    MIN(website_pageview_id) as first_pageview_id
FROM website_pageviews
WHERE pageview_url = '/lander-1'
	AND created_at IS NOT NULL;

-- STEP 2.1: Identify landing pages
DROP TABLE first_test_pv;
CREATE TEMPORARY TABLE first_test_pv 
SELECT 
	website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_pv_id
FROM website_pageviews
	INNER JOIN website_sessions
		ON website_sessions.website_session_id = website_pageviews.website_session_id
		AND website_sessions.created_at < '2012-07-28'
		AND website_pageviews.website_pageview_id > 23504
		AND utm_source = 'gsearch'
		AND utm_campaign = 'nonbrand'
        -- AND website_sessions.created_at  BETWEEN '2012-06-19' AND '2012-07-28' -- < '2012-06-14' --
GROUP BY
	website_pageviews.website_session_id;

-- STEP 2.2 Find landing pages for sessions
DROP TABLE sessions_w_home_landing_page;
CREATE TEMPORARY TABLE sessions_w_home_landing_page
SELECT
	first_test_pv.website_session_id ,
    website_pageviews.pageview_url as lp
FROM first_test_pv
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = first_test_pv.min_pv_id
WHERE website_pageviews.pageview_url IN ('/home','/lander-1');

SELECT * -- lp, count(website_pageviews.website_session_id) 
	FROM sessions_w_home_landing_page; -- GROUP BY lp;

-- STEP 2.3 Find bouncers for sessions
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
	COUNT(website_pageviews.website_pageview_id) = 1; -- the bouncers 
    
SELECT lp, count(lp) FROM bounced_t_only GROUP BY lp;
SELECT * FROM bounced_t_only;

-- STEP 4: summarise tool sessions and bounce sessions by LP
SELECT
	sessions_w_home_landing_page.lp,
    sessions_w_home_landing_page.website_session_id,
    bounced_t_only.website_session_id as bounced_we_s_id
FROM sessions_w_home_landing_page
	LEFT JOIN bounced_t_only
		ON sessions_w_home_landing_page.website_session_id = bounced_t_only.website_session_id
ORDER BY 
	sessions_w_home_landing_page.website_session_id
    ;

-- FINAL OUTPUT
SELECT
	sessions_w_home_landing_page.lp,
    count(distinct sessions_w_home_landing_page.website_session_id) as sessions,
    count(distinct bounced_t_only.website_session_id) as bounced_sessions,
    count(distinct bounced_t_only.website_session_id)/count(distinct sessions_w_home_landing_page.website_session_id) as bounce_rate
FROM sessions_w_home_landing_page
	LEFT JOIN bounced_t_only
		ON sessions_w_home_landing_page.website_session_id = bounced_t_only.website_session_id
GROUP BY 
	sessions_w_home_landing_page.lp
    ;