with raw_data as (
    select
        -- Assigning meaningful names and suitable data types
        "Invoice/Item Number" as invoice_id,
        
        -- Validating and converting the order date
        CASE
            WHEN "Date" ~ '^\d{2}/\d{2}/\d{2}' THEN 
                to_timestamp("Date", 'MM/DD/YYYY') AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York'
            ELSE NULL
        END as order_date,

        -- Store-related information
        "Store Number"::integer as store_id,
        "Store Name" as store_name,
        "Address" as address,
        "City" as city,
        "Zip Code"::varchar(10) as zip,  -- Assuming ZIP codes are strings, not integers
        "Store Location" as store_location,

        -- County information
        "County Number"::integer as county_id,  -- Correcting "country_id" to "county_id"
        "County" as county_name,  -- Correcting "country_name" to "county_name"

        -- Category information
        "Category"::integer as category_id,
        "Category Name" as category_name,

        -- Vendor information
        "Vendor Number"::integer as vendor_id,
        "Vendor Name" as vendor_name,

        -- Item-related information
        "Item Number"::integer as item_id,
        "Item Description" as item_name,
        "Pack"::integer as pack,
        "Bottle Volume (ml)"::integer as volume,  -- Assuming volume is an integer

        -- Pricing information
        "State Bottle Cost"::numeric(10, 2) as bottle_cost,  -- Numeric with 2 decimal places for currency
        "State Bottle Retail"::numeric(10, 2) as bottle_retail,  -- Same as above

        -- Sales-related information
        "Bottles Sold"::integer as quantity,
        "Sale (Dollars)"::numeric(10, 2) as amount,
        "Volume Sold (Liters)"::numeric(10, 3) as sold_in_liters,  -- Numeric with 3 decimal places
        "Volume Sold (Gallons)"::numeric(10, 3) as sold_in_gallons  -- Same as above
    from 
        {{ source('public', 'raw_liquor_sales_data') }}
)

select
    invoice_id,
    order_date,
    EXTRACT(YEAR FROM order_date) AS order_year,
    EXTRACT(MONTH FROM order_date) AS order_month,
    EXTRACT(DAY FROM order_date) AS order_day,
    store_id,
    store_name,
    address,
    city,
    zip,
    store_location,
    county_id,
    county_name,
    category_id,
    category_name,
    vendor_id,
    vendor_name,
    item_id,
    item_name,
    pack,
    volume,
    bottle_cost,
    bottle_retail,
    quantity,
    amount,
    sold_in_liters,
    sold_in_gallons
from raw_data
order by order_date

-- Add primary key constraint as a post-hook
{{ config(
    post_hook=[
        """
        DO $$
        BEGIN
            IF NOT EXISTS (
                SELECT 1
                FROM pg_constraint
                WHERE conname = 'stg_sales_pkey'
            ) THEN
                ALTER TABLE {{ this }}
                ADD CONSTRAINT stg_sales_pkey PRIMARY KEY (invoice_id);
            END IF;
        END $$;
        """
    ]
) }}
