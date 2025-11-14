select * from order_details;

select * from orders;

select * from pizza_types;

select * from pizzas;

#Calculate total numbers of order placed
select count(order_id) as total_orders from order_details;

#Calculate the total revenue generated from pizza sales
select round(sum(o.quantity * p.price),2) as revenue
from order_details o
left join pizzas p
on o.pizza_id = p.pizza_id;

#Identify the highest-priced pizza
with pizza_high_priced as(
select *
from pizzas
where price in
(select max(price) from pizzas))
select pt.name, ph.price
from pizza_high_priced ph
join pizza_types pt
on pt.pizza_type_id = ph.pizza_type_id;

#Identify the most common pizza size ordered
with count_size as(
select size, count(size) as counts from pizzas group by size)
select size, counts 
from count_size
order by counts desc
limit 1;

#List the top 5 most ordered pizza types along with their quantities.
select pt.name, sum(o.quantity) as Total_quantity
from order_details o
join pizzas p
on o.pizza_id = p.pizza_id
join pizza_types pt
on pt.pizza_type_id = p.pizza_type_id
group by pt.name
order by Total_quantity desc
limit 5;

#Determine the distribution of orders by hour of the day.
select EXTRACT(hour from time) as hour_of_order, count(order_id) as orders_done
from orders o
group by hour_of_order
order by hour_of_order;

#Determine the top 3 most ordered pizza types based on revenue.
select pt.name, round(sum(od.quantity * p.price),2) as revenue
from order_details od
join pizzas p
on od.pizza_id = p.pizza_id
join pizza_types pt
on pt.pizza_type_id = p.pizza_type_id
group by pt.name
order by revenue desc
limit 3;

#Calculate the percentage contribution of each pizza type to total revenue
select od.pizza_id, pt.name, 
round(sum(od.quantity * p.price) * 100.0 / sum(sum(od.quantity * p.price)) over (), 2) as percent_contri
from order_details od
left join pizzas p 
on p.pizza_id = od.pizza_id
join pizza_types pt
on p.pizza_type_id = pt.pizza_type_id
group by od.pizza_id, pt.name, od.quantity, p.price
order by percent_contri desc;

#Analyze the cumulative revenue generated over time
select o.date, round(sum(SUM(od.quantity*p.price)) over (order by o.date),2) as cumulative_revenue
from orders o
join order_details od
on od.order_id = o.order_id
left join pizzas p
on p.pizza_id = od.pizza_id
group by o.date
order by o.date;

#Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select od.pizza_id, pt.name, 
round(sum(od.quantity * p.price), 2) as Revenue
from order_details od
left join pizzas p 
on p.pizza_id = od.pizza_id
join pizza_types pt
on p.pizza_type_id = pt.pizza_type_id
group by od.pizza_id, pt.name, od.quantity, p.price
order by Revenue desc
limit 3;


#Join the necessary tables to find the total quantity of each pizza category ordered
select pt.name, sum(od.quantity) as Total_Quantity
from order_details od
left join pizzas p
on p.pizza_id = od.pizza_id
join pizza_types pt
on pt.pizza_type_id = p.pizza_type_id
group by pt.name
order by Total_Quantity desc;

#Join relevant tables to find the category-wise distribution of pizzas
select pt.name, round(sum(od.quantity)*100.0/ sum(sum(od.quantity)) over(),2) as percentage_overall
from order_details od
left join pizzas p
on p.pizza_id = od.pizza_id
join pizza_types pt
on pt.pizza_type_id = p.pizza_type_id
group by pt.name
order by percentage_overall desc;

#Group the orders by the date and calculate the average number of pizzas ordered per day.
select o.date , round(avg(od.quantity),2) as avg_rders_daily
from orders o
join order_details od
on od.order_id = o.order_id
group by o.date
order by o.date;

