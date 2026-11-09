-- =========================================================
-- 5. STORED PROCEDURES
-- Deposit, withdrawal, and account-to-account transfer.
-- Each procedure uses transactions and TRY/CATCH.
-- =========================================================
USE BankingTransactionDB;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Deposit
    @AccountID INT,
    @Amount DECIMAL(18,2),
    @Description NVARCHAR(250) = N'Deposit',
    @NewBalance DECIMAL(18,2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @Amount IS NULL OR @Amount <= 0
            THROW 50001, 'Deposit amount must be greater than zero.', 1;

        BEGIN TRANSACTION;

        UPDATE dbo.Accounts WITH (UPDLOCK, ROWLOCK)
        SET Balance = Balance + @Amount
        WHERE AccountID = @AccountID AND AccountStatus = N'Active';

        IF @@ROWCOUNT = 0
            THROW 50002, 'Active account was not found.', 1;

        SELECT @NewBalance = Balance
        FROM dbo.Accounts
        WHERE AccountID = @AccountID;

        INSERT INTO dbo.AccountTransactions
            (AccountID, TransactionType, Amount, BalanceAfter, Description)
        VALUES
            (@AccountID, N'Deposit', @Amount, @NewBalance, @Description);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Withdraw
    @AccountID INT,
    @Amount DECIMAL(18,2),
    @Description NVARCHAR(250) = N'Withdrawal',
    @NewBalance DECIMAL(18,2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @Amount IS NULL OR @Amount <= 0
            THROW 50003, 'Withdrawal amount must be greater than zero.', 1;

        BEGIN TRANSACTION;

        UPDATE dbo.Accounts WITH (UPDLOCK, ROWLOCK)
        SET Balance = Balance - @Amount
        WHERE AccountID = @AccountID
          AND AccountStatus = N'Active'
          AND Balance >= @Amount;

        IF @@ROWCOUNT = 0
            THROW 50004, 'Account not found, inactive, or insufficient balance.', 1;

        SELECT @NewBalance = Balance
        FROM dbo.Accounts
        WHERE AccountID = @AccountID;

        INSERT INTO dbo.AccountTransactions
            (AccountID, TransactionType, Amount, BalanceAfter, Description)
        VALUES
            (@AccountID, N'Withdrawal', @Amount, @NewBalance, @Description);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_Transfer
    @FromAccountID INT,
    @ToAccountID INT,
    @Amount DECIMAL(18,2),
    @Description NVARCHAR(250) = N'Account transfer'
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @FromBalance DECIMAL(18,2);
    DECLARE @ToBalance DECIMAL(18,2);

    BEGIN TRY
        IF @Amount IS NULL OR @Amount <= 0
            THROW 50005, 'Transfer amount must be greater than zero.', 1;

        IF @FromAccountID = @ToAccountID
            THROW 50006, 'Source and destination accounts must be different.', 1;

        BEGIN TRANSACTION;

        -- Debit source account.
        UPDATE dbo.Accounts WITH (UPDLOCK, ROWLOCK)
        SET Balance = Balance - @Amount
        WHERE AccountID = @FromAccountID
          AND AccountStatus = N'Active'
          AND Balance >= @Amount;

        IF @@ROWCOUNT = 0
            THROW 50007, 'Source account not found, inactive, or insufficient balance.', 1;

        -- Credit destination account.
        UPDATE dbo.Accounts WITH (UPDLOCK, ROWLOCK)
        SET Balance = Balance + @Amount
        WHERE AccountID = @ToAccountID
          AND AccountStatus = N'Active';

        IF @@ROWCOUNT = 0
            THROW 50008, 'Destination account not found or inactive.', 1;

        SELECT @FromBalance = Balance FROM dbo.Accounts WHERE AccountID = @FromAccountID;
        SELECT @ToBalance = Balance FROM dbo.Accounts WHERE AccountID = @ToAccountID;

        INSERT INTO dbo.AccountTransactions
            (AccountID, TransactionType, Amount, BalanceAfter, RelatedAccountID, Description)
        VALUES
            (@FromAccountID, N'TransferOut', @Amount, @FromBalance, @ToAccountID, @Description),
            (@ToAccountID, N'TransferIn', @Amount, @ToBalance, @FromAccountID, @Description);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
