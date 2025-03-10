"""
Challenges:
- Column selection (include/exclude columns)
- Filter rows on database level
- Add extra columns on database level

Adapters:
- engine_adapter_callback
- table_adapter_callback
- type_adapter_callback
- query_adapter_callback

"""

import os
from datetime import datetime, timezone

import dlt
import sqlalchemy as sa
import sqlalchemy.dialects.postgresql as pg_sql_type
from dlt.destinations import duckdb, filesystem
from dlt.sources.sql_database import sql_database, sql_table

database = os.environ.get("SRC_PG_CONTOSO_DATABASE")
password = os.environ.get("SRC_PG_CONTOSO_PASSWORD")
username = os.environ.get("SRC_PG_CONTOSO_USERNAME")
host = os.environ.get("SRC_PG_CONTOSO_HOST")
port = os.environ.get("SRC_PG_CONTOSO_PORT")

connection_string = f"postgresql://{username}:{password}@{host}:{port}/{database}"


incremental = dlt.sources.incremental(
    cursor_path="UpdatedAt",
    initial_value=datetime(1900, 1, 1, 0, 0, 0, tzinfo=timezone.utc),
    row_order="asc",
)


def engine_adapter_callback(engine: sa.Engine) -> sa.Engine:
    engine.echo = True
    return engine


def table_adapter_callback(table: sa.Table) -> sa.Table:
    # if table.fullname == "public.DepartmentGroups":

    #     updated_at = sa.sql.type_coerce(
    #         sa.func.coalesce(table.c.UpdatedAt, table.c.CreatedAt),
    #         sa.DateTime,
    #     ).label("UpdatedAt")

    #     for column in list(table._columns):
    #         if column.name == "UpdatedAt":
    #             table._columns.remove(column)

    #     subquery = sa.select(*table.c, updated_at).subquery()

    #     return subquery
    if table.fullname == "public.products":
        columns_keep = ["id", "product_name", "status", "created_at", "updated_at"]
        columns_exclude = ["product_description", "image_url", "product_url"]
        selection_type = "exclude"

        for column in table._columns:
            if selection_type == "keep":
                if column.name not in columns_keep:
                    table._columns.remove(column)
            if selection_type == "exclude":
                if column.name in columns_exclude:
                    table._columns.remove(column)

        return table


def type_adapter_callback(sql_type):
    if isinstance(sql_type, pg_sql_type.MONEY):
        return sa.String(255)


products = sql_table(
    credentials=connection_string,
    schema="public",
    table="products",
    # included_columns=["id", "product_name", "unit_cost"],
    # engine_adapter_callback=engine_adapter_callback,
    table_adapter_callback=table_adapter_callback,
    type_adapter_callback=type_adapter_callback,
)


def query_adapter_callback(
    query: sa.Select,
    table: sa.Table,
    incremental: dlt.sources.incremental,
    engine: sa.Engine,
):
    if table.fullname == "public.DepartmentGroups":
        if incremental and incremental.initial_value is not None:
            columns_list = [
                f'"{column.name}"'
                for column in table.columns
                if column.name != "UpdatedAt"
            ]
            query = sa.text(
                f"""
                    SELECT
                        {", ".join(columns_list)},
                        COALESCE("UpdatedAt", "CreatedAt") AS "UpdatedAt",

                    FROM "{table.schema}"."{table.name}"
                    WHERE COALESCE("UpdatedAt", "CreatedAt") >= '{incremental.initial_value}'
                    ORDER BY "UpdatedAt" ASC
                """
            )
            return query
    return query


departments = sql_table(
    credentials=connection_string,
    schema="public",
    table="DepartmentGroups",
    engine_adapter_callback=engine_adapter_callback,
    query_adapter_callback=query_adapter_callback,
).apply_hints(incremental=incremental)


dlt.config["data_writer.disable_compression"] = True

# for relative path, don't use `file://`
filesystem_destination = filesystem("file:data/output/sql_adapters")
duck_destination = duckdb("duckdb:///data/duckdbs/sql_adapters.duckdb")

pipeline = dlt.pipeline(
    pipeline_name="sql_adapters",
    destination=filesystem_destination,
    dataset_name="demo",
    # Drop tables and source and resource state for all sources currently being processed
    # in `run` or `extract` methods of the pipeline. (Note: schema history is erased)
    # refresh="drop_sources",
)

data = [
    departments,
    # products,
]

pipeline.run(
    data=data,
    write_disposition="append",
    loader_file_format="csv",
)
