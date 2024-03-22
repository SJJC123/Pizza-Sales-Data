-- Updated date to use more comfortably on Tableau (USA date method)
UPDATE pizza_sales
SET order_date = DATE_FORMAT(STR_TO_DATE(order_date, '%d-%m-%Y'), '%m-%d-%Y');


-- KPI's (Key Performance Indicators) --

-- Total Revenue of pizza sales (sum of money of all pizzas sold)
select sum(total_price) as Total_Revenue
from pizza_sales;

-- Average Order Value (average amount spent on each pizza order)
select (sum(total_price) / count(distinct order_id)) as Avg_Order_Value
from pizza_sales;

-- Total pizzas sold
select sum(quantity) as Total_pizza_sold
from pizza_sales;

-- Total orders placed
select count(distinct order_id) as Total_orders
from pizza_sales;

-- Average Number of Pizzas Per Order
select round(sum(quantity) / count(distinct order_id), 2) as Avg_num_per_order
from pizza_sales;

-- Inferences of pizza data --
 
-- Hourly Trend for Total Pizzas sold
select extract(hour from order_time) AS order_hours, sum(quantity) as total_pizzas_sold
from pizza_sales
group by extract(hour from order_time)
order by extract(hour from order_time);

-- Weekly Trend for Total Orders (calculated but using monthly instead)
SELECT WEEK(STR_TO_DATE(order_date, '%d-%m-%Y'), 3) AS Week_of_Year, YEAR(STR_TO_DATE(order_date, '%d-%m-%Y')) AS Year,
COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales
GROUP BY Year, Week_of_Year;

SELECT WEEK(order_date) AS Week_of_Year, YEAR(order_date) AS Year,
       COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales
GROUP BY Year, Week_of_Year;


-- Monthly Trend for Total Order (using this in tableau instead of weekly)
SELECT MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) AS Week_of_Year, YEAR(STR_TO_DATE(order_date, '%d-%m-%Y')) AS Year,
COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales
GROUP BY Year, Week_of_Year;

-- Percentage of sales by pizza category
SELECT pizza_category,round(sum(total_price),2) AS total_revenue,
round((sum(total_price) * 100) / (SELECT SUM(total_price) FROM pizza_sales),2) AS Percentage
FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_revenue DESC;

-- Percetnage of sales by pizza size
SELECT pizza_size, round(sum(total_price),2) as total_revenue,
round((SUM(total_price) * 100) / (SELECT SUM(total_price) from pizza_sales),2) AS Percentage
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size;

-- Total pizzas sold by category
-- date in data was structured differently than what MySQL uses so I altered its structure below to suit it
SELECT pizza_category, sum(quantity) AS Total_Quan_Sold 
FROM pizza_sales 
WHERE MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) between 1 and 12  -- Number corresponds to month (ex: 1 = January)
GROUP BY pizza_category 
ORDER BY Total_Quan_Sold DESC;


-- Top 5 pizzas by revenue
SELECT pizza_name, sum(total_price) AS Top_5_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Top_5_Revenue DESC
LIMIT 5;

-- Lowest 5 selling pizzas by revenue
SELECT pizza_name, sum(total_price) AS Top_5_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Top_5_Revenue ASC
LIMIT 5;

-- Top 5 selling pizzas by quantity
SELECT pizza_name, sum(quantity) AS Top_5_quan
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Top_5_quan DESC
LIMIT 5;

-- Lowest 5 selling pizzas by quantity
SELECT pizza_name, sum(quantity) AS Top_5_quan
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Top_5_quan ASC
LIMIT 5;

-- Top 5 selling pizzas by total orders
SELECT pizza_name, count(distinct order_id) AS Top_5_total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Top_5_total_orders DESC
LIMIT 5;

-- Lowest 5 selling pizzas by total orders
SELECT pizza_name, count(distinct order_id) AS Top_5_total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Top_5_total_orders ASC
LIMIT 5;






