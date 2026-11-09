Q1: Retrieve all customer records

select * from customers;

--Q2: Display customer names, cities, and segments

select customer_name,city,customer_segment
from customers;

--Q3: customers living in Nairobi
 
select *
 from customers c 
 where city = 'Nairobi';

--Q4: customers registered after January 1, 2025

select * 
from customers 
where registration_date > '2025-01-01';

--Q5: unique customer cities

select distinct city 
from customers;

--Q6: Retrieve the 10 most recent orders

select * 
from orders 
order by order_date desc
limit 10;

--Q7: orders with unit prices above KSh 10,000

select * 
from orders 
where unit_price >10000
order by unit_price desc;

--Q8: customers whose names start with A

select *
from customers 
where customer_name like 'A%';

--Q9: Retrieve orders with quantities between 2 and 5

select * 
from orders 
where quantity between 2 and 5
order by quantity desc;

--Q10: orders paid through M-Pesa

select * 
from orders 
where payment_method = 'M-Pesa';


--- B: Aggregation and grouping

select * from customers;
select * from orders;
--Q11: Count all customers

select count(*) as total_customers
from customers;

--Q12: Count all orders

select count(*) as total_orders
from orders;

--Q13: Calculate completed-order revenue

select sum(quantity * unit_price * (1 - discount / 100)) as total_revenue
from orders 
where order_status = 'Completed';

--Q14: Calculate the average completed-order value

select avg(quantity * unit_price * (1 - discount / 100)) as average_completed_order_value
from orders
where order_status = 'completed';


--Q15: highest and lowest product prices

select max(unit_price) AS highest_price,
    min(unit_price) AS lowest_price
from orders;

--Q16: revenue by product category

select product_category,
sum(quantity * unit_price * (1 - discount / 100.0)) as total_revenue
from orders
where order_status = 'Completed'
group by product_category
order by total_revenue desc;

--Q17: Count customers by city

select city,
count(customer_id) as total_customers
from customers
group by city
order by total_customers desc;

--Q18: quantity sold by product

select product_name,
   sum(quantity) as total_quantity_sold
from orders
where order_status = 'Completed'
group by product_name
order by total_quantity_sold desc;

--Q19: categories generating more than KSh 100,000 in revenue

select product_category,
        sum(quantity * unit_price * (1 - discount / 100.0)) as total_revenue
from orders
where order_status = 'Completed'
group by product_category
having sum(quantity * unit_price * (1 - discount / 100.0)) > 100000
order by total_revenue desc;

--Q20:  percentage of cancelled orders

select
        100.0 * count(*) FILTER (
            WHERE order_status = 'Cancelled')/ NULLIF(COUNT(*), 0) as cancelled_order_percentage
from orders;

---C Joins and customer analytics

--Q21: Display orders with customer names and cities

select o.order_id,
     c.customer_name,
     c.city
from orders o
join customers c on o.customer_id = c.customer_id;

--Q22: total spending by customer

select c.customer_id,c.customer_name,
    coalesce( round(sum(o.quantity * o.unit_price * (1 - o.discount / 100.0)),2),0) as total_spending
from customers c
left join orders o on c.customer_id = o.customer_id 
   and o.order_status = 'Completed'
group by c.customer_id, c.customer_name
order by total_spending desc;

--Q23: customers who have never ordered

select c.customer_id,c.customer_name
from customers c
left join orders o on c.customer_id = o.customer_id
where o.order_id is null;

--Q24: 10 highest-spending customers

select c.customer_id, c.customer_name,
    round(sum(o.quantity * o.unit_price * (1 - o.discount / 100.0)),2) as total_spending
from customers c
join orders o on c.customer_id = o.customer_id
where o.order_status = 'Completed'
group by c.customer_id, c.customer_name
order by total_spending desc
limit 10;

--Q25: revenue by customer city

select c.city,
    round(sum(o.quantity * o.unit_price * (1 - o.discount / 100.0)),2) as city_revenue
from customers c
join orders o on c.customer_id = o.customer_id
where o.order_status = 'Completed'
group by c.city
order by city_revenue desc;

--Q26:  customers with more than five orders

select c.customer_id, c.customer_name,
     count(o.order_id) as total_orders
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having count(o.order_id) > 5
order by total_orders desc;

--Q27: average customer spending by segment

with customer_spending as (
    select c.customer_id, c.customer_name, c.customer_segment,
        coalesce(sum(o.quantity * o.unit_price * (1 - o.discount / 100.0)),0) as total_spending
    from customers c
    left join orders o on c.customer_id = o.customer_id
      and o.order_status = 'Completed'
    group by c.customer_id, c.customer_name, c.customer_segment)
select
    customer_segment,
    round(avg(total_spending), 2) as average_customer_spending
from customer_spending
group by customer_segment
order by average_customer_spending desc;

select * from customers;

--Q28: most popular category among VIP customers

select o.product_category,
    sum(o.quantity) as total_quantity_sold,
    count(o.order_id) as total_orders
from customers c
join orders o on c.customer_id = o.customer_id
where c.customer_segment = 'VIP'
  and o.order_status = 'Completed'
group by o.product_category
order by total_quantity_sold desc
limit 1;

---D Subqueries and CTEs

--Q29: customers spending above the average total spending per purchasing customer
  
with customer_spending as (
    select c.customer_id, c.customer_name,
        coalesce(sum(o.quantity * o.unit_price * (1 - o.discount / 100.0)),0) as total_spending
    from customers c
    left join orders o on c.customer_id = o.customer_id
       and o.order_status = 'Completed'
    group by c.customer_id, c.customer_name)
select customer_id, customer_name,
    round(total_spending, 2) as total_spending
from customer_spending
where total_spending > (
    select avg(total_spending)
    from customer_spending
    where total_spending > 0)
order by total_spending desc;

--Q30: products priced above the overall average unit price

 select distinct product_name, unit_price
from orders
where unit_price > (
    select avg(unit_price)
    from orders)
order by unit_price desc;

--Q31: CTE to identify the three highest-revenue months

select date_trunc('month', order_date)::date as sales_month,
    round(sum(quantity * unit_price * (1 - discount / 100.0)),2) as monthly_revenue
from orders
where order_status = 'Completed'
group by date_trunc('month', order_date)
order by monthly_revenue desc
limit 3;

--Q32: customers purchasing from at least three categories

select c.customer_id, c.customer_name,
    count(distinct o.product_category) as categories_purchased
from customers c
join orders o on c.customer_id = o.customer_id
where o.order_status = 'Completed'
group by c.customer_id, c.customer_name
having count(distinct o.product_category) >= 3
order by categories_purchased desc;

--Q33: calculate category revenue, cost, profit, and profit margin

select product_category,
    round(sum(quantity * unit_price * (1 - discount / 100.0)),2) as total_revenue,
round(sum(quantity * cost_price),2) as total_cost,
round(sum(quantity * unit_price * (1 - discount / 100.0)- quantity * cost_price),2) as total_profit,
round(100.0 * sum(quantity * unit_price * (1 - discount / 100.0) - quantity * cost_price
) / nullif(sum(quantity * unit_price * (1 - discount / 100.0)),0),2) AS profit_margin_percentage
from orders
where order_status = 'Completed'
group by product_category
order by total_profit desc;

--Q34: customers whose latest completed order is more than 90 days before the latest order date in the dataset.

WITH latest_dataset_order AS (
    SELECT MAX(order_date) AS latest_order_date
    FROM orders
),
customer_latest_order AS (
    SELECT
        customer_id,
        MAX(order_date) AS last_completed_order
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.customer_name,
    clo.last_completed_order,
    ldo.latest_order_date
FROM customer_latest_order clo
JOIN customers c
    ON c.customer_id = clo.customer_id
CROSS JOIN latest_dataset_order ldo
WHERE clo.last_completed_order < ldo.latest_order_date - INTERVAL '90 days'
ORDER BY clo.last_completed_order;

---E: Window functions

--Q35: Rank customers by spending using RANK()

WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(
            o.quantity * o.unit_price * (1 - o.discount / 100.0)
        ) AS total_spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    ROUND(total_spending, 2) AS total_spending,
    RANK() OVER (
        ORDER BY total_spending DESC
    ) AS spending_rank
FROM customer_spending
ORDER BY spending_rank;

--Q36: Number each customer's orders by recency using ROW_NUMBER()

select customer_id, order_id, order_date, order_status,
    row_number() over ( partition by customer_id
    order by order_date DESC, order_id desc) as order_recency_number
from orders
order by customer_id, order_recency_number;

--Q37: Rank products within categories using DENSE_RANK()

WITH product_revenue AS (
    SELECT
        product_category,
        product_name,
        SUM(
            quantity * unit_price * (1 - discount / 100.0)
        ) AS total_revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY product_category, product_name
)
SELECT
    product_category,
    product_name,
    ROUND(total_revenue, 2) AS total_revenue,
    DENSE_RANK() OVER (
        PARTITION BY product_category
        ORDER BY total_revenue DESC
    ) AS category_product_rank
FROM product_revenue
ORDER BY product_category, category_product_rank;

--Q38: cumulative monthly revenue

WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', order_date)::date AS sales_month,
        SUM(
            quantity * unit_price * (1 - discount / 100.0)
        ) AS revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    sales_month,
    ROUND(revenue, 2) AS monthly_revenue,
    ROUND(
        SUM(revenue) OVER (
            ORDER BY sales_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_revenue
FROM monthly_revenue
ORDER BY sales_month;

--Q39: Compare monthly revenue using LAG()

WITH month_calendar AS (
    SELECT GENERATE_SERIES(
        DATE_TRUNC('month', MIN(order_date)),
        DATE_TRUNC('month', MAX(order_date)),
        INTERVAL '1 month'
    )::date AS sales_month
    FROM orders
),
monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', order_date)::date AS sales_month,
        SUM(
            quantity * unit_price * (1 - discount / 100.0)
        ) AS revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_TRUNC('month', order_date)
),
monthly_comparison AS (
    SELECT
        mc.sales_month,
        COALESCE(mr.revenue, 0) AS revenue
    FROM month_calendar mc
    LEFT JOIN monthly_revenue mr
        ON mc.sales_month = mr.sales_month
)
SELECT
    sales_month,
    ROUND(revenue, 2) AS current_month_revenue,
    ROUND(
        LAG(revenue) OVER (ORDER BY sales_month),
        2
    ) AS previous_month_revenue
FROM monthly_comparison
ORDER BY sales_month;

--Q40: Calculate month-over-month revenue growth (%)

WITH month_calendar AS (
    SELECT GENERATE_SERIES(
        DATE_TRUNC('month', MIN(order_date)),
        DATE_TRUNC('month', MAX(order_date)),
        INTERVAL '1 month'
    )::date AS sales_month
    FROM orders
),
monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', order_date)::date AS sales_month,
        SUM(
            quantity * unit_price * (1 - discount / 100.0)
        ) AS revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_TRUNC('month', order_date)
),
monthly_comparison AS (
    SELECT
        mc.sales_month,
        COALESCE(mr.revenue, 0) AS revenue
    FROM month_calendar mc
    LEFT JOIN monthly_revenue mr
        ON mc.sales_month = mr.sales_month
),
revenue_with_previous AS (
    SELECT
        sales_month,
        revenue,
        LAG(revenue) OVER (ORDER BY sales_month) AS previous_revenue
    FROM monthly_comparison
)
SELECT
    sales_month,
    ROUND(revenue, 2) AS current_revenue,
    ROUND(previous_revenue, 2) AS previous_revenue,
    ROUND(
        100.0 * (revenue - previous_revenue)
        / NULLIF(previous_revenue, 0),
        2
    ) AS growth_percentage
FROM revenue_with_previous
ORDER BY sales_month;

--Q41: Divide customers into four spending groups using NTILE(4)

with customer_spending as (
    select c.customer_id, c.customer_name,
        coalesce(sum(o.quantity * o.unit_price * (1 - o.discount / 100.0)),0) as total_spending
    from customers c
    left join orders o on c.customer_id = o.customer_id
       and o.order_status = 'Completed'
    group by c.customer_id, c.customer_name
)
select customer_id, customer_name,
    round(total_spending, 2) as total_spending,
    ntile(4) over (
    order by total_spending desc) as spending_quartile
from customer_spending
order by spending_quartile, total_spending desc;

--Q42: Calculate each category's share of total revenue using window functions

with category_revenue as (
    select product_category,
    sum(quantity * unit_price * (1 - discount / 100.0)) as total_revenue
    from orders
    where order_status = 'Completed'
    group by product_category
)
select product_category,
    round(total_revenue, 2) as total_revenue,
    round(100.0 * total_revenue
 / nullif(sum(total_revenue) over (), 0),2) as revenue_percentage_share
from category_revenue
order by total_revenue desc;

---F: Advanced business intelligence

--Q43: Create a monthly_sales_summary view (month, orders, revenue, cost, profit), then select from it.

create or replace view monthly_sales_summary as
select
    date_trunc('month', order_date)::date as sales_month,
    count(*) as total_orders,
    sum(quantity) as total_quantity_sold,
    round(sum(quantity * unit_price * (1 - discount / 100.0)),2) as total_revenue,
    round(sum(quantity * cost_price),2) as total_cost,
    round(sum(quantity * unit_price * (1 - discount / 100.) - quantity * cost_price),2) as total_profit
from orders
where order_status = 'Completed'
group by date_trunc('month', order_date);

select * from monthly_sales_summary;

--Q44: Create a PL/pgSQL function that returns completed-order revenue for a supplied customer ID — show it for one customer and for an ID that does not exist (it must return 0)

create or replace function get_customer_revenue( p_customer_id integer
)
returns numeric
language plpgsql
as $$
DECLARE
    v_total_revenue NUMERIC;
BEGIN
    SELECT
        COALESCE(
            SUM(
                quantity * unit_price * (1 - discount / 100.0)
            ),
            0
        )
    INTO v_total_revenue
    FROM orders
    WHERE customer_id = p_customer_id
      AND order_status = 'Completed';

    RETURN ROUND(v_total_revenue, 2);
END;
$$;

--Q45: Segment customers into High, Medium and Low Value, and explain why you chose your thresholds

WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COALESCE(
            SUM(
                o.quantity * o.unit_price * (1 - o.discount / 100.0)
            ),
            0
        ) AS total_spending
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
       AND o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
),
ranked_customers AS (
    SELECT
        customer_id,
        customer_name,
        total_spending,
        NTILE(4) OVER (
            ORDER BY total_spending DESC
        ) AS spending_quartile
    FROM customer_spending
)
SELECT
    customer_id,
    customer_name,
    ROUND(total_spending, 2) AS total_spending,
    CASE
        WHEN spending_quartile = 1 THEN 'High'
        WHEN spending_quartile IN (2, 3) THEN 'Medium'
        ELSE 'Low'
    END AS customer_segment
FROM ranked_customers
ORDER BY total_spending DESC;

--Q46: Produce a management report: top five customers, top five products, the most profitable category, and the lowest-revenue month

---top five customers
select c.customer_id, c.customer_name,
    round(
        sum(o.quantity * o.unit_price * (1 - o.discount / 100.0)),2) as total_spending
from customers c
join orders o on c.customer_id = o.customer_id
where  o.order_status = 'Completed'
group by c.customer_id, c.customer_name
order by total_spending desc
limit 5;

---top five products
select product_name,
    sum(quantity) as total_quantity_sold,
    round(sum(quantity * unit_price * (1 - discount / 100.0)),2) as total_revenue
from orders
where order_status = 'Completed'
group by product_name
order by total_revenue desc
limit 5;

---most profitable category
select product_category,
    round(sum(quantity * unit_price * (1 - discount / 100.0) - quantity * cost_price),2) as total_profit
from orders
where order_status = 'Completed'
group by product_category
order by total_profit desc
limit 1;

---lowest-revenue month
select
    date_trunc('month', order_date)::date as sales_month,
    round(sum(quantity * unit_price * (1 - discount / 100.0)),2) as monthly_revenue
from orders
where order_status = 'Completed'
group by date_trunc('month', order_date)
order by monthly_revenue asc
limit 1;