# 1) Total Credit Amount
select Transaction_Type, round(sum(amount),2) as Total_Credit_Amount
from debitcr
where transaction_type="credit";

# 2) Total Debit Amount
select Transaction_Type, round(sum(amount),2) as Total_Debit_Amount
from debitcr
where transaction_type="debit";

# 3) Credit to Debit Ratio
select round(
sum(case when transaction_type="credit" then amount else 0 end) /
sum(case when transaction_type="debit" then amount else 0 end),2)
as Debit_Credit_Ratio
from debitcr;

# 4) Net Transaction Amount
select round(
sum(case when transaction_type="credit" then amount else 0 end)- sum(case when transaction_type="debit" then amount else 0 end),2)
as Net_Transaction_Amount
from debitcr;

# 5) Account Activity Ratio
SELECT 
    ROUND(COUNT(*) / sum(Balance), 5) 
    AS Account_Activity_Ratio
FROM debitcr;

# 6) Transactions per Day/Week/Month:
# Per day
select 
date(transaction_date) as transaction_day,
count(*) as total_transactions
from debitcr
group by 1
order by 1;

# Per week
select year(transaction_date) as transaction_year,
week(transaction_date,1) as transaction_week,
count(*) as total_transactions
from debitcr
group by year(transaction_date), week(transaction_date,1)
order by week(transaction_date,1);

#Per month
select year(transaction_date) as transaction_year,
month(transaction_date) as transaction_month,
count(*) as total_transactions
from debitcr
group by 1, 2
order by 1;

# 7) Total Transaction Amount by Branch:
select Branch,round(sum(amount),2) as Transaction_Amount
from debitcr
group by 1
order by 2;

# 8.Transaction Volume by Bank
select bank_name, round(sum(amount),2) as Transaction_Amount
from debitcr
group by 1
order by 2; 

# 9. Transaction Method Distribution
select distinct transaction_method, 
count(customer_id) as Transactions_Count,
round(count(customer_id)/(select count(*) from debitcr),3)*100 as Percentage
from debitcr
group by 1
order by 2;

# 10. Branch Transaction Growth:

with monthly_total as 
(select branch, DATE_FORMAT(Transaction_Date, '%Y-%m-01') as transaction_month,
round(sum(amount),2) as transaction_amount
from debitcr
group by 1,2),
growth_calc as
(select branch,transaction_month, transaction_amount,
round(lag(transaction_amount) over(partition by branch order by transaction_amount),2) as previous_month_amount
from monthly_total)
select branch, transaction_month, transaction_amount,previous_month_amount,
round((transaction_amount-previous_month_amount) / (previous_month_amount) * 100,2) as Growth_Percentage
from growth_calc
order by 2; 


# 11. High-Risk Transaction Flag 
select Customer_Id, Amount, Transaction_type,
case when amount>avg(amount) over() then "Large Transaction"
when transaction_type="debit" and amount>1.5*avg(amount) over() then "High Risk: Large Withdrawal"
else "Normal"
end as Risk_Flag
from debitcr;

# 12. Suspicious Transaction Frequency:
# Formula: Count of flagged high-risk transactions over a period

WITH FlaggedTransactions AS (
    SELECT 
        Transaction_Date,
        CASE 
            WHEN Transaction_type = 'debit' AND Amount > 1.5 * AVG(Amount) OVER() THEN 'High Risk'
            ELSE 'Normal'
        END AS Risk_Status
    FROM debitcr
)
SELECT 
    DATE_FORMAT(Transaction_Date, '%Y-%m') AS Month,
    COUNT(*) AS Suspicious_Count
FROM FlaggedTransactions
WHERE Risk_Status = 'high risk'
GROUP BY 1
ORDER BY 1;













