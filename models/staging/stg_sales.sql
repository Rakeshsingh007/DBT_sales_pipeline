with raw_data as (
    select
        CASE
            WHEN "Order ID" ~ '^[0-9]+$' THEN "Order ID"::integer
            ELSE NULL
        END as order_id,
        "Product" as product,
        
        -- Validate and cast Quantity Ordered
        CASE
            WHEN "Quantity Ordered" ~ '^[0-9]+$' THEN "Quantity Ordered"::integer
            ELSE NULL
        END as quantity_ordered,

        -- Validate and round Price Each to 2 decimal places
        CASE
            WHEN "Price Each" ~ '^[0-9]+(\.[0-9]+)?$' THEN ROUND("Price Each"::numeric, 2)
            ELSE NULL
        END as price_each,

        -- Validate and parse Order Date with specific format
        CASE
            WHEN "Order Date" ~ '^\d{2}/\d{2}/\d{2} \d{2}:\d{2}$' THEN 
                to_timestamp("Order Date", 'MM/DD/YY HH24:MI') AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York'
            ELSE NULL
        END as order_date,

        -- Keep Purchase Address as is
        "Purchase Address" as purchase_address
    from 
        {{ source('public', 'raw_sales_data') }}
)

select
    row_number() over () as id,
    order_id,
    product,
    quantity_ordered,
    price_each,
    order_date,
    purchase_address
from raw_data
where order_id is not null
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
                ADD CONSTRAINT stg_sales_pkey PRIMARY KEY (id);
            END IF;
        END $$;
        """
    ]
) }}
