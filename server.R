function(input, output, session) {
    
    # create and update select inputs
    dropdownSelect_server("dropdown_menus")
    
    # obtain all useful data for user input
    data_to_display <- reactive({
        get_data(type = input$`dropdown_menus-type_selection`,
                 name = input$`dropdown_menus-name_selection`)
    })
    
    # create the map
    map_server(id = "map")

    # update data on the map
    observe({
        map_proxy("map-map", data_to_display())
    })
    
    # update infographics
    observe({
        req(data_to_display())
        
        # post information in infobox
        info_server(id = "info_box", 
                    info_data = data_to_display())
        
        # draw a plot
        plot_server("plot", data_to_display())
    })

}