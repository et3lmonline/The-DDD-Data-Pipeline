import os

import dlt
from dlt.sources.sql_database import sql_database, sql_table

database = os.environ.get("SRC_PG_CONTOSO_DATABASE")
password = os.environ.get("SRC_PG_CONTOSO_PASSWORD")
username = os.environ.get("SRC_PG_CONTOSO_USERNAME")
host = os.environ.get("SRC_PG_CONTOSO_HOST")
port = os.environ.get("SRC_PG_CONTOSO_PORT")


credentials = {
    "drivername": "postgresql",
    "database": database,
    "password": password,
    "username": username,
    "host": host,
    "port": port,
}

connection_string = f"postgresql://{username}:{password}@{host}:{port}/{database}"

# 01 : Source
my_table_data = sql_table(credentials=connection_string, table="brands")
my_tables_data = sql_database(
    credentials=connection_string,
    table_names=["brands", "colors", "departments"],
)

# print(list(my_table_data)[0])

# 02 : Destination
# 03 Pipeline
destination_schema_name = "contoso_raw"
pipeline = dlt.pipeline(
    pipeline_name="my_first_dlt_pipeline",
    destination="duckdb",
    dataset_name=destination_schema_name,
    progress="log",
)

# 04: run the pipeline
# pipeline.run(data=my_table_data)
pipeline.run(data=my_tables_data, write_disposition="replace")


#   +----------+    Extract     +---------------+   Normalize     +---------------+   Load     +-------------+
#   |  Source  | -------------> | Local File(s) | --------------> | Local File(s) | ---------> | Destination |
#   +----------+                +---------------+                 +---------------+            +-------------+
