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

  selection1 <- selectInput(
    inputId = ns("type_selection"),
    label = "Vessel Type",
    choices = type_options,
    selected = "Tanker",
    multiple = FALSE,
    width = "300px"
  )
  selection2 <- selectInput(
    inputId = ns("name_selection"),
    label = "Vessel Name",
    choices = name_options,
    selected = "PALLAS GLORY",
    multiple = FALSE,
    width = "300px"
  )

  grid(
    grid_template = g,
    selection1 = selection1,
    spacer = p(),
    selection2 = selection2
  )
}

dropdownSelect_server <- function(id) {
  moduleServer(
    id = id,
    module = function(input, output, session) {
      name_options <- reactive({
        vessel_by_type[
          vessel_by_type$ship_type == input$type_selection,
          "ship_name"
        ]
      })

      observeEvent(input$type_selection, {
        updateSelectInput(
          session = session,
          inputId = "name_selection",
          choices = name_options()
        )
      })
    }
  )
}
