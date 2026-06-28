# 🛒 Amazon E-commerce ETL Pipeline & Business Analytics (MySQL)

---

## 📌 Project Overview

Modern e-commerce platforms continuously generate large volumes of transactional data from customers, products, sellers, payment methods, and logistics operations. Before this information can be transformed into meaningful business insights, the raw operational data must first be cleaned, standardized, validated, and optimized for analytical workloads.

This project demonstrates the development of an **end-to-end ETL (Extract, Transform, Load) pipeline** using **MySQL 8**, transforming raw Amazon e-commerce transaction data into a clean, analysis-ready dataset capable of supporting business intelligence and operational reporting.

The project goes beyond basic SQL querying by integrating:

* Raw data ingestion
* Data transformation & cleansing
* Data quality validation
* Performance optimization through indexing
* Business KPI generation
* Advanced SQL analytics
* Stored Procedure automation
* Scheduled pipeline execution using MySQL Event Scheduler

Rather than focusing solely on writing SQL queries, this repository demonstrates how SQL can be used to build a lightweight analytical data pipeline that resembles real-world data engineering and business intelligence workflows.

---

## 🎯 Project Objectives

The primary objective of this project is to simulate a simplified production-style ETL pipeline capable of transforming raw transactional data into trusted analytical datasets.

Specifically, this project aims to:

* Design a structured ETL workflow using MySQL.
* Preserve raw source data for auditing and traceability.
* Transform inconsistent data into standardized business-ready formats.
* Validate data quality before analytical processing.
* Produce meaningful business KPIs using SQL.
* Demonstrate modern SQL analytical techniques including Window Functions and Common Table Expressions (CTEs).
* Automate repetitive refresh processes through Stored Procedures and Event Scheduler.

---

## 💼 Business Problem

E-commerce organizations rely on accurate transactional data to monitor operational performance, customer behavior, logistics efficiency, and revenue generation.

However, raw datasets collected from operational systems often contain problems such as:

* Text-based numeric values
* String-formatted dates
* Leading and trailing whitespaces
* Inconsistent Boolean values
* Missing or malformed records
* Invalid business values
* Mixed data types unsuitable for analytics

Without proper transformation and validation, these issues can negatively impact downstream reporting and business decision-making.

This project addresses those challenges by building a complete SQL pipeline that transforms raw operational data into a reliable analytical dataset.

---

## 📂 Dataset Setup & Installation

Due to GitHub's file size limitations, the raw transactional dataset has been compressed into a ZIP file inside this repository. To run the ETL pipeline locally, please follow these steps:

1. **Extract the Dataset:** Locate and extract `amazon_ecommerce_1M - Stable Space.zip` inside the `DATA/` folder.
2. **Locate MySQL Uploads Folder:** Ensure the extracted `amazon_ecommerce.csv` file is placed in your MySQL secure uploads directory (e.g., `C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/`).
3. **Execute the Script:** Open your preferred SQL IDE (MySQL Workbench, DBeaver, etc.) and run the `amazon_analyst_script.sql` located in the `SQL/` folder.

---

## 📊 Dataset Description

The dataset used in this project is an Amazon E-commerce transactional dataset publicly available on Kaggle and published by **Stable Space**.

The dataset contains transactional information covering multiple aspects of e-commerce operations, including:

| Category        | Description                              |
| --------------- | ---------------------------------------- |
| Customer        | User identifiers                         |
| Product         | Product ID, category, subcategory, brand |
| Sales           | Original price, discount, final price    |
| Seller          | Seller ID and seller rating              |
| Customer Review | Product rating and review count          |
| Inventory       | Stock availability                       |
| Logistics       | Shipping duration, delivery status       |
| Geography       | Customer location                        |
| Device          | Purchase device                          |
| Payment         | Payment method                           |
| Returns         | Product return indicator                 |

The raw dataset intentionally stores several fields as text strings, requiring extensive transformation before they become suitable for business analytics.

---

## 🏗️ Solution Architecture

The overall architecture follows a lightweight layered ETL approach.

```text
                 Amazon Ecommerce CSV
                          │
                          ▼
             ┌──────────────────────────┐
             │     Raw Ingestion Layer   │
             │ ecommerce_amazon_raw      │
             └─────────────┬────────────┘
                           │
                 Data Cleansing
                 Type Conversion
                 Standardization
                           │
                           ▼
             ┌──────────────────────────┐
             │      Clean Layer          │
             │ ecommerce_amazon_clean    │
             └─────────────┬────────────┘
                           │
          ┌────────────────┴─────────────────┐
          ▼                                  ▼
 ┌──────────────────┐              ┌──────────────────┐
 │ Data Quality     │              │ Business         │
 │ Validation       │              │ Analytics        │
 │ Audit Table      │              │ KPI & Insights   │
 └─────────┬────────┘              └────────┬─────────┘
           │                                │
           └──────────────┬─────────────────┘
                          ▼
              Stored Procedure Refresh
                          │
                          ▼
               MySQL Event Scheduler
```

This architecture separates operational data from analytical data, making the pipeline easier to maintain, validate, and extend.

---

## 🔄 ETL Pipeline Workflow

The project implements a complete ETL workflow composed of several sequential stages.

```text
Raw CSV Dataset
       │
       ▼
LOAD DATA INFILE
       │
       ▼
Raw Table
       │
       ▼
Data Cleansing
       │
       ▼
Data Transformation
       │
       ▼
Clean Analytical Table
       │
       ├───────────────┐
       ▼               ▼
Data Quality       Business Analytics
Validation         KPI Reporting
       │               │
       └───────┬───────┘
               ▼
Stored Procedure Refresh
               │
               ▼
Daily Event Scheduler
```

Each stage has a clearly defined responsibility, helping ensure that analytical queries operate only on validated and standardized data.

---

## 🏛️ Data Pipeline Layers

### 1️⃣ Raw Ingestion Layer

The `ecommerce_amazon_raw` table functions as the landing zone for all incoming data.

This layer intentionally preserves the original dataset exactly as received without applying any business transformations.

Key responsibilities include:

* High-speed bulk ingestion using `LOAD DATA INFILE`
* Source file tracking
* Original data preservation
* Audit traceability
* Historical reproducibility

Keeping the raw dataset unchanged provides an immutable source of truth that can be reprocessed whenever business rules evolve.

---

### 2️⃣ Transformation & Cleansing Layer

After ingestion, the raw records are transformed into a standardized analytical model.

Major transformation activities include:

* Removing unnecessary whitespaces using `TRIM()`
* Converting text values into numeric data types with `CAST()`
* Parsing purchase dates using `STR_TO_DATE()`
* Converting Boolean values into SQL-compatible format
* Standardizing column naming conventions
* Creating optimized indexes for analytical workloads

The resulting `ecommerce_amazon_clean` table serves as the primary source for reporting and business analytics.

---

## ⭐ Key Features

This project demonstrates practical implementation of multiple SQL engineering concepts within a single workflow.

### Data Engineering

* Raw-to-Clean ETL Pipeline
* Layered Data Architecture
* Bulk Data Loading
* Automated Refresh Pipeline

### Data Cleaning

* String Standardization
* Date Parsing
* Numeric Conversion
* Boolean Transformation
* Missing Value Handling

### Data Quality

* Row Count Validation
* Invalid Date Detection
* Negative Price Detection
* Rating Validation
* Discount Validation
* Stock Validation

### Business Analytics

* KPI Reporting
* Revenue Analysis
* Product Ranking
* Return Rate Analysis
* Logistics Performance

### Database Engineering

* Composite Indexing
* Stored Procedures
* Event Scheduler Automation
* Transaction Handling
* Performance-Oriented Table Design

---

## 🚀 Why This Project?

Unlike many SQL portfolio projects that only showcase isolated `SELECT` statements, this repository demonstrates how SQL can support an entire analytical workflow—from raw data ingestion to automated reporting.

The project emphasizes not only query writing but also:

* Database design
* ETL architecture
* Data quality assurance
* Query optimization
* Automation
* Business-oriented analytics

These are practical skills commonly applied in Data Analyst, Business Intelligence, Analytics Engineering, and entry-level Data Engineering roles.

---

# 🧹 Data Cleaning Framework

Raw operational data is rarely suitable for direct analytical processing. To improve data reliability and consistency, multiple transformation and cleansing techniques were applied before loading records into the analytical table.

| Cleaning Process        | Purpose                                                 |
| ----------------------- | ------------------------------------------------------- |
| `TRIM()`                | Remove leading and trailing whitespaces                 |
| `NULLIF()`              | Convert blank values into SQL NULL                      |
| `CAST()`                | Convert text-based values into numeric data types       |
| `STR_TO_DATE()`         | Parse string dates into DATE format                     |
| Boolean Standardization | Normalize return status into SQL-compatible values      |
| Column Standardization  | Create consistent analytical naming conventions         |
| Data Type Conversion    | Ensure each attribute uses an appropriate SQL data type |

These transformations improve data consistency while reducing the risk of inaccurate analytical results.

---

# ✅ Data Quality Framework

After the transformation process, the cleaned dataset is validated using several automated quality checks before analytical queries are executed.

The validation process ensures that the dataset satisfies minimum quality standards required for business reporting.

| Validation Rule          | Objective                                             |
| ------------------------ | ----------------------------------------------------- |
| Row Count Validation     | Ensure transformed records match the expected volume  |
| Purchase Date Validation | Detect invalid or failed date parsing                 |
| Negative Price Detection | Prevent invalid revenue calculations                  |
| Rating Validation        | Verify seller ratings remain within acceptable limits |
| Discount Validation      | Detect discounts outside expected business rules      |
| Stock Validation         | Identify invalid inventory quantities                 |

The validation results are stored in a dedicated audit table, providing a lightweight data quality monitoring mechanism for the ETL pipeline.

---

# 🗄️ Database Design

The project follows a simple layered database architecture.

```text
Amazon CSV
      │
      ▼
ecommerce_amazon_raw
      │
      ▼
ecommerce_amazon_clean
      │
      ├─────────────┐
      ▼             ▼
Data Quality     Business Analytics
Audit Table      KPI Reporting
```

This separation prevents accidental modification of the original dataset while allowing repeated transformations whenever business rules change.

---

# 📈 Business KPI Dashboard

The ETL pipeline generates several business-oriented Key Performance Indicators (KPIs) that can support operational monitoring and executive reporting.

The KPI layer includes:

* Total Revenue
* Total Orders
* Average Order Value (AOV)
* Average Product Rating
* Average Seller Rating
* Total Returned Orders
* Return Rate
* Average Shipping Duration
* Total Product Categories
* Total Active Brands

These KPIs provide a high-level overview of overall business performance before deeper analytical exploration.

---

# ❓ Business Questions

The analytical queries included in this repository are designed to answer practical business questions rather than simply demonstrate SQL syntax.

### Revenue Performance

* How much revenue has the business generated?
* How does revenue change over time?
* What is the month-over-month revenue growth?

---

### Product Performance

* Which product categories generate the highest revenue?
* Which brands contribute the most sales?
* Which products achieve the highest rankings within each category?

---

### Customer Behavior

* Which payment methods are used most frequently?
* Which purchase devices are most popular?
* How frequently do customers return products?

---

### Logistics Performance

* Which cities experience the highest return rates?
* Which delivery statuses occur most frequently?
* What is the average shipping duration?

---

### Operational Monitoring

* Are there invalid records remaining after cleansing?
* Are there pricing anomalies?
* Are there inventory inconsistencies?
* Does the transformed dataset satisfy quality validation rules?

These business questions simulate the types of analytical requests commonly received by Data Analysts and Business Intelligence teams.

---

# 📊 Advanced SQL Analytics

Beyond descriptive reporting, this project applies advanced SQL analytical techniques to produce richer business insights.

The implementation includes:

## Window Functions

Used to perform ranking and trend analysis without complex self-joins.

Examples include:

* Product ranking
* Brand ranking
* Monthly revenue trend
* Revenue growth analysis

---

## Common Table Expressions (CTEs)

CTEs improve query readability by separating intermediate calculations from the final analytical output.

This makes complex SQL significantly easier to maintain and review.

---

## Ranking Analysis

Ranking functions are used to identify top-performing entities across different business dimensions.

Examples include:

* Top-selling categories
* Highest-performing brands
* Product rankings

---

## Trend Analysis

Monthly revenue trends are calculated using Window Functions to evaluate business growth over time.

This approach allows decision-makers to quickly identify seasonal fluctuations and revenue patterns.

---

# 🎯 Business Value

The analytical outputs generated by this project can support multiple business functions.

| Business Area        | Potential Insight     |
| -------------------- | --------------------- |
| Sales                | Revenue monitoring    |
| Marketing            | Best-selling products |
| Product              | Category performance  |
| Operations           | Delivery efficiency   |
| Logistics            | Shipping performance  |
| Inventory            | Stock monitoring      |
| Customer Service     | Return behavior       |
| Executive Management | Overall KPI reporting |

Although the dataset is intended for learning purposes, the analytical workflow closely resembles real-world reporting pipelines used by modern e-commerce organizations.

---

# 💡 Technical Highlights

This project focuses on applying SQL to solve practical data engineering and business analytics problems rather than demonstrating isolated SQL syntax.

The implementation showcases an end-to-end analytical workflow, beginning with raw data ingestion and ending with automated reporting.

| Technical Area           | Implementation                                                                             |
| ------------------------ | ------------------------------------------------------------------------------------------ |
| Data Ingestion           | Bulk loading raw CSV files using `LOAD DATA INFILE`                                        |
| Data Transformation      | Standardized raw operational data into an analytical data model                            |
| Data Cleaning            | Trimmed strings, parsed dates, converted numeric values, standardized Boolean fields       |
| Data Validation          | Automated quality checks for row counts, dates, pricing, ratings, discounts, and inventory |
| Analytical SQL           | Business KPIs, ranking analysis, revenue trends, logistics analysis                        |
| Performance Optimization | Composite indexing for faster analytical queries                                           |
| Automation               | Stored Procedure and MySQL Event Scheduler for automatic refresh                           |
| ETL Design               | Layered Raw → Clean → Analytics workflow                                                   |

This project emphasizes practical SQL engineering skills commonly required in Data Analyst, Business Intelligence, and Analytics Engineering roles.

---

# 🤖 Automation

To reduce repetitive manual execution, the ETL process has been encapsulated inside a Stored Procedure.

The procedure performs a complete refresh of the analytical dataset by:

1. Clearing the analytical table.
2. Reloading transformed data from the raw layer.
3. Applying all cleansing and standardization rules.
4. Refreshing the clean analytical dataset.

A MySQL Event Scheduler is then configured to execute the procedure automatically at scheduled intervals.

Automating repetitive ETL tasks improves consistency while reducing manual operational effort.

---

# ⚡ Performance Optimization

Several optimization strategies were incorporated into the project to improve analytical query performance.

### Composite Indexes

Indexes are created on frequently queried columns to reduce execution time for filtering and aggregation operations.

Example optimization targets include:

* Product Category
* Brand
* Revenue Analysis
* Delivery Status
* Customer Location

These indexes improve query responsiveness when working with larger analytical datasets.

---

# 📂 Repository Structure

```text
Amazon-Ecommerce-ETL-Pipeline/
│
├── DATA /
│   └── DATA/amazon_ecommerce_1M - Stable Space.zip
│
├── SQL/
│   └── amazon_analyst_script.sql
│
├── README.md
│
└── LICENSE
```

> **Note:**
> Folder names can be adjusted based on your preferred repository structure.

---

# 🛠️ Technology Stack

| Category        | Technology                         |
| --------------- | ---------------------------------- |
| Database        | MySQL 8                            |
| Language        | SQL                                |
| ETL             | SQL-Based ETL Pipeline             |
| Data Quality    | SQL Validation Rules               |
| Automation      | Stored Procedure & Event Scheduler |
| Version Control | Git & GitHub                       |

---

# 🧠 Skills Demonstrated

This project demonstrates practical experience in multiple technical domains.

### SQL

* Data Definition Language (DDL)
* Data Manipulation Language (DML)
* Aggregate Functions
* Window Functions
* Common Table Expressions (CTEs)
* Conditional Logic
* Stored Procedures
* Event Scheduler

### Data Engineering

* ETL Pipeline Design
* Data Transformation
* Data Cleansing
* Data Validation
* Data Standardization
* Query Performance Optimization

### Business Analytics

* KPI Development
* Revenue Analysis
* Product Performance Analysis
* Logistics Performance Analysis
* Customer Return Analysis
* Trend Analysis

### Database Design

* Layered Architecture
* Analytical Table Design
* Composite Indexing
* Transaction Management

---

# 🚀 Future Improvements

Potential enhancements for future iterations of this project include:

* Incremental ETL loading instead of full refresh.
* Error logging framework for ETL execution.
* Slowly Changing Dimension (SCD) implementation.
* Data warehouse star schema modeling.
* Power BI dashboard integration.
* Tableau dashboard integration.
* Docker-based deployment.
* CI/CD pipeline for automated testing and deployment.

These enhancements would further align the project with production-grade analytical data pipelines.

---

# 📖 Key Learning Outcomes

Throughout this project, the following practical concepts were applied:

* Designing a structured ETL workflow.
* Transforming raw operational data into analytical datasets.
* Applying SQL data quality validation techniques.
* Implementing reusable automation using Stored Procedures.
* Improving query performance through indexing.
* Generating business insights using advanced SQL analytical techniques.

The project demonstrates how SQL can be used not only for querying data but also for building maintainable analytical workflows.

---

# 👨‍💻 About the Author

**Bogo**

Accounting Professional | Audit | Data Analytics Enthusiast

I enjoy combining accounting, auditing, and data analytics to transform raw business data into meaningful insights. My current learning journey focuses on SQL, Business Intelligence, Data Analytics, and Data Engineering while continuously building practical portfolio projects based on real-world business scenarios.

Feel free to connect, provide feedback, or discuss ideas for improving this project.

---

# ⭐ If You Found This Repository Helpful

If you found this project useful or interesting, consider giving it a ⭐ on GitHub.

Feedback, suggestions, and constructive discussions are always welcome.

---

# 📄 License & Data Attribution

The dataset used in this project is a publicly available Amazon E-commerce transactional dataset published on Kaggle by Stable Space.
All custom data tier designs, automated data quality tracking logic, indexing schemes, and advanced metrics queries have been designed and coded independently by the author for professional portfolio and data verification evaluation.

---

# 🙏 Acknowledgements

Special thanks to the open data community for making publicly available datasets accessible for learning and portfolio development.

This project was created solely for educational purposes to demonstrate SQL, ETL, and Business Analytics techniques using a publicly available e-commerce dataset.
