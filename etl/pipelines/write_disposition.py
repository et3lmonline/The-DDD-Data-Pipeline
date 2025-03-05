import os
from datetime import datetime, timezone

import dlt
from dlt.destinations import duckdb
from dlt.sources.sql_database import sql_table

# from dlt.destinations import bigquery
# from dlt.sources.sql_database import sql_database

dlt.config["load.truncate_staging_dataset"] = True  # default = False

credentials = {
    "drivername": "postgresql",
    "database": os.environ.get("SRC_PG_CONTOSO_DATABASE"),
    "password": os.environ.get("SRC_PG_CONTOSO_PASSWORD"),
    "username": os.environ.get("SRC_PG_CONTOSO_USERNAME"),
    "host": os.environ.get("SRC_PG_CONTOSO_HOST"),
    "port": os.environ.get("SRC_PG_CONTOSO_PORT"),
}

incremental = dlt.sources.incremental(
    cursor_path="updated_at",
    initial_value=datetime(1900, 1, 1, 0, 0, 0, tzinfo=timezone.utc),
    row_order="asc",
)


colors = sql_table(
    credentials=credentials,
    schema="public",
    table="colors",
).apply_hints(
    incremental=incremental,
)

# Make sure that the directory exists
destination = duckdb("duckdb:///data/duckdbs/dlt_wd.duck")

# #########################################
# Full Load / Append (the default mode)
# @dlt.resource(table_name=, write_disposition=)
append = colors.apply_hints(
    table_name="colors_append",
    write_disposition="append",
)

dlt.pipeline(
    pipeline_name="dlt_wd_append",
    destination=destination,
    dataset_name="wd_demo",
).run(
    data=append,
    # write_disposition="replace",
)

# Replace (always Full Load)
#       incremental load configuration is not considered - reset state.json
replace = colors.apply_hints(
    table_name="colors_replace",
    write_disposition="replace",
)

dlt.pipeline(
    pipeline_name="dlt_wd_replace",
    destination=destination,
    dataset_name="wd_demo",
).run(data=replace)


# # MERGE / (DELETE+INSERT)
merge_del_ins = colors.apply_hints(
    table_name="colors_merge_del_ins",
    write_disposition={
        "disposition": "merge",
        "strategy": "delete-insert",
    },
    primary_key=["id"],
    # merge_key=['color_name']
)

dlt.pipeline(
    pipeline_name="dlt_wd_merge_del_ins",
    destination=destination,
    dataset_name="wd_demo",
).run(data=merge_del_ins)

# # MERGE / (SCD2)
merge_scd2 = colors.apply_hints(
    table_name="colors_merge_scd2",
    write_disposition={
        "disposition": "merge",
        "strategy": "scd2",
    },
    merge_key=["id"],
)

dlt.pipeline(
    pipeline_name="dlt_wd_merge_scd2",
    destination=destination,
    dataset_name="wd_demo",
).run(data=merge_scd2)
