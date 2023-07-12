# The name of this view in Looker is "Distribution Centers Pre"
view: distribution_centers {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `@{GCP_PROJECT}.@{PRE_DATASET}.distribution_centers_pre` ;;
  view_label: "Distribution Centers"
  dimension: location {
    type: location
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
  }

  dimension: latitude {
    label: "Latitude"
    sql: ${TABLE}.latitude ;;
    hidden: yes
  }

  dimension: longitude {
    label: "Longitude"
    sql: ${TABLE}.longitude ;;
    hidden: yes
  }

  dimension: id {
    label: "ID"
    type: number
    primary_key: yes
    sql: ${TABLE}.id ;;
  }

  dimension: name {
    label: "Name"
    sql: ${TABLE}.name ;;
  }
}
