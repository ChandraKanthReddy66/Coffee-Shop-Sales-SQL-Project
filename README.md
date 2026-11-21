# Coffee Shop Sales SQL Project

## Project Overview
The Coffee Shop Sales SQL Project focuses on cleaning, analyzing, and reporting coffee shop sales data using SQL. The project transforms raw transaction records into meaningful sales information that helps understand business performance.

The analysis covers sales trends, monthly growth, store performance, product categories, and peak sales hours.

## Project Objectives
- Clean and prepare raw sales data for analysis.
- Calculate Total Sales, Total Orders, and Total Quantity Sold.
- Analyze Month-over-Month (MoM) growth.
- Identify daily, weekly, monthly, and hourly sales trends.
- Compare sales performance across store locations.
- Identify top-performing product categories and product types.

## Tools & Technologies
- MySQL
- SQL
- Excel
- CSV datasets

## Dataset Description
The project uses coffee shop transaction data containing the following fields:

- `transaction_id` – Unique transaction identifier.
- `transaction_date` – Date of the transaction.
- `transaction_time` – Time of the transaction.
- `transaction_qty` – Quantity of products sold.
- `unit_price` – Selling price per unit.
- `store_location` – Store or branch location.
- `product_category` – Product category.
- `product_type` – Specific product type.

## Data Cleaning
The following data preparation tasks are covered:
- Converting transaction dates into the correct DATE format.
- Converting transaction times into the correct TIME format.
- Fixing column names and removing hidden encoding characters.
- Preparing the data for accurate SQL analysis.

## Key Analysis
- Total Sales, Total Orders, and Total Quantity Sold.
- Month-over-Month sales growth.
- Daily sales performance.
- Weekday vs. weekend sales.
- Sales by day of the week.
- Hourly sales trends.
- Store location performance.
- Product category analysis.
- Top 10 products by sales.
- Sales analysis by weekday and hour.

## Repository Structure
```text
Coffee-Shop-Sales-SQL-Project/
│
├── Data/
│   ├── Transactions.csv
│   ├── Dim_Stores.csv
│   ├── Dim_Products.csv
│   └── README.md
│
├── Documentation/
│   ├── Coffee Shop Sales Analysis — SQL Reporting Project.xlsx
│   └── README.md
│
├── SQL/
│   ├── Coffee Shop Sales Analysis — SQL Reporting Project.sql
│   └── README.md
│
├── Coffee_Shop_Sales_BRD.docx
└── README.md
```

## Project Outcome
This project demonstrates how SQL can be used to clean sales data, calculate business KPIs, analyze historical sales trends, and identify high-performing stores and products.

## Project Scope
This repository focuses on SQL-based data preparation and historical sales reporting. Predictive forecasting and dashboard development tools are outside the scope of this SQL project.
