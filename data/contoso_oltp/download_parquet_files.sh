#!/bin/bash

# Base URL
BASE_URL="https://github.com/et3lmonline/datasets/raw/refs/heads/main/contoso_oltp_v1/"

# Lite files list
lite_files=(
  # Part 01
  "colors.parquet"
  "brands.parquet"
  "product_subcategories.parquet"
  "product_categories.parquet"
  "products.parquet"
  "customers.parquet"
  "stores.parquet"
  "currencies.parquet"
  "promotions.parquet"
  "addresses.parquet"
  "geographies.parquet"
  "manufacturers.parquet"
  "entities.parquet"
  "employees.parquet"
  "departments.parquet"
  "job_titles.parquet"
  "online_sales_order_lines/online_sales_order_lines_2007_5.parquet"

  # Part 02
  # "scenarios.parquet"
  # "sales_territories.parquet"
  # "outages.parquet"
  # "outage_transactions.parquet"
  # "machines.parquet"
  # "it_machine_costs.parquet"
  # "gl_accounts.parquet"
  # "exchange_rates.parquet"
  # "channels.parquet"
  # "inventory_weekly_snapshot/inventory_weekly_snapshot_2007_3.parquet"
  # "sales_quotas/sales_quotas_2007_4.parquet"
  # "strategy_plans/strategy_plans_2007_1.parquet"
  # "sales_order_lines/sales_order_lines_2007_2.parquet"
)

# Full files list (includes the lite files and additional ones)
full_files=(
  "${lite_files[@]}"
  "inventory_weekly_snapshot/inventory_weekly_snapshot_2007_1.parquet"
  "inventory_weekly_snapshot/inventory_weekly_snapshot_2007_2.parquet"
  "inventory_weekly_snapshot/inventory_weekly_snapshot_2007_3.parquet"
  "inventory_weekly_snapshot/inventory_weekly_snapshot_2007_4.parquet"
  "inventory_weekly_snapshot/inventory_weekly_snapshot_2008_1.parquet"
  "inventory_weekly_snapshot/inventory_weekly_snapshot_2008_2.parquet"
  "inventory_weekly_snapshot/inventory_weekly_snapshot_2008_3.parquet"
  "inventory_weekly_snapshot/inventory_weekly_snapshot_2009_1.parquet"
  "inventory_weekly_snapshot/inventory_weekly_snapshot_2009_2.parquet"
  "online_sales_order_lines/online_sales_order_lines_2007_1.parquet"
  "online_sales_order_lines/online_sales_order_lines_2007_2.parquet"
  "online_sales_order_lines/online_sales_order_lines_2007_3.parquet"
  "online_sales_order_lines/online_sales_order_lines_2007_4.parquet"
  "online_sales_order_lines/online_sales_order_lines_2007_5.parquet"
  "online_sales_order_lines/online_sales_order_lines_2008_1.parquet"
  "online_sales_order_lines/online_sales_order_lines_2008_2.parquet"
  "online_sales_order_lines/online_sales_order_lines_2008_3.parquet"
  "online_sales_order_lines/online_sales_order_lines_2008_4.parquet"
  "online_sales_order_lines/online_sales_order_lines_2009_1.parquet"
  "online_sales_order_lines/online_sales_order_lines_2009_2.parquet"
  "online_sales_order_lines/online_sales_order_lines_2009_3.parquet"
  "online_sales_order_lines/online_sales_order_lines_2009_4.parquet"
  "online_sales_order_lines/online_sales_order_lines_2009_5.parquet"
  "online_sales_order_lines/online_sales_order_lines_2009_6.parquet"
  "sales_quotas/sales_quotas_2007_1.parquet"
  "sales_quotas/sales_quotas_2007_2.parquet"
  "sales_quotas/sales_quotas_2007_3.parquet"
  "sales_quotas/sales_quotas_2008_1.parquet"
  "sales_quotas/sales_quotas_2008_2.parquet"
  "sales_quotas/sales_quotas_2008_3.parquet"
  "sales_quotas/sales_quotas_2009_1.parquet"
  "sales_quotas/sales_quotas_2009_2.parquet"
  "sales_order_lines/sales_order_lines_2009_1.parquet"
  "sales_order_lines/sales_order_lines_2008_2.parquet"
  "sales_order_lines/sales_order_lines_2008_1.parquet"
  "sales_order_lines/sales_order_lines_2007_1.parquet"
  "strategy_plans/strategy_plans_2009_1.parquet"
  "strategy_plans/strategy_plans_2008_1.parquet"
)

remaining_files=()
for file in "${full_files[@]}"; do
  if [[ ! " ${lite_files[@]} " =~ " ${file} " ]]; then
    remaining_files+=("$file")
  fi
done

# Ask user for choice
echo "Choose the version to process:"
echo "1) Lite"
echo "2) Full"
echo "3) Remaining only"
read -p "Enter your choice (1, 2, or 3): " choice

# Check for debug flag
DEBUG_MODE=false
if [[ "$1" == "--debug" ]]; then
  DEBUG_MODE=true
  echo "Debug mode enabled: Files will only be listed, not downloaded."
fi

# Set files to process based on choice
if [ "$choice" -eq 1 ]; then
  files_to_process=("${lite_files[@]}")
elif [ "$choice" -eq 2 ]; then
  files_to_process=("${full_files[@]}")
elif [ "$choice" -eq 3 ]; then
  files_to_process=("${remaining_files[@]}")
else
  echo "Invalid choice. Exiting."
  exit 1
fi

# Debug mode: List files only
if [ "$DEBUG_MODE" = true ]; then
  echo "Files to process:"
  for file in "${files_to_process[@]}"; do
    echo "$file"
  done
  exit 0
fi

# Download files
output_dir="data/contoso_oltp/data"
mkdir -p "$output_dir"

for file in "${files_to_process[@]}"; do
  mkdir -p "${output_dir}/$(dirname "$file")"
  curl -L "${BASE_URL}${file}" -o "${output_dir}/${file}"
done

echo "Download completed."

