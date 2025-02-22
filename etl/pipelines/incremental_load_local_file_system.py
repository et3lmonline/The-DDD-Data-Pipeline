import os

import dlt
from dlt.sources.sql_database import sql_database

database = os.environ.get("SRC_PG_CONTOSO_DATABASE")
password = os.environ.get("SRC_PG_CONTOSO_PASSWORD")
username = os.environ.get("SRC_PG_CONTOSO_USERNAME")
host = os.environ.get("SRC_PG_CONTOSO_HOST")
port = os.environ.get("SRC_PG_CONTOSO_PORT")


connection_string = f"postgresql://{username}:{password}@{host}:{port}/{database}"

# 01 : Source
table_names = ["brands", "colors", "departments"]
my_tables_data = sql_database(
    credentials=connection_string,
    table_names=table_names,
)


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
pipeline.run(data=my_tables_data, write_disposition="replace")
