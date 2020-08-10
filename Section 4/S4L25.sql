USE mavenfuzzyfactory;

SELECT
	-- year(created_at)
    week(created_at)
    , min(date(created_at)) as week_start_date
    , count(distinct website_session_id) as sessions
--    , created_at
--    , month(created_at)
    
    
FROM website_sessions
WHERE 
-- 	created_at BETWEEN '2012-04-12' AND '2012-05-10'
	created_at < '2012-05-10'

GROUP BY
	1