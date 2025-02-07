-- SQl Retail sales analysis
create table retail_sales (
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(20),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM retail_sales LIMIT 10;

SELECT COUNT(*) FROM retail_sales ;

-- Data Cleaning

SELECT * FROM retail_sales WHERE 
	
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	category IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

	DELETE FROM retail_sales WHERE 
	
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	category IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Data Exploration

--Total number of sales

SELECT COUNT(*) AS Total_Sales FROM retail_sales ;

--Total number of distinct customers

SELECT COUNT(DISTINCT customer_id) AS No_0f_Customers FROM retail_sales;

--Total number of distinct category

SELECT COUNT(DISTINCT category) AS No_0f_Categories FROM retail_sales;

--Different Categories

SELECT DISTINCT category FROM retail_sales

--Data Analysis & Business key problems & Answers

--My Analysis & Findings

--Q1. Write a SQL Query to retrieve all columns for sales made on '2022-11-05'

SELECT * FROM retail_sales WHERE sale_date='2022-11-05'

--Q2. Write a SQL Query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month Nov 2022

SELECT * FROM retail_sales WHERE category='Clothing' AND quantity>3 AND TO_CHAR(sale_date,'YYYY-MM')='2022-11'

--Q3. Write a SQL Query to calculate the total sales for each category

SELECT DISTINCT category,SUM(total_sale) AS Net_profit,COUNT(*) AS No_of_orders FROM retail_sales GROUP BY category

--Q4. Write a SQL Query to find the average age of customers who purchased item from the 'Beauty' category

SELECT ROUND(AVG(age),2) AS AVG_AGE FROM retail_sales WHERE category='Beauty'

--Q5. Write a SQL Query to find all the transactions where the total sale is greater than 1000.

SELECT * FROM retail_sales WHERE total_sale > 1000;

--Q6. Write a SQL Query to find the total number of transactions (transactio_id)made by each gender in each category

SELECT gender,category,COUNT(transactions_id) AS Total_transaction FROM retail_sales GROUP BY Category,gender ORDER BY 1

--Q7. Write a SQL Query to Calculate the average sale for each month.Find out best selling month in each year

SELECT Year,Month,AVG_SALE FROM
(
	SELECT EXTRACT(YEAR FROM sale_date) AS Year, 
	EXTRACT(MONTH FROM sale_date) AS Month, 
	AVG(total_sale)AS AVG_SALE,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC) AS Rank
	FROM retail_sales GROUP BY 1,2
) AS T1 WHERE Rank=1

--Q8. Write a SQL Query to find the top 5 customers based on the highest total sales

SELECT customer_id,SUM(total_sale) FROM retail_sales GROUP BY 1 ORDER BY 2 DESC LIMIT 5

--Q9. Write a SQL Query to find the number of unique customers who purchased items from each category

SELECT category,COUNT(DISTINCT customer_id)AS Unique_customer FROM retail_sales GROUP BY category

--Q10. Write a SQL Query to create each shift and number of orders(Example Morning <12, Afternoon between 12 and 17,Evening>17)

WITH hourly_sale AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS Shift
FROM retail_sales
)
SELECT 
	Shift,
	COUNT(*)AS Total_orders
FROM hourly_sale
GROUP BY Shift