include: "/views/extendable/*.*"

# The name of this view in Looker is "Events Output Flat"
view: events_output_flat {
  view_label: "Events"
  extends: [users_reuseable,products_reuseable]
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `blaa-bi-in-a-box.web_output.events_output_flat` ;;
  drill_fields: [id]

  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    view_label: "Events"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: bounce_created {
    view_label: "Session Bounce Page"
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.bounce_created_at ;;
  }
    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Bounce Event ID" in Explore.

  dimension: bounce_event_id {
    view_label: "Session Bounce Page"
    type: number
    sql: ${TABLE}.bounce_event_id ;;
  }

  dimension: bounce_event_type {
    view_label: "Session Bounce Page"
    type: string
    sql: ${TABLE}.bounce_event_type ;;
  }

  dimension: bounce_funnel_step {
    view_label: "Session Bounce Page"
    type: string
    sql: ${TABLE}.bounce_funnel_step ;;
  }

  dimension: bounce_uri {
    view_label: "Session Bounce Page"
    type: string
    sql: ${TABLE}.bounce_uri ;;
  }

  dimension: bounce_user_id {
    view_label: "Session Bounce Page"
    type: number
    sql: ${TABLE}.bounce_user_id ;;
  }

  dimension: browse_events {
    type: number
    sql: ${TABLE}.browse_events ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_browse_events {
    type: sum
    sql: ${browse_events} ;;  }
  measure: average_browse_events {
    type: average
    sql: ${browse_events} ;;  }

  dimension: browser {
    type: string
    sql: ${TABLE}.browser ;;
  }

  dimension: cart_events {
    type: number
    sql: ${TABLE}.cart_events ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension_group: created_at {
    view_label: "Events"
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  dimension: event_type {
    view_label: "Events"
    type: string
    sql: ${TABLE}.event_type ;;
  }

  dimension: funnel_step {
    view_label: "Events"
    type: string
    sql: ${TABLE}.funnel_step ;;
  }

  dimension: ip {
    type: string
    sql: ${TABLE}.ip_address ;;
  }

  measure: unique_visitors {
    label: "Unique Visitors"
    type: count_distinct
    description: "Uniqueness determined by IP Address and User Login"
    view_label: "Visitors"
    sql: ${ip} ;;
    # drill_fields: [visitors*]
  }

  dimension_group: landing_created {
    view_label: "Session Landing Page"
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.landing_created_at ;;
  }

  dimension: landing_event_id {
    view_label: "Session Landing Page"
    type: number
    sql: ${TABLE}.landing_event_id ;;
  }

  dimension: landing_event_type {
    view_label: "Session Landing Page"
    type: string
    sql: ${TABLE}.landing_event_type ;;
  }

  dimension: landing_funnel_step {
    view_label: "Session Landing Page"
    type: string
    sql: ${TABLE}.landing_funnel_step ;;
  }

  dimension: landing_uri {
    view_label: "Session Landing Page"
    type: string
    sql: ${TABLE}.landing_uri ;;
  }

  dimension: landing_user_id {
    view_label: "Session Landing Page"
    type: number
    sql: ${TABLE}.landing_user_id ;;
  }

  dimension: number_of_events_in_session {
    type: number
    sql: ${TABLE}.number_of_events_in_session ;;
  }

  dimension: is_bounce_session {
    label: "Is Bounce Session"
    type: yesno
    sql: ${number_of_events_in_session} = 1 ;;
  }

  measure: count_bounce_sessions {
    label: "Count Bounce Sessions"
    type: count
    filters: {
      field: is_bounce_session
      value: "Yes"
    }
    # drill_fields: [detail*]
  }

  measure: percent_bounce_sessions {
    label: "Count Bounce Sessions"
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${count_bounce_sessions} / nullif(${count},0) ;;
  }

  dimension: number_of_browse_events_in_session {
    label: "Number of Browse Events in Session"
    type: number
    hidden: yes
    sql: ${TABLE}.browse_events ;;
  }

  dimension: number_of_product_events_in_session {
    label: "Number of Product Events in Session"
    type: number
    hidden: yes
    sql: ${TABLE}.product_events ;;
  }

  dimension: number_of_cart_events_in_session {
    label: "Number of Cart Events in Session"
    type: number
    hidden: yes
    sql: ${TABLE}.cart_events ;;
  }

  dimension: number_of_purchase_events_in_session {
    label: "Number of Purchase Events in Session"
    type: number
    hidden: yes
    sql: ${TABLE}.purchase_events ;;
  }

  dimension: includes_browse {
    label: "Includes Browse"
    type: yesno
    sql: ${number_of_browse_events_in_session} > 0 ;;
  }

  dimension: includes_product {
    label: "Includes Product"
    type: yesno
    sql: ${number_of_product_events_in_session} > 0 ;;
  }

  dimension: includes_cart {
    label: "Includes Cart"
    type: yesno
    sql: ${number_of_cart_events_in_session} > 0 ;;
  }

  dimension: includes_purchase {
    label: "Includes Purchase"
    type: yesno
    sql: ${number_of_purchase_events_in_session} > 0 ;;
  }

  dimension: furthest_funnel_step {
    label: "Furthest Funnel Step"
    sql: CASE
      WHEN ${number_of_purchase_events_in_session} > 0 THEN '(5) Purchase'
      WHEN ${number_of_cart_events_in_session} > 0 THEN '(4) Add to Cart'
      WHEN ${number_of_product_events_in_session} > 0 THEN '(3) View Product'
      WHEN ${number_of_browse_events_in_session} > 0 THEN '(2) Browse'
      ELSE '(1) Land'
      END
       ;;
  }

  measure: all_sessions {
    view_label: "Funnel View"
    label: "(1) All Sessions"
    type: count
    # drill_fields: [detail*]
  }

  measure: count_browse_or_later {
    view_label: "Funnel View"
    label: "(2) Browse or later"
    type: count
    filters: {
      field: furthest_funnel_step
      value: "(2) Browse,(3) View Product,(4) Add to Cart,(5) Purchase"
    }
    # drill_fields: [detail*]
  }

  measure: count_product_or_later {
    view_label: "Funnel View"
    label: "(3) View Product or later"
    type: count
    filters: {
      field: furthest_funnel_step
      value: "(3) View Product,(4) Add to Cart,(5) Purchase"
    }
    # drill_fields: [detail*]
  }

  measure: count_cart_or_later {
    view_label: "Funnel View"
    label: "(4) Add to Cart or later"
    type: count
    filters: {
      field: furthest_funnel_step
      value: "(4) Add to Cart,(5) Purchase"
    }
    # drill_fields: [detail*]
  }

  measure: count_purchase {
    view_label: "Funnel View"
    label: "(5) Purchase"
    type: count
    filters: {
      field: furthest_funnel_step
      value: "(5) Purchase"
    }
    # drill_fields: [detail*]
  }

  measure: cart_to_checkout_conversion {
    view_label: "Funnel View"
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${count_purchase} / nullif(${count_cart_or_later},0) ;;
  }

  measure: overall_conversion {
    view_label: "Funnel View"
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${count_purchase} / nullif(${count},0) ;;
  }

  measure: count_with_cart {
    label: "Count with Cart"
    type: count
    filters: {
      field: includes_cart
      value: "Yes"
    }
    # drill_fields: [detail*]
  }

  measure: count_with_purchase {
    label: "Count with Purchase"
    type: count
    filters: {
      field: includes_purchase
      value: "Yes"
    }
    # drill_fields: [detail*]
  }

  dimension: product_events {
    type: number
    sql: ${TABLE}.product_events ;;
  }

  dimension: purchase_events {
    type: number
    sql: ${TABLE}.purchase_events ;;
  }

  dimension: sequence_number {
    view_label: "Events"
    type: number
    sql: ${TABLE}.sequence_number ;;
  }

  dimension: is_entry_event {
    view_label: "Events"
    label: "Is Entry Event"
    type: yesno
    description: "Yes indicates this was the entry point / landing page of the session"
    sql: ${sequence_number} = 1 ;;
  }

  dimension: is_exit_event {
    view_label: "Events"
    type: yesno
    label: "UTM Source"
    sql: ${sequence_number} = ${number_of_events_in_session} ;;
    description: "Yes indicates this was the exit point / bounce page of the session"
  }

  measure: count_bounces {
    view_label: "Events"
    label: "Count Bounces"
    type: count
    description: "Count of events where those events were the bounce page for the session"

    filters: {
      field: is_exit_event
      value: "Yes"
    }
  }

  measure: bounce_rate {
    view_label: "Events"
    label: "Bounce Rate"
    type: number
    value_format_name: percent_2
    description: "Percent of events where those events were the bounce page for the session, out of all events"
    sql: ${count_bounces}*1.0 / nullif(${count}*1.0,0) ;;
  }

  dimension_group: session_end {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.session_end ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension_group: session_start {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.session_start ;;
  }

  dimension: duration {
    label: "Duration (sec)"
    type: number
    sql: (UNIX_MICROS(${TABLE}.session_end) - UNIX_MICROS(${TABLE}.session_start))/1000000 ;;
  }

  measure: average_duration {
    label: "Average Duration (sec)"
    type: average
    value_format_name: decimal_2
    sql: ${duration} ;;
  }

  dimension: duration_seconds_tier {
    label: "Duration Tier (sec)"
    type: tier
    tiers: [10, 30, 60, 120, 300]
    style: integer
    sql: ${duration} ;;
  }

  dimension: session_user_id {
    type: number
    sql: ${TABLE}.session_user_id ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: full_page_url {
    view_label: "Events"
    type: string
    sql: ${TABLE}.uri ;;
  }

  # dimension: user_id {
  #   view_label: "Events"
  #   type: number
  #   sql: ${TABLE}.user_id ;;
  # }

  dimension: viewed_product_id {
    view_label: "Events"
    type: number
    sql: ${TABLE}.viewed_product_id ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }
  measure: count {
    type: count
    drill_fields: [id]
  }

  measure: sessions_count {
    view_label: "Events"
    label: "Sessions Count"
    type: count_distinct
    sql: ${session_id} ;;
  }

  measure: count_m {
    label: "Count (MM)"
    type: number
    hidden: yes
    sql: ${count}/1000000.0 ;;
    # drill_fields: [simple_page_info*]
    value_format: "#.### \"M\""
  }

  measure: unique_visitors_m {
    label: "Unique Visitors (MM)"
    view_label: "Visitors"
    type: number
    sql: count (distinct ${ip}) / 1000000.0 ;;
    description: "Uniqueness determined by IP Address and User Login"
    value_format: "#.### \"M\""
    hidden: yes
    # drill_fields: [visitors*]
  }

  measure: unique_visitors_k {
    label: "Unique Visitors (k)"
    view_label: "Visitors"
    type: number
    hidden: yes
    description: "Uniqueness determined by IP Address and User Login"
    sql: count (distinct ${ip}) / 1000.0 ;;
    value_format: "#.### \"k\""
    # drill_fields: [visitors*]
  }

  dimension: location {
    label: "Location"
    type: location
    view_label: "Visitors"
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
  }

  dimension: approx_location {
    label: "Approximate Location"
    type: location
    view_label: "Visitors"
    sql_latitude: round(${TABLE}.latitude,1) ;;
    sql_longitude: round(${TABLE}.longitude,1) ;;
  }

  dimension: has_user_id {
    label: "Has User ID"
    type: yesno
    view_label: "Visitors"
    description: "Did the visitor sign in as a website user?"
    sql: ${user_id} > 0 ;;
  }
}
