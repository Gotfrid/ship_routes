library(shiny)
library(shiny.semantic)
library(leaflet)
library(dplyr)
library(DBI)
library(sf)
library(echarts4r)

source("R/global_functions.R")

vessel_by_type <- readRDS("data/vessel_by_type.RDS")



myGridTemplate <- grid_template(
    default = list(
        areas = rbind(
            c("title", "title", "title", "title"),
            c("type_selection", "name_selection", "vertical_separation", "blank_space"),
            c("map", "map", "vertical_separation", "info_box"),
            c("map", "map", "vertical_separation","infographic")
        ),
        cols_width = c("320px", "300px", "20px", "320px"),
        rows_height = c("50px", "80px", "210px", "auto")
    )
    # , mobile = list(
    #     areas = rbind(
    #         "title",
    #         "type_selection", 
    #         "name_selection",
    #         "map"
    #     ),
    #     rows_height = c("50px", "80px", "80px", "auto"),
    #     cols_width = c("100%")
    # )
)



# dt = get_db_data("data/DB.db", "select * from ships where SHIPNAME = ?", list("UMAR1"))
# pal <- colorNumeric('viridis', dt$date)
# 
# geo <- dt %>%
#     mutate(date = as.Date(date, origin = "1970-01-01")) %>%
#     st_as_sf(coords = c("LON", "LAT"), crs = 4326)
# 
# geo %>% 
#     group_by(date, DESTINATION) %>%
#     summarise(avg_speed = mean(SPEED, na.rm = TRUE), do_union = FALSE) %>%
#     st_cast("LINESTRING") %>% 
#     nngeo::st_segments(progress = FALSE) %>% 
#     mutate(distance = as.numeric(units::set_units(st_length(.), m))) %>% 
#     # filter(distance < 5000) %>% 
#     leaflet() %>% 
#     addTiles() %>% 
#     addPolylines(color = ~pal(date))
# 
# 
# 
# geo %>% 
#     leaflet() %>% 
#     addTiles() %>% 
#     addCircles(color = ~pal(date))

# geo <- dt %>% 
#     as_tibble() %>% 
#     mutate(date = as.Date(date, origin = "1970-01-01")) %>% 
#     st_as_sf(coords = c("LON", "LAT"), crs = 4326)
# 

# 
# segments <- geo %>% 
#     group_by(date) %>%
#     summarise(avg_speed = mean(SPEED, na.rm = TRUE), do_union = FALSE) %>%
#     st_cast("LINESTRING") %>%
#     nngeo::st_segments(progress = FALSE) %>% 
#     mutate(distance = as.numeric(units::set_units(st_length(.), m)))
# 
# segments %>% 
#     mutate(distance = units::set_units(st_length(.), m)) %>% 
#     filter(distance == max(distance)) %>% 
#     st_cast("POINT") %>% 
#     leaflet() %>% 
#     addTiles() %>% 
#     addMarkers()
