USE credit_risk_db;

DROP TABLE IF EXISTS credit_risk_sql_1k;

CREATE TABLE credit_risk_sql_1k (
    SK_ID_CURR INT,
    TARGET INT,
    CODE_GENDER VARCHAR(10),
    AGE_YEARS INT,
    EMPLOYED_YEARS DOUBLE,
    AMT_INCOME_TOTAL DOUBLE,
    AMT_CREDIT DOUBLE,
    EXT_SOURCE_2 DOUBLE
);

SELECT COUNT(*) FROM credit_risk_sql_1k;

SELECT * 
FROM credit_risk_sql_1k 
LIMIT 10;

## Total Customers & Default Rate

SELECT 
    COUNT(*) AS total_customers,
    SUM(TARGET) AS total_defaulters,
    ROUND(AVG(TARGET)*100, 2) AS default_rate_percent
FROM credit_risk_sql_1k;

-- Shows overall loan default rate
-- First metric banks always check


## Default Rate by Gender

SELECT 
    CODE_GENDER,
    COUNT(*) AS customers,
    ROUND(AVG(TARGET)*100, 2) AS default_rate_percent
FROM credit_risk_sql_1k
GROUP BY CODE_GENDER;

-- Gender has minor impact on default risk
-- Used for segmentation, not decision alone

## Income-Based Risk Segmentation

SELECT 
    CASE 
        WHEN AMT_INCOME_TOTAL < 100000 THEN 'Low Income'
        WHEN AMT_INCOME_TOTAL BETWEEN 100000 AND 300000 THEN 'Middle Income'
        ELSE 'High Income'
    END AS income_group,
    COUNT(*) AS customers,
    ROUND(AVG(TARGET)*100, 2) AS default_rate_percent
FROM credit_risk_sql_1k
GROUP BY income_group
ORDER BY default_rate_percent DESC;


-- Low-income group shows highest default risk
-- Income is a strong risk indicator


## Credit Score Risk Analysis--------------


SELECT 
    CASE 
        WHEN EXT_SOURCE_2 < 0.3 THEN 'Low Credit Score'
        WHEN EXT_SOURCE_2 BETWEEN 0.3 AND 0.6 THEN 'Medium Credit Score'
        ELSE 'High Credit Score'
    END AS credit_score_group,
    COUNT(*) AS customers,
    ROUND(AVG(TARGET)*100, 2) AS default_rate_percent
FROM credit_risk_sql_1k
GROUP BY credit_score_group
ORDER BY default_rate_percent DESC;

-- Lower credit score → much higher default rate
-- Confirms Python EDA findings


## Age Group vs Default

SELECT 
    CASE 
        WHEN AGE_YEARS < 30 THEN 'Young'
        WHEN AGE_YEARS BETWEEN 30 AND 50 THEN 'Adult'
        ELSE 'Senior'
    END AS age_group,
    COUNT(*) AS customers,
    ROUND(AVG(TARGET)*100, 2) AS default_rate_percent
FROM credit_risk_sql_1k
GROUP BY age_group
ORDER BY default_rate_percent DESC;

-- Younger applicants show slightly higher risk
-- Age is a moderate predictor


## Employment Stability vs Default


SELECT 
    CASE 
        WHEN EMPLOYED_YEARS < 2 THEN 'Low Experience'
        WHEN EMPLOYED_YEARS BETWEEN 2 AND 5 THEN 'Medium Experience'
        ELSE 'High Experience'
    END AS employment_group,
    COUNT(*) AS customers,
    ROUND(AVG(TARGET)*100, 2) AS default_rate_percent
FROM credit_risk_sql_1k
GROUP BY employment_group
ORDER BY default_rate_percent DESC;

-- Less employment stability → higher default risk
