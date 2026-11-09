-- =========================================================
-- 7. VIEWS AND ADVANCED REPORTS
-- Run after 06_test_transactions.sql to see sample activity.
-- =========================================================
USE BankingTransactionDB;
GO

CREATE OR ALTER VIEW dbo.vw_AccountSummary
AS
SELECT a.AccountID, a.AccountNumber, a.AccountType, a.Balance,
       a.AccountStatus, c.CustomerID, c.FullName, c.Email, c.City
FROM dbo.Accounts AS a
INNER JOIN dbo.Customers AS c ON c.CustomerID = a.CustomerID;
GO

CREATE OR ALTER VIEW dbo.vw_TransactionDetails
AS
SELECT t.TransactionID, t.AccountID, a.AccountNumber,
       c.FullName, t.TransactionType, t.Amount, t.BalanceAfter,
       t.RelatedAccountID, t.Description, t.TransactionDate
FROM dbo.AccountTransactions AS t
INNER JOIN dbo.Accounts AS a ON a.AccountID = t.AccountID
INNER JOIN dbo.Customers AS c ON c.CustomerID = a.CustomerID;
GO

-- Account summary.
SELECT * FROM dbo.vw_AccountSummary ORDER BY AccountID;

-- Transaction details.
SELECT * FROM dbo.vw_TransactionDetails ORDER BY TransactionDate, TransactionID;

-- Total amount by transaction type.
SELECT TransactionType, COUNT(*) AS TransactionCount,
       SUM(Amount) AS TotalAmount, AVG(Amount) AS AverageAmount
FROM dbo.AccountTransactions
GROUP BY TransactionType
ORDER BY TransactionType;

-- Running ledger total per account (signed amount).
SELECT AccountID, TransactionID, TransactionType, Amount,
       CASE
           WHEN TransactionType IN (N'Deposit', N'TransferIn') THEN Amount
           ELSE -Amount
       END AS SignedAmount,
       SUM(CASE
               WHEN TransactionType IN (N'Deposit', N'TransferIn') THEN Amount
               ELSE -Amount
           END) OVER
           (PARTITION BY AccountID ORDER BY TransactionDate, TransactionID
            ROWS UNBOUNDED PRECEDING) AS RunningNetMovement
FROM dbo.AccountTransactions
ORDER BY AccountID, TransactionDate, TransactionID;

-- Most recent transaction for each account.
WITH RecentTransactions AS
(
    SELECT *,
           ROW_NUMBER() OVER
           (PARTITION BY AccountID ORDER BY TransactionDate DESC, TransactionID DESC) AS rn
    FROM dbo.AccountTransactions
)
SELECT TransactionID, AccountID, TransactionType, Amount, TransactionDate
FROM RecentTransactions
WHERE rn = 1
ORDER BY AccountID;
GO
