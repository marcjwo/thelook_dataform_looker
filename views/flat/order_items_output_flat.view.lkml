include: "/views/extendable/*.*"

# The name of this view in Looker is "Order Items Output Post"
view: order_items_output_flat {
  view_label: "Order Items"
  extends: [products_reuseable, users_reuseable]
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `@{GCP_PROJECT}.@{ORDERS_OUTPUT}.order_items_output_flat` ;;

  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Age" in Explore.




  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created_at {
    view_label: "Orders"
    type: time
    description: "Timestamp of record creation"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    view_label: "Orders"
    type: time
    description: "Timestamp of delivery"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: distribtution_center_name {
    view_label: "Distribution Center"
    type: string
    description: "Name of distribtution center"
    sql: ${TABLE}.distribtution_center_name ;;
  }

  dimension: distribution_center_latitude {
    view_label: "Distribution Center"
    type: number
    description: "Lat of distribution center"
    sql: ${TABLE}.distribution_center_latitude ;;
  }

  dimension: distribution_center_longitude {
    view_label: "Distribution Center"
    type: number
    description: "Lon of distribution center"
    sql: ${TABLE}.distribution_center_longitude ;;
  }

  dimension: is_first_purchase {
    view_label: "Orders"
    type: yesno
    description: "Is order first purchase in BOOL"
    sql: ${TABLE}.is_first_purchase ;;
  }






  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.





  dimension: order_amount {
    view_label: "Orders"
    type: number
    description: "Amount of order in USD"
    value_format_name: usd
    sql: ${TABLE}.order_amount ;;
  }

  measure: total_order_amount {
    view_label: "Orders"
    type: sum
    description: "Total amount of order in USD"
    value_format_name: usd
    sql: ${order_amount} ;;
  }

  dimension: order_cost {
    view_label: "Orders"
    type: number
    description: "Cost of order in USD"
    value_format_name: usd
    sql: ${TABLE}.order_cost ;;
  }

  measure: total_order_cost {
    view_label: "Orders"
    type: sum
    description: "Total cost of order in USD"
    value_format_name: usd
    sql: ${order_cost} ;;
  }

  dimension: order_id {
    view_label: "Orders"
    type: number
    description: "Order ID"
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_margin {
    view_label: "Orders"
    type: number
    description: "Margin of order in USD"
    value_format_name: usd
    sql: ${TABLE}.order_margin ;;
  }

  measure: total_order_margin {
    view_label: "Orders"
    type: sum
    description: "Total margin of orders in USD"
    value_format_name: usd
    sql: ${order_margin} ;;
  }

  dimension: order_sequence_number {
    view_label: "Orders"
    type: number
    description: "Sequential number of order by user"
    sql: ${TABLE}.order_sequence_number ;;
  }

  dimension_group: returned {
    view_label: "Orders"
    type: time
    description: "Timestamp of return"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    view_label: "Orders"
    type: number
    description: "Sale price of item in USD"
    sql: ${TABLE}.sale_price ;;
  }

  measure: total_sale_price {
    view_label: "Orders"
    type: sum
    description: "Total sale price in USD"
    sql: ${sale_price} ;;
  }

  dimension_group: shipped {
    view_label: "Orders"
    type: time
    description: "Timestamp of shipping"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.shipped_at ;;
  }


  dimension: status {
    view_label: "Orders"
    type: string
    description: "Shipping Status"
    sql: ${TABLE}.status ;;
  }

  measure: count {
    hidden: yes
    type: count
    # drill_fields: [distribtution_center_name, first_name, last_name, product_name]
  }
}
