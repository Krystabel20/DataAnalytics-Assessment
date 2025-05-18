# Data Analytics Assessment

This repository contains SQL solutions for a Data Analyst Assessment focused on analyzing customer data across multiple relational database tables.

## Approach to Solutions

### Question 1: High-Value Customers with Multiple Products
- **Approach**: I joined the users table with plans and savings accounts tables to identify customers with both savings and investment plans.
- **Key Techniques**: Used COUNT with CASE statements to determine the number of each plan type per customer and concatenated first_name and last_name fields to display the full customer name.
- **Notes**: Converted amounts from kobo to the main currency unit by dividing by 100 for better readability.

### Question 2: Transaction Frequency Analysis
- **Approach**: Created a CTE to calculate each customer's average monthly transaction count, then categorized them into frequency segments.
- **Key Techniques**: Used TIMESTAMPDIFF to determine the timespan in months between the first and last transaction.
- **Challenges**: Ensuring accurate monthly averages required careful consideration of edge cases where customers might have very short tenure periods.

### Question 3: Account Inactivity Alert
- **Approach**: Identified the most recent transaction date for each plan and calculated the inactivity period.
- **Key Techniques**: Used MAX() with dates and DATEDIFF to calculate days since last activity.
- **Notes**: Included plans with no transactions by using a LEFT JOIN to catch accounts that have never had any transactions.

### Question 4: Customer Lifetime Value Estimation
- **Approach**: Calculated tenure in months for each customer, counted their total transactions, and applied the CLV formula.
- **Key Techniques**: Used aggregation functions with mathematical operations to implement the CLV formula.
- **Challenges**: Handling the profit calculation required careful consideration of the 0.1% profit margin and conversion from kobo currency units. Added NULLIF to prevent division by zero errors.

## Challenges Faced

1. **Data Structure Understanding**: Without direct access to the database schema documentation, I had to make reasonable assumptions about certain fields (like date_created for timestamps and status for plan activity).

2. **Currency Conversion**: All financial values are stored in kobo, requiring conversion to the main currency unit for meaningful results.

3. **Edge Cases**: Ensuring queries handle edge cases like zero transactions or very short tenure periods without errors by implementing NULLIF and appropriate HAVING clauses.

4. **Query Optimization**: Structured the queries to be efficient while maintaining readability, using appropriate joins and filtering conditions.
