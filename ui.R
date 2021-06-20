shinyUI(
  semanticPage(
    includeCSS("www/style.css"),
    use_cicerone(),
    add_busy_spinner(
      spin = "fading-circle",
      position = "bottom-right",
      color = "steelblue"
    ),
    title = "Ship Routes App",
    margin = "0px 30px 0px 30px",
    grid(
      grid_template = myGridTemplate,
      id = "main_grid",
      title = h1(
        "Ship Routes",
        icon("ship"),
        style = "padding: 30px 0;"
      ),
      selection = dropdownSelect_ui("dropdown_menus"),

      help = div(
        class = "content",
        style = "float: right; padding: 30px 0px 0px 0px;",
        actionButton("help", "Tutorial")
      ),
      map = map_ui("map"),
      info_box = info_ui("info_box"),
      infographic = card(
        class = "ui raised",
        div(
          class = "content",
          div(
            class = "header",
            "Coordinates Distribution"
          ),
          div(
            class = "meta",
            "by days"
          ),
          plot_ui("plot")
        )
      ),
      blank_space = p(),
      vertical_separation = p()
    )
  )
)
