USE adashi_staging;
WITH customer_transactions AS (
    SELECT 
        cu.id AS customer_id,
        -- Ensure we don't divide by zero by using NULLIF or adding 1 to month difference
        COUNT(sa.id) AS total_transactions,
        -- Get the time range in months (at least 1 month to avoid division by zero)
        GREATEST(1, TIMESTAMPDIFF(MONTH, MIN(sa.transaction_date), CURDATE())) AS months_active,
        -- Calculate average transactions per month
        COUNT(sa.id) / GREATEST(1, TIMESTAMPDIFF(MONTH, MIN(sa.transaction_date), CURDATE())) AS avg_transactions_per_month
    FROM 
        users_customuser cu
    JOIN 
        savings_savingsaccount sa ON cu.id = sa.owner_id
    WHERE
        sa.transaction_date IS NOT NULL
    GROUP BY 
        cu.id
)

SELECT 
    CASE 
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month BETWEEN 3 AND 9.99 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM 
    customer_transactions
GROUP BY 
    CASE 
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month BETWEEN 3 AND 9.99 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;