@echo off
REM ============================================
REM EXECUTE MIGRATIONS - Windows Batch Script
REM Description: Execute all Reserve Connect migrations
REM Usage: execute_migrations.bat <database-url>
REM ============================================

setlocal EnableDelayedExpansion

REM Check if database URL is provided
if "%~1"=="" (
    echo Error: Database URL not provided
    echo Usage: execute_migrations.bat "postgresql://postgres:[password]@db.xxxxx.supabase.co:5432/postgres"
    echo.
    echo Or set environment variable:
    echo set DATABASE_URL=postgresql://postgres:[password]@db.xxxxx.supabase.co:5432/postgres
    echo execute_migrations.bat
    exit /b 1
)

set "DATABASE_URL=%~1"

echo ========================================
echo RESERVE CONNECT MIGRATION EXECUTOR
echo ========================================
echo.
echo Database: Reserve Connect
echo Total migrations: 7
echo Estimated time: 2-5 minutes
echo.

REM Check if psql is available
where psql >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: psql is not installed
    echo Please install PostgreSQL client:
    echo   scoop install postgresql
    echo   or download from https://www.postgresql.org/download/
    exit /b 1
)

REM Check if migrations directory exists
if not exist "supabase\migrations" (
    echo Error: supabase\migrations directory not found
    echo Please run this script from the project root directory
    exit /b 1
)

cd supabase\migrations

echo Starting migrations...
echo.

REM Execute each migration
set MIGRATIONS=001_foundation_schema.sql 002_booking_core.sql 003_financial_module.sql 004_operations_audit.sql 005_analytics_marketing.sql 006_future_placeholders.sql 007_qa_verification.sql

for %%M in (%MIGRATIONS%) do (
    if not exist "%%M" (
        echo Error: Migration file not found: %%M
        exit /b 1
    )
    
    echo Executing: %%M
    
    psql "%DATABASE_URL%" -f "%%M" > migration_%%~nM.log 2>&1
    
    if %errorlevel% equ 0 (
        echo [OK] %%M completed successfully
    ) else (
        echo [FAIL] %%M failed!
        echo.
        echo Error log:
        type migration_%%~nM.log
        echo.
        echo Migration failed. Please check the error above.
        exit /b 1
    )
    echo.
)

echo ========================================
echo ALL MIGRATIONS COMPLETED SUCCESSFULLY!
echo ========================================
echo.
echo Summary:
echo   [OK] 001_foundation_schema.sql - Cities, properties, units
echo   [OK] 002_booking_core.sql - Travelers, intents, reservations
echo   [OK] 003_financial_module.sql - Payments, ledger, payouts
echo   [OK] 004_operations_audit.sql - Audit logs, notifications
echo   [OK] 005_analytics_marketing.sql - Events, reviews, ads
echo   [OK] 006_future_placeholders.sql - Owner portal, services
echo   [OK] 007_qa_verification.sql - Quality assurance tests
echo.
echo Next steps:
echo   1. Check Supabase Dashboard - Table Editor
echo   2. Verify all tables are visible
echo   3. Review QA verification output
echo   4. Test with sample queries
echo.

pause
