"""
This script is meant to be used only one time while loading the data to postgres
The batch size is added to save time while doing the PoC, instead of loading all records, only load a subset.
"""

import os
from datetime import datetime, timezone
from pathlib import Path

import numpy as np
import pyarrow.parquet as pq
import yaml
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.exc import IntegrityError

# fmt: off
CURRENCY_FIELDS = [
    "unit_cost","unit_price","discount_amount","total_cost","sales_amount","return_amount",
    "cost_amount","sales_quantity_quota","sales_amount_quota","gross_margin_quota","amount"
]
# fmt: on


def clean_currency(value):
    """Remove dollar signs, handle negative parentheses, and convert to float."""
    if isinstance(value, str):
        value = value.replace(",", "")

        # negative values
        if value.startswith("($") and value.endswith(")"):
            value = "-" + value[2:-1]

        value = value.replace("$", "")

        return float(value) if value else None

    # Convert NumPy types to Python float
    elif isinstance(value, (np.float64, np.int64)):
        return float(value)

    return value


def set_created_at_and_updated_at_to_now(record):

    now = datetime.now(tz=timezone.utc)

    record["created_at"] = now
    record["updated_at"] = now

    # Casting VARCHAR fields into NUMERIC
    for field in CURRENCY_FIELDS:
        if field in record:
            record[field] = clean_currency(record[field])

    return record


def read_parquet_in_chunks(
    file_path,
    batch_size: int = 10000,
    batches_count: int = -1,
):
    if batches_count == 0:
        raise ValueError(
            "Zero is not allowed value for the argument `batches_count`, use `-1` for reading the entire file, or positive value greater than zero to control number or rows (batch_size * batches_count)"
        )

    parquet_file = pq.ParquetFile(file_path)

    if parquet_file.metadata.num_rows == 0:
        return

    counter = 0
    for batch in parquet_file.iter_batches(batch_size=batch_size):
        df = batch.to_pandas()
        if not df.empty:
            print("Loading new batch...")
            yield df

        counter += 1
        if counter == batches_count:
            break


def load_data_to_postgres(
    file_path, table_name: str, chunk_size=10000, batches_count: int = -1
):
    for chunk in read_parquet_in_chunks(file_path, chunk_size, batches_count):

        # For table department groups, don't set created_at and updated_at to now,
        # use the values in the parquet file.
        if table_name == "DepartmentGroups":
            chunk.to_sql(table_name, engine, if_exists="append", index=False)
        else:
            modified_chunk = chunk.apply(set_created_at_and_updated_at_to_now, axis=1)
            modified_chunk.to_sql(table_name, engine, if_exists="append", index=False)


if __name__ == "__main__":
    load_dotenv()
    current_dir = Path(__file__).parent
    yaml_file_path = current_dir / "contoso_data_files.yaml"
    write_mode = "replace"  # "fail", "replace", "append"
    batches_count = 2
    chunk_size = 100000

    host = os.environ["SRC_PG_CONTOSO_HOST"]
    port = os.environ["SRC_PG_CONTOSO_PORT"]
    database = os.environ["SRC_PG_CONTOSO_DATABASE"]
    username = os.environ["SRC_PG_CONTOSO_USERNAME"]
    password = os.environ["SRC_PG_CONTOSO_PASSWORD"]
    engine = create_engine(
        f"postgresql://{username}:{password}@{host}:{port}/{database}"
    )

    with open(yaml_file_path, "r") as file:
        yaml_data = yaml.safe_load(file)

    tables = yaml_data["tables"]
    for table in tables:
        if not table["is_enabled"]:
            continue
        table_name = table["name"]
        print(f"Processing table: {table_name}")
        for data_file in table["files"]:
            try:
                load_data_to_postgres(
                    data_file,
                    table_name,
                    chunk_size=chunk_size,
                    batches_count=batches_count,
                )
            # SQLAlchemy Exception
            except IntegrityError as e:
                print(e.orig)
                continue
