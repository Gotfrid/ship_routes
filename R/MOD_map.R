library(shiny)

map_ui <- function(id) {
  ns <- NS(id)

  card(
    withLoader(
      ui_element = leafletOutput(ns("map"),
                    height = 580,
                    width = 620),
      type =  "html", 
      loader = "loader9"
    ),
    class = "fluid",
    width = 620
  )
}

map_server <- function(id, map_data) {
  moduleServer(
    id = id,
    module = function(input, output, session) {
      output$map <- renderLeaflet({
        leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
          addProviderTiles(providers$CartoDB.Voyager) %>%
          # setView(
          #   lng = 11.75497,
          #   lat = 57.65783,
          #   zoom = 10
          # ) %>%
          addLegend(
            colors = c("#c61123", "#208c6d"),
            opacity = 0.6,
            labels = c("Older", "More recent"),
            title = "Color Legend",
            position = "bottomleft"
          )
      })
    }
  )
}
