# Loading BikeSotres Data into Postgres Database

- Copy the `.sql` files under `data/bikes` into the docker container
  ```bash
  docker cp data/bikes/q01_create_db.sql pg_db:/tmp
  docker cp data/bikes/q02_create_tables.sql pg_db:/tmp
  docker cp data/bikes/q03_insert_values.sql pg_db:/tmp
  ```
- Open the postgres container terminal
  ```bash
  docker exec -it pg_db bash
  ```
- Execute the sql scripts (in the docker terminal)
  ```bash
  psql -U postgres -f /tmp/q01_create_db.sql
  psql -U postgres -d bikes -f /tmp/q02_create_tables.sql
  psql -U postgres -d bikes -f /tmp/q03_insert_values.sql
  ```

