# Amazon_Sales_Report_Cleaning_Analysis

Project overview:
This project focuses on analyzing Amazon sales report data using MYSQL to identify business insights related to sales, performance, product demand, order trends, customer locations and fulfillment operations.
The project involves exploring and cleaning raw data than analysis to answer practical business questions.

Business Problem:
Amazon sales report data contains information about orders, products, quantities, revenue, status, fulfillment methods and customer locations.
The company wants to understand sales performance, identify high-performing products and categories, analyze customer demand across locations, and evaluate order and fulfillment performance. 

This project uses MYSQL to answer relevant business questions and generate insights that can support better business decisions.

Dataset: 
amazon products sales  [source: Kaggle (thanks)] 

Tools & Technologies: 
SQL (MYSQL)
GitHub

Data Cleaning:
The raw dataset was checked and cleaned for analysis using MYSQL.
- Check the dataset and understand structure.
- Checking duplicates.
- Identifying null and blank values.
- Removing unnecessary columns.
- Handling blank values in important columns.
- Cleaning strings and Standardizing them.
- Handling dates and data types.
- Checking outliers and validating.
- Final checking and validations.

Data Analysis:
- Total orders.
- Total revenue (Gross revenue, Net revenue).
- Average quantity per order.
- Monthly sales trend.
- Highest/Lowest sales dates.
- Highest order volume date.
- Top 5 states (Net revenue).
- Top 5 states (Highest/Lowest orders).
- Top 5 states (cancellation rate).
- Top 3 categories (Net revenue).
- Top 3 categories (average selling price).
- Category which has highest cancellation rate.
- Top 10 most selling SKUs.
- Top 3 most frequently ordered sizes.
- Top 10 best performing product styles.
- Total shipped orders.
- Total cancelled orders.
- Cancellation percentage.
- Total returned and rejected orders.
- Total lost in transit orders.
- Total damaged orders.
- Most revenue generating fulfillment method.
- Highest successful delivery rate fulfillment method.
- Fulfillment method which has more cancellations.
- Comparing amazon fulfillment method and merchant fulfillment method.

Project Outcomes:
Cleaned the raw dataset and prepared it for analysis using MYSQL.
Key Findings:
Revenue: Gross revenue is 78592678.30 INR however Net revenue is 68975070.00 INR because some orders are pending and a few returned or rejected.
Quantity: average quantity per order is 1.08, it means mostly retail customer are purchasing.
Cancellation: Cancellations percentage is 14.28, which is a bit high.
Lost: lost in transit products are 4, its in control.
Damage: Only one product is damaged, which is a good sing.
Fulfillment method: Amazon fulfillment method overall performed better than Merchant fulfillment method.

Future Improvements:
- Build an interactive Power BI dashboard.
- Advanced analysis.
- Add detailed business recommendations.
