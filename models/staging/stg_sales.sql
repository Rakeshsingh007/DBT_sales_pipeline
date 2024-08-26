with
    raw_data as (
        select
            case
                when "Order ID" ~ '^[0-9]+$' then "Order ID"::integer else null
            end as order_id,
            "Product" as product,

            -- Validate and cast Quantity Ordered
            case
                when "Quantity Ordered" ~ '^[0-9]+$'
                then "Quantity Ordered"::integer
                else null
            end as quantity_ordered,

            -- Validate and round Price Each to 2 decimal places
            case
                when "Price Each" ~ '^[0-9]+(\.[0-9]+)?$'
                then round("Price Each"::numeric, 2)
                else null
            end as price_each,

            -- Validate and parse Order Date with specific format
            case
                when "Order Date" ~ '^\d{2}/\d{2}/\d{2} \d{2}:\d{2}$'
                then
                    to_timestamp(
                        "Order Date", 'MM/DD/YY HH24:MI'
                    ) at time zone 'UTC' at time zone 'America/New_York'
                else null
            end as order_date,

            -- Keep Purchase Address as is
            "Purchase Address" as purchase_address
        from {{ source("public", "raw_sales_data") }}
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
order by
    order_date

    -- Add primary key constraint as a post-hook
    {{
        config(
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
        )
    }}
