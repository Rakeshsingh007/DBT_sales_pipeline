{{ config(materialized="table", alias="sales_analysis") }}

with

    -- Calculate total sales
    total_sales as (
        select sum(amount) as total_sales from {{ ref("stg_liquor_sales") }}
    ),

    -- Calculate sales by category
    sales_by_category as (
        select category_name, sum(amount) as category_sales
        from {{ ref("stg_liquor_sales") }}
        group by category_name
    ),

    -- Calculate sales by store location
    sales_by_store as (
        select store_location, sum(amount) as store_sales
        from {{ ref("stg_liquor_sales") }}
        group by store_location
    ),

    -- Calculate sales by item
    top_selling_items as (
        select item_name, sum(quantity) as quantity_sold
        from {{ ref("stg_liquor_sales") }}
        group by item_name
        order by quantity_sold desc
        limit 10
    ),

    -- Calculate sales by month
    sales_by_month as (
        select
            date_trunc('month', order_date) as sales_month, sum(amount) as monthly_sales
        from {{ ref("stg_liquor_sales") }}
        group by sales_month
    )

-- Combine all analysis into a single table
select
    total_sales.total_sales,
    sales_by_category.category_name,
    sales_by_category.category_sales,
    sales_by_store.store_location,
    sales_by_store.store_sales,
    top_selling_items.item_name,
    top_selling_items.quantity_sold,
    sales_by_month.sales_month,
    sales_by_month.monthly_sales
from total_sales, sales_by_category, sales_by_store, top_selling_items, sales_by_month
