# retail-sales-sql
# Retail Sales Analysis

## 1. Project Overview

The Retail Sales SQL Analysis project analyses customer and sales transaction data using PostgreSQL.It investigates customer behaviour, sales performance, product performance, revenue generation, and business profitability.
The analysis consists of 46 SQL queries.
The main objective is to transform retail transaction data into meaningful business insights that can support management decision-making.

## 2. Project Objectives

The project aims to:

- Analyse customer distribution across different cities.
- Calculate total orders and completed-order revenue.
- Identify the highest-performing products and categories.
- Analyse customer spending patterns.
- Identify high-value customers.
- Evaluate product profitability and profit margins.
- Analyse monthly revenue trends and growth.
- Apply advanced SQL techniques to generate management reports.

## 3. Dataset Description

The project uses a database named `retail_analytics`.
It contains two main tables:

### Customers
It Stores customer information.
Key fields include:
- `customer_id`
- `city`
- `registration_date`
- `customer_segment`

### Orders
Stores retail transaction information.
Key fields include:

- `order_id`
- `customer_id`
- `order_date`
- `product_name`
- `product_category`
- `quantity`
- `unit_price`
- `cost_price`
- `discount`
- `payment_method`
- `order_status`

### Dataset Verification
The data verification script confirms:
- 150 customers.
- 800 orders.
- Five product categories.
- Three order statuses: Completed, Cancelled, and Pending.
- Order dates ranging from January 2025 to September 2026.
- No orders with missing customer references.

## 4. Tools and Technologies

| Tool | Purpose |
|---|---|
| PostgreSQL | Database management and querying |
| SQL | Data analysis and business reporting |
| GitHub | Project documentation and version control |

## 5. SQL Concepts 
The project contains 46 queries organised into six sections.

| Section | Questions | SQL Concepts |
|---|---|---|
| SQL Fundamentals | Q1–Q10 | SELECT, WHERE, DISTINCT, ORDER BY, LIKE |
| Aggregate Functions | Q11–Q20 | COUNT, SUM, AVG, GROUP BY, HAVING |
| Joins and Customer Analytics | Q21–Q28 | INNER JOIN, LEFT JOIN, GROUP BY |
| Subqueries and CTEs | Q29–Q34 | WITH, subqueries, DATE_TRUNC |
| Window Functions | Q35–Q42 | RANK, DENSE_RANK, LAG, NTILE |
| Advanced SQL and BI | Q43–Q46 | Views, functions, CASE statements |

## 6. Business Calculations

The project uses the following calculations:

Revenue	quantity * unit_price * (1 - discount / 100)
Cost	quantity * cost_price
Profit	revenue - cost
Profit margin %	profit / NULLIF(revenue, 0) * 100

**Revenue**

`Quantity × Unit Price × (1 - Discount / 100)`

**Cost**

`Quantity × Cost Price`

**Profit**

`Total Revenue - Total Cost`

**Profit Margin %**

`profit / NULLIF(revenue, 0) * 100`

Completed orders are used for sales revenue and profitability calculations. Pending and cancelled orders are excluded from completed-sales calculations.

## 7. Key Analysis Areas
### Customer Analysis
Investigates customer distribution, spending patterns, customer segments, and purchasing behaviour.

### Sales Analysis
Measures total revenue, average order value, cancelled orders, and monthly sales performance.

### Product Analysis
Identifies high-performing products and categories based on sales revenue, quantity sold, and profitability.

### Profitability Analysis
Calculates product category revenue, costs, gross profit, and profit margins.

### Business Intelligence
Creates reusable SQL views, customer revenue functions, customer segments, and management reports.

## 8. Key Findings and Business Insights
This file presents at least five business insights supported by actual SQL query results and screenshots.

## 9. Repository Structure

```text
retail-sales-sql/
│
├── README.md
├── schema.sql
├── queries.sql
│
└── screenshots/
    ├── 05_verify_data.png
    ├── customer_analysis.png
    ├── revenue_analysis.png
    ├── product_performance.png
    └── monthly_sales_trend.png
```

### File Descriptions

- `README.md` – Provides an overview of the project, objectives, tools, and methodology.
- `schema.sql` – Contains the SQL statements used to create the database tables.
- `queries.sql` – Contains all 46 SQL analysis queries, labelled Q1 to Q46.
- `screenshots/` – Stores screenshots showing query execution and analysis results.

## 10. How to Run the Project

1. Set up PostgreSQL and connect to the `retail_analytics` database.
2. Execute `schema.sql` to create the required tables.
3. Load the customer and order records into the database.
4. Execute the data verification script.
5. Run the queries in `queries.sql`.
6. Save relevant screenshots in the `screenshots/` folder.

## 11. Business Recommendations

Based on the results, management can consider:

- Introducing customer loyalty programmes to retain high-value customers.
- Improving marketing in cities with lower customer activity.
- Prioritising products and categories with strong profitability.
- Investigating the causes of cancelled orders.
- Monitoring monthly revenue to identify changes in sales performance.
- Using customer segmentation to improve targeted marketing.

## 12. Conclusion

This project demonstrates the practical application of PostgreSQL in retail business analysis.By applying the 46 SQL queries, the project explores customer behaviour, sales performance, product profitability, and revenue trends.
The results provide a foundation for data-driven decision-making.
