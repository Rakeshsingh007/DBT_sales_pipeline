{{ config(
    materialized='table',
    alias='sales_analysis'
) }}

WITH 

-- Calculate total sales
total_sales AS (
    SELECT 
        SUM(amount) AS total_sales
    FROM 
        {{ ref('stg_liquor_sales') }}
),

-- Calculate sales by category
sales_by_category AS (
    SELECT 
        category_name,
        SUM(amount) AS category_sales
    FROM 
        {{ ref('stg_liquor_sales') }}
    GROUP BY 
        category_name
),

-- Calculate sales by store location
sales_by_store AS (
    SELECT 
        store_location,
        SUM(amount) AS store_sales
    FROM 
        {{ ref('stg_liquor_sales') }}
    GROUP BY 
        store_location
),

-- Calculate sales by item
top_selling_items AS (
    SELECT 
        item_name,
        SUM(quantity) AS quantity_sold
    FROM 
        {{ ref('stg_liquor_sales') }}
    GROUP BY 
        item_name
    ORDER BY 
        quantity_sold DESC
    LIMIT 10
),

-- Calculate sales by month
sales_by_month AS (
    SELECT 
        DATE_TRUNC('month', order_date) AS sales_month,
        SUM(amount) AS monthly_sales
    FROM 
        {{ ref('stg_liquor_sales') }}
    GROUP BY 
        sales_month
)

-- Combine all analysis into a single table
SELECT 
    total_sales.total_sales,
    sales_by_category.category_name,
    sales_by_category.category_sales,
    sales_by_store.store_location,
    sales_by_store.store_sales,
    top_selling_items.item_name,
    top_selling_items.quantity_sold,
    sales_by_month.sales_month,
    sales_by_month.monthly_sales
FROM 
    total_sales,
    sales_by_category,
    sales_by_store,
    top_selling_items,
    sales_by_month