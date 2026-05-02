SELECT *
FROM order_details;

SELECT * 
FROM pizzas;

SELECT * 
FROM  orders;

SELECT
	o.date,
    o.time,
	od.order_id,
    pt.name AS pizza_name,
    p.size,
    od.quantity,
    p.price,
    (od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
JOIN orders o ON od.order_id = o.order_id;	


SELECT 
    pt.category,
    SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_revenue DESC;


SELECT 
    HOUR(o.time) AS order_hour,
    COUNT(DISTINCT od.order_id) AS total_orders
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
GROUP BY HOUR(o.time)
ORDER BY total_orders DESC;


WITH DailySales AS (
    SELECT 
        o.date, 
        SUM(od.quantity) AS daily_total
    FROM order_details od
    JOIN orders o ON od.order_id = o.order_id
    GROUP BY o.date
)
SELECT 
    ROUND(AVG(daily_total), 0) AS avg_pizzas_per_day
FROM DailySales;


WITH PizzaRevenues AS (
    SELECT 
        pt.category,
        pt.name AS pizza_name,
        SUM(od.quantity * p.price) AS revenue
    FROM order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name
)
SELECT 
    category,
    pizza_name,
    revenue,
    RANK() OVER(PARTITION BY category ORDER BY revenue DESC) AS rank_in_category
FROM PizzaRevenues;

SELECT 
    o.order_id,
    o.date,
    o.time,
    pt.name AS pizza_name,
    pt.category,
    p.size,
    od.quantity,
    p.price,
    (od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
JOIN orders o ON od.order_id = o.order_id;									