map_proxy <- function(id, map_data) {
  req(map_data)

  if (map_data$status == "fail") {
    map <- leafletProxy(id) %>%
      clearMarkers() %>%
      clearShapes() %>%
      clearMarkerClusters()
    return(map)
  }

  # points of start and end of the longest segment
  points <- st_coordinates(map_data$points)

  # route points - resampled for better performance
  df <- as.data.frame(map_data$map_points)
  df_poits <- df %>%
    filter(
      lng %in% points[, "X"],
      lat %in% points[, "Y"]
    )

  if (nrow(df) > 500) {
    df <- df %>%
      sample_n(size = 500, replace = FALSE) %>%
      arrange(datetime) %>%
      bind_rows(df_poits) %>%
      unique()
  }

  # color palette for route points
  pal <- colorNumeric("RdYlGn", df$datetime)

  # small trick for better initial zoom
  points <- points + matrix(c(0, 0, 0.03, -0.03), nrow = 2)

  map <- leafletProxy(id) %>%
    clearMarkers() %>%
    clearShapes() %>%
    clearMarkerClusters() %>%
    addCircleMarkers(
      data = df,
      lng = ~lng,
      lat = ~lat,
      label = ~ as.POSIXct(datetime, origin = "1970-01-01"),
      labelOptions = labelOptions(textsize = "12px"),
      radius = 5,
      color = "#2d2d2d",
      opacity = 0.6,
      fillColor = ~ pal(datetime),
      fillOpacity = 0.3,
      weight = 0.5
    ) %>%
    addMarkers(
      data = map_data$points,
      label = ~label,
      labelOptions = labelOptions(
        noHide = TRUE,
        textsize = "14px",
        textOnly = TRUE,
        direction = "top",
        offset = c(0, -30),
        style = list(
          color = "white",
          `text-shadow` = "1px 1px 2px black, 0 0 25px blue, 0 0 5px darkblue"
        )
      )
    ) %>%
    addPolylines(
      data = map_data$line,
      dashArray = "10 10"
    ) %>%
    fitBounds(
      points[1, 1],
      points[1, 2],
      points[2, 1],
      points[2, 2]
    )

  return(map)
}
