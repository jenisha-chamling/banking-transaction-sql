-- =========================================================
-- 4. BASIC QUERIES AND REPORTS
-- =========================================================
USE BankingTransactionDB;
GO

-- View all customers and accounts.
SELECT c.CustomerID, c.FullName, c.Email, c.City,
       a.AccountID, a.AccountNumber, a.AccountType, a.Balance, a.AccountStatus
FROM dbo.Customers AS c
INNER JOIN dbo.Accounts AS a ON a.CustomerID = c.CustomerID
ORDER BY c.CustomerID;

-- Aggregate account statistics.
SELECT COUNT(*) AS TotalAccounts,
       SUM(Balance) AS TotalBankBalance,
       AVG(Balance) AS AverageAccountBalance,
       MIN(Balance) AS MinimumBalance,
       MAX(Balance) AS MaximumBalance
FROM dbo.Accounts
WHERE AccountStatus = N'Active';

-- CASE expression: classify account balances.
SELECT AccountNumber, Balance,
       CASE
           WHEN Balance >= 10000 THEN N'High Balance'
           WHEN Balance >= 5000 THEN N'Medium Balance'
           ELSE N'Low Balance'
       END AS BalanceCategory
FROM dbo.Accounts;

-- String and date functions.
SELECT UPPER(FullName) AS CustomerNameUpper,
       LEN(FullName) AS NameLength,
       LEFT(FullName, 3) AS NamePrefix,
       RIGHT(Email, 12) AS EmailSuffix,
       GETDATE() AS CurrentDateTime,
       DATEADD(DAY, 30, GETDATE()) AS DateAfter30Days
FROM dbo.Customers;

-- Subquery: accounts above the average balance.
SELECT AccountNumber, Balance
FROM dbo.Accounts
WHERE Balance > (SELECT AVG(Balance) FROM dbo.Accounts);

-- CTE: rank accounts by balance.
WITH AccountRanking AS
(
    SELECT AccountNumber, Balance,
           ROW_NUMBER() OVER (ORDER BY Balance DESC) AS RowNum,
           RANK() OVER (ORDER BY Balance DESC) AS BalanceRank,
           DENSE_RANK() OVER (ORDER BY Balance DESC) AS DenseBalanceRank
    FROM dbo.Accounts
)
SELECT * FROM AccountRanking ORDER BY RowNum;
GO
