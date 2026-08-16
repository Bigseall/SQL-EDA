# Exploratory Data Analysis (EDA) with SQL

A comprehensive Data Analysis project performing Exploratory Data Analysis (EDA) on Microsoft's AdventureWorks relational database using SQL. This project focuses on evaluating overall sales performance, customer demographics, product category distribution, and purchasing trends over time.

---

**Key Objectives:**
- Evaluate core business KPIs (Total Revenue, Order Volume, AOV).
- Identify top and bottom-performing products and categories.
- Analyze customer demographic distribution across territories.
- Uncover time-based purchasing behavior (Day-of-Week trends).
- Highlight top sales personnel based on Year-to-Date (YTD) revenue.

---

## 🛠️ Tools & Environment
* **Database Engine:** SQL Server (AdventureWorks2025)
* **Language:** T-SQL (Transact-SQL)
* **IDE:** SQL Server Management Studio (SSMS)

---

## 💡 Key Business Insights

### 1. Overall Sales Performance
* Calculated **Total Revenue**, **Total Units Sold**, and **Average Unit Selling Price** across all historical orders.
* Comparison between total registered vs. active ordering customers to gauge overall customer engagement.

### 2. Product & Category Highlights
* **Best-Selling Category:** Identifies the top category driving volume and revenue.
* **Top & Bottom Products:** Pinpoints high-yield revenue drivers alongside underperforming SKUs (potential candidates for clearance or restocking adjustments).
* **Category Pricing:** Evaluates price distribution across sub-categories to assess product positioning.

### 3. Customer Demographics & Purchasing Habits
* **Geographic Distribution:** Maps customer concentrations across major markets.
* **Weekly Sales Trends:** Aggregates revenue and order counts by day of the week to reveal optimal marketing.

---

## 🔍 Sample Queries

### 1. Total Sales Overview
```sql
select sum(Subtotal) as Total_Sales from Sales.SalesOrderHeader;
```

### 2. Top 5 Products by Revenue
```sql
select top 5 p.Name, sum(s.LineTotal) as Total_revenue
from Sales.SalesOrderDetail as s
left join Production.Product as p on s.ProductID = p.ProductID
group by p.Name
order by sum(s.LineTotal) desc;
```

### 3. Total Revenue by Customer
```sql
select sc.CustomerID, pp.FirstName, pp.LastName, sum(sh.Subtotal) as Total_revenue
from Person.Person as pp
left join Sales.Customer sc on sc.PersonID = pp.BusinessEntityID
left join Sales.SalesOrderHeader as sh on sc.CustomerID = sh.CustomerID
group by sc.CustomerID, pp.FirstName, pp.LastName
order by sum(sh.Subtotal) desc;
```

### 4. Total Revenue and Orders by Day of Week
```sql
select 
    datepart(weekday, OrderDate) as Day_number,
    datename(weekday, OrderDate) as Day,
    count(SalesOrderID) as Total_orders,
    sum(SubTotal) as Total_revenue
from Sales.SalesOrderHeader
group by datepart(weekday, OrderDate), datename(weekday, OrderDate)
order by Day_number;
```

### 5. Top 5 Salespeople by Total Sales
```sql
select top 5
    FirstName, LastName, SalesYTD
from Sales.vSalesPerson
order by SalesYTD desc;
```
