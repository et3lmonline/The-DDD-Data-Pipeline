DROP TABLE IF EXISTS public.gl_accounts CASCADE;
CREATE TABLE IF NOT EXISTS public.gl_accounts (
    id SERIAL PRIMARY KEY,
    parent_id INT REFERENCES public.gl_accounts(id),
    account_label TEXT,
    account_name TEXT,
    account_description TEXT,
    account_type TEXT,
    operator TEXT,
    custom_members TEXT,
    value_type TEXT,
    custom_member_options TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);


DROP TABLE IF EXISTS public.channels CASCADE;
CREATE TABLE IF NOT EXISTS public.channels (
    id SERIAL PRIMARY KEY,
    channel_label TEXT NOT NULL,
    channel_name TEXT,
    channel_description TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

DROP TABLE IF EXISTS public.currencies CASCADE;
CREATE TABLE IF NOT EXISTS public.currencies (
    id SERIAL PRIMARY KEY,
    currency_label TEXT UNIQUE NOT NULL,
    currency_name TEXT NOT NULL,
    currency_description TEXT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);
DROP TABLE IF EXISTS public.addresses CASCADE;
CREATE TABLE IF NOT EXISTS public.addresses (
    id SERIAL PRIMARY KEY,
    address_line1 TEXT,
    address_line2 TEXT,
    zip_code TEXT,
    zip_code_extension TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

DROP TABLE IF EXISTS public.geographies CASCADE;
CREATE TABLE IF NOT EXISTS public.geographies (
    id SERIAL PRIMARY KEY,
    geography_type TEXT,
    continent_name TEXT,
    city_name TEXT,
    state_province_name TEXT,
    region_country_name TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

DROP TABLE IF EXISTS public.customers CASCADE;
CREATE TABLE IF NOT EXISTS public.customers (
    id SERIAL PRIMARY KEY,
    geography_id INT REFERENCES public.geographies(id),
    address_id INT REFERENCES public.addresses(id),
    customer_label TEXT NOT NULL,
    title TEXT,
    first_name TEXT,
    middle_name TEXT,
    last_name TEXT,
    name_style BOOLEAN,
    birth_date DATE,
    marital_status CHAR(1),
    suffix TEXT,
    gender TEXT,
    email_address TEXT,
    yearly_income NUMERIC,
    total_children SMALLINT,
    number_children_at_home SMALLINT,
    education TEXT,
    occupation TEXT,
    house_owner_flag BOOLEAN,
    number_cars_owned SMALLINT,
    phone TEXT,
    date_first_purchase DATE,
    customer_type TEXT,
    company_name TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

DROP TABLE IF EXISTS public.departments CASCADE;
CREATE TABLE IF NOT EXISTS public.departments (
    id SERIAL PRIMARY KEY,
    department_name TEXT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

DROP TABLE IF EXISTS public.job_titles CASCADE;
CREATE TABLE IF NOT EXISTS public.job_titles (
    id SERIAL PRIMARY KEY,
    job_title_name TEXT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

DROP TABLE IF EXISTS public.employees CASCADE;
CREATE TABLE IF NOT EXISTS public.employees (
    id SERIAL PRIMARY KEY,
    parent_id INT REFERENCES public.employees(id),
    department_id INT REFERENCES public.departments(id),
    job_title_id INT REFERENCES public.job_titles(id),
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    middle_name TEXT,
    hire_date DATE,
    birth_date DATE,
    email_address TEXT,
    phone TEXT,
    marital_status CHAR(1),
    emergency_contact_name TEXT,
    emergency_contact_phone TEXT,
    salaried_flag BOOLEAN,
    gender CHAR(1),
    pay_frequency SMALLINT,
    base_rate NUMERIC,
    vacation_hours SMALLINT,
    current_flag BOOLEAN NOT NULL,
    salesperson_flag BOOLEAN NOT NULL,
    start_date DATE,
    end_date DATE,
    status TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

DROP TABLE IF EXISTS public.entities CASCADE;
CREATE TABLE IF NOT EXISTS public.entities (
    id SERIAL PRIMARY KEY,
    parent_id INT REFERENCES public.entities(id),
    entity_label TEXT,
    entity_name TEXT,
    entity_description TEXT,
    entity_type TEXT,
    start_date DATE,
    end_date DATE,
    status TEXT DEFAULT 'Current',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

DROP TABLE IF EXISTS public.stores CASCADE;
CREATE TABLE IF NOT EXISTS public.stores (
    id SERIAL PRIMARY KEY,
    store_manager_id INT REFERENCES public.employees(id),
    geography_id INT REFERENCES public.geographies(id),
    entity_id INT REFERENCES public.entities(id),
    address_id INT REFERENCES public.addresses(id),
    store_name TEXT NOT NULL,
    store_description TEXT NOT NULL,
    store_type TEXT,
    status TEXT NOT NULL,
    open_date DATE NOT NULL,
    close_date DATE,
    close_reason TEXT,
    employee_count INT,
    selling_area_size NUMERIC,
    last_remodel_date DATE,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);


DROP TABLE IF EXISTS public.machines CASCADE;
CREATE TABLE IF NOT EXISTS public.machines (
    id SERIAL PRIMARY KEY,
    store_id INT REFERENCES public.stores(id),
    machine_label TEXT,
    machine_type TEXT NOT NULL,
    machine_name TEXT NOT NULL,
    machine_description TEXT NOT NULL,
    vendor_name TEXT NOT NULL,
    machine_os TEXT NOT NULL,
    machine_source TEXT NOT NULL,
    machine_hardware TEXT,
    machine_software TEXT NOT NULL,
    status TEXT NOT NULL,
    service_start_date DATE NOT NULL,
    decommission_date DATE,
    last_modified_date DATE,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

DROP TABLE IF EXISTS public.outages CASCADE;
CREATE TABLE IF NOT EXISTS public.outages (
    id SERIAL PRIMARY KEY,
    outage_label TEXT NOT NULL,
    outage_name TEXT NOT NULL,
    outage_description TEXT NOT NULL,
    outage_type TEXT NOT NULL,
    outage_type_description TEXT NOT NULL,
    outage_subtype TEXT NOT NULL,
    outage_subtype_description TEXT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

DROP TABLE IF EXISTS public.brands CASCADE;
CREATE TABLE IF NOT EXISTS public.brands (
    id SERIAL PRIMARY KEY,
    brand_name TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

DROP TABLE IF EXISTS public.manufacturers CASCADE;
CREATE TABLE IF NOT EXISTS public.manufacturers (
    id SERIAL PRIMARY KEY,
    manufacturer_name TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

DROP TABLE IF EXISTS public.colors CASCADE;
CREATE TABLE IF NOT EXISTS public.colors (
    id SERIAL PRIMARY KEY,
    color_name TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

DROP TABLE IF EXISTS public.product_categories CASCADE;
CREATE TABLE IF NOT EXISTS public.product_categories (
    id SERIAL PRIMARY KEY,
    category_name TEXT,
    category_label TEXT,
    category_description TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

DROP TABLE IF EXISTS public.product_subcategories CASCADE;
CREATE TABLE IF NOT EXISTS public.product_subcategories (
    id SERIAL PRIMARY KEY,
    category_id INT REFERENCES public.product_categories(id),
    product_subcategory_label TEXT,
    subcategory_name TEXT,
    subcategory_description TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

DROP TABLE IF EXISTS public.promotions CASCADE;
CREATE TABLE IF NOT EXISTS public.promotions (
    id SERIAL PRIMARY KEY,
    promotion_label VARCHAR(100),
    promotion_name VARCHAR(100),
    promotion_description VARCHAR(255),
    discount_percent FLOAT,
    type VARCHAR(50),
    category VARCHAR(50),
    start_date DATE NOT NULL,
    end_date DATE,
    min_quantity INT,
    max_quantity INT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

DROP TABLE IF EXISTS public.sales_territories CASCADE;
CREATE TABLE IF NOT EXISTS public.sales_territories (
    id SERIAL PRIMARY KEY,
    geography_id INT NOT NULL REFERENCES public.geographies(id),
    manager_id INT NOT NULL REFERENCES public.employees(id),
    sales_territory_label VARCHAR(100),
    sales_territory_name VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    group_name VARCHAR(50),
    level VARCHAR(10),
    start_date DATE,
    end_date DATE,
    status VARCHAR(50),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

DROP TABLE IF EXISTS public.scenarios CASCADE;
CREATE TABLE IF NOT EXISTS public.scenarios (
    id SERIAL PRIMARY KEY,
    scenario_label VARCHAR(100) NOT NULL,
    scenario_name VARCHAR(20),
    scenario_description VARCHAR(50),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);


DROP TABLE IF EXISTS public.products CASCADE;
CREATE TABLE IF NOT EXISTS public.products (
    id SERIAL PRIMARY KEY,
    subcategory_id INT REFERENCES public.product_subcategories(id),
    manufacturer_id INT REFERENCES public.manufacturers(id),
    brand_id INT REFERENCES public.brands(id),
    color_id INT REFERENCES public.colors(id),
    product_label TEXT,
    product_name TEXT,
    product_description TEXT,
    class TEXT,
    style TEXT,
    size TEXT,
    size_measuring_unit TEXT,
    weight NUMERIC,
    weight_measuring_unit TEXT,
    stock_type_name TEXT,
    unit_cost MONEY, /* ⛔ dlt doesn't handle MONEY data type properly */
    unit_price NUMERIC,
    available_for_sale_date DATE,
    stop_sale_date DATE,
    status TEXT,
    image_url TEXT,
    product_url TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

-- ----------------------------------------------------------------------------
-- ---------------------------- Transaction Tables ----------------------------
-- ----------------------------------------------------------------------------

DROP TABLE IF EXISTS public.inventory_weekly_snapshot CASCADE;
CREATE TABLE IF NOT EXISTS public.inventory_weekly_snapshot (
    id SERIAL PRIMARY KEY,
    store_id INT NOT NULL REFERENCES public.stores(id),
    product_id INT NOT NULL REFERENCES public.products(id),
    currency_id INT NOT NULL REFERENCES public.currencies(id),
    snapshot_date DATE NOT NULL,
    on_hand_quantity INT NOT NULL,
    on_order_quantity INT NOT NULL,
    safety_stock_quantity INT,
    unit_cost NUMERIC NOT NULL,
    days_in_stock INT,
    min_days_in_stock INT,
    max_days_in_stock INT,
    aging INT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

DROP TABLE IF EXISTS public.sales_order_lines CASCADE;
CREATE TABLE IF NOT EXISTS public.sales_order_lines (
    id SERIAL PRIMARY KEY,
    channel_id INT REFERENCES public.channels(id),
    store_id INT REFERENCES public.stores(id),
    product_id INT REFERENCES public.products(id),
    promotion_id INT REFERENCES public.promotions(id),
    currency_id INT REFERENCES public.currencies(id),
    ordered_at TIMESTAMP NOT NULL,
    sales_quantity INT NOT NULL,
    unit_cost NUMERIC NOT NULL,
    unit_price NUMERIC NOT NULL,
    discount_quantity INT,
    discount_amount NUMERIC,
    total_cost NUMERIC NOT NULL,
    sales_amount NUMERIC NOT NULL, -- (sales_quantity * unit_price) - discount_amount
    return_quantity INT,
    return_amount NUMERIC,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);


DROP TABLE IF EXISTS public.online_sales_order_lines CASCADE;
CREATE TABLE  IF NOT EXISTS  public.online_sales_order_lines (
    id SERIAL PRIMARY KEY,
    store_id INT NOT NULL REFERENCES public.stores(id),
    product_id INT NOT NULL REFERENCES public.products(id),
    promotion_id INT NOT NULL REFERENCES public.promotions(id),
    currency_id INT NOT NULL REFERENCES public.currencies(id),
    customer_id INT NOT NULL REFERENCES public.customers(id),
    ordered_at TIMESTAMP NOT NULL,
    sales_order_number VARCHAR(20) NOT NULL,
    sales_order_line_number INT,
    sales_quantity INT NOT NULL,
    unit_cost NUMERIC NOT NULL,
    unit_price NUMERIC NOT NULL,
    discount_quantity INT,
    discount_amount NUMERIC NOT NULL,
    total_cost NUMERIC NOT NULL,
    sales_amount NUMERIC NOT NULL, -- (sales_quantity * unit_price) - discount_amount
    return_quantity INT NOT NULL,
    return_amount NUMERIC NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

DROP TABLE IF EXISTS public.exchange_rates CASCADE;
CREATE TABLE IF NOT EXISTS public.exchange_rates (
    id SERIAL PRIMARY KEY,
    currency_id INT NOT NULL REFERENCES public.currencies(id),
    date DATE NOT NULL,
    average_rate FLOAT NOT NULL,
    end_of_day_rate FLOAT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);


DROP TABLE IF EXISTS public.it_machine_costs CASCADE;
CREATE TABLE IF NOT EXISTS public.it_machine_costs (
    id SERIAL PRIMARY KEY,
    machine_id INT NOT NULL REFERENCES public.machines(id),
    date DATE NOT NULL,
    cost_amount NUMERIC NOT NULL,
    cost_type VARCHAR(200) NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

-- original data is from fact_itsla
DROP TABLE IF EXISTS public.outage_transactions CASCADE;
CREATE TABLE   IF NOT EXISTS public.outage_transactions (
    id SERIAL PRIMARY KEY,
    store_id INT NOT NULL REFERENCES public.stores(id),
    machine_id INT NOT NULL REFERENCES public.machines(id),
    outage_id INT NOT NULL REFERENCES public.outages(id),
    outage_date DATE NOT NULL,
    outage_started_at TIMESTAMP NOT NULL,
    outage_ended_at TIMESTAMP NOT NULL,
    downtime INT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);


DROP TABLE IF EXISTS public.sales_quotas CASCADE;
CREATE TABLE   IF NOT EXISTS public.sales_quotas (
    id SERIAL PRIMARY KEY,
    channel_id INT NOT NULL REFERENCES public.channels(id),
    store_id INT NOT NULL REFERENCES public.stores(id),
    product_id INT NOT NULL REFERENCES public.products(id),
    currency_id INT NOT NULL REFERENCES public.currencies(id),
    scenario_id INT NOT NULL REFERENCES public.scenarios(id),
    date DATE NOT NULL,
    sales_quantity_quota NUMERIC NOT NULL,
    sales_amount_quota NUMERIC NOT NULL,
    gross_margin_quota NUMERIC NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);

DROP TABLE IF EXISTS public.strategy_plans CASCADE;
CREATE TABLE  IF NOT EXISTS public.strategy_plans (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    entity_id INT NOT NULL REFERENCES public.entities(id),
    scenario_id INT NOT NULL REFERENCES public.scenarios(id),
    gl_account_id INT NOT NULL REFERENCES public.gl_accounts(id),
    currency_id INT NOT NULL REFERENCES public.currencies(id),
    product_category_id INT REFERENCES public.product_categories(id),
    amount NUMERIC NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL
);
