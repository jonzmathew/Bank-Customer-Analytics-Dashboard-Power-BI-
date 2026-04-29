create database bank_data;
select * from loan_data;

-- 1. Total Loan Amount Funded
SELECT format(sum('Loan Amount'),2) as Total_loan_Funded from loan_data;

-- 2.Total Loans
SELECT count(*) as Total_loans from loan_data;

-- 3.Total collection
select format(sum(`Total Rec Prncp`)+sum(`Total Rec Interest`),2) as Total_Collection from loan_data;

-- 4. Total intrest
select format(sum(`Total Rec Interest`),2)
 as Total_Intrest from loan_data;
 
 -- 5. Branchwie data
 SELECT 
    `Branch Name`,
    format(SUM(`Total Rec Interest`) ,2) as Total_rec,
    format(SUM(`Total Fees`),2)  as Fee ,
    format(SUM(`Total Rec Interest` + `Total Fees`),2) AS TotalRevenue
FROM loan_data
GROUP BY `Branch Name`
ORDER BY TotalRevenue DESC;

-- 6.. State-Wise Loan
SELECT 
    `State Name`,
    COUNT(`Client id`) AS NumberOfLoans,
    SUM(`Loan Amount`) AS TotalLoanAmount,
    ROUND(
        100.0 * SUM(`Loan Amount`) / (SELECT SUM(`Loan Amount`) FROM loan_data), 
        2
    ) AS PercentageOfTotal
FROM Loan_data
GROUP BY `State Name`
ORDER BY TotalLoanAmount DESC;

-- 7. Religion wise Loan
SELECT 
    Religion,
    COUNT(`Client id`) AS NumberOfLoans,
    SUM(`Loan Amount`) AS TotalLoanAmount,
    ROUND(
        100.0 * SUM(`Loan Amount`) / (SELECT SUM(`Loan Amount`) FROM loan_data), 
        2
    ) AS PercentageOfTotal
FROM Loan_data
GROUP BY Religion
ORDER BY TotalLoanAmount DESC;

-- 8. product groupwise loans
SELECT 
    `Purpose Category`,
    COUNT(`Client id`) AS NumberOfLoans,
    SUM(`Loan Amount`) AS TotalLoanAmount,
    ROUND(
        100.0 * SUM(`Loan Amount`) / (SELECT SUM(`Loan Amount`) FROM loan_data), 
        2
    ) AS PercentageOfTotal
FROM Loan_data
GROUP BY `Purpose Category`
ORDER BY TotalLoanAmount DESC;

-- 9.Disbursement trend
select `Disbursement Date (Years)`,count(`Center Id`) as total_loan
from loan_data
group by `Disbursement Date (Years)`
order by`Disbursement Date (Years)` asc;

--  10.Gradewise loan
SELECT 
    Grade,
    COUNT(`Client id`) AS NumberOfLoans,
    SUM(`Loan Amount`) AS TotalLoanAmount,
    ROUND(
        100.0 * SUM(`Loan Amount`) / (SELECT SUM(`Loan Amount`) FROM loan_data), 
        2
    ) AS PercentageOfTotal
FROM Loan_data
GROUP BY Grade
ORDER BY TotalLoanAmount DESC;


-- 11. Default Loan Count: Counts loans in default.
select format( COUNT(
     case when  'Is Default Loan' = 'Y' THEN 1 END),0) as default_loan_count
 from loan_data;

-- 12. Delinquent Client Count: Tracks borrowers with missed payments 
 SELECT 
    COUNT(DISTINCT `Client id`) AS Delinquent_Client_Count
FROM Loan_data
WHERE `Is Delinquent Loan` = 'Y';

-- 13.Delinquent Loan Rate: Percentage of loans overdue in the portfolio.

SELECT 
    ROUND(
        100.0 * COUNT(CASE WHEN `Is Delinquent Loan` = 'Y' THEN `Client id` END) 
        / COUNT(`Client id`), 
        2
    ) AS Delinquent_Loan_Rate
FROM Loan_data;

-- 14.Default Loan Rate

SELECT 
    ROUND(
        100.0 * count(CASE WHEN `Is Default Loan` = 'Y' THEN 1 END) 
        / COUNT(`Client id`), 
        2
    ) AS Default_Loan_Rate
FROM Loan_data;


-- 15.Loan Status-Wise Loan: 
    
    SELECT 
    `Loan Status`,
    COUNT(*) AS total_loans,
    SUM(`Loan Amount`) AS total_amount,
    ROUND(SUM(`Loan Amount`) * 100.0 / SUM(SUM(`Loan Amount`)) OVER (), 2) AS percentage_share
FROM loan_data
GROUP BY `Loan Status`
ORDER BY total_amount DESC;
    
 -- 16. agegroup wise loan  
   SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '55+'
    END AS age_group,
    COUNT(*) AS total_loans,
    SUM(`Loan Amount`) AS total_amount,
    ROUND(SUM(`Loan Amount`) * 100.0 / SUM(SUM(`Loan Amount`)) OVER (), 2) AS percentage_share
FROM 
    loan_data
GROUP BY 
    age_group
ORDER BY 
    age_group;


-- 17. Loan Maturity

select Term,count(`Client id`) as total_loans
from loan_data
group by Term;

-- 18. No verified loans
SELECT COUNT(*) AS no_verified_loans
from loan_data
WHERE 
    `Loan Status` = 'Not Verified';


