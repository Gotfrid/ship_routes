library(cicerone)
library(magrittr)

guide <- Cicerone %$%
  new(allow_close = FALSE) %$%
  step(
    el = "main_grid-title",
    title = "Welcome!",
    description = "This is a vessel tracking application that uses
       data from the Automatic Identification System (AIS).",
    class = "startup_tutorial"
  ) %$%
  step(
    el = "dropdown_menus-type_selection",
    title = "Vessel Type",
    description = "Here you select a vessel type 
    that you want to choose from."
  ) %$%
  step(
    el = "dropdown_menus-name_selection",
    title = "Vessel Name",
    description = "To discover route and info of a specific vessel,
    choose its name from the list."
  ) %$%
  step(
    el = "map-map",
    title = "Map",
    description = "There are multiple elements displayed.
    <li>
      Circle markers of green and red color are the coordinates
      transmitted on the AIS signal.
    </li>
    <li>
      Color palette goes from red through yellow to green, 
      where red represents older coordinates, 
      green - more recent ones.
    </li> 
    <li>
      The two pins \"Start\" and \"End\"
      are the <strong>most important </strong> elements here. 
      They represent the longest segment 
      between two consecutive coordinates.
    </li>
    <small>
      NB! If there is more than 500 coordinates available,
      a random sample of size 500 is taken to ensure stable performance.
    </small>",
    position = "mid-center"
  ) %$%
  step(
    el = "main_grid-info_box",
    title = "Vessel information",
    description = "Here is the information on a vessel's route
    and the vessel itself.",
    position = "left-center"
  ) %$%
  step(
    el = "main_grid-infographic",
    title = "Infographics",
    description = "This bar plot of daily data distribution
    will give you additional understanding of the route.",
    position = "left-center"
  )
