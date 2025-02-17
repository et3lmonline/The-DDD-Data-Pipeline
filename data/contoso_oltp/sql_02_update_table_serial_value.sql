SELECT setval('public.gl_accounts_id_seq', coalesce(max(id), 0) + 1, false) FROM public.gl_accounts;
SELECT setval('public.channels_id_seq', coalesce(max(id), 0) + 1, false) FROM public.channels;
SELECT setval('public.currencies_id_seq', coalesce(max(id), 0) + 1, false) FROM public.currencies;
SELECT setval('public.addresses_id_seq', coalesce(max(id), 0) + 1, false) FROM public.addresses;
SELECT setval('public.currencies_id_seq', coalesce(max(id), 0) + 1, false) FROM public.currencies;
SELECT setval('public.customers_id_seq', coalesce(max(id), 0) + 1, false) FROM public.customers;
SELECT setval('public.departments_id_seq', coalesce(max(id), 0) + 1, false) FROM public.departments;
SELECT setval('public.job_titles_id_seq', coalesce(max(id), 0) + 1, false) FROM public.job_titles;
SELECT setval('public.employees_id_seq', coalesce(max(id), 0) + 1, false) FROM public.employees;
SELECT setval('public.entities_id_seq', coalesce(max(id), 0) + 1, false) FROM public.entities ;
SELECT setval('public.stores_id_seq', coalesce(max(id), 0) + 1, false) FROM public.stores;
SELECT setval('public.machines_id_seq', coalesce(max(id), 0) + 1, false) FROM public.machines;
SELECT setval('public.outages_id_seq', coalesce(max(id), 0) + 1, false) FROM public.outages;
SELECT setval('public.brands_id_seq', coalesce(max(id), 0) + 1, false) FROM public.brands;
SELECT setval('public.manufacturers_id_seq', coalesce(max(id), 0) + 1, false) FROM public.manufacturers;
SELECT setval('public.colors_id_seq', coalesce(max(id), 0) + 1, false) FROM public.colors;
SELECT setval('public.product_categories_id_seq', coalesce(max(id), 0) + 1, false) FROM public.product_categories;
SELECT setval('public.product_subcategories_id_seq', coalesce(max(id), 0) + 1, false) FROM public.product_subcategories;
SELECT setval('public.promotions_id_seq', coalesce(max(id), 0) + 1, false) FROM public.promotions;
SELECT setval('public.sales_territories_id_seq', coalesce(max(id), 0) + 1, false) FROM public.sales_territories;
SELECT setval('public.scenarios_id_seq', coalesce(max(id), 0) + 1, false) FROM public.scenarios;
SELECT setval('public.products_id_seq', coalesce(max(id), 0) + 1, false) FROM public.products;
SELECT setval('public.inventory_weekly_snapshot_id_seq', coalesce(max(id), 0) + 1, false) FROM public.inventory_weekly_snapshot;
SELECT setval('public.sales_order_lines_id_seq', coalesce(max(id), 0) + 1, false) FROM public.sales_order_lines;
SELECT setval('public.online_sales_order_lines_id_seq', coalesce(max(id), 0) + 1, false) FROM public.online_sales_order_lines;
SELECT setval('public.exchange_rates_id_seq', coalesce(max(id), 0) + 1, false) FROM public.exchange_rates;
SELECT setval('public.outage_transactions_id_seq', coalesce(max(id), 0) + 1, false) FROM public.outage_transactions;
SELECT setval('public.it_machine_costs_id_seq', coalesce(max(id), 0) + 1, false) FROM public.it_machine_costs;
SELECT setval('public.strategy_plans_id_seq', coalesce(max(id), 0) + 1, false) FROM public.strategy_plans;
SELECT setval('public.sales_quotas_id_seq', coalesce(max(id), 0) + 1, false) FROM public.sales_quotas;
