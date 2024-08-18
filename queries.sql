/*запрос, который считает общее количество покупателей из таблицы customers*/
select
    count(customer_id) as customers_count
from customers;

/*запрос по определению десятки лучших продавцов*/
select
    concat(e.first_name, ' ', e.last_name) as seller,
    count(s.sales_id) as operation,
    floor(sum(p.price * s.quantity)) as income
from sales as s
inner join employees as e
    on s.sales_person_id = e.employee_id
inner join products as p
    on s.product_id = p.product_id
group by e.first_name, e.last_name
order by income desc
limit 10;

/*запрос по поиску продавцах, чья средняя выручка за сделку меньше 
 * средней выручки за сделку по всем продавцам*/
select
    concat(e.first_name, ' ', e.last_name) as seller,
    floor(avg(p.price * s.quantity)) as average_income
from employees as e
inner join sales as s
    on e.employee_id = s.sales_person_id
inner join products as p
    on s.product_id = p.product_id
group by e.employee_id
having
    avg(p.price * s.quantity) < (
        select
            avg(avg_income)
        from (
            select
                avg(s.quantity * p.price) as avg_income
            from employees as e
            inner join sales as s
                on e.employee_id = s.sales_person_id
            inner join products as p
                on s.product_id = p.product_id
            group by e.employee_id
        ) as subquery
    )
order by average_income;

/*запрос, который содержит информацию о выручке по дням недели*/
with tab as (
    select
        concat(e.first_name, ' ', e.last_name) as seller,
        to_char(s.sale_date, 'Day') as day_of_week,
        to_char(s.sale_date, 'ID') as day_of_week_id,
        p.price,
        s.quantity
    from sales as s
    inner join employees as e
        on s.sales_person_id = e.employee_id
    inner join products as p
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

/*запрос, который подсчитывает количество покупателей в разных возрастных группах*/
 select
    case
        when age between 16 and 25 then '16-25'
        when age between 26 and 40 then '26-40'
        else '40+'
    end as age_category,
    count(*) as age_count
from customers
group by age_category
order by age_category;

/*запрос, который подсчитывает количество уникальных покупателей 
 и выручку, которую они принесли*/
select
    to_char(s.sale_date, 'YYYY-MM') as selling_month,
    count(distinct(s.customer_id)) as total_customers,
    floor(sum(p.price * s.quantity)) as income
from sales as s
inner join products as p
    on s.product_id = p.product_id
group by selling_month
order by selling_month;
