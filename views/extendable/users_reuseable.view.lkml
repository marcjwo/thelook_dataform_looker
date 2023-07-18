view: users_reuseable {
  view_label: "Users"
  extension: required

  dimension: user_id {
    view_label: "Users"
    label: "ID"
    # primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
    # tags: ["user_id"]
  }

  dimension: first_name {
    view_label: "Users"
    label: "First Name"
    hidden: yes
    sql: CONCAT(UPPER(SUBSTR(${TABLE}.first_name,1,1)), LOWER(SUBSTR(${TABLE}.first_name,2))) ;;

  }

  dimension: last_name {
    view_label: "Users"
    label: "Last Name"
    hidden: yes
    sql: CONCAT(UPPER(SUBSTR(${TABLE}.last_name,1,1)), LOWER(SUBSTR(${TABLE}.last_name,2))) ;;
  }

  dimension: name {
    view_label: "Users"
    label: "Name"
    sql: concat(${first_name}, ' ', ${last_name}) ;;
  }

  dimension: age {
    view_label: "Users"
    label: "Age"
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: over_21 {
    view_label: "Users"
    label: "Over 21"
    type: yesno
    sql:  ${age} > 21;;
  }

  dimension: age_tier {
    view_label: "Users"
    label: "Age Tier"
    type: tier
    tiers: [0, 10, 20, 30, 40, 50, 60, 70]
    style: integer
    sql: ${age} ;;
  }

  dimension: gender {
    view_label: "Users"
    label: "Gender"
    sql: ${TABLE}.gender ;;
  }

  dimension: gender_short {
    view_label: "Users"
    label: "Gender Short"
    sql: LOWER(SUBSTR(${gender},1,1)) ;;
  }

  dimension: user_image {
    view_label: "Users"
    label: "User Image"
    sql: ${image_file} ;;
    html: <img src="{{ value }}" width="220" height="220"/>;;
  }

  dimension: email {
    view_label: "Users"
    label: "Email"
    sql: ${TABLE}.email ;;
    tags: ["email"]

    link: {
      label: "User Lookup Dashboard"
      url: "/dashboards-next/ayalascustomerlookupdb?Email={{ value | encode_uri }}"
      icon_url: "https://cdn.icon-icons.com/icons2/2248/PNG/512/monitor_dashboard_icon_136391.png"
    }
    action: {
      label: "Email Promotion to Customer"
      url: "https://desolate-refuge-53336.herokuapp.com/posts"
      icon_url: "https://sendgrid.com/favicon.ico"
      param: {
        name: "some_auth_code"
        value: "abc123456"
      }
      form_param: {
        name: "Subject"
        required: yes
        default: "Thank you {{ users.name._value }}"
      }
      form_param: {
        name: "Body"
        type: textarea
        required: yes
        default:
        "Dear {{ users.first_name._value }},

        Thanks for your loyalty to the Look.  We'd like to offer you a 10% discount
        on your next purchase!  Just use the code LOYAL when checking out!

        Your friends at the Look"
      }
    }
    required_fields: [name, first_name]
  }

  dimension: image_file {
    label: "Image File"
    hidden: yes
    sql: concat('https://docs.looker.com/assets/images/',${gender_short},'.jpg') ;;
  }

  ## Demographics ##

  dimension: city {
    view_label: "Users"
    label: "City"
    sql: ${TABLE}.city ;;
    drill_fields: [zip]
  }

  dimension: state {
    view_label: "Users"
    label: "State"
    sql: ${TABLE}.state ;;
    map_layer_name: us_states
    drill_fields: [zip, city]
  }

  dimension: zip {
    view_label: "Users"
    label: "Zip"
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  dimension: uk_postcode {
    view_label: "Users"
    label: "UK Postcode"
    sql: case when ${TABLE}.country = 'UK' then regexp_replace(${zip}, '[0-9]', '') else null end;;
    map_layer_name: uk_postcode_areas
    drill_fields: [city, zip]
  }

  dimension: country {
    view_label: "Users"
    label: "Country"
    map_layer_name: countries
    drill_fields: [state, city]
    sql: CASE WHEN ${TABLE}.country = 'UK' THEN 'United Kingdom'
           ELSE ${TABLE}.country
           END
       ;;
  }

  dimension: location {
    view_label: "Users"
    label: "Location"
    type: location
    sql_latitude: ${TABLE}.user_latitude ;;
    sql_longitude: ${TABLE}.user_longitude ;;
  }

  dimension: approx_latitude {
    view_label: "Users"
    label: "Approx Latitude"
    type: number
    sql: round(${TABLE}.user_latitude,1) ;;
  }

  dimension: approx_longitude {
    view_label: "Users"
    label: "Approx Longitude"
    type: number
    sql:round(${TABLE}.user_longitude,1) ;;
  }

  dimension: approx_location {
    view_label: "Users"
    label: "Approx Location"
    type: location
    drill_fields: [location]
    sql_latitude: ${approx_latitude} ;;
    sql_longitude: ${approx_longitude} ;;
    link: {
      label: "Google Directions from {{ distribution_centers.name._value }}"
      url: "{% if distribution_centers.location._in_query %}https://www.google.com/maps/dir/'{{ distribution_centers.latitude._value }},{{ distribution_centers.longitude._value }}'/'{{ approx_latitude._value }},{{ approx_longitude._value }}'{% endif %}"
      icon_url: "http://www.google.com/s2/favicons?domain=www.google.com"
    }

  }

  ## Other User Information ##

  dimension_group: created {
    view_label: "Users"
    label: "Created"
    type: time
#     timeframes: [time, date, week, month, raw]
    sql: ${TABLE}.user_created_at ;;
  }

  dimension: history {
    view_label: "Users"
    label: "History"
    sql: ${TABLE}.user_id ;;
    html: <a href="/explore/thelook_event/order_items?fields=order_items.detail*&f[users.id]={{ value }}">Order History</a>
      ;;
  }

  dimension: traffic_source {
    view_label: "Users"
    label: "Traffic Source"
    sql: ${TABLE}.user_traffic_source ;;
  }

  dimension: ssn {
    view_label: "Users"
    label: "SSN"
    # dummy field used in next dim, generate 4 random numbers to be the last 4 digits
    hidden: yes
    type: string
    sql: CONCAT(CAST(FLOOR(10*RAND()) AS INT64),CAST(FLOOR(10*RAND()) AS INT64),
      CAST(FLOOR(10*RAND()) AS INT64),CAST(FLOOR(10*RAND()) AS INT64));;
  }

  # dimension: ssn_last_4 {
  #   label: "SSN Last 4"
  #   description: "Only users with sufficient permissions will see this data"
  #   type: string
  #   sql: CASE WHEN '{{_user_attributes["can_see_sensitive_data"]}}' = 'Yes'
  #               THEN ${ssn}
  #               ELSE '####' END;;
  # }

  ## MEASURES ##

  measure: count {
    label: "Count"
    type: count
    drill_fields: [detail*]
  }

  measure: count_percent_of_total {
    label: "Count (Percent of Total)"
    type: percent_of_total
    sql: ${count} ;;
    drill_fields: [detail*]
  }

  measure: average_age {
    label: "Average Age"
    type: average
    value_format_name: decimal_2
    sql: ${age} ;;
    drill_fields: [detail*]
  }

  # set: detail {
  #   fields: [id, name, email, age, created_date, orders.count, order_items.count]
  # }

  ############

  dimension_group: first_order {
    view_label: "Users"
    label: "First Order"
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: latest_order {
    view_label: "Users"
    label: "Latest Orders"
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.latest_order ;;
  }


  dimension: days_as_customer {
    view_label: "Users"
    label: "Days As Customer"
    description: "Days between first and latest order"
    type: number
    sql: TIMESTAMP_DIFF(${TABLE}.latest_order, ${TABLE}.first_order, DAY)+1 ;;
  }

  dimension: days_as_customer_tiered {
    view_label: "Users"
    label: "Days as Customer Tiered"
    type: tier
    tiers: [0, 1, 7, 14, 21, 28, 30, 60, 90, 120]
    sql: ${days_as_customer} ;;
    style: integer
  }

  ##### Lifetime Behavior - Order Counts ######

  dimension: lifetime_orders {
    view_label: "Users"
    label: "Lifetime Orders"
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: repeat_customer {
    view_label: "Users"
    label: "Repeat Customer"
    description: "Lifetime Count of Orders > 1"
    type: yesno
    sql: ${lifetime_orders} > 1 ;;
  }

  dimension: lifetime_orders_tier {
    view_label: "Users"
    label: "Lifetime Orders Tier"
    type: tier
    tiers: [0, 1, 2, 3, 5, 10]
    sql: ${lifetime_orders} ;;
    style: integer
  }

  measure: average_lifetime_orders {
    view_label: "Users"
    label: "Average Lifetime Orders"
    type: average
    value_format_name: decimal_2
    sql: ${lifetime_orders} ;;
  }

  dimension: distinct_months_with_orders {
    view_label: "Users"
    label: "Distinct Months with Orders"
    type: number
    sql: ${TABLE}.number_of_distinct_months_with_orders ;;
  }

  ##### Lifetime Behavior - Revenue ######

  dimension: lifetime_revenue {
    view_label: "Users"
    label: "Lifetime Revenue"
    type: number
    value_format_name: usd
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension: lifetime_revenue_tier {
    view_label: "Users"
    label: "Lifetime Reveneue Tier"
    type: tier
    tiers: [0, 25, 50, 100, 200, 500, 1000]
    sql: ${lifetime_revenue} ;;
    style: integer
  }

  measure: average_lifetime_revenue {
    view_label: "Users"
    label: "Average Lifetime Margin"
    type: average
    value_format_name: usd
    sql: ${lifetime_revenue} ;;
  }

}
