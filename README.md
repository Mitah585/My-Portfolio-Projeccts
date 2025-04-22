# Cyclistic Case Study Project Outline

## Project Overview
This case study explores the behavioral differences between Cyclistic’s two primary user segments: **casual riders** and **annual members**. By examining historical bike trip data, we aim to uncover patterns in usage, preferences, and habits that distinguish these groups. Through data cleaning, exploratory analysis, and visualization, we seek to generate actionable insights that support strategic decision-making.

The motivation behind this analysis stems from Cyclistic’s overarching business goal: **increasing the number of annual memberships**. Since annual members contribute more to long-term profitability, converting casual riders into subscribers presents a valuable growth opportunity. Our Director of Marketing, Lily Moreno, believes that a targeted, data-informed marketing campaign could be the key to achieving this goal.

Our findings will serve as the foundation for that campaign, offering a clearer understanding of casual riders' behavior and motivations. These insights will enable the development of tailored strategies that address their preferences and highlight the benefits of membership.

By identifying what resonates with casual riders, we hope to help Cyclistic craft compelling marketing messages and initiatives. Ultimately, this work aims to support Cyclistic's vision of providing inclusive, accessible, and sustainable transportation—while driving profitability and long-term growth.

## 1. Ask

### A. Company Background
Cyclistic is a bike-share company based in Chicago with:
- Fleet of 5,824 bikes
- 692 docking stations
- Offers traditional bikes plus accessible options (reclining bikes, hand tricycles, cargo bikes)
- Used for both leisure and commuting

### B. Products
- Subscription-based model (casual riders and annual members)
- Committed to inclusive and accessible transportation

### C. Stakeholders
- **Lily Moreno**: Director of Marketing (campaign development)
- **Cyclistic marketing analytics team**: Data collection, analysis, and reporting
- **Cyclistic's executive team**: Decision-makers for marketing program approval

### D. Business Task
Determine how casual riders and annual members use Cyclistic bikes differently to inform marketing strategies aimed at converting casual riders into annual members.

### E. Key Questions:
- How do annual members and casual riders use Cyclistic bikes differently?
- What patterns/behaviors are unique to casual riders that could be addressed by marketing?
- What are the trends over time for these groups? Any seasonal patterns?

### F. Assumptions and Limitations:
- **Assumptions**: 
  - Data is accurate, up-to-date, and representative
  - Behaviors are primarily influenced by rider status (casual vs member)
- **Limitations**:
  - No direct demographic data (age, gender, socioeconomic status)
  - Analysis based solely on ride patterns

## 2. Prepare

### a. Data Used
- **Collection method**: Historical trip data via GPS-enabled bikes
- **Publisher**: Motivate International Inc.
- **Format**: CSV files with ride details (timestamps, station info, rideable type, user type)
- **Drawbacks**:
  - No personally identifiable information
  - Significant missing values in station fields
- **Credibility**: High (public data following ROCCC principles)
  - Reliable
  - Original
  - Comprehensive
  - Current
  - Cited

## 3. Process

### a. Organize data using Power Query
### b. Clean using Excel
### c. Record errors and changes

## 4. Analyse
- Transfer data to PostgreSQL from Excel
- Validate data transfer using SQL
- Aggregate the tables
- Conduct diagnostic analysis

### Questions for comparison analysis:
- Which weekdays are most active? What times? Why?
- Weekdays vs. trip duration – Are rides longer at certain days or times? Why?
- Duration brackets – What percentage of rides comprise each bracket? How does it differ for each group?
- Are there certain locations that are frequented more than others? Why?
- Which bike type is used more by each group? Why?
- Which months have higher usage? Why? How does it differ for the two user groups?

## 5. Share
- Download analysis results to Excel and create visualizations
- Upload results to Tableau for additional visualizations
- Create report with analysis process, visualizations, and recommendations
- Develop presentation and presentation video

---

# Cyclistic Case Study: Data Cleaning Changelog

## Step 1: Power Query
- Loaded CSV files into Power Query
- Visually inspected data using ROCCC principles:
  - Reliable
  - Original
  - Comprehensive
  - Current
  - Cited
- Deleted columns with high missing values:
  - start_station_name
  - end_station_name
  - start_station_id
  - end_station_id
- Split timestamps:
  - 'started_at' → started_date, started_time
  - 'ended_at' → ended_date, ended_time
- Extracted:
  - month_name from started_date
  - day_name from started_date
- Loaded cleaned data to Excel worksheet (not as table)

## Step 2: Excel
- Converted table to normal range
- Performed spellcheck (no errors found)
- Searched for duplicates using conditional formatting (none found)
- Filtered and removed rows with blank fields:

| Month       | Blanks Removed | Additional Notes                     |
|-------------|----------------|--------------------------------------|
| April 2024  | 6,706          | start_lat column                     |
| May 2024    | 11,760         | start_lat column                     |
| June 2024   | 15,736         | Also 308,597 errors in station names |
| July 2024   | 16,200         | start_lat column                     |
| August 2024 | 15,405         | start_lat column                     |
| September 2024 | 10,542      | start_lat column                     |
| October 2024 | 7,952        | Also 410,160 errors in station names |
| November 2024 | 4,095        | start_lat column                     |
| December 2024 | 1,703        | start_lat column                     |
| January 2025 | 793          | start_lat column                     |
| February 2025 | 57           | start_lat column                     |
| March 2025  | 241           | start_lat column                     |

- Applied appropriate column formatting (Date, Time, Text, Number)
- Verified ID column lengths using `=LEN()`
- Created 'trip_duration_minutes' column (time difference calculation)
- Fixed negative values using `MOD()` for midnight-crossing errors
- Used `ABS()` for validation

## Step 3: Power Query
- Transformed trip_duration_minutes from time to minutes
- Created 'duration_buckets' column (trip duration ranges)
- Trimmed white spaces from text fields
- Created 'start_hour' column (extracted from started_time)

## Step 4: Excel
- Checked for '0' hour values
- Created new column with `=TEXT()` for AM/PM format
- Formatted start_hour as number
- Verified duration_buckets reflect corrected durations
- Verified column formats

*Repeated these steps for all 12 datasets (April 2024 - March 2025)*
