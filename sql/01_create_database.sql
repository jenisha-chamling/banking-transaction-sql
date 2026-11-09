-- =========================================================
-- 1. CREATE DATABASE
-- =========================================================
USE master;
GO

IF DB_ID(N'BankingTransactionDB') IS NULL
BEGIN
    CREATE DATABASE BankingTransactionDB;
END;
GO

USE BankingTransactionDB;
GO
