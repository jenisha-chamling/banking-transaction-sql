-- =========================================================
-- 2. CREATE TABLES
-- Run after 01_create_database.sql
-- =========================================================
USE BankingTransactionDB;
GO

IF OBJECT_ID(N'dbo.AccountTransactions', N'U') IS NOT NULL DROP TABLE dbo.AccountTransactions;
IF OBJECT_ID(N'dbo.Accounts', N'U') IS NOT NULL DROP TABLE dbo.Accounts;
IF OBJECT_ID(N'dbo.Customers', N'U') IS NOT NULL DROP TABLE dbo.Customers;
GO

CREATE TABLE dbo.Customers
(
    CustomerID INT IDENTITY(1,1) CONSTRAINT PK_Customers PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) NOT NULL CONSTRAINT UQ_Customers_Email UNIQUE,
    Phone VARCHAR(20) NULL,
    City NVARCHAR(60) NULL,
    CreatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_Customers_CreatedAt DEFAULT SYSDATETIME()
);
GO

CREATE TABLE dbo.Accounts
(
    AccountID INT IDENTITY(1,1) CONSTRAINT PK_Accounts PRIMARY KEY,
    CustomerID INT NOT NULL,
    AccountNumber VARCHAR(20) NOT NULL CONSTRAINT UQ_Accounts_AccountNumber UNIQUE,
    AccountType NVARCHAR(20) NOT NULL,
    Balance DECIMAL(18,2) NOT NULL CONSTRAINT DF_Accounts_Balance DEFAULT (0),
    AccountStatus NVARCHAR(20) NOT NULL CONSTRAINT DF_Accounts_Status DEFAULT N'Active',
    OpenedAt DATETIME2(0) NOT NULL CONSTRAINT DF_Accounts_OpenedAt DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Accounts_Customers FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID),
    CONSTRAINT CK_Accounts_Balance CHECK (Balance >= 0),
    CONSTRAINT CK_Accounts_Type CHECK (AccountType IN (N'Savings', N'Current')),
    CONSTRAINT CK_Accounts_Status CHECK (AccountStatus IN (N'Active', N'Inactive', N'Closed'))
);
GO

CREATE TABLE dbo.AccountTransactions
(
    TransactionID BIGINT IDENTITY(1,1) CONSTRAINT PK_AccountTransactions PRIMARY KEY,
    AccountID INT NOT NULL,
    TransactionType NVARCHAR(30) NOT NULL,
    Amount DECIMAL(18,2) NOT NULL,
    BalanceAfter DECIMAL(18,2) NOT NULL,
    RelatedAccountID INT NULL,
    Description NVARCHAR(250) NULL,
    TransactionDate DATETIME2(0) NOT NULL CONSTRAINT DF_Transactions_Date DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Transactions_Account FOREIGN KEY (AccountID) REFERENCES dbo.Accounts(AccountID),
    CONSTRAINT FK_Transactions_RelatedAccount FOREIGN KEY (RelatedAccountID) REFERENCES dbo.Accounts(AccountID),
    CONSTRAINT CK_Transactions_Amount CHECK (Amount > 0),
    CONSTRAINT CK_Transactions_Type CHECK (TransactionType IN (N'Deposit', N'Withdrawal', N'TransferOut', N'TransferIn'))
);
GO

CREATE INDEX IX_Accounts_CustomerID ON dbo.Accounts(CustomerID);
CREATE INDEX IX_Transactions_AccountDate ON dbo.AccountTransactions(AccountID, TransactionDate DESC);
GO
