shinyUI(
    semanticPage(
        title = "Marine App",
        margin = "50px",
        
        grid(
            grid_template = myGridTemplate,
            id = "main_grid", 
            title = h1("Marine Dashboard"),
            type_selection = selectInput(inputId = "ship_type_input",
                                         label = "Ship Type",
                                         choices = unique(vessel_by_type$ship_type),
                                         multiple = FALSE,
                                         width = "300px"),
            name_selection = selectInput(inputId = "ship_name_input",
                                         label = "Ship Name",
                                         choices = c(""),
                                         multiple = FALSE,
                                         width = "300px"),
            
            blank_space = p(),
            vertical_separation = p(),
            map = card(leafletOutput("map",
                                height = 550,
                                width = 620), 
                       class = "fluid",
                       width = 620),
            info_box = uiOutput("info_box"),
            infographic = echarts4r::echarts4rOutput("plot")
        )
    )
)

