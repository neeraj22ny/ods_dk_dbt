#!/bin/bash

set -e

echo "=========================================="
echo "ODS_DK_DBT Environment Setup"
echo "=========================================="

echo "Checking required tools..."

if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python 3 is required but not installed."
    exit 1
fi

if ! command -v dbt &> /dev/null; then
    echo "ERROR: DBT is required but not installed."
    echo "Install with: pip install dbt-snowflake"
    exit 1
fi

echo "All required tools are installed"

if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

echo "Activating virtual environment..."
source venv/bin/activate

echo "Installing Python dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

echo "Installing DBT packages..."
cd dbt_project
dbt deps

echo "Testing Snowflake connection..."
dbt debug

echo "=========================================="
echo "Environment setup complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Update dbt_project/profiles.yml with your Snowflake credentials"
echo "2. Run 'dbt run' to build the models"
echo "3. Run 'dbt test' to validate data quality"
