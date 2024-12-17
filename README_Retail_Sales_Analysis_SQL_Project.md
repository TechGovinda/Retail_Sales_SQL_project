# Retail Sales Analysis SQL Project

## Project Overview

This project demonstrates essential SQL skills and techniques commonly used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. It is ideal for beginners in data analysis who aim to build a strong foundation in SQL.

## Objectives

- **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
- **Data Cleaning**: Identify and remove any records with missing or null values.
- **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
- **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: Create a database named `p1_retail_db`.
- **Table Creation**: Create a table named `retail_sales` to store the sales data.

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find the total number of unique customers in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for null values in the dataset and delete records with missing data.

**SQL Queries:**

```sql
-- Total number of records
SELECT COUNT(*) FROM retail_sales;

-- Total number of unique customers
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- Unique product categories
SELECT DISTINCT category FROM retail_sales;

-- Check for null values in the dataset
SELECT * FROM retail_sales
WHERE  
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR  
    gender IS NULL OR age IS NULL OR category IS NULL OR  
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- Delete records with null values
DELETE FROM retail_sales
WHERE  
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR  
    gender IS NULL OR age IS NULL OR category IS NULL OR  
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were used to answer specific business questions:

1. **Sales made on '2022-11-05':**

```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Transactions where category is 'Clothing' and quantity is more than 4 in November 2022:**

```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
    AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND quantity > 4;
```

3. **Total sales for each category:**

```sql
SELECT category, SUM(total_sale) AS net_sale, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

4. **Average age of customers who purchased 'Beauty' products:**

```sql
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
```

5. **Transactions with total sales greater than 1000:**

```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

6. **Total number of transactions made by each gender in each category:**

```sql
SELECT category, gender, COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY category;
```

7. **Average sale for each month and best-selling month in each year:**

```sql
SELECT year, month, avg_sale
FROM (
    SELECT EXTRACT(YEAR FROM sale_date) AS year,
           EXTRACT(MONTH FROM sale_date) AS month,
           AVG(total_sale) AS avg_sale,
           RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY year, month
) AS ranked_sales
WHERE rank = 1;
```

8. **Top 5 customers based on the highest total sales:**

```sql
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

9. **Number of unique customers for each category:**

```sql
SELECT category, COUNT(DISTINCT customer_id) AS cnt_unique_cs
FROM retail_sales
GROUP BY category;
```

10. **Number of orders in different time shifts (Morning, Afternoon, Evening):**

```sql
WITH hourly_sale AS (
    SELECT *,
           CASE
               WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
               WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
               ELSE 'Evening'
           END AS shift
    FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
```

## Findings

- **Customer Demographics**: Customers of various age groups are present, with sales distributed across multiple categories such as Clothing and Beauty.
- **High-Value Transactions**: Transactions with a total sale amount greater than 1000 indicate premium purchases.
- **Sales Trends**: Monthly analysis highlights variations in sales, providing insights into peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: Detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings can help drive business decisions by providing insights into sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform the analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.
