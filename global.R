library(shiny)
library(shiny.semantic) # beautiful UI
library(shinycustomloader) # animate map on start-up
library(shinybusy) # show spinner for calculations
library(leaflet) # interactive map
library(dplyr) # data manipulations
library(DBI) # connect to local database
library(RSQLite) # SQLite driver
library(sf) # basic GIS operations
library(nngeo) # helper functions to segmentize linestring
library(echarts4r) # interactive viz

# prepare initial select options
vessel_by_type <- readRDS("data/vessel_by_type.RDS")
type_options <- unique(vessel_by_type$ship_type)
name_options <- vessel_by_type[vessel_by_type$type == "Tanker", "ship_name"]

# page grid
myGridTemplate <- grid_template(
  default = list(
    areas = rbind(
      c("title", "title", "title", "title"),
      c("selection", "selection", "vertical_separation", "blank_space"),
      c("map", "map", "vertical_separation", "info_box"),
      c("map", "map", "vertical_separation", "infographic")
    ),
    cols_width = c("320px", "300px", "20px", "320px"),
    rows_height = c("50px", "80px", "210px", "auto")
  )
)
