use sales;
create table us_sales(Order_Number varchar(30) primary key,Product_Name varchar(30),Sales_Channel varchar(30),Order_Date date,
					Ship_date date,Delivery_date date,Currency_Code varchar(5),Order_Quantity int,Discount_Applied Decimal(4,2),
                    Unit_Price int,Unit_Cost int,Customer_names varchar(25),City_Name varchar(50),StateCode varchar(5),State varchar(50),
                    Area_type varchar(10),Region varchar(20),Sales_team varchar(30));

select * from us_sales limit 5;

-- Feature Engineering want to be done..
Alter table us_sales add column days_taken_to_deliver int,add column sale_$ int,
add column expense_$ int,add column profit_$ int;

Update us_sales set days_taken_to_deliver=datediff(Delivery_date,Order_Date),
sale_$=(Order_Quantity*Unit_Price)-((Order_Quantity*Unit_Price)*Discount_Applied)/100,
expense_$=Unit_Cost*Order_Quantity where Order_Number like 'SO%';

Update us_sales set profit_$=sale_$-expense_$ where Order_Number like 'SO%';

-- Give me Total Sales,Total Expenses,Total Profits!!!
select sum(sale_$) as "Total Sales($)",sum(expense_$) as "Total Expenses($)",sum(profit_$) as "Total Profits($)" from us_sales;

-- Give me average number of days taken to deliver the products!!!
select round(avg(days_taken_to_deliver)) as "Number of days taken to deliver" from us_sales;

-- What are the products are solded ?
select distinct(Product_Name) as Products from us_sales;

--  Total no of products solded and no of unique products solded!!!
select sum(Order_Quantity) as "Total no of products solded",count(distinct(Product_name)) as "No of unique products solded"
from us_sales;

-- what are the unique sales channel the products were solded?
select distinct(sales_channel) from us_sales;

-- what are the states where the product are solded ?
select distinct(state) as States from us_sales;

-- No of states and no of cities the product were solded!!!
select count(distinct(state)) as "No of states products solded" ,count(distinct(City_Name)) as "No of cities products solded" from us_sales;

-- No of Sales_Teams involved in product selling!!!
select count(distinct(Sales_team)) as "No of Sales Team" from us_sales;

-- In Each unique product how much products has been solded and there total sales,total expenses,total profits!!!
select Distinct(Product_Name),sum(Order_Quantity) as "Product_Quantity",sum(sale_$) as "Total Sales",
sum(expense_$) as "Total Expenses",sum(profit_$) as "Total Profits" from us_sales group by Product_Name;

-- In Region wise How much product quantity, total sales,total expenses,total profits!!!
select distinct(Region),sum(Order_Quantity) as "Product_Quantity",sum(sale_$) as "Total Sales",
sum(expense_$) as "Total Expenses",sum(profit_$) as "Total Profits" from us_sales group by region;

-- In Area Type wise How much product quantity, total sales,total expenses,total profits!!!
select distinct(Area_type),sum(Order_Quantity) as "Product_Quantity",sum(sale_$) as "Total Sales_$",
sum(expense_$) as "Total Expenses_$",sum(profit_$) as "Total Profits_$" from us_sales group by Area_type;

-- Top 5 Products where the more sales happened!!!
select Distinct(Product_Name),sum(sale_$) as 'Total_Sales_$' from us_sales group by Product_Name order by Total_Sales_$ desc limit 5;

-- Top 5 Products where the Least sales happened!!!
select Distinct(Product_Name),sum(sale_$) as 'Total_Sales_$' from us_sales group by Product_Name order by Total_Sales_$ limit 5;

-- Top 5 States where the more sales happened!!!
select Distinct(State),sum(sale_$) as 'Total_Sales_$' from us_sales group by State order by Total_Sales_$ desc limit 5;

-- Top 5 States where the least sales happened!!!
select Distinct(State),sum(sale_$) as 'Total_Sales_$' from us_sales group by State order by Total_Sales_$ limit 5;

-- Top 5 Cities where the more sales happened!!!
select Distinct(City_Name),sum(sale_$) as 'Total_Sales_$' from us_sales group by City_Name order by Total_Sales_$ desc limit 5;

-- Top 5 Cities where the least sales happened!!!
select Distinct(City_Name),sum(sale_$) as 'Total_Sales_$' from us_sales group by City_Name order by Total_Sales_$ limit 5;

-- Top 5 Customers where the more sales happened!!!
select Distinct(Customer_names),sum(sale_$) as 'Total_Sales_$' from us_sales group by Customer_names order by Total_Sales_$ desc limit 5;

-- Top 5 Customers where the least sales happened!!!
select Distinct(Customer_names),sum(sale_$) as 'Total_Sales_$' from us_sales group by Customer_names order by Total_Sales_$ limit 5;

-- Top 5 Sales_teams where they generated more sales!!!
select Distinct(Sales_team),sum(sale_$) as 'Total_Sales_$' from us_sales group by Sales_team order by Total_Sales_$ desc limit 5;

-- Top 5 Sales_teams where they generated least sales!!!
select Distinct(Sales_team),sum(sale_$) as 'Total_Sales_$' from us_sales group by Sales_team order by Total_Sales_$ limit 5;

-- Adding column year for year wise sales
Alter table us_sales add column year int ;
update us_sales set year=Year(Order_Date) where Order_Number like 'SO%';

-- What are the years sales happened and each year how much sales happened and profit earned!!!
select distinct(year),sum(sale_$) as "Total Sales$",sum(profit_$) as "Total_Profit$" from us_sales group by year;

-- Give the average salse,Expenses,profits!!!
select round(avg(sale_$)) as"Avg Sales_$",round(avg(expense_$)) as "Avg Expenses_$",round(avg(profit_$)) as "Avg Profits_$" from us_sales;

-- Which Customer placed more or maximum orders !!!
select Distinct(Customer_names),sum(Order_Quantity) as "Max_Orders" from us_sales group by Customer_names order by Max_Orders desc limit 1;

-- Which Customer placed least or minimum orders !!!
select Distinct(Customer_names),sum(Order_Quantity) as "Min_Orders" from us_sales group by Customer_names order by Min_Orders limit 1;

-- which product have picken more orders!!!
select Distinct(Product_Name),sum(Order_Quantity) as "Max_Orders" from us_sales group by Product_Name order by Max_Orders desc limit 1;

-- which product have picken least orders!!!
select Distinct(Product_Name),sum(Order_Quantity) as "Min_Orders" from us_sales group by Product_Name order by Min_Orders limit 1;

-- Retrieve the customer names and their corresponding order quantities 
-- where the order quantity is greater than the average order quantity for all customers.
select Distinct(Customer_names),Order_Quantity from us_sales where Order_Quantity > (select round(avg(Order_Quantity)) from us_sales);

-- 1. 
with stud as (select name from students where major="Computer Science") select * from stud;
-- 2. 
with maj as(select distinct(major),avg(age) from students group by major) select * from maj;
select * from courses;
-- 3. 
with co as (select distinct(name) from students join courses on id=course_id group by course_name) select * from co;
-- 4. 
with co_enrolled as (select distinct(course_name),count(*) from courses group by course_name having count(*)>=1) select * from co_enrolled;
-- 5. 
with old_stud as (select name,case when age>avg(age) then age end from students where major="Computer Science" group by major) select * from old_stud;

