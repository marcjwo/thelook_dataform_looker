view: users {
  sql_table_name: `@{GCP_PROJECT}.@{PRE_DATASET}.users_output_pre` ;;
  view_label: "Users"
  ## Demographics ##

  dimension: id {
    label: "ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    tags: ["user_id"]
  }

  dimension: first_name {
    label: "First Name"
    hidden: yes
    sql: CONCAT(UPPER(SUBSTR(${TABLE}.first_name,1,1)), LOWER(SUBSTR(${TABLE}.first_name,2))) ;;

  }

  dimension: last_name {
    label: "Last Name"
    hidden: yes
    sql: CONCAT(UPPER(SUBSTR(${TABLE}.last_name,1,1)), LOWER(SUBSTR(${TABLE}.last_name,2))) ;;
  }

  dimension: name {
    label: "Name"
    sql: concat(${first_name}, ' ', ${last_name}) ;;
  }

  dimension: age {
    label: "Age"
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: over_21 {
    label: "Over 21"
    type: yesno
    sql:  ${age} > 21;;
  }

  dimension: age_tier {
    label: "Age Tier"
    type: tier
    tiers: [0, 10, 20, 30, 40, 50, 60, 70]
    style: integer
    sql: ${age} ;;
  }

  dimension: gender {
    label: "Gender"
    sql: ${TABLE}.gender ;;
  }

  dimension: gender_short {
    label: "Gender Short"
    sql: LOWER(SUBSTR(${gender},1,1)) ;;
  }

  dimension: user_image {
    label: "User Image"
    sql: ${image_file} ;;
    html: <img src="{{ value }}" width="220" height="220"/>;;
  }

  dimension: email {
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
    label: "City"
    sql: ${TABLE}.city ;;
    drill_fields: [zip]
  }

  dimension: state {
    label: "State"
    sql: ${TABLE}.state ;;
    map_layer_name: us_states
    drill_fields: [zip, city]
  }

  dimension: zip {
    label: "Zip"
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  dimension: uk_postcode {
    label: "UK Postcode"
    sql: case when ${TABLE}.country = 'UK' then regexp_replace(${zip}, '[0-9]', '') else null end;;
    map_layer_name: uk_postcode_areas
    drill_fields: [city, zip]
  }

  dimension: country {
    label: "Country"
    map_layer_name: countries
    drill_fields: [state, city]
    sql: CASE WHEN ${TABLE}.country = 'UK' THEN 'United Kingdom'
           ELSE ${TABLE}.country
           END
       ;;
  }

  dimension: location {
    label: "Location"
    type: location
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
  }

  dimension: approx_latitude {
    label: "Approx Latitude"
    type: number
    sql: round(${TABLE}.latitude,1) ;;
  }

  dimension: approx_longitude {
    label: "Approx Longitude"
    type: number
    sql:round(${TABLE}.longitude,1) ;;
  }

  dimension: approx_location {
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
    label: "Created"
    type: time
#     timeframes: [time, date, week, month, raw]
    sql: ${TABLE}.created_at ;;
  }

  dimension: history {
    label: "History"
    sql: ${TABLE}.id ;;
    html: <a href="/explore/thelook_event/order_items?fields=order_items.detail*&f[users.id]={{ value }}">Order History</a>
      ;;
  }

  dimension: traffic_source {
    label: "Traffic Source"
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: ssn {
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

  set: detail {
    fields: [id, name, email, age, created_date, orders.count, order_items.count]
  }
}

# # If necessary, uncomment the line below to include explore_source.
# # include: "thelook.model.lkml"

# view: first_table {
#   derived_table: {
#     explore_source: order_items {
#       column: order_count {}
#       column: name { field: distribution_centers.name }
#     }
#   }
#   dimension: order_count {
#     label: "Orders Order Count"
#     description: ""
#     type: number
#   }
#   dimension: name {
#     label: "Distribution Center Name"
#     description: ""
#   }
# }


# # The name of this view in Looker is "Users Output Pre"
# view: users_output_pre {
#   # The sql_table_name parameter indicates the underlying database table
#   # to be used for all fields in this view.
#   sql_table_name: `semantics-390012.pre_thelook_output.users_output_pre` ;;
#   drill_fields: [id]

#   # This primary key is the unique key for this table in the underlying database.
#   # You need to define a primary key in a view in order to join to other views.

#   dimension: id {
#     primary_key: yes
#     type: number
#     sql: ${TABLE}.id ;;
#   }
#     # Here's what a typical dimension looks like in LookML.
#     # A dimension is a groupable field that can be used to filter query results.
#     # This dimension will be called "Age" in Explore.

#   dimension: age {
#     type: number
#     sql: ${TABLE}.age ;;
#   }

#   # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
#   # measures for this dimension, but you can also add measures of many different aggregates.
#   # Click on the type parameter to see all the options in the Quick Help panel on the right.

#   measure: total_age {
#     type: sum
#     sql: ${age} ;;  }
#   measure: average_age {
#     type: average
#     sql: ${age} ;;  }

#   dimension: city {
#     type: string
#     sql: ${TABLE}.city ;;
#   }

#   dimension: country {
#     type: string
#     map_layer_name: countries
#     sql: ${TABLE}.country ;;
#   }
#   # Dates and timestamps can be represented in Looker using a dimension group of type: time.
#   # Looker converts dates and timestamps to the specified timeframes within the dimension group.

#   dimension_group: created {
#     type: time
#     timeframes: [raw, time, date, week, month, quarter, year]
#     sql: ${TABLE}.created_at ;;
#   }

#   dimension: email {
#     type: string
#     sql: ${TABLE}.email ;;
#   }

#   dimension: first_name {
#     type: string
#     sql: ${TABLE}.first_name ;;
#   }

#   dimension: gender {
#     type: string
#     sql: ${TABLE}.gender ;;
#   }

#   dimension: last_name {
#     type: string
#     sql: ${TABLE}.last_name ;;
#   }

#   dimension: latitude {
#     type: number
#     sql: ${TABLE}.latitude ;;
#   }

#   dimension: longitude {
#     type: number
#     sql: ${TABLE}.longitude ;;
#   }

#   dimension: postal_code {
#     type: string
#     sql: ${TABLE}.postal_code ;;
#   }

#   dimension: state {
#     type: string
#     sql: ${TABLE}.state ;;
#   }

#   dimension: street_address {
#     type: string
#     sql: ${TABLE}.street_address ;;
#   }

#   dimension: traffic_source {
#     type: string
#     sql: ${TABLE}.traffic_source ;;
#   }
#   measure: count {
#     type: count
#     drill_fields: [id, last_name, first_name]
#   }
# }
