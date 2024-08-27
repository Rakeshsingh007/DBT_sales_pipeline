with
    total_sales  /* Calculate total sales */
    as (
        select sum(amount) as total_sales
        from {{ ref("stg_liquor_sales") }} as stg_liquor_sales
    ),
    sales_by_category  /* Calculate sales by category */
    as (
        select category_name, sum(amount) as category_sales
        from "sales_analytics"."public"."stg_liquor_sales" as stg_liquor_sales
        group by category_name
    ),
    sales_by_store  /* Calculate sales by store location */
    as (
        select store_location, sum(amount) as store_sales
        from {{ ref("stg_liquor_sales") }} as stg_liquor_sales
        group by store_location
    ),
    top_selling_items  /* Calculate sales by item */
    as (
        select item_name, sum(quantity) as quantity_sold
        from "sales_analytics"."public"."stg_liquor_sales"
        group by item_name
        order by quantity_sold desc nulls last
        limit 10
    ),
    sales_by_month  /* Calculate sales by month */
    as (
        select
            date_trunc('MONTH', order_date) as sales_month, sum(amount) as monthly_sales
        from "sales_analytics"."public"."stg_liquor_sales"
        group by sales_month
    )
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
