map_proxy <- function(id, map_data) {
    req(map_data)

    if (map_data$status == "fail") {
        map <- leafletProxy(id) %>%
            clearMarkers() %>%
            clearShapes()
        return(map)
    }
    
    points <- st_coordinates(map_data$points)
    points <- points + matrix(c(0,  0, 0.03, -0.03), nrow = 2)

    map <- leafletProxy(id) %>%
        clearMarkers() %>%
        clearShapes() %>%
        addMarkers(data = map_data$points,
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
        addPolylines(data = map_data$line,
                     dashArray = "10 10") %>%
        fitBounds(points[1,1],
                  points[1,2],
                  points[2,1],
                  points[2,2])
    
    return(map)
}