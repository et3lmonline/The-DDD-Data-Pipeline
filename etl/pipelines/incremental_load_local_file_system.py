import os
from datetime import datetime, timezone

import dlt
import sqlalchemy as sa
from dlt.destinations import filesystem
from dlt.sources.sql_database import sql_database

database = os.environ.get("SRC_PG_CONTOSO_DATABASE")
password = os.environ.get("SRC_PG_CONTOSO_PASSWORD")
username = os.environ.get("SRC_PG_CONTOSO_USERNAME")
host = os.environ.get("SRC_PG_CONTOSO_HOST")
port = os.environ.get("SRC_PG_CONTOSO_PORT")


connection_string = f"postgresql://{username}:{password}@{host}:{port}/{database}"


# 01 : Source
def query_adapter_callback(query: sa.Select, table: sa.Table):
    print("table_name", table.fullname)
    print("query\n===========\n", query)
    return query


table_names = ["brands", "colors", "DepartmentGroups"]
my_tables_data = sql_database(
    credentials=connection_string,
    table_names=table_names,
    query_adapter_callback=query_adapter_callback,
)


color_table = my_tables_data.resources.get("colors")
color_incremental_config = dlt.sources.incremental(
    # we can reference a path (APIs) > "data.update_at"
    cursor_path="updated_at",
    initial_value=datetime(1900, 1, 1, 0, 0, 0, tzinfo=timezone.utc),
    primary_key=["id"],
    row_order="asc",
)
color_table.apply_hints(incremental=color_incremental_config)


department_groups_table = my_tables_data.resources.get("DepartmentGroups")
department_groups_incremental_config = dlt.sources.incremental(
    cursor_path="UpdatedAt",
    initial_value=datetime(1900, 1, 1, 0, 0, 0, tzinfo=timezone.utc),
    primary_key=["Id"],
    # on_cursor_value_missing="include",
    row_order="asc",
)
department_groups_table.apply_hints(incremental=department_groups_incremental_config)


# 02 : Destination
buckets_root_dir = os.environ.get("OUTPUTS_DIR")
bucket_url = f"file:///{buckets_root_dir}"
local_filesystem_destination = filesystem(bucket_url=bucket_url)

# 03 Pipeline
dlt.config["data_writer.disable_compression"] = True


pipelines_dir = os.environ.get("DLT_PIPELINES_DIR")
destination_schema_name = "contoso_raw"
pipeline = dlt.pipeline(
    pipeline_name="incremental_load_01",
    pipelines_dir=pipelines_dir,
    destination=local_filesystem_destination,
    dataset_name=destination_schema_name,
    progress="log",
)

# 04: run the pipeline
pipeline.run(
    data=my_tables_data,
    write_disposition="append",
    loader_file_format="csv",
)
