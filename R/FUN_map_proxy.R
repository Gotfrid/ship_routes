map_proxy <- function(id, map_data) {
  req(map_data)

  if (map_data$status == "fail") {
    map <- leafletProxy(id) %>%
      clearMarkers() %>%
      clearShapes() %>%
      clearMarkerClusters()
    return(map)
  }

  # decide, if there are too many points to display
  if (length(map_data$map_points$lng) > 150) {
    cluster_disable_zoom <- 15
  } else {
    cluster_disable_zoom <- 1
  }

  # points of start and end of the longest segment
  points <- st_coordinates(map_data$points)
  points <- points + matrix(c(0, 0, 0.03, -0.03), nrow = 2)

  pal <- colorNumeric("RdYlGn", map_data$map_points$datetime)

  map <- leafletProxy(id) %>%
    clearMarkers() %>%
    clearShapes() %>%
    clearMarkerClusters() %>%
    addCircleMarkers(
      data = map_data$map_points,
      lng = ~lng,
      lat = ~lat,
      radius = 5,
      color = "#2d2d2d",
      opacity = 0.6,
      fillColor = ~ pal(datetime),
      fillOpacity = 0.3,
      weight = 0.5,
      clusterOptions = markerClusterOptions(
        disableClusteringAtZoom = cluster_disable_zoom,
        spiderfyOnMaxZoom = FALSE,
        removeOutsideVisibleBounds = TRUE,
        maxClusterRadius = 1,
        singleMarkerMode = FALSE
      )
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
