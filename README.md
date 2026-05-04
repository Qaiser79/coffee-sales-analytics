# ☕ Coffee Sales Analytics Pipeline

> End-to-end ELT pipeline built with AWS S3, 
Snowflake, dbt and Power BI

![AWS S3](https://img.shields.io/badge/AWS_S3-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)
![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)
![PowerBI](https://img.shields.io/badge/PowerBI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)

---

## 📋 Project Overview

This project demonstrates a complete end-to-end 
ELT pipeline for a coffee sales business operating 
across 3 stores in New York City. Raw transactional 
data is ingested from AWS S3 into Snowflake, 
transformed using dbt into a star schema, and 
visualized in an interactive Power BI dashboard.

---

## 🏗️ Architecture

![Architecture Diagram](add_your_canva_diagram_image_here)

CSV Files → AWS S3 → Snowflake (Raw Layer)
→ dbt (Staging + Marts) → Power BI Dashboard

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| AWS S3 | Raw data storage |
| Snowflake | Cloud data warehouse |
| dbt | Data transformation |
| Power BI | Business intelligence |
| SQL | Data modeling |

---

## 📁 Project Structure

coffee-sales-analytics/
├── models/
│   ├── staging/
│   │   ├── stg_products.sql
│   │   └── stg_stores.sql
│   │   └── stg_sales_transactions.sql
│   └── marts/
│       ├── dim_products.sql
│       ├── dim_stores.sql
│       ├── fct_sales_transactions.sql
│       ├── mart_daily_sales_by_store.sql
│       ├── mart_daily_sales_per_store_per_category.sql
│       └── mart_top_products.sql
├── tests/
├── macros/
├── dbt_project.yml
└── packages.yml

---

## 📊 Data Model

### Star Schema

DIM_PRODUCTS ────┐
↓
DIM_STORES ──────→ FCT_SALES_TRANSACTIONS
↑
DIM_DATES ───────┘

### Mart Tables (Pre-aggregated)

mart_daily_sales_by_store
mart_daily_sales_per_store_per_category
mart_top_products


---

## 🔄 dbt Layers

### Staging Layer
- Raw data cleaning and renaming
- Basic type casting
- Null handling
- Surrogate keys generation

### Marts Layer
**Dimension Tables:**
- `dim_products` → Product details and categories
- `dim_stores` → Store names and locations

**Fact Table:**
- `fct_sales_transactions` → All sales transactions

**Aggregated Marts:**
- `mart_daily_sales_by_store` → Daily revenue per store
- `mart_daily_sales_per_store_per_category` → Category breakdown
- `mart_top_products` → Top performing products ranking

---

## 📈 Power BI Dashboard

### Page 1 — Overview
<img width="1454" height="816" alt="Coffee Dashboard Pic2" src="https://github.com/user-attachments/assets/dffd889c-0eb2-45e0-9d16-2884c67c7208" />


### Page 2 — Store & Category Performance
<img width="1462" height="814" alt="Coffee Dashboard Pic3" src="https://github.com/user-attachments/assets/1494cc5e-c0ba-4456-9522-ccea91f0f7d9" />



**Key Metrics:**
- Total Revenue
- Total Transactions
- Average Transaction Value
- Month over Month Growth
- YTD Revenue
- Revenue by Store
- Revenue by Category
- Store Performance Heatmap

---

## 🚀 How To Run

### Prerequisites

Snowflake account
AWS S3 bucket
dbt installed
Python 3.8+

### Setup

**1. Clone the repository**
```bash
git clone https://github.com/Qaiser79/coffee-sales-analytics.git
cd coffee-sales-analytics
```

**2. Install dbt dependencies**
```bash
dbt deps
```

**3. Configure profiles.yml**
```yaml
coffee_sales_analytics:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: your_account
      user: your_user
      password: your_password
      role: your_role
      database: your_database
      warehouse: your_warehouse
      schema: your_schema
```

**4. Load raw data to Snowflake**
```sql
-- Create stage
CREATE OR REPLACE STAGE coffee_stage
  URL = 's3://your-bucket/'
  CREDENTIALS = (
    AWS_KEY_ID = 'your_key'
    AWS_SECRET_KEY = 'your_secret'
  );

-- Load data
COPY INTO raw.sales_transactions
FROM @coffee_stage/sales.csv
FILE_FORMAT = csv_format;
```

**5. Run dbt models**
```bash
-- Test connection
dbt debug

-- Run all models
dbt run

-- Run tests
dbt test
```

---

## 💡 Key Insights

- **Hell's Kitchen** is the top performing store
- **Coffee** is the highest revenue category
- Revenue shows consistent **month over month growth**
- **May 2023** was the best performing month
- All 3 stores perform similarly with ~$124-126K revenue

---

## 👤 Author

**Qaiser**
- GitHub: [@Qaiser79](https://github.com/Qaiser79)
- Snowflake Certified Data Engineer
- Microsoft Power BI Data Analyst Associate
- Google Advanced Data Analytics Certificate
