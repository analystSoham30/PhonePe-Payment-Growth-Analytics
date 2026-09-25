# PhonePe-Payment-Growth-Analytics

The primary objective of this project is to analyze multi-year PhonePe transaction, user, and device data to uncover macro payment trends, regional penetration gaps, and customer usage behaviors across India. By leveraging Python for data extraction, MySQL for relational querying, and Power BI for interactive visualization, the project translates raw fintech datasets into actionable business insights—identifying tier-2/3 market expansion opportunities, merchant adoption dynamics, hardware optimization needs, and seasonal infrastructure demand.

## Dashboard preview - 

1. State based overview

<img width="1346" height="755" alt="PhonePe - 1" src="https://github.com/user-attachments/assets/932237e4-aa4c-4e53-a524-989c49df4825" />

2. District based overview:
   
<img width="1345" height="756" alt="PhonePe - 2" src="https://github.com/user-attachments/assets/4d298dfd-b853-4fd1-b424-13583ca26aca" />

3. Payment categories overview

<img width="1343" height="758" alt="PhonePe - 3" src="https://github.com/user-attachments/assets/9640bc81-ea9f-4e50-a073-457e7ebb7538" />

4. Device brand overview

<img width="1341" height="755" alt="PhonePe - 4" src="https://github.com/user-attachments/assets/bc0947bb-3ebc-4484-ac7c-ffea1b83e650" />

## Tech stack -
* Excel – Data source and initial data preparation
* Python - Data cleaning, handling missing values and necessary data imputation
* MySQL – Analysis queries and view creation
* Power BI – Data modeling, DAX measure creation, and interactive 4-page executive dashboard

## Repository Architecture - 
-**/Raw data/**: original database used for the analysis.

-**/SQL scripts/**: MySQL scripts used for analysis, view creation.

-**/Python scripts/**: Python scripts used for data cleaning, data imputation.

-**/PowerBI Dashboard/**: Data visualization and dashboard creation

## Key business insights - 

1. Top 5 states (led by Maharashtra & Telangana) generate 68% of total GTV, demonstrating a strong Pareto distribution in geographic payment adoption.

2. Merchant payments account for 42.5% of total transaction volume with an ATV of ₹220, proving high-frequency offline retail penetration.

3. Top 10% of districts account for 54% of total state transaction volume, highlighting significant growth opportunity in 400+ under-penetrated tier-2/3 districts.

4. Entry-level Android smartphones power 78% of active user volume, driving the priority for lightweight app architecture, fast QR scanning, and low-memory resource usage.

5. Q3 and Q4 transaction volumes surge by 22% compared to H1, driven by festive consumer demand and localized merchant promotions.

## Strategic Recommendations - 
1. **Target Tier-2/3 Merchant Expansion:** Deploy QR distribution hubs to high-density, low-penetration districts (where 90% of districts yield only 46% of volume) to capture untapped regional growth.

2. **Optimize for Entry-Level Hardware:** Reduce app memory footprint and speed up camera/QR scanning for budget Android devices (78% of users) to prevent transaction drop-offs.

3. **Scale Infrastructure for Q3/Q4 Festive Surges:** Implement dynamic server auto-scaling and targeted merchant cashback ahead of Q3/Q4 to seamlessly handle the 22% seasonal volume spike.

