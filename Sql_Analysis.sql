-- 1. Display all records
SELECT * FROM superstore_db.train;

-- 2. Check number of rows
select count(*) as Count_rows
from superstore_db.train;

-- 3. Check the columns and their data types
describe superstore_db.train;

-- 4. Check for NULL values
select count(*) as null_sales
from superstore_db.train
where Sales IS null;

-- 5.What is the total sales?
select sum(Sales) as Total_Sales
from superstore_db.train;

-- 6. What is the average sales?
select avg(Sales) as Average_Sales
from superstore_db.train;

-- 7. what is the fhighest salary
select max(Sales) as Highest_Sales
from superstore_db.train;

-- 8. What is the lowest sales
select min(Sales) as lowest_Sales
from superstore_db.train;

-- 9. How many unique order are there
select count(distinct `Order ID`)as Total_Order
from superstore_db.train;

-- 10. How many unique customer are there
select count(distinct `Customer ID`) as Total_Customer
from superstore_db.train;

-- 10. How many unique product are there
select count(distinct `Product ID`) as Total_Product
from superstore_db.train;

-- 11. category generates the highest sales?
select Category, sum(Sales) as Total_Sales
from superstore_db.train
group by Category
order by Total_Sales DESC;

-- 12. Category Performance
select Category,
round(sum(Sales),2) as Total_Sales,
round(avg(Sales),2) as Avg_Sales,
round(max(Sales),2) as Max_Sales,
count(distinct `Order ID`) as Total_Order
from superstore_db.train
group by Category
order by Total_Sales DESC;

-- 13. Segment Performance
-- Which customer segment generates the highest sales and has the highest number of orders?
select Segment,
round(sum(Sales),2) as Total_Sales,
round(avg(Sales),2) as Avg_Sales,
round(max(Sales),2) as Highest_Sales,
count(distinct `Order ID`) as Order_Count
from superstore_db.train
group by Segment
order by Total_Sales desc;

-- 15.State Performance
-- Which states generate the highest total sales?
select State,
round(sum(Sales),2) as Total_Sales,
round(avg(Sales),2) as Average_Sales,
round(max(Sales),2) as Highest_Sales,
count(distinct `Order ID`) as total_Order
from superstore_db.train
group by State
order by total_Sales desc limit 10;

-- 16. Region Performance
-- Which region generates the highest total sales?
select Region,
round(sum(Sales),2)as Total_Sales,
round(avg(Sales),2)as Avg_Sales,
round(max(Sales),2) as Highest_Sales,
count(distinct `Order ID`) as Total_Orders
from superstore_db.train
group by Region
order by Total_Sales desc ;

-- 17. Sub-Category Performance
-- Which sub-categories generate the highest sales?
select `Sub-Category`,
round(sum(Sales),2)as Total_Sales,
round(avg(Sales),2)as Avg_Sales,
round(max(Sales),2) as Highest_Sales,
count(distinct `Order ID`) as Total_Orders
from superstore_db.train
group by `Sub-Category`
order by Total_Sales desc ;

-- Top 10 Products
-- What are the top 10 products based on total sales?
select `Product Name`,
round(sum(Sales),2)as Total_Sales,
round(avg(Sales),2)as Avg_Sales,
round(max(Sales),2) as Highest_Sales,
count(distinct `Order ID`) as Total_Orders
from superstore_db.train
group by `Product Name`
order by Total_Sales desc limit 10;

-- Which 10 products generate the lowest total sales?
select `Product Name`,
round(sum(Sales),2)as Total_Sales,
round(avg(Sales),2)as Avg_Sales,
round(max(Sales),2) as Highest_Sales,
count(distinct `Order ID`) as Total_Orders
from superstore_db.train
group by `Product Name`
order by Total_Sales asc limit 10;

-- Who are the top 10 customers based on total sales?
select `Customer ID`,`customer Name`,
round(sum(Sales),2) as Total_Sales,
count(distinct `Order ID`) as Total_Order
from superstore_db.train
group by `Customer ID`,`customer Name`
order by Total_Sales desc 
limit 10;

-- Customer Filtering
-- Which customers have total sales greater than 1,000?
select `Customer ID`,`Customer Name`,
round(sum(Sales),2) as Total_Sales,
round(avg(Sales),2) as Average_Sales,
count(distinct `Order ID`) as Total_Orders
from superstore_db.train
group by `Customer ID`,`Customer Name`
having Total_Sales > 1000
order by Total_Sales desc;

SELECT
    `Customer Name`,
    SUM(Sales) AS Total_Sales
FROM superstore_db.train
GROUP BY `Customer Name`
HAVING Total_Sales > 1000;

-- Which customers from the Consumer segment have total sales greater than 500?
select `Customer Name`,`Customer ID`,
round(sum(Sales),2) as Total_Sales
from superstore_db.train
where Segment = "Consumer"
group by `Customer Name`,`Customer ID`
having  sum(Sales)> 500
order by Total_Sales desc;

-- Find the top 5 highest-selling orders
select `Customer Name`,Sales,
row_number() over(order by Sales Desc) as Rownum 
from superstore_db.train limit 5;

-- Write the SQL query to find the top 5 customers by total sales.
select `Customer ID`,`Customer Name`,sum(Sales) as Total_Sales
from superstore_db.train
group by  `Customer ID`,`Customer Name` order by Total_Sales desc 
limit 5; 

-- Find the categories whose total sales are greater than the average sales across all categories.
select Category,sum(Sales)as Total_sales
from superstore_db.train
group by Category;


select Category,Total_Sales
from(select category,sum(Sales)as Total_Sales
from superstore_db.train
group by Category) as Category_Sales
WHERE Total_Sales >
(
    SELECT AVG(Total_Sales)
    FROM (
        SELECT
            Category,
            SUM(Sales) AS Total_Sales
        FROM superstore_db.train
        GROUP BY Category
    ) AS Category_Averages
);


-- Calculates total sales for each customer and assigns a ROW_NUMBER() based on total sales from highest to lowest.
select `Customer ID`,`Customer Name`,
sum(Sales)as Total_Sales,
row_number() over(order by sum(Sales) desc) as row_num
from superstore_db.train
group by `Customer Name`,`Customer ID`;


-- Calculate total sales for each customer and assign a RANK() based on total sales 
-- from highest to lowest.
select `Customer Name`,`Customer ID`,
sum(Sales)as Total_Sales,
rank() over(order by sum(Sales) desc)as rank_order
from superstore_db.train
group by `Customer ID`,`Customer Name`;


-- Calculate total sales for each customer and assign a DENSE_RANK() based on total sales from highest to lowest.
select `Customer Name`,`Customer ID`,
sum(Sales)as Total_Sales,
dense_rank() over(order by sum(Sales) desc)as rank_order
from superstore_db.train
group by `Customer ID`,`Customer Name`;

-- PARTITION BY
-- Rank customers by their total sales within each Segment
select `Customer ID`,`Customer Name`,Segment,
sum(Sales) as Total_Sales,
rank()over(partition by Segment
order by sum(Sales)desc) as Customer_rank
from superstore_db.train
group by `Customer ID`, `Customer Name`, Segment;

-- Find the top 3 customers by total sales within each Segment.
with CustomerRank as(
select `Customer ID`,`Customer Name`,Segment,
sum(Sales)as Total_Sales,
row_number()
over(partition by Segment
order by sum(Sales) desc)as Customer_rank
from superstore_db.train
group by `Customer ID`,`Customer Name`,Segment
)
select * from CustomerRank where Customer_rank <=3;


-- Find the top 3 sales ranks in each Segment, including customers tied at the third rank.
with CustomerRank as(
select `Customer ID`,`Customer Name`,Segment,
sum(Sales)as Total_Sales,
rank()
over(partition by Segment
order by sum(Sales) desc)as Customer_rank
from superstore_db.train
group by `Customer ID`,`Customer Name`,Segment
)
select * from CustomerRank where Customer_rank <=3;

-- Challenge: Find each segment's highest-selling customer(s), including ties.
with HighSellCustomer as(
select `Customer ID`,`Customer Name`,Segment,
sum(Sales)as Total_Sales,
rank()over(partition by Segment
order by sum(Sales)desc)as rn
from superstore_db.train
group by `Customer ID`,`Customer Name`,Segment
)
select * from HighSellCustomer where rn <=1;

-- write a query that displays:
-- Order ID,-- Sales,-- A new column named Sales_Category
select `Order ID`,Sales,
case
when Sales >=500 then "High Sales"
when Sales >=100 then "Medium Sales"
else "Low Sales"
end as Sales_Category
from superstore_db.train;


-- Count how many order lines fall into each sales category (High, Medium, Low).
select 
Sales_Category,
count(*)as Order_line_count
from(
select `Order ID`,Sales,
case
when Sales >=500 then "High Sales"
when Sales >=100 then "Medium Sales"
else "Low Sales"
end as Sales_Category
from superstore_db.train
)as SalesData
group by Sales_Category;

-- Calculate the total sales amount for each Sales Category.
with SalesData as(
select `Order ID`,Sales,
case
when Sales >=500 then "High Sales"
when Sales >=100 then "Medium Sales"
else "Low Sales"
end as Sales_Category
from superstore_db.train
)
select Sales_Category,
sum(Sales) as Total_Sales_Category
from SalesData
group by Sales_Category;

-- Classify customers based on their total sales:
-- High Value → Total Sales >= 5,000
-- Medium Value → Total Sales >= 2,000
-- Low Value → Total Sales < 2,000
with CustomerSales as(
select `Customer ID`,`Customer Name`,
sum(Sales) as Total_Sales
from superstore_db.train
group by `Customer ID`,`Customer Name`
)
SELECT
    `Customer ID`,
    `Customer Name`,
    Total_Sales,
    CASE
        WHEN Total_Sales >= 5000 THEN 'High Value'
        WHEN Total_Sales >= 2000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Customer_Category
FROM CustomerSales;

-- Count how many customers belong to each Customer Category (High Value, Medium Value, Low Value).
with CustomerSales as(
select `Customer ID`,`Customer Name`,
sum(Sales) as Total_Sales
from superstore_db.train
group by`Customer ID`,`Customer Name`),
customerCategories as(
SELECT
        `Customer ID`,
        `Customer Name`,
        Total_Sales,
        CASE
            WHEN Total_Sales >= 5000 THEN 'High Value'
            WHEN Total_Sales >= 2000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS Customer_Category
    FROM CustomerSales
)
SELECT
    Customer_Category,
    COUNT(*) AS Customer_Count
FROM CustomerCategories
GROUP BY Customer_Category;

-- Which customers have never placed an order?
select Customers.Customer_ID,
Customers.Customer_Name,
sum(Orders.Sales)as total_Sales
from customers
left join Orders
on Customers.Customer_ID=Orders.Customer_ID
group by Customers.Customer_ID,Customers.Customer_Name ;

-- Find customers whose total sales are greater than 600.
SELECT
    Customers.Customer_ID,
    Customers.Customer_Name,
    SUM(Orders.Sales) AS Total_Sales
FROM Customers
INNER JOIN Orders
    ON Customers.Customer_ID = Orders.Customer_ID
GROUP BY
    Customers.Customer_ID,
    Customers.Customer_Name
HAVING Total_Sales > 600;


-- Find the total sales generated by each customer using Customers and Orders.
SELECT
    Customers.Customer_ID,
    Customers.Customer_Name,
    SUM(Orders.Sales) AS Total_Sales
FROM Customers
INNER JOIN Orders
    ON Customers.Customer_ID = Orders.Customer_ID
GROUP BY
    Customers.Customer_ID,
    Customers.Customer_Name;

-- Which customers generated the highest sales for each product category?
select 
Customers.Cutomer_Name,
Orders.Order_ID,
Orders.Product_ID,
products.Product_Name,
Products.Category,
Orders.Sales
from customers
inner join Orders 
ON Customers.Customer_ID = Orders.Customer_ID
inner join Products
on Orders.Product_ID = Products.Product_ID;

-- Find the total sales for each customer and product category.
select 
Customers.Customer_Name,
Products.Category,
sum(Orders.Sales)as Total_Sales
from customers
inner join Orders 
ON Customers.Customer_ID = Orders.Customer_ID
inner join Products
on Orders.Product_ID = Products.Product_ID
group by Customers.Customer_Name,
Products.Category;

-- Find the total sales for each product category and show only 
-- categories where total sales are greater than 1,000.
select 
Customers.Customer_Name,
Products.Category,
sum(Orders.Sales)as Total_Sales
from customers
inner join Orders 
ON Customers.Customer_ID = Orders.Customer_ID
inner join Products
on Orders.Product_ID = Products.Product_ID
group by Customers.Customer_Name,
Products.Category
Having Total_Sales > 1000;

-- Find the top 3 product categories by total sales.
select Products.Category,
sum(Orders.Sales)as Total_Sales
from Orders
inner join Products
on Orders.Product_ID = Products.Product_ID
group by Products.Category
Order by Total_Sales desc
limit 3;


-- How much total sales were generated in each year?
select year(`Order Date`)as Order_Year,
sum(Sales)as Total_Sales
from superstore_db.train
group by YEAR(`Order Date`)
order by Order_Year desc;

-- Checking Actual Values
select `Order Date`
from superstore_db.train
limit 10;

describe superstore_db.train;

-- convwerting string to date
SELECT
    YEAR(STR_TO_DATE(`Order Date`, '%m/%d/%Y')) AS Order_Year,
    SUM(Sales) AS Total_Sales
FROM superstore_db.train
GROUP BY YEAR(STR_TO_DATE(`Order Date`, '%m/%d/%Y'))
ORDER BY Order_Year DESC;

SELECT
    `Order Date`,
    Sales
FROM superstore_db.train
WHERE STR_TO_DATE(`Order Date`, '%m/%d/%Y') IS NULL;

SELECT
    COUNT(*) AS Invalid_Dates,
    SUM(Sales) AS Sales_From_Invalid_Dates
FROM superstore_db.train
WHERE STR_TO_DATE(`Order Date`, '%m/%d/%Y') IS NULL;

select distinct `Order Date`
from superstore_db.train
where STR_TO_DATE(`Order Date`, '%m/%d/%Y') IS NULL;

-- Create a robust date conversion
-- Because dates where the first number is greater than 12 must be DD/MM/YYYY,
SELECT
    `Order Date`,
    CASE
        WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
            THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
        ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
    END AS Converted_Date
FROM superstore_db.train
LIMIT 20;

-- calculate yearly sales correctly
SELECT
    YEAR(
        CASE
            WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
            ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
        END
    ) AS Order_Year,

    SUM(Sales) AS Total_Sales

FROM superstore_db.train

GROUP BY
    YEAR(
        CASE
            WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
            ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
        END
    )

ORDER BY Order_Year DESC;

-- Monthly Sales Analysis
-- Step 1: Convert the text into a real date
select`Order Date`,
case
when cast(substring_index(`Order Date`,'/',1)as unsigned)>12
THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
        ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
    END AS Converted_Date
FROM superstore_db.train
LIMIT 10;

-- Step 2: Extract the year
SELECT
    YEAR(
        CASE
            WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
            ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
        END
    ) AS Order_Year,
    -- -- Extract the month
    MONTHNAME(
        CASE
            WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
            ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
        END
    ) AS Order_Month,
    SUM(Sales) AS Total_Sales

FROM superstore_db.train

GROUP BY
    YEAR(
        CASE
            WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
            ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
        END
    ),
    MONTHName(
        CASE
            WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
            ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
        END
    )

ORDER BY
    Order_Year,
    Order_Month;


-- How much total sales were generated in each quarter of each year?
select year (
case
when CAST(substring_index(`Order Date`,'/',1)AS UNSIGNED)>12
THEN str_to_date(`Order Date`,'%d/%m/%Y')
ELSE str_to_date(`Order Date`,'%m/%d/%Y')
END
)as Order_Year,

quarter(
case 
WHEN CAST(substring_index(`Order Date`,'/',1)AS UNSIGNED)>12
THEN str_to_date(`Order Date`,'%d/%m/%Y')
ELSE str_to_date(`Order Date`,'%m/%d/%Y')
END)as Order_Quarter,

sum(Sales)as Total_Sales
from superstore_db.train

group by 
year (
case
when CAST(substring_index(`Order Date`,'/',1)AS UNSIGNED)>12
THEN str_to_date(`Order Date`,'%d/%m/%Y')
ELSE str_to_date(`Order Date`,'%m/%d/%Y')
END
),
quarter(
case 
WHEN CAST(substring_index(`Order Date`,'/',1)AS UNSIGNED)>12
THEN str_to_date(`Order Date`,'%d/%m/%Y')
ELSE str_to_date(`Order Date`,'%m/%d/%Y')
END)
order by 
Order_Year,
Order_Quarter;

-- Sales Contribution %
-- What percentage of total sales does each Category contribute?
select Category,
sum(Sales)as Category_Sales,
round(sum(Sales)/(select sum(Sales) from superstore_db.train)*100,2) as Sales_Percentage
from superstore_db.train
group by Category;

-- LAG()
-- Show each month's sales along with the previous month's sales.
WITH MonthlySales AS (
    SELECT
        YEAR(
            CASE
                WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                    THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
                ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        ) AS Order_Year,

        MONTH(
            CASE
                WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                    THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
                ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        ) AS Order_Month,

        SUM(Sales) AS Total_Sales

    FROM superstore_db.train

    GROUP BY
        YEAR(
            CASE
                WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                    THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
                ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        ),
        MONTH(
            CASE
                WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                    THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
                ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        )
)
SELECT Order_Year,
    Order_Month,
    Total_Sales,
    LAG(Total_Sales) OVER (
        ORDER BY Order_Year, Order_Month
    ) AS Previous_Month_Sales
FROM MonthlySales
ORDER BY Order_Year, Order_Month;


-- LEAD()-Looks at the next row
-- Show each month's sales along with the next month's sales
WITH MonthlySales AS (
    SELECT
        YEAR(
            CASE
                WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                    THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
                ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        ) AS Order_Year,

        MONTH(
            CASE
                WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                    THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
                ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        ) AS Order_Month,

        SUM(Sales) AS Total_Sales

    FROM superstore_db.train

    GROUP BY
        YEAR(
            CASE
                WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                    THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
                ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        ),
        MONTH(
            CASE
                WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                    THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
                ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        )
)
SELECT Order_Year,
    Order_Month,
    Total_Sales,
    LEAD(Total_Sales) OVER (
        ORDER BY Order_Year, Order_Month
    ) AS Next_Month_Sales
FROM MonthlySales
ORDER BY Order_Year, Order_Month;

-- MoM Sales Growth %
-- How much did sales increase or decrease compared with the previous month?
WITH MonthlySales AS (
    SELECT
        YEAR(
            CASE
                WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                    THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
                ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        ) AS Order_Year,

        MONTH(
            CASE
                WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                    THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
                ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        ) AS Order_Month,

        SUM(Sales) AS Total_Sales

    FROM superstore_db.train

    GROUP BY
        YEAR(
            CASE
                WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                    THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
                ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        ),
        MONTH(
            CASE
                WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                    THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
                ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        )
), MonthlyComparison as(
SElECT Order_Year,
    Order_Month,
    Total_Sales,
    
    LAG(Total_Sales) OVER (
        ORDER BY Order_Year, Order_Month
    ) AS Previous_Month_Sales
    From MonthlySales
    )
    
    SELECT Order_Year,
    Order_Month,
    Total_Sales,
    Previous_Month_Sales,
   ROUND((Total_Sales - Previous_Month_Sales)/Previous_Month_Sales * 100 ,2
   ) 
   as MOM_Growth_Percentage
   from MonthlyComparison
ORDER BY Order_Year, Order_Month;

-- Year-over-Year (YoY) Sales Growth
-- How did total sales change compared with the previous year
WITH YearlySales AS (
    SELECT
        YEAR(
            CASE
                WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                    THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
                ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        ) AS Order_Year,

        SUM(Sales) AS Total_Sales

    FROM superstore_db.train

    GROUP BY
        YEAR(
            CASE
                WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                    THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
                ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        )
),

YearlyComparison AS (
    SELECT
        Order_Year,
        Total_Sales,
        LAG(Total_Sales) OVER (
            ORDER BY Order_Year
        ) AS Previous_Year_Sales

    FROM YearlySales
)

SELECT
    Order_Year,
    Total_Sales,
    Previous_Year_Sales,

    ROUND(
        (Total_Sales - Previous_Year_Sales)
        / Previous_Year_Sales * 100,
        2
    ) AS YoY_Growth_Percentage

FROM YearlyComparison
ORDER BY Order_Year;

-- For each Category, find the category's total sales
-- and its percentage contribution to the overall sales.
select Category,
sum(Sales)as Category_Sales,
ROUND(
        SUM(Sales) /
        SUM(SUM(Sales)) OVER () * 100,
        2
    ) AS Sales_Percentage
from superstore_db.train 
group by Category;

-- For each Region, find the top 2 customers based on total sales. Include ties.
with CustomerRank as(
select `Customer ID`,`Customer Name`,Region,
sum(Sales)as Total_Sales,
rank()over(partition by Region
order by sum(Sales)desc)as rn
from superstore_db.train
group by `Customer ID`,`Customer Name`,Region)

select * from customerRank 
where rn <=2;

-- For each Region, calculate each customer's total sales and their 
-- percentage contribution to that region's total sales.
Select `Customer ID`,`Customer Name`,Region,
sum(Sales) as Customer_Sales,
sum(sum(Sales))over(
partition by Region
)as Region_Sales,
round(
sum(Sales)/sum(sum(Sales))over(Partition by Region)* 100,2)as sales_Percentage
from superstore_db.train
group by 
`Customer ID`,
`Customer Name`, 
Region;


-- Question: Find the Customer ID, Customer Name, 
-- and Total Sales for customers whose total sales are greater than 5,000.
select `Customer ID`,`Customer Name`,
sum(Sales)as Total_Sales
from superstore_db.train
group by `Customer ID`,`Customer Name`
having Total_Sales > 5000;

-- Find customers whose total sales are greater than the average customer sales.
select `Customer ID`,`Customer Name`,Total_Sales
from(
select `Customer ID`,
`Customer Name`,
sum(Sales)as Total_Sales
from superstore_db.train
group by `Customer ID`,`Customer Name`
)as Customer_Sales
where Total_Sales > (
select avg(Total_Sales)
from(
select 
`Customer ID`,
`Customer Name`,
sum(Sales) as Total_Sales
from superstore_db.train
group by `Customer ID`,`Customer Name`)
as Avg_Sales);


-- For each Region, find the customer with the highest total sales. Include ties.
with CustomerRank as(
select `Customer ID`,`Customer Name`,Region,
sum(Sales)as Total_Sales,
rank()over(
partition by Region
order by sum(Sales) desc)as Customer_rank
from superstore_db.train
group by `Customer ID`,`Customer Name`,Region)

select * from CustomerRank
where Customer_rank =1;

-- Find customers whose sales increased from one year to the next.
WITH CustomerYearlySales AS (
    SELECT `Customer ID`,`Customer Name`,
        YEAR(
            CASE
                WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                    THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
                ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        ) AS Order_Year,

        SUM(Sales) AS Total_Sales

    FROM superstore_db.train

    GROUP BY
    `Customer ID`,`Customer Name`,
        YEAR(
            CASE
                WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                    THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
                ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        )
),

CustomerComparison AS (
    SELECT
    `Customer ID`,
    `Customer Name`,
        Order_Year,
        Total_Sales,
        LAG(Total_Sales) OVER (
        partition by `Customer ID`
            ORDER BY Order_Year
        ) AS Previous_Year_Sales

    FROM CustomerYearlySales
)

SELECT
`Customer ID`,
`Customer Name`,
    Order_Year,
    Total_Sales,
    Previous_Year_Sales,

    ROUND(
        (Total_Sales - Previous_Year_Sales)
        / Previous_Year_Sales * 100,
        2
    ) AS YoY_Growth_Percentage

FROM CustomerComparison
where Previous_Year_Sales is not NULL
and Total_Sales > Previous_Year_Sales
ORDER BY Order_Year,`Customer ID`;

-- Find customers whose sales decreased from one year to the next, 
-- and calculate their YoY decline percentage.

WITH CustomerYearlySales AS (
    SELECT `Customer ID`,`Customer Name`,
        YEAR(
            CASE
                WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                    THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
                ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        ) AS Order_Year,

        SUM(Sales) AS Total_Sales

    FROM superstore_db.train

    GROUP BY
    `Customer ID`,`Customer Name`,
        YEAR(
            CASE
                WHEN CAST(SUBSTRING_INDEX(`Order Date`, '/', 1) AS UNSIGNED) > 12
                    THEN STR_TO_DATE(`Order Date`, '%d/%m/%Y')
                ELSE STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        )
),

CustomerComparison AS (
    SELECT
    `Customer ID`,
    `Customer Name`,
        Order_Year,
        Total_Sales,
        LAG(Total_Sales) OVER (
        partition by `Customer ID`
            ORDER BY Order_Year
        ) AS Previous_Year_Sales

    FROM CustomerYearlySales
)

SELECT
`Customer ID`,
`Customer Name`,
    Order_Year,
    Total_Sales,
    Previous_Year_Sales,

    ROUND(
        (Previous_Year_Sales - Total_Sales)
        / Previous_Year_Sales * 100,
        2
    ) AS YoY_Decline_Percentage

FROM CustomerComparison
where Previous_Year_Sales is not NULL
and Total_Sales < Previous_Year_Sales
ORDER BY Order_Year,`Customer ID`;

-- Find the top-selling product in each Category, including ties.
with TopSellingProduct as(
Select `Product ID`,Category,
sum(Sales) as Total_Sales,
rank() over(
Partition by Category
order by sum(Sales)desc)as rn
from superstore_db.train 
group by Category,`Product ID`)

select * from TopSellingProduct 
where rn =1;


-- Find the top 2 products in each Category, including ties.
with TopSellingProduct as(
Select `Product ID`,`Product Name`,Category,
sum(Sales) as Total_Sales,
rank() over(
Partition by Category
order by sum(Sales)desc)as rn
from superstore_db.train 
group by Category,`Product ID`,`Product Name`)

select * from TopSellingProduct 
where rn <= 2;

-- Find customers who purchased products from more than one Category
select `Customer ID`,`Customer Name`,
count(distinct Category) as Category_Count
from superstore_db.train
group by `Customer ID` ,`Customer Name`
having count(distinct Category)>1;

-- Find customers who have placed more than 5 orders 
-- and have total sales greater than ₹5,000.
select `Customer ID`,`Customer Name`,
count(distinct `Order ID`) as Order_Count,
sum(Sales)as Total_Sales
from superstore_db.train
group by `Customer ID`,`Customer Name`
having Order_Count > 5 and Total_Sales > 5000
ORDER BY Total_Sales DESC;

