USE banking_intelligence;
SELECT
    AccountID,
    total_transactions,
    ROUND(total_spend,2) AS total_spend,
    ROUND(avg_spend,2) AS avg_spend,
    InactiveDays
FROM customer_summary
ORDER BY total_spend DESC
LIMIT 10;
SELECT 
    AccountID,
    total_transactions,
    ROUND(total_spend, 2) AS total_spend,
    InactiveDays,
    CASE 
        WHEN InactiveDays > 60 THEN 'High Risk'
        WHEN InactiveDays > 30 THEN 'Medium Risk'
        ELSE 'Active'
    END AS churn_risk
FROM customer_summary
ORDER BY InactiveDays DESC
LIMIT 10;
SELECT 
    Channel,
    COUNT(*) AS total_transactions,
    ROUND(SUM(TransactionAmount), 2) AS total_revenue,
    ROUND(AVG(TransactionAmount), 2) AS avg_transaction,
    ROUND(SUM(TransactionAmount) * 100.0 / 
        SUM(SUM(TransactionAmount)) OVER(), 2) 
        AS revenue_percentage
FROM transactions
GROUP BY Channel
ORDER BY total_revenue DESC;
WITH customer_segments AS (
    SELECT 
        AccountID,
        ROUND(total_spend, 2) AS total_spend,
        total_transactions,
        InactiveDays,
        CASE 
            WHEN total_spend > 3000 THEN 'VIP'
            WHEN total_spend > 1500 THEN 'Regular'
            ELSE 'Low Value'
        END AS segment
    FROM customer_summary
)
SELECT 
    segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_spend), 2) AS avg_spend,
    ROUND(SUM(total_spend), 2) AS total_revenue
FROM customer_segments
GROUP BY segment
ORDER BY total_revenue DESC;
SELECT 
    AccountID,
    ROUND(total_spend, 2) AS total_spend,
    total_transactions,
    InactiveDays,
    RANK() OVER (ORDER BY total_spend DESC) AS spend_rank,
    NTILE(4) OVER (ORDER BY total_spend DESC) AS spend_quartile
FROM customer_summary
LIMIT 15;
SELECT 
    YEAR(TransactionDate) AS year,
    MONTH(TransactionDate) AS month,
    COUNT(*) AS total_transactions,
    ROUND(SUM(TransactionAmount), 2) AS monthly_revenue,
    ROUND(AVG(TransactionAmount), 2) AS avg_transaction
FROM transactions
GROUP BY YEAR(TransactionDate), MONTH(TransactionDate)
ORDER BY year, month;
SELECT 
    AccountID,
    unique_devices,
    unique_locations,
    total_transactions,
    ROUND(total_spend, 2) AS total_spend,
    CASE
        WHEN unique_devices > 5 
             AND unique_locations > 5 THEN 'High Fraud Risk'
        WHEN unique_devices > 3 
             OR unique_locations > 4 THEN 'Medium Fraud Risk'
        ELSE 'Low Risk'
    END AS fraud_risk
FROM customer_summary
HAVING fraud_risk != 'Low Risk'
ORDER BY unique_devices DESC
LIMIT 15;
    