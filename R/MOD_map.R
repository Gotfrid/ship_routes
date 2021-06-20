library(shiny)

map_ui <- function(id) {
  ns <- NS(id)

  card(
    withLoader(
      ui_element = leafletOutput(ns("map"),
        height = 580,
        width = "100%"
      ),
      type = "html",
      loader = "loader9"
    ),
    class = "fluid"
  )
}

map_server <- function(id, map_data) {
  moduleServer(
    id = id,
    module = function(input, output, session) {
      output$map <- renderLeaflet({
        leaflet(options = leafletOptions(zoomControl = TRUE)) %>%
          addProviderTiles(providers$CartoDB.Voyager) %>%
          addLegend(
            colors = c("#c61123", "#208c6d"),
            opacity = 0.6,
            labels = c("Older", "Newer"),
            title = "Date",
            position = "bottomright"
          )
      })
    }
  )
}
