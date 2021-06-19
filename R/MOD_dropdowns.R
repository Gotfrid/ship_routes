library(shiny)

dropdownSelect_ui <- function(id) {
    ns <- NS(id)
    
    g <- grid_template(
        default = list(
            areas = rbind(
                c("selection1", "spacer", "selection2")
            ),
            cols_width = c("300px", "20px", "300px"),
            rows_height = c("80px")
        )
    )
    
    grid(
        grid_template = g,
        selection1 = selectInput(
            inputId = ns("type_selection"),
            label = "Ship Type",
            choices = type_options,
            multiple = FALSE,
            width = "300px"
        ),
        spacer = p(),
        selection2 = selectInput(
            inputId = ns("name_selection"),
            label = "Ship Name",
            choices = "",
            multiple = FALSE,
            width = "300px"
        )
    )

}

dropdownSelect_server <- function(id) {
    moduleServer(
        id = id,
        module = function(input, output, session) {
            local_reactive_values <- reactiveValues()
            
            observeEvent(input$type_selection, {
                input$type_selection
                local_reactive_values$type_selection <- input$type_selection
                local_reactive_values$name_selection <- input$name_selection
                # print(type_selection)

                name_options <- vessel_by_type %>%
                    filter(ship_type == input$type_selection) %>%
                    pull(ship_name)
                updateSelectInput(
                        session = session,
                        inputId = "name_selection",
                        choices = name_options)

            })
            
            return(local_reactive_values)
        }
    )
}