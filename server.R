function(input, output, session) {

  # start tutorial
  guide$init()$start()

  observeEvent(input$help, {
    guide$init()$start()
  })

  # init reactive values
  rv <- reactiveValues()

  # create and update select inputs
  dropdownSelect_server("dropdown_menus")

  # obtain all useful data for user input
  observeEvent(input$`dropdown_menus-name_selection`, {
    rv$data_to_display <- get_data(
      type = input$`dropdown_menus-type_selection`,
      name = input$`dropdown_menus-name_selection`
    )
  })

  # create the map
  map_server(id = "map")

  # update data on the map: i was not sure that the map is not recreated everytime
  # so i moved proxy to separate function
  observe({
    map_proxy("map-map", rv$data_to_display)
  })

  # update infographics
  observe({
    req(rv$data_to_display)

    # post information in infobox
    info_server(
      id = "info_box",
      info_data = rv$data_to_display
    )

    # draw a plot
    plot_server("plot", rv$data_to_display)
  })
}
