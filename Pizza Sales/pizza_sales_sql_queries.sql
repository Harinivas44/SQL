create database pizza_sales;
use pizza_sales;

-- Basic Questions

-- 1.Retrieve the total number of orders placed.
select count(order_id) as total_no from orders;

-- 2. Calculate the total revenue generated from pizza sales.
select round(sum(od.quantity * p.price),2) as tot_rev_gen from pizzas p join order_details as od on p.pizza_id=od.pizza_id;

-- 3. Identify the highest-priced pizza.
select pt.name as pizza_name from pizzas p join pizza_types pt on p.pizza_type_id=pt.pizza_type_id 
where p.price=(select max(price) from pizzas);

-- 4. Identify the most common pizza size ordered.
select p.size,count(od.order_id) as no_orders from pizzas p join order_details od on p.pizza_id=od.pizza_id 
group by p.size order by no_orders desc;

-- 5. List the top 5 most ordered pizza types along with their quantities.
select pt.name,sum(o.quantity) as total_quantity from pizza_types pt join pizzas p on p.pizza_type_id = pt.pizza_type_id 
 join order_details o on p.pizza_id=o.pizza_id group by pt.name order by total_quantity desc limit 5;
 
 
 -- Intermediate Questions :
 
 -- 6. Join the necessary tables to find the total quantity of each pizza category ordered.
 select pt.category,sum(o.quantity) as total_quantity from pizza_types pt join pizzas p on p.pizza_type_id = pt.pizza_type_id 
 join order_details o on p.pizza_id=o.pizza_id group by pt.category order by total_quantity desc;
 
 -- 7. Determine the distribution of orders by hour of the day.
 select substring(time,1,2) as hour_of_day ,count(order_id) as total_orders from orders group by hour_of_day;
 
 -- 8.Join relevant tables to find the category-wise distribution of pizzas.
  select pt.category,count(p.pizza_id) as total_no from pizza_types pt join pizzas p on p.pizza_type_id = pt.pizza_type_id 
  group by pt.category order by total_no desc;
  
-- 9.Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(nos),0) as avg_piz_ord_per_day from 
(select o.date,sum(od.quantity) as nos from orders o join order_details od on o.order_id=od.order_id group by o.date) res;

-- 10. Determine the top 3 most ordered pizza types based on revenue.
select * from (select pt.name,round(sum(od.quantity*p.price),2) as revenue,dense_rank() over(order by sum(od.quantity*p.price) desc) as rank_no 
from pizza_types pt join pizzas p on p.pizza_type_id = pt.pizza_type_id join order_details od on p.pizza_id=od.pizza_id
group by pt.name) res where rank_no<=3;

-- Advanced Questions :

-- 11. Calculate the percentage contribution of each pizza type to total revenue.

with rev as (select sum(p.price*od.quantity) as tot_rev from pizzas p join order_details od on p.pizza_id=od.pizza_id)

select pt.name,round(100.0*sum(p.price*od.quantity)/(select tot_rev from rev),2) as perc_cont from pizzas p join order_details od 
on p.pizza_id=od.pizza_id join pizza_types pt on p.pizza_type_id=pt.pizza_type_id
group by pt.name order by perc_cont desc;

-- 12. Analyze the cumulative revenue generated over time.

select DISTINCT o.date ,ROUND(sum(p.price*od.quantity) over(order by o.date),2) as tot_rev from pizzas p join order_details od 
on p.pizza_id=od.pizza_id join orders o on o.order_id=od.order_id ;

-- 13.Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select * from (select pt.category,pt.name,round(sum(od.quantity*p.price),2) as revenue,dense_rank() over(partition by pt.category 
order by sum(od.quantity*p.price) desc) as rank_no 
from pizza_types pt join pizzas p on p.pizza_type_id = pt.pizza_type_id join order_details od on p.pizza_id=od.pizza_id
group by pt.category,pt.name) res where rank_no<=3;
