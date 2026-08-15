-- ===================================================================
-- Project: AdventureWorks Exploratory Data Analysis (EDA)
-- Database: AdventureWorks (SQL Server)
-- Description: Comprehensive EDA covering Sales Performance, Customer
--              Demographics, Product Categories, and Time-Series Trends.
-- ===================================================================
-- SECTION 1: Database Exploration
-- -------------------------------------------------------------------
select
    table_schema, 
    table_type, 
    count(*) as total_tables
from INFORMATION_SCHEMA.TABLES
group by table_schema, table_type
order by total_tables desc;

select  * from INFORMATION_SCHEMA.TABLES
where TABLE_SCHEMA = 'Sales'
select  * from INFORMATION_SCHEMA.TABLES
where TABLE_SCHEMA = 'Production'

-- -------------------------------------------------------------------
-- SECTION 2: Key Executive Metrics (KPIs)
-- -------------------------------------------------------------------

-- Find the Total Sales
select sum(Subtotal) as Total_Sales from Sales.SalesOrderHeader 

-- Find how many items are sold
select sum(orderQty) as Total_Quantity  from Sales.SalesOrderDetail 

-- Find the average selling price
select avg(UnitPrice) as Average_Price from Sales.SalesOrderDetail 

-- Find the total number of products
select count(distinct ProductID) as Total_Products from Production.Product

-- Find the number of customers
select count(CustomerID) as Total_Customers from Sales.Customer

-- Find the number of customers that placed the order
select count(distinct CustomerID) as Total_Customers from Sales.SalesOrderHeader

-- -------------------------------------------------------------------
-- SECTION 3: Customer & Demographic Analysis
-- -------------------------------------------------------------------

-- Find total customers by country 
select case 
			when st.Name in ('Northwest','Northeast','Central','Southwest','Southeast') then 'United States'
			else st.Name end as Country,count(sc.CustomerID) as Total_Customers
from Sales.Customer as sc
left join Sales.SalesTerritory as st
on sc.TerritoryID = st.TerritoryID
group by case 
			when st.Name in ('Northwest','Northeast','Central','Southwest','Southeast') then 'United States'
			else st.Name end
order by count(sc.CustomerID) desc

--Find the total revenue by each customer
select sc.CustomerID,pp.FirstName,pp.LastName,sum(sh.Subtotal) as Total_revenue
from Person.Person as pp
left join Sales.Customer sc
ON sc.PersonID = pp.BusinessEntityID
inner join Sales.SalesOrderHeader as sh
on sc.CustomerID = sh.CustomerID
group by sc.CustomerID,pp.FirstName,pp.LastName
order by sum(sh.Subtotal) desc


-- -------------------------------------------------------------------
-- SECTION 4: Product & Category Performance
-- -------------------------------------------------------------------

-- Find top 5 Best-Selling Products
select top 5 p.Name,sum(s.orderQty) as Number_of_unit_sold
from Sales.SalesOrderDetail as s
left join Production.Product as p
on s.ProductID = p.ProductID
group by p.Name
order by sum(s.orderQty) desc

-- Find top 5 products that generate the highest revenue
select top 5 p.Name, sum(s.LineTotal) as Total_revenue
from Sales.SalesOrderDetail as s
left join Production.Product as p on s.ProductID = p.ProductID
group by p.Name
order by sum(s.LineTotal) desc

-- Find top 5 products that generate the lowest revenue
select top 5 p.Name, sum(s.LineTotal) as Total_revenue
from Sales.SalesOrderDetail as s
left join Production.Product as p on s.ProductID = p.ProductID
group by p.Name
order by sum(s.LineTotal) 

-- Find the Best-selling product category
select top 1 pc.Name,sum(s.orderQty) as Number_of_unit_sold
from Production.ProductCategory as pc
left join Production.ProductSubcategory as ps
on pc.ProductCategoryID = ps.ProductCategoryID
left join Production.Product as p
on ps.ProductSubcategoryID = p.ProductSubcategoryID
left join Sales.SalesOrderDetail as s
on s.ProductID = p.ProductID
group by pc.Name
order by sum(s.orderQty) desc

-- Find the average cost in each category
select pc.Name,avg(s.UnitPrice) as Average_cost
from Production.ProductCategory as pc
left join Production.ProductSubcategory as ps
on pc.ProductCategoryID = ps.ProductCategoryID
left join Production.Product as p
on ps.ProductSubcategoryID = p.ProductSubcategoryID
left join Sales.SalesOrderDetail as s
on s.ProductID = p.ProductID
group by pc.Name
order by avg(s.UnitPrice) desc

--Find the total revenue for each category
select pc.Name,sum(s.LineTotal) as Total_revenue
from Production.ProductCategory as pc
left join Production.ProductSubcategory as ps
on pc.ProductCategoryID = ps.ProductCategoryID
left join Production.Product as p
on ps.ProductSubcategoryID = p.ProductSubcategoryID
left join Sales.SalesOrderDetail as s
on s.ProductID = p.ProductID
group by pc.Name
order by sum(s.LineTotal) desc

-- -------------------------------------------------------------------
-- SECTION 5: Time-Series & Employee Performance
-- -------------------------------------------------------------------

-- Find Total revenue and Total Orders by Day of Week
select 
    datepart(weekday, OrderDate) as Day_number,
    datename(weekday, OrderDate) as Day,
    count(SalesOrderID) as Total_orders,
    sum(SubTotal) as Total_revenue
from Sales.SalesOrderHeader
group by datepart(weekday, OrderDate), datename(weekday, OrderDate)
order by Day_number;

-- Find the top 5 employees with the highest total sales.
select top 5
FirstName,LastName,SalesYTD
from Sales.vSalesPerson
order by SalesYTD desc

