USE mavenfuzzyfactory;

SELECT 
	orders.primary_product_id ,
    -- order_items.product_id as cross_sell_product,
    COUNT(Distinct orders.order_id) as orders,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 1 THEN orders.order_id ELSE NULL END) as x_sell_pr1,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 2 THEN orders.order_id ELSE NULL END) as x_sell_pr2,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 3 THEN orders.order_id ELSE NULL END) as x_sell_pr3,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 1 THEN orders.order_id ELSE NULL END)/COUNT(Distinct order_items.order_id) as x_sell_pr1_cr_rt,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 2 THEN orders.order_id ELSE NULL END)/COUNT(Distinct order_items.order_id) as x_sell_pr2_rt,
    COUNT(DISTINCT CASE WHEN order_items.product_id = 3 THEN orders.order_id ELSE NULL END)/COUNT(Distinct order_items.order_id) as x_sell_pr3_rt
FROM orders
	LEFT JOIN order_items ON order_items.order_id = orders.order_id
    AND order_items.is_primary_item = 0
WHERE 
	orders.order_id BETWEEN 10000 and 11000

GROUP BY 1
	
;