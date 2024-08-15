/*запрос, который считает общее количество покупателей из таблицы customers*/
SELECT
    COUNT(customer_id) AS customers_count
FROM customers;

/*запрос по определению десятки лучших продавцов*/
select
    CONCAT(e.first_name, ' ', e.last_name) as seller,
    COUNT(s.sales_id) as operation,
    FLOOR(SUM(p.price * s.quantity)) as income
from sales s
inner join employees e 
on s.sales_person_id = e.employee_id 
inner join products p 
on s.product_id = p.product_id 
group by e.first_name, e.last_name 
order by income desc 
limit 10;

/*запрос по поиску продавцах, чья средняя выручка за сделку меньше 
 * средней выручки за сделку по всем продавцам*/
select
    CONCAT(e.first_name, ' ', e.last_name) as seller,
    FLOOR(AVG(p.price * s.quantity)) as average_income
from employees e 
inner join sales s 
on e.employee_id = s.sales_person_id 
inner join products p 
on s.product_id  = p.product_id 
group by e.employee_id 
having avg(p.price * s.quantity) < (
select 
    avg(avg_income)
from (
select
    avg(s.quantity * p.price) as avg_income
from employees e
inner join sales s 
on e.employee_id = s.sales_person_id
inner join products p 
on s.product_id = p.product_id
group by e.employee_id
) as subquery
)
order by average_income;

/*запрос, который содержит информацию о выручке по дням недели*/
with tab as (
select 
    concat(e.first_name, ' ', e.last_name) as seller,
    TO_CHAR(s.sale_date, 'Day') as day_of_week,
    TO_CHAR(s.sale_date, 'ID') as day_of_week_id,
    p.price as price,
    s.quantity as quantity
from sales s 
inner join employees e 
on s.sales_person_id = e.employee_id
inner join products p 
on s.product_id = p.product_id
order by to_char(s.sale_date, 'ID'), seller
)
select
    seller,
    day_of_week,
    floor(sum(price * quantity)) as income
from tab
group by seller, day_of_week, day_of_week_id
order by day_of_week_id, seller;

