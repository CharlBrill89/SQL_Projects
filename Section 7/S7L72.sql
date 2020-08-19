USE mavenfuzzyfactory;

SELECT 
	primary_product_id,
	COUNT(order_id) as orders,
    sum(price_usd) as revenue,
    sum(price_usd - cogs_usd) as margin,
    avg(price_usd) as aov
from orders
where order_id between 10000 and 11000
GROUP BY 1
ORDER BY 1,2 DESC