-- =========================================================
-- 3. INSERT FICTIONAL SAMPLE DATA
-- Run once after creating the tables.
-- =========================================================
USE BankingTransactionDB;
GO

INSERT INTO dbo.Customers (FullName, Email, Phone, City)
VALUES
(N'Aarav Sharma', 'aarav.sharma@example.com', '9800000001', N'Kathmandu'),
(N'Sita Karki', 'sita.karki@example.com', '9800000002', N'Lalitpur'),
(N'Rohan Thapa', 'rohan.thapa@example.com', '9800000003', N'Bhaktapur'),
(N'Anisha Rai', 'anisha.rai@example.com', '9800000004', N'Lalitpur'),
(N'Bikash Gurung', 'bikash.gurung@example.com', '9800000005', N'Pokhara');
GO

INSERT INTO dbo.Accounts (CustomerID, AccountNumber, AccountType, Balance)
VALUES
(1, 'BA-1001', N'Savings', 5000.00),
(2, 'BA-1002', N'Current', 8000.00),
(3, 'BA-1003', N'Savings', 3500.00),
(4, 'BA-1004', N'Savings', 10000.00),
(5, 'BA-1005', N'Current', 6200.00);
GO
