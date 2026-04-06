# 🚀 Global Space Missions Analysis (1957–2022)

### 🌌 End-to-End Data Analytics Project | SQL + Power BI

## 📌 1. Project Title & Headline

🚀 **Global Space Missions Analysis (1957–2022)**
📊 An end-to-end data analytics project leveraging SQL and Power BI to uncover trends, performance, and global patterns in space missions.

## 🧭 2. Short Description / Purpose
   This project analyzes global space mission data from 1957 to 2022 to uncover insights related to launch trends, mission success rates, country dominance,          rocket usage, and geographic launch patterns. SQL was used for data cleaning, transformation, and feature engineering to make the dataset analysis-ready. Power    BI was then used to build an interactive dashboard that enables users to explore historical trends and performance metrics. The dashboard is designed to           provide both high-level summaries and detailed insights for decision-making. Overall, the project demonstrates how raw data can be transformed into meaningful     business insights through analytics and visualization.

## 🛠️ 3. Tech Stack
* 🧮 **SQL Server** – Data cleaning, transformation, feature engineering, analytical queries
* 📊 **Power BI** – Data visualization, dashboard design, interactive reporting
* 📐 **DAX (Data Analysis Expressions)** – Measures and KPIs (Success Rate, Total Missions, etc.)
* 📁 **Excel (Optional)** – Initial data inspection and preprocessing

## 📂 4. Data Source
* 📡 Dataset: Historical Space Missions Data (1957–2022)
* Contains:
  * Launch date and time
  * Location and country
  * Rocket details and status
  * Mission status (Success/Failure)
  * Price (where available)

## ✨ 5. Features / Highlights
### 🧩 a) Business Problem
    The space industry has evolved significantly over decades, but understanding patterns in mission success, launch frequency, country dominance, and                 infrastructure concentration is complex due to fragmented and raw data.

The goal was to transform this raw dataset into actionable insights that answer key questions such as:
* How have space missions evolved over time?
* Which countries dominate space exploration?
* Which rockets are most used and still active?
* Where are launches geographically concentrated?

### 🎯 b) Goal of the Project

#### 🔹 SQL (Data Preparation & Analysis)
      * Cleaned raw data by handling missing values and removing inconsistencies
      
      * Extracted meaningful features:
          * `launch_year`
          * `launch_decade`
          * `country`
          * `launch_site
          
      * Created analytical views for:
          * Launch trends over time
          * Mission success rate
          * Country performance
          * Rocket usage
          * Launch location patterns
      
      * Structured data for efficient Power BI consumption

#### 🔹 Power BI (Visualization & Storytelling)
      * Built a 2-page interactive dashboard :
          * 📊 Page 1: Visual Analysis Dashboard
          * 📄 Page 2: Key Insights Summary
          
      * Created KPIs:
          * Total Missions
          * Successful Missions
          * Success Rate
          * Added slicers for dynamic filtering:
              * Year
              * Country
              
      * Designed a clean and intuitive layout for storytelling
      
### 📊 c) Project Walkthrough (SQL + Visuals)

#### 🔹 SQL Work
      * Data Cleaning:
          * Removed duplicates
          * Handled NULL and NaN values
          
      * Feature Engineering:
          * Extracted year, decade, country, and launch site
      
      * Created views such as:
          * `launches_per_year`
          * `success_rate_yearly`
          * `country_success`
          * `rocket_usage`
          * `launches_by_site`

#### 🔹 Power BI Visuals

| Visual                                   | Purpose                                       |
| ---------------------------------------- | --------------------------------------------- |
| 📈 **Line Chart (Launch Trend)**         | Shows how mission frequency changed over time |
| 📈 **Line Chart (Success Rate)**         | Tracks improvement in mission reliability     |
| 📊 **Bar Chart (Country Success)**       | Identifies top-performing countries           |
| 📊 **Bar Chart (Rocket Usage)**          | Shows most used rockets and their status      |
| 🌍 **Map Visual**                        | Displays global launch distribution           |
| 📊 **Bar Chart (Launch Sites)**          | Highlights top launch locations               |
| 📊 **Stacked Column (Decade Dominance)** | Shows country dominance across decades        |

### 💡 d) Business Impact & Insights

#### 🔍 Key Insights:
* 🚀 **Launch Growth**: Significant increase in launches after 2000 due to commercial space expansion
* 📈 **Reliability Improvement**: Mission success rates improved steadily over time
* 🌍 **Global Leadership**: USA and Russia dominated historically; China is rapidly growing
* 🛰 **Rocket Utilization**: Few rockets account for most missions, indicating standardization
* 📍 **Launch Clusters**: Launches are concentrated in key locations like Cape Canaveral and Baikonur

#### 📌 Business Impact:
* Helps understand **technological progress in aerospace**
* Enables **strategic planning for space missions**
* Identifies **high-performance launch sites and rockets**
* Supports **resource allocation and infrastructure decisions**

### 🏆Conclusion :
This project analyzes global space missions from 1957–2022 to uncover trends in launch frequency, mission success, country dominance, and launch locations. Using SQL and Power BI, it transforms raw data into actionable insights, highlighting the evolution of the space industry and the growing role of modern space programs.

## 📷 Screenshots :
https://github.com/ChirasreeRoy/Space-Missions-Dashboard/blob/main/1st%20Snapshot.png

https://github.com/ChirasreeRoy/Space-Missions-Dashboard/blob/main/2nd%20Snapshot.png


