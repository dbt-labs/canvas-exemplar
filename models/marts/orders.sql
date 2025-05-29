with

orders as (

    select 
        order_id,
        customer_id,
        ordered_at
    from {{ ref('stg_orders') }}

),

order_items as (

    select 
        order_item_id,
        order_id,
        supply_cost,
        product_price,
        is_food_item,
        is_drink_item
    from {{ ref('order_items') }}

),

order_items_summary as (

    select
        order_id,

        sum(supply_cost) as order_cost,
        sum(product_price) as order_items_subtotal,
        count(order_item_id) as count_order_items,
        sum(
            case
                when is_food_item then 1
                else 0
            end
        ) as count_food_items,
        sum(
            case
                when is_drink_item then 1
                else 0
            end
        ) as count_drink_items

    from order_items

    group by 1

),

compute_booleans as (

    select
        orders.order_id,
        orders.customer_id,
        orders.ordered_at,

        order_items_summary.order_cost,
        order_items_summary.order_items_subtotal,
        order_items_summary.count_food_items,
        order_items_summary.count_drink_items,
        order_items_summary.count_order_items,
        order_items_summary.count_food_items > 0 as is_food_order,
        order_items_summary.count_drink_items > 0 as is_drink_order

    from orders

    left join
        order_items_summary
        on orders.order_id = order_items_summary.order_id

),

customer_order_count as (

    select
        compute_booleans.order_id,
        compute_booleans.customer_id,
        compute_booleans.ordered_at,
        compute_booleans.order_cost,
        compute_booleans.order_items_subtotal,
        compute_booleans.count_food_items,
        compute_booleans.count_drink_items,
        compute_booleans.count_order_items,
        compute_booleans.is_food_order,
        compute_booleans.is_drink_order,

        row_number() over (
            partition by customer_id
            order by ordered_at asc
        ) as customer_order_number

    from compute_booleans

)

select 
    customer_order_count.order_id,
    customer_order_count.customer_id,
    customer_order_count.ordered_at,
    customer_order_count.order_cost,
    customer_order_count.order_items_subtotal,
    customer_order_count.count_food_items,
    customer_order_count.count_drink_items,
    customer_order_count.count_order_items,
    customer_order_count.is_food_order,
    customer_order_count.is_drink_order,
    customer_order_count.customer_order_number
from customer_order_count