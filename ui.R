shinyUI(
    semanticPage(
        title = "The Baltic Marine App",
        margin = "50px",
        grid(
            grid_template = myGridTemplate,
            id = "main_grid", 
            title = h1("Marine Vessels of the Baltic Sea"),
            selection = dropdownSelect_ui("dropdown_menus"),
            blank_space = p(),
            vertical_separation = p(),
            map = map_ui('map'),
            info_box = info_ui("info_box"),
            infographic = plot_ui("plot")
        )
    )
)

