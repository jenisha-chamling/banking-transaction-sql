# Banking Transaction Management System using Microsoft SQL Server

A beginner-friendly SQL Server project demonstrating relational database design, account management, deposits, withdrawals, account-to-account transfers, transaction ledgers, stored procedures, transaction control, error handling, views, and reporting.

> **Educational project only.** It uses fictional sample data and is not intended for real banking or financial transactions.

## Project objectives

- Design relational tables for customers, accounts, and account transactions.
- Apply primary keys, foreign keys, unique constraints, check constraints, and indexes.
- Use SQL Server data types, aggregate functions, `CASE`, joins, subqueries, and CTEs.
- Use window functions such as `ROW_NUMBER`, `RANK`, `DENSE_RANK`, and `SUM() OVER`.
- Create stored procedures for deposits, withdrawals, and transfers.
- Use `BEGIN TRANSACTION`, `COMMIT`, `ROLLBACK`, `TRY...CATCH`, and `THROW`.
- Maintain a transaction ledger and create views and reports.

## Project structure

```text
banking-transaction-management-sql-server/
├── sql/
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   ├── 03_insert_sample_data.sql
│   ├── 04_basic_queries_and_reports.sql
│   ├── 05_stored_procedures.sql
│   ├── 06_test_transactions.sql
│   └── 07_views_and_advanced_reports.sql
├── README.md
└── .gitignore
```

## Requirements

- Microsoft SQL Server (Developer, Standard, or Express edition)
- SQL Server Management Studio (SSMS)

## How to run

Open each script in SSMS and execute the scripts **in this exact order**:

1. `01_create_database.sql` — create and select the database.
2. `02_create_tables.sql` — create tables, constraints, and indexes.
3. `03_insert_sample_data.sql` — insert the fictional customers and accounts.
4. `04_basic_queries_and_reports.sql` — explore basic queries and reports.
5. `05_stored_procedures.sql` — create the deposit, withdrawal, and transfer procedures.
6. `06_test_transactions.sql` — execute sample transactions and verify balances and ledger entries.
7. `07_views_and_advanced_reports.sql` — create views and run advanced reports using the transaction data from step 6.

Run each script separately and check the Messages/Results panes for errors before moving to the next script.

**Important:** `06_test_transactions.sql` changes account balances and inserts ledger records. Run it only once on a fresh database. If you need to repeat the demonstration from the original sample balances, recreate the database by running scripts 1–3 again, then scripts 4–7 in order.

## Sample operations

The stored procedures support:

- Depositing an amount into an active account.
- Withdrawing an amount when the account has sufficient funds.
- Transferring an amount between two different active accounts.
- Returning updated balances for deposit and withdrawal operations.
- Recording transaction details, including `TransferOut` and `TransferIn`, in the ledger.

The transfer procedure performs both account balance updates and both ledger inserts inside one database transaction. If an operation fails, the transaction is rolled back.

## Notes and limitations

- All customer names, account numbers, and transactions are fictional.
- This is a learning project, not a production banking application.
- It does not implement authentication, authorization, regulatory controls, interest calculations, fees, or production-grade audit/security requirements.
