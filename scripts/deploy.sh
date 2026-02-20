#!/bin/bash

set -e

echo "=========================================="
echo "ODS_DK_DBT Deployment"
echo "Environment: dev"
echo "=========================================="

cd dbt_project

echo ""
echo "Step 1: Installing dependencies..."
dbt deps

echo ""
echo "Step 2: Compiling models..."
dbt compile

echo ""
echo "Step 3: Running tests..."
dbt test

echo ""
echo "Step 4: Running models..."
dbt run

echo ""
echo "Step 5: Generating documentation..."
dbt docs generate

echo ""
echo "=========================================="
echo "Deployment completed successfully!"
echo "=========================================="
