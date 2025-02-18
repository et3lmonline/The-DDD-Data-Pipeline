# Loading Data into Source Database

Prerequisites:
- Docker & Docker Compose
- Bash terminal (WSL / Git Bash)
- VS Code
- Good to install these VS Code extensions:
  - Docker
  - Parquet Explorer by Adam Viola


Follow these steps to download the parquet files and load its content into the source database (Postgres):

1. Download the parquet files from [this repo](https://github.com/et3lmonline/datasets/tree/main/contoso_oltp_v1)
   - use the command below to download the files, files will be downloaded into `data/contoso_oltp/data`
     ```bash
     data/contoso_oltp/download_parquet_files.sh --debug # for listing files without downloading
     data/contoso_oltp/download_parquet_files.sh
     ```
     - The script will ask your input to determine which files to be downloaded
       1. `1` The lite version, includes lookup tables, single file per event table (e.g., online_sales_order_lines,   sales_order_lines, ...)
       2. `2` All the files
       3. `3` Remaining files (all - lite)
2. **Setup Postgres Environment Variables**
   - Copy `.env.examples` and rename it to `.env`
   - Enter proper values for the environment variables below
     ```ini
     SRC_PG_CONTOSO_HOST=
     SRC_PG_CONTOSO_PORT=
     SRC_PG_CONTOSO_DATABASE=
     SRC_PG_CONTOSO_USERNAME=
     SRC_PG_CONTOSO_PASSWORD=
     ```
     - Open a new terminal (**PowerShell**) and test whether the environment variables are integrated to the terminal
       ```powershell
       echo $env:SRC_PG_CONTOSO_HOST
       ```
     - If we didn't get an output, we have to create the environment variables either through the GUI or through the terminal
       ```powershell
       $env:FOO='BAR'; # session based
       echo $env:FOO
       # premetanet, replace `User` with `Machine` to make it system environment variable
       [System.Environment]::SetEnvironmentVariable("SRC_PG_CONTOSO_HOST", "localhost", "User")
       [System.Environment]::SetEnvironmentVariable("SRC_PG_CONTOSO_PORT", "5430", "User")
       [System.Environment]::SetEnvironmentVariable("SRC_PG_CONTOSO_DATABASE", "contoso", "User")
       [System.Environment]::SetEnvironmentVariable("SRC_PG_CONTOSO_USERNAME", "postgres", "User")
       [System.Environment]::SetEnvironmentVariable("SRC_PG_CONTOSO_PASSWORD", "123456", "User")
       ```
3. Start Postgres database service
   ```bash
   docker compose -f 'docker\docker_compose_pg.yaml' up -d
   ```
   - This will create a database and the list of tables defined in `docker/scripts/sql/02_pg_ddl_tables.sql`
4. **Configure `contoso_data_files.yaml`**
   - Open the `contoso_data_files.yaml` file.
   - Locate the `is_enabled` key for each table entry and set it to `true`/`false` to control which tables to be loaded.
   - Verify that the paths specified under the `files` key are accurate and point to the correct Parquet files.
   - ⚠ Don't change the order of tables in the file to avoid database error related to violating foreign key constraints

5. Create a virtual environment and install the necessary packages
   ```
   python -m venv .venv
   .venv/Scripts/activate
   python.exe -m pip install --upgrade pip
   pip install -r requirements.txt
   ```
6. **Run the Script**
   - Execute the `load_tables.py` script to load data from the Parquet files into the PostgreSQL database.
     ```bash
     python data/contoso_oltp/load_tables.py
     ```
   - Note: By default, the script is configured to:
     - Load **two batches** per Parquet file.
     - Each batch contains up to **100,000 records**.
     - To change this, search for `batches_count` and set it to `-1` to load the entire file

7. Run the SQL script located in `data\contoso_oltp\sql_02_update_table_serial_value.sql` to update the serial value associated with the primary key, this will enables us to insert new records with the right id
