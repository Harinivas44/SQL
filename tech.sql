-- TOP 50 US TECH COMPANIES
create database tech;

use tech;
create table tech_company(Company_name varchar(50),Industry varchar(50),Sector varchar(50),HQ_State varchar(50),Founding_year int,
						  Annual_Rev_2022_2023_usd_in_billions decimal(6,2),Market_cap_usd_trillion decimal(6,2),Stock_name varchar(30),
                          Annual_income_tax_2022_2023_usd_billions decimal(6,3),Employees_size int);

select * from tech_company;

-- 1. Retrieve the names of all companies in the dataset.
select Company_name from tech_company;

-- 2. How many companies are based in California?
select count(*) as "No_of_companies_based_on_california" from tech_company where HQ_State="California";

-- 3. Find the total number of employees in the table. 
select sum(employees_size) as "Total Employees" from tech_company;

-- 4. List the companies that were founded before the year 2000. 
select * from tech_company where Founding_year<2000;  -- 37 Companies were founded before 2000

-- 5. Display the technology sectors present in the table.
select sector from tech_company;

-- 6. Calculate the average annual revenue of all companies.
select avg(Annual_Rev_2022_2023_usd_in_billions) as "Avg_Revenue_in_billions($)" from tech_company;

-- 7. Which company has the highest market cap?
select company_name,market_cap_usd_trillion  from tech_company where Market_cap_usd_trillion in(select max(Market_cap_usd_trillion) from tech_company);

-- 8. What is the total annual income tax paid by all companies in 2022-2023?
select sum(Annual_income_tax_2022_2023_usd_billions) as "Total Annual tax Paid by all companies in billions(22-23)" from tech_company;

-- 9. Group the companies by their technology sectors and display the count of companies in each sector.
select distinct(sector),count(*) as "No_of_companies" from tech_company group by sector;

-- 10. Retrieve the companies with negative annual income tax.
select company_name,Annual_income_tax_2022_2023_usd_billions from tech_company where Annual_income_tax_2022_2023_usd_billions<0;

-- 11. Find the average revenue of companies founded in California.
select avg(Annual_Rev_2022_2023_usd_in_billions) as "Avg Revenue by California based Companies(billion_$)" 
from  tech_company where HQ_state="California";

-- 12.Display the top 5 companies with the highest employee size.
select company_name,employees_size from tech_company order by employees_size desc limit 5;

-- 13. List the companies with annual revenue greater than 50 billion and an employee size greater than 50,000.
select company_name from tech_company where Annual_Rev_2022_2023_usd_in_billions>50 and employees_size > 50000;

-- 14. Display the companies in the "Software Infrastructure" sector with a market cap between 0.5 and 1 trillion USD.
select company_name from tech_company where sector="Software Infrastructure" and market_cap_usd_trillion between 0.5 and 1;

-- 15. Calculate the sum of annual revenue and income tax for each sector.
select distinct(Sector),sum(Annual_Rev_2022_2023_usd_in_billions),sum(Annual_income_tax_2022_2023_usd_billions)
from tech_company group by sector;

-- 16.Determine the highest and lowest annual revenue in each state.
select distinct(HQ_state),max(Annual_Rev_2022_2023_usd_in_billions),min(Annual_Rev_2022_2023_usd_in_billions) from tech_company group by HQ_state;

-- 17.Determine the highest and lowest annual revenue in each sector.
select distinct(sector),max(Annual_Rev_2022_2023_usd_in_billions),min(Annual_Rev_2022_2023_usd_in_billions) from tech_company group by sector;

-- 18. Display the companies that have annual revenue greater than the average revenue for all companies.
select company_name,Annual_Rev_2022_2023_usd_in_billions from tech_company 
where Annual_Rev_2022_2023_usd_in_billions > (select avg(Annual_Rev_2022_2023_usd_in_billions) from tech_company);

-- 19. Calculate the total annual revenue for each sector and rank them in descending order.
select distinct(sector),sum(Annual_Rev_2022_2023_usd_in_billions),
Rank() over(order by sum(Annual_Rev_2022_2023_usd_in_billions) desc ) as "Rank" from tech_company group by sector;

-- 20. Calculate the total number of employees for technology companies in each state and rank them in descending order.
select distinct(HQ_state),sum(employees_size),rank() over(order by sum(employees_size) desc) as "Rank" from tech_company group by HQ_state;







