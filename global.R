library(shiny)
library(shiny.semantic)
library(leaflet)
library(dplyr)
library(DBI)
library(sf)
library(echarts4r)

vessel_by_type <- readRDS("data/vessel_by_type.RDS")
type_options <- unique(vessel_by_type$ship_type)

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
