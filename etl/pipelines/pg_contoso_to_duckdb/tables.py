from datetime import datetime, timezone

incremental = {
    "cursor_path": "updated_at",
    "initial_value": datetime(1900, 1, 1, 0, 0, 0, tzinfo=timezone.utc),
    "row_order": "asc",
}

primary_key = ["id"]

# fmt: off
public_schema_tables = [
    {
        "name": "addresses", "is_enabled": True,
        "write_disposition": "merge", "primary_ke": primary_key, "incremental": incremental,
    },
    {
        "name": "brands", "is_enabled": True,
        "write_disposition": "merge", "primary_key": primary_key, "incremental": incremental,
    },
    {   "name": "channels", "is_enabled": False   },
    {
        "name": "colors", "is_enabled": True,
        "write_disposition": "merge", "primary_key": primary_key, "incremental": incremental,
    },
    {
        "name": "currencies", "is_enabled": True,
        "write_disposition": "merge", "primary_key": primary_key, "incremental": incremental,
    },
    {
        "name": "customers", "is_enabled": True,
        "write_disposition": "merge", "primary_key": primary_key, "incremental": incremental,
    },
    {
        "name": "departments", "is_enabled": True,
        "write_disposition": "merge", "primary_key": primary_key, "incremental": incremental,
    },
    {
        "name": "employees", "is_enabled": True,
        "write_disposition": "merge", "primary_key": primary_key, "incremental": incremental,
    },
    {
        "name": "entities", "is_enabled": True,
        "write_disposition": "merge", "primary_key": primary_key, "incremental": incremental,
    },
    {
        "name": "geographies", "is_enabled": True,
        "write_disposition": "merge", "primary_key": primary_key, "incremental": incremental,
    },

    {
        "name": "job_titles", "is_enabled": True,
        "write_disposition": "merge", "primary_key": primary_key, "incremental": incremental,
    },
    {
        "name": "manufacturers", "is_enabled": True,
        "write_disposition": "merge", "primary_key": primary_key, "incremental": incremental,
    },
    {
        "name": "online_sales_order_lines", "is_enabled": True,
        "write_disposition": "merge", "primary_key": primary_key, "incremental": incremental,
    },
    {
        "name": "product_categories", "is_enabled": True,
        "write_disposition": "merge", "primary_key": primary_key, "incremental": incremental,
    },
    {
        "name": "product_subcategories", "is_enabled": True,
        "write_disposition": "merge", "primary_key": primary_key, "incremental": incremental,
    },
    {
        "name": "products", "is_enabled": True,
        "write_disposition": "merge", "primary_key": primary_key, "incremental": incremental,
    },
    {
        "name": "promotions", "is_enabled": True,
        "write_disposition": "merge", "primary_key": primary_key, "incremental": incremental,
    },
    {   "name": "sales_territories", "is_enabled": False   },
    {   "name": "scenarios", "is_enabled": False   },
    {
        "name": "stores", "is_enabled": True,
        "write_disposition": "merge", "primary_key": primary_key, "incremental": incremental,
    },
]
# fmt: on
