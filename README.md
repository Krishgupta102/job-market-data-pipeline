# Job Market Data Pipeline

An end-to-end data engineering pipeline built with **PySpark, Databricks, Delta Lake, and SQL** to transform raw job-posting data into a structured analytical data model.

The project follows a **Bronze → Silver → Gold** architecture and implements a **star schema** for job-market analytics.

## 📌 Project Overview

This project processes approximately **22,000 job postings** from a raw CSV dataset.

The pipeline performs:

- Raw data ingestion using PySpark
- Data cleaning and standardization
- Salary extraction and parsing
- Job-type normalization
- Duplicate and data-quality validation
- Dimensional modeling
- Star-schema construction
- Delta Lake storage
- SQL-based analytical queries

The final Gold layer contains a fact table and four dimension tables that can be queried for job-market insights.

## 🏗️ Architecture

```text
                    Raw CSV Dataset
                          │
                          ▼
                 ┌─────────────────┐
                 │  Bronze Layer   │
                 │   Raw Job Data  │
                 └────────┬────────┘
                          │
                          ▼
                 ┌─────────────────┐
                 │  Silver Layer   │
                 │                 │
                 │ • Data Cleaning │
                 │ • Salary Parsing│
                 │ • Normalization │
                 │ • Validation    │
                 └────────┬────────┘
                          │
                          ▼
                 ┌─────────────────┐
                 │   Gold Layer    │
                 │   Delta Lake    │
                 └────────┬────────┘
                          │
             ┌────────────┼────────────┐
             │            │            │
             ▼            ▼            ▼
       Dimensions      Fact Table   SQL Analytics
             │            │
       ┌─────┼─────┐      │
       │     │     │      │
    Industry Role Location │
                     Job Type
                          │
                          ▼
                   Job Market Insights
```

## 🔄 Data Pipeline

### 1. Bronze Layer

The Bronze layer contains the raw job-posting data ingested from the CSV dataset.

PySpark CSV ingestion was configured to correctly handle:

- Header rows
- Quoted fields
- Multiline job descriptions
- Embedded quotation marks

The raw dataset contains **22,000 job postings** and **14 source columns**.

### 2. Silver Layer

The Silver layer applies data cleaning and transformation using PySpark.

### Data Cleaning

The pipeline performs:

- String trimming
- Empty-string handling
- Null handling
- Job-title cleaning
- Job-type normalization
- Boolean standardization
- Duplicate validation

### Job Type Normalization

Different representations of the same job type were standardized.

For example:

```text
Full Time
Full Time Employee
Full Time, Employee
Full Time / Employee
```

are normalized into:

```text
Full Time
```

Similarly, part-time and temporary/contract values are standardized.

### Job Title Cleaning

Raw job titles containing HTML, CSS, JavaScript artifacts, and unnecessary whitespace were cleaned to produce a standardized `job_title_clean` field.

### Salary Parsing

Salary strings were transformed into structured fields:

```text
salary_min
salary_max
salary_period
salary_parse_status
```

The pipeline handles salary formats such as:

```text
80,000.00 - 95,000.00 $ /year
9.00 - 13.00 $ /hour
Up to $32000.00
$50,000.00+ /year
```

Invalid salary ranges were identified and corrected during validation.

## 🥇 Gold Layer

The Gold layer contains the final analytical data model stored using **Delta Lake**.

The model follows a **star-schema design**.

### Fact Table

#### `fact_job_postings`

Key columns:

```text
job_id
role_id
industry_id
location_id
job_type_id
salary_min
salary_max
salary_period
salary_parse_status
has_expired
job_board
page_url
```

## 📊 Dimension Tables

### `dim_industry`

```text
industry_id
industry_name
```

Records: **164**

### `dim_role`

```text
role_id
role_name
```

Records: **18,754**

### `dim_location`

```text
location_id
location
country
country_code
```

Records: **8,424**

### `dim_job_type`

```text
job_type_id
job_type
```

Records: **8**

The dimension includes an `Unknown` category for missing values.

## ⭐ Star Schema

```text
                    dim_industry
                         │
                         │
dim_location ─── fact_job_postings ─── dim_role
                         │
                         │
                    dim_job_type
```

Foreign keys are used to connect the fact table with the corresponding dimension tables.

An `Unknown` key with value `0` is used where dimension attributes are unavailable.

## 🧪 Data Quality Validation

| Validation | Result |
|---|---:|
| Source records | 22,000 |
| Fact records | 22,000 |
| Unique job IDs | 22,000 |
| Duplicate job IDs | 0 |
| Invalid salary ranges | 0 |
| NULL role foreign keys | 0 |
| NULL industry foreign keys | 0 |
| NULL location foreign keys | 0 |
| NULL job-type foreign keys | 0 |

The final Gold layer passed all implemented validation checks.

## 🔎 SQL Analytics

The `sql/analytics.sql` file contains queries for:

- Jobs by Industry
- Jobs by Job Type
- Top Locations
- Salary Statistics
- Top Job Roles
- Industry + Job Type Analysis
- Salary by Industry

## 🛠️ Technology Stack

| Technology | Purpose |
|---|---|
| Python | Data engineering scripting |
| PySpark | Data processing and ETL |
| Apache Spark | Distributed data processing |
| Databricks | Development and execution environment |
| Delta Lake | Analytical data storage |
| SQL | Data analysis and querying |
| Git | Version control |
| GitHub | Project repository |

## 📁 Project Structure

```text
job-market-data-pipeline/
│
├── README.md
│
├── notebooks/
│   └── job_market_data_pipeline.py
│
├── sql/
│   └── analytics.sql
│
└── .gitignore
```

## 🚀 Pipeline Workflow

```text
1. Load raw CSV data
        ↓
2. Create Bronze dataset
        ↓
3. Clean and transform data using PySpark
        ↓
4. Parse and standardize salary information
        ↓
5. Normalize job types
        ↓
6. Clean job titles
        ↓
7. Validate data quality
        ↓
8. Build dimension tables
        ↓
9. Build fact table
        ↓
10. Create star schema
        ↓
11. Store Gold tables as Delta
        ↓
12. Run SQL analytics
```

## 📈 Project Results

The completed pipeline successfully transformed **22,000 raw job postings** into a structured analytical model.

```text
dim_industry       → 164 records
dim_role           → 18,754 records
dim_location       → 8,424 records
dim_job_type       → 8 records
fact_job_postings  → 22,000 records
```

The fact table contains:

- 22,000 unique job IDs
- 0 duplicate job IDs
- 0 NULL foreign keys
- 0 invalid salary ranges after validation

## 🎯 Key Data Engineering Concepts Demonstrated

- ETL pipeline development
- PySpark DataFrame operations
- Data cleaning and transformation
- Data normalization
- Salary parsing
- Data quality validation
- Joins and aggregations
- Window functions
- Dimensional modeling
- Star schema design
- Fact and dimension tables
- Delta Lake
- SQL analytics
- Bronze/Silver/Gold architecture

## 🔮 Future Enhancements

Possible future improvements include:

- Implementing Slowly Changing Dimensions (SCD Type 2)
- Adding automated data-quality checks
- Scheduling the pipeline using Databricks Workflows
- Adding Apache Airflow orchestration
- Integrating additional job-data sources
- Adding incremental data ingestion
- Introducing real-time/streaming job data
- Adding cloud-based orchestration and monitoring

## 📚 Dataset

The project uses a job-posting dataset containing job listings and attributes such as job title, job description, location, organization, salary, sector, job type, job board, and posting URL.

The raw dataset is not included in this repository. Refer to the original dataset source and its licensing/usage terms when obtaining the data.

## 👨‍💻 Author

**Krish Gupta**

Integrated M.Tech — Computer Science & Engineering  
VIT-AP University

## ⭐ Project Highlights

```text
22,000+ Job Records
        +
PySpark ETL
        +
Databricks
        +
Delta Lake
        +
Star Schema
        +
SQL Analytics
        +
Data Quality Validation
```

An end-to-end data engineering project demonstrating the transformation of raw job-market data into a structured analytical data platform.
