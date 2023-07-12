# The name of this view in Looker is "Order Items Output Post"
view: order_items_output_post {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `@{GCP_PROJECT}.@{POST_DATASET}.order_items_output_post` ;;

  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Age" in Explore.

  dimension: age {
    view_label: "User"
    type: number
    description: "User age"
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    view_label: "User"
    type: string
    description: "City"
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    view_label: "User"
    type: string
    description: "Country"
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }
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

  dimension: email {
    view_label: "User"
    type: string
    description: "Email address"
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    view_label: "User"
    type: string
    description: "User first name"
    sql: ${TABLE}.first_name ;;
  }

  dimension_group: first_order {
    view_label: "User"
    type: time
    description: "Date of first user order"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.first_order ;;
  }

  dimension: gender {
    view_label: "User"
    type: string
    description: "User gender"
    sql: ${TABLE}.gender ;;
  }

  dimension: is_first_purchase {
    view_label: "Orders"
    type: yesno
    description: "Is order first purchase in BOOL"
    sql: ${TABLE}.is_first_purchase ;;
  }

  dimension: last_name {
    view_label: "User"
    type: string
    description: "User last name"
    sql: ${TABLE}.last_name ;;
  }

  dimension_group: latest_order {
    view_label: "User"
    type: time
    description: "Date of last user order"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.latest_order ;;
  }

  dimension: lifetime_orders {
    view_label: "User"
    type: number
    description: "Number of lifetime orders"
    sql: ${TABLE}.lifetime_orders ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_lifetime_orders {
    view_label: "User"
    type: sum
    sql: ${lifetime_orders} ;;  }

  # measure: average_lifetime_orders {
  #   type: average
  #   sql: ${lifetime_orders} ;;  }

  dimension: lifetime_revenue {
    view_label: "User"
    type: number
    description: "Amount of lifetime user revenue in USD"
    sql: ${TABLE}.lifetime_revenue ;;
  }
  measure: total_lifetime_revenue {
    view_label: "User"
    type: sum
    value_format_name: usd
    description: "Total amount of lifetime user revenue in USD"
    sql: ${lifetime_revenue} ;;
  }

  dimension: number_of_distinct_months_with_orders {
    view_label: "User"
    type: number
    description: "Number of distinct months with an order"
    sql: ${TABLE}.number_of_distinct_months_with_orders ;;
  }

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

  dimension: postal_code {
    view_label: "User"
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: product_brand {
    view_label: "Products"
    type: string
    description: "Product Brand"
    sql: ${TABLE}.product_brand ;;
  }

  dimension: product_category {
    view_label: "Products"
    type: string
    description: "Product Category"
    sql: ${TABLE}.product_category ;;
  }

  dimension: product_department {
    view_label: "Products"
    type: string
    description: "Product department"
    sql: ${TABLE}.product_department ;;
  }

  dimension: product_id {
    view_label: "Products"
    type: number
    description: "Product ID"
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    view_label: "Products"
    type: string
    description: "Name of the product"
    sql: ${TABLE}.product_name ;;
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

  dimension: state {
    view_label: "User"
    type: string
    description: "State"
    sql: ${TABLE}.state ;;
  }

  dimension: status {
    view_label: "Orders"
    type: string
    description: "Shipping Status"
    sql: ${TABLE}.status ;;
  }

  dimension: street_address {
    view_label: "User"
    type: string
    description: "Street address"
    sql: ${TABLE}.street_address ;;
  }

  dimension: traffic_source {
    view_label: "User"
    type: string
    description: "User traffic source"
    sql: ${TABLE}.traffic_source ;;
  }

  dimension_group: user_created {
    view_label: "User"
    type: time
    description: "Timestampe the user was created"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.user_created_at ;;
  }

  dimension: user_id {
    view_label: "User"
    type: number
    description: "User ID"
    sql: ${TABLE}.user_id ;;
  }

  dimension: user_latitude {
    view_label: "User"
    type: number
    description: "User latitude"
    sql: ${TABLE}.user_latitude ;;
  }

  dimension: user_longitude {
    view_label: "User"
    type: number
    description: "User longitude"
    sql: ${TABLE}.user_longitude ;;
  }
  measure: count {
    hidden: yes
    type: count
    drill_fields: [distribtution_center_name, first_name, last_name, product_name]
  }
}
