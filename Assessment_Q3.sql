USE adashi_staging;
SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    COALESCE(MAX(s.transaction_date), MAX(w.transaction_date)) AS last_transaction_date,
    DATEDIFF(NOW(), COALESCE(MAX(s.transaction_date), MAX(w.transaction_date))) AS inactivity_days
FROM 
    plans_plan p
LEFT JOIN 
    savings_savingsaccount s ON p.id = s.plan_id AND s.transaction_status = 'successful'
LEFT JOIN 
    withdrawals_withdrawal w ON p.id = w.plan_id
WHERE 
    (p.is_regular_savings = 1 OR p.is_a_fund = 1)
    AND p.is_deleted = 0
    AND p.is_archived = 0
GROUP BY 
    p.id, p.owner_id
HAVING 
    inactivity_days > 365 OR inactivity_days IS NULL
ORDER BY 
 inactivity_days DESC;