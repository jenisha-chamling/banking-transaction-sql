-- =========================================================
-- 6. TEST TRANSACTIONS
-- IMPORTANT: This script changes account balances and inserts
-- ledger rows. Run it only once on a fresh sample database,
-- or reset/recreate the database before running it again.
-- =========================================================
USE BankingTransactionDB;
GO

DECLARE @BalanceAfterDeposit DECIMAL(18,2);
DECLARE @BalanceAfterWithdrawal DECIMAL(18,2);

-- Deposit Rs. 1,000 into account BA-1001.
EXEC dbo.usp_Deposit
    @AccountID = 1,
    @Amount = 1000.00,
    @Description = N'Sample cash deposit',
    @NewBalance = @BalanceAfterDeposit OUTPUT;
SELECT @BalanceAfterDeposit AS BalanceAfterDeposit;

-- Withdraw Rs. 500 from account BA-1002.
EXEC dbo.usp_Withdraw
    @AccountID = 2,
    @Amount = 500.00,
    @Description = N'Sample cash withdrawal',
    @NewBalance = @BalanceAfterWithdrawal OUTPUT;
SELECT @BalanceAfterWithdrawal AS BalanceAfterWithdrawal;

-- Transfer Rs. 750 from account BA-1001 to account BA-1003.
EXEC dbo.usp_Transfer
    @FromAccountID = 1,
    @ToAccountID = 3,
    @Amount = 750.00,
    @Description = N'Sample account transfer';
GO

-- Verify account balances after the sample transactions.
SELECT AccountID, AccountNumber, Balance
FROM dbo.Accounts
ORDER BY AccountID;

-- Verify transaction ledger.
SELECT TransactionID, AccountID, TransactionType, Amount,
       BalanceAfter, RelatedAccountID, Description, TransactionDate
FROM dbo.AccountTransactions
ORDER BY TransactionID;
GO
