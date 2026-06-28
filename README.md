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

