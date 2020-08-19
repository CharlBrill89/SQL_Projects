USE mavenfuzzyfactory;

SELECT 
-- 	primary_product_id,
	YEAR(created_at) as yr,
    MONTH(created_at) as mo,
    COUNT(order_id) as number_of_sales,
    SUM(price_usd) as total_revenue,
    SUM(price_usd - cogs_usd) as total_margin,
    avg(price_usd) as aov
FROM orders
WHERE 
	created_at <= '2013-01-04'
GROUP BY
	yr,mo
ORDER BY yr asc,mo asc