#!/bin/bash
# ============================================
# EXECUTE MIGRATIONS SCRIPT
# Description: Execute all Reserve Connect migrations in order
# Usage: ./execute_migrations.sh <database-url>
# ============================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if database URL is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Database URL not provided${NC}"
    echo "Usage: ./execute_migrations.sh 'postgresql://postgres:[password]@db.xxxxx.supabase.co:5432/postgres'"
    echo ""
    echo "Or set environment variable:"
    echo "export DATABASE_URL='postgresql://postgres:[password]@db.xxxxx.supabase.co:5432/postgres'"
    echo "./execute_migrations.sh"
    exit 1
fi

DATABASE_URL="${1:-$DATABASE_URL}"

if [ -z "$DATABASE_URL" ]; then
    echo -e "${RED}Error: DATABASE_URL not set${NC}"
    exit 1
fi

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}RESERVE CONNECT MIGRATION EXECUTOR${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Database: Reserve Connect"
echo "Total migrations: 7"
echo "Estimated time: 2-5 minutes"
echo ""

# List of migrations in order
MIGRATIONS=(
    "001_foundation_schema.sql"
    "002_booking_core.sql"
    "003_financial_module.sql"
    "004_operations_audit.sql"
    "005_analytics_marketing.sql"
    "006_future_placeholders.sql"
    "007_qa_verification.sql"
)

# Check if psql is available
if ! command -v psql &> /dev/null; then
    echo -e "${RED}Error: psql is not installed${NC}"
    echo "Please install PostgreSQL client:"
    echo "  Windows: scoop install postgresql"
    echo "  Mac: brew install postgresql"
    echo "  Linux: sudo apt-get install postgresql-client"
    exit 1
fi

# Check if migrations directory exists
if [ ! -d "supabase/migrations" ]; then
    echo -e "${RED}Error: supabase/migrations directory not found${NC}"
    echo "Please run this script from the project root directory"
    exit 1
fi

cd supabase/migrations

echo -e "${YELLOW}Starting migrations...${NC}"
echo ""

# Execute each migration
for migration in "${MIGRATIONS[@]}"; do
    if [ ! -f "$migration" ]; then
        echo -e "${RED}Error: Migration file not found: $migration${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Executing: $migration${NC}"
    
    if psql "$DATABASE_URL" -f "$migration" > /tmp/migration_${migration}.log 2>&1; then
        echo -e "${GREEN}✓ $migration completed successfully${NC}"
    else
        echo -e "${RED}✗ $migration failed!${NC}"
        echo ""
        echo "Error log:"
        cat /tmp/migration_${migration}.log
        echo ""
        echo -e "${RED}Migration failed. Please check the error above.${NC}"
        exit 1
    fi
    echo ""
done

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}ALL MIGRATIONS COMPLETED SUCCESSFULLY!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Summary:"
echo "  ✓ 001_foundation_schema.sql - Cities, properties, units"
echo "  ✓ 002_booking_core.sql - Travelers, intents, reservations"
echo "  ✓ 003_financial_module.sql - Payments, ledger, payouts"
echo "  ✓ 004_operations_audit.sql - Audit logs, notifications"
echo "  ✓ 005_analytics_marketing.sql - Events, reviews, ads"
echo "  ✓ 006_future_placeholders.sql - Owner portal, services"
echo "  ✓ 007_qa_verification.sql - Quality assurance tests"
echo ""
echo "Next steps:"
echo "  1. Check Supabase Dashboard → Table Editor"
echo "  2. Verify all tables are visible"
echo "  3. Review QA verification output"
echo "  4. Test with sample queries"
echo ""
