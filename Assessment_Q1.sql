USE adashi_staging;
SELECT 
    cu.id AS owner_id,
    CONCAT(cu.first_name, ' ', cu.last_name) AS name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    SUM(sa.confirmed_amount) / 100 AS total_deposits  -- Converting kobo to main currency
FROM 
    users_customuser cu
JOIN 
    plans_plan p ON cu.id = p.owner_id
JOIN 
    savings_savingsaccount sa ON p.id = sa.plan_id
GROUP BY 
    cu.id, cu.first_name, cu.last_name
HAVING 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) >= 1
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) >= 1
ORDER BY 
    total_deposits DESC;