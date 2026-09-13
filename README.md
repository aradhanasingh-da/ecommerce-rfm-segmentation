# End-to-End E-Commerce Customer RFM Segmentation

## 📌 Project Overview
Analyzed 500k+ transaction records from an online retail database to segment customers based on Recency, Frequency, and Monetary (RFM) metrics. Implemented data cleaning and transformation in PostgreSQL and created an interactive dashboard in Power BI.

## 🛠️ Tools & Technologies Used
- **Database / Data Transformation**: PostgreSQL 16 (SQL - Aggregations, Window Functions, CASE WHEN)
- **Business Intelligence**: Power BI Desktop
- **Data Export**: CSV

## 📊 Key Business Insights
1. **Champions Focus**: 18.1% of the customer base accounts for over $5.2M (58%+) of total revenue ($8.91M total).
2. **Churn Risk**: 35.9% of customers fall into the **Lost / Inactive** segment, representing a target for win-back campaigns.
3. **Core Metrics**: 4,338 unique active customer profiles analyzed.

## 🚀 How to Run
1. Run SQL scripts in `/sql/01_rfm_segmentation.sql` against PostgreSQL.
2. Open `/dashboards/RFM_Customer_Segmentation_Dashboard.pbix` in Power BI Desktop to interact with dashboard filters.
