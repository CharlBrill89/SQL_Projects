SELECT 
	primary_product_id
--    , order_id
--    , items_purchased
    , COUNT( DISTINCT CASE WHEN items_purchased = 1 THEN order_id ELSE NULL END) AS count_single_item_orders
    , COUNT( DISTINCT CASE WHEN items_purchased = 2 THEN order_id ELSE NULL END) AS count_two_item_orders
FROM orders

WHERE order_id between 31000 and 32000

GROUP BY 1 
-- ,2,3