
CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY, 
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT, 
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale int
);


select * from retail_Sales
select count(*) from retail_sales

--Data Cleaning
select * from retail_Sales
where transaction_id is NULL;

select * from retail_Sales
where sale_date is NULL;


DELETE from retail_Sales
where
	transaction_id is NULL
	or
	sale_date is NULL
	or 
	sale_time is NULL
	or 
	customer_id is NULL
	or
	gender is NULL
	or 
	age is NULL
	or 
	Category is NULL
	or 
	quantity is NULL
	or 
	Price_per_unit is NULL
	or 
	cogs is NULL
	or 
	total_sale is NULL


-- Data Expolation

--How many sales we have?
select COUNT(*) as total_sale from retail_sales

-- How many customers we have?
select count(Distinct customer_id) as total_sale from retail_sales 

-- show all different category present in it?
select distinct category from retail_sales


---Data Analysis & Business key Problem & Answers

--1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select * from retail_Sales 
where 
	sale_date='2022-11-05'
	
--2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select * from retail_Sales
where
	category ='Clothing' 
	and quantity>=4 
	-- another method TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	and sale_date between'2022-11-1' and '2022-11-30' 

--3. Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

--ANOTHER METHOD
-- select category, sum(total_sale) from retail_sales
-- group by category


--4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

select round(avg(age),0) as avg_age from retail_Sales
where category='Beauty'
--5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select * from retail_sales 
where
	total_sale>1000
	
--6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select gender,count(transaction_id) as total_transaction from retail_sales 
group by gender

--7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT 
    year,
    month,
    avg_sale
FROM 
(
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY year , month 
) AS t1
WHERE rank = 1;


--8. Write a SQL query to find the top 5 customers based on the highest total sales **:
select customer_id, sum(Total_sale) AS total_Sales from retail_sales
group by customer_id 
order by 2 DESC
limit 5
--9. Write a SQL query to find the number of unique customers who purchased items from each category.:
select count(distinct(customer_id)) as cnt_unique_category
from retail_Sales
group by category
--10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

with hourly_sale
AS
(
select *,
	case
		when EXTRACT(HOUR FROM sale_time)<12 then 'morning'
		when EXTRACT(HOUR FROM sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
		

	END as shift
from retail_sales
)
select shift,count(*) as total_orders
from hourly_Sale
group by shift 
order by total_orders


 