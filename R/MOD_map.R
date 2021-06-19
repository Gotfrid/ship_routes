library(shiny)

map_ui <- function(id) {
    ns <- NS(id)

    card(
        leafletOutput(ns("map"),
                       height = 550,
                       width = 620), 
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
                    setView(lng = 11.75497,
                            lat = 57.65783,
                            zoom = 10)
            })
        }
    )
}
