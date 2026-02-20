#!/bin/bash

set -e

DBT_COMMAND="${1:-run}"

echo "=========================================="
echo "ODS_DK_DBT Pipeline Execution"
echo "Environment: dev"
echo "Command: $DBT_COMMAND"
echo "=========================================="

cd dbt_project

case $DBT_COMMAND in
    "run")
        dbt run
        ;;
    "test")
        dbt test
        ;;
    "freshness")
        dbt source freshness
        ;;
    "docs")
        dbt docs generate
        ;;
    "compile")
        dbt compile
        ;;
    *)
        echo "ERROR: Unknown DBT command: $DBT_COMMAND"
        echo "Available commands: run, test, freshness, docs, compile"
        exit 1
        ;;
esac

echo "=========================================="
echo "DBT $DBT_COMMAND completed successfully!"
echo "=========================================="
