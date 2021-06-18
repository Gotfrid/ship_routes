function(input, output, session) {
    
    # instantiate reactive values
    # rv <- reactiveValues(
    #     type_selected = NULL,
    #     name_selected = NULL
    # )
        
    data_to_display <- reactive({
        # input$ship_name_input
        # input$ship_type_input
        
        if (is.null(input$ship_name_input) || 
            is.null(input$ship_type_input) ||
            input$ship_name_input == "" ||
            input$ship_type_input == "") return()
        
        s <- get_db_data(
            db_path = "data/DB.db",
            sql = "select * from ships where ship_type = ? and SHIPNAME = ?",
            variables = list(input$ship_type_input, input$ship_name_input)
        )
        
        # TODO show message of error
        if (nrow(s) < 2) {
            leafletProxy("map") %>% 
                clearMarkers() %>% 
                clearShapes() 
            return()
        }
        
        geo <- s %>%
            mutate(date = as.Date(date, origin = "1970-01-01")) %>%
            st_as_sf(coords = c("LON", "LAT"), crs = 4326)

        lines <- geo %>% 
            group_by(date) %>%
            summarise(avg_speed = mean(SPEED, na.rm = TRUE), do_union = FALSE) %>%
            st_cast("LINESTRING") %>%
            # make sure only true lines stay
            filter(as.numeric(st_length(geometry)) > 0)
        
        if(!nrow(lines)) return()
        
        segments <- lines %>% 
            nngeo::st_segments(progress = FALSE) %>% 
            mutate(distance = as.numeric(units::set_units(st_length(.), m))) 
        
        longest_segment <- segments %>% 
            # there are problems in data: great distance in same day
            filter(distance < 10000) %>% 
            filter(distance == max(distance)) %>% 
            # data is pre-sorted by datetime
            tail(n = 1)
        
        points <- suppressWarnings(st_cast(longest_segment, "POINT"))
        points$label <- c("Start", "End")
        
        max_segment_datetime <- s %>% 
            filter(LON == st_coordinates(points)[2,1] &
                   LAT == st_coordinates(points)[2,2]) %>% 
            pull(DATETIME) %>% 
            max(na.rm = TRUE)
        
        total_distance <- sum(segments$distance)
        
        # browser()
        return(list(line = longest_segment,
                    points = points,
                    total_distance = total_distance,
                    ship_id = s$SHIP_ID[1],
                    width = s$WIDTH[1],
                    length = s$LENGTH[1],
                    weight = s$DWT[1],
                    flag = s$FLAG[1],
                    max_segment_datetime = max_segment_datetime,
                    plot_data = list(datetime = s$DATETIME,
                                     speed = s$SPEED,
                                     course = s$COURSE)))
        
    })
    
    # create the map
    output$map <- renderLeaflet({
        leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
            addProviderTiles(providers$CartoDB.Voyager) %>% 
            setView(lng = 11.75497,
                    lat = 57.65783,
                    zoom = 10)
    })
    
    observe({
        req(data_to_display())
    
        points <- st_coordinates(data_to_display()$points)
        
        # little trick to overcome situations, when marker out of map
        # it makes map zoom out a little: e.g. Tanker Patricia Essberger
        points <- points + matrix(c(0,  0, 0.03, -0.03), nrow = 2)
        
        # update the map
        leafletProxy("map") %>% 
            clearMarkers() %>% 
            clearShapes() %>% 
            addMarkers(data = data_to_display()$points,
                       label = ~label,
                       labelOptions = labelOptions(
                           noHide = TRUE, 
                           textsize = "14px",
                           textOnly = TRUE,
                           direction = "top",
                           offset = c(0, -30),
                           style = list(
                               color = "white",
                               `text-shadow` = "1px 1px 2px black, 0 0 25px blue, 0 0 5px darkblue"
                           )
                        )
            ) %>%
            addPolylines(data = data_to_display()$line,
                         dashArray = "10 10") %>%
            fitBounds(points[1,1],
                      points[1,2],
                      points[2,1],
                      points[2,2])
    })
    
    
    # update infobox
    output$info_box <- renderUI({
        if (is.null(data_to_display())) {
            ui_element <- card(div(
                class = "content",
                div(class = "header", "Sorry!"),
                div(class = "meta", "Not enough information found"),
                div(class = "description", 
                    HTML(
                        "Please, try visiting this page later, ",
                        "when we aquire more info on this vessel.<br><br>",
                        "Thank you!"
                        
                    )
                )
            ))
            return(ui_element)
        }
        total_distance <- data_to_display()$total_distance
        total_distance <- format(round(total_distance, 1), big.mark = " ")
        
        longest_segment <- data_to_display()$line$distance
        longest_segment <- format(round(longest_segment, 1), big.mark = " ")
        
        weight <- data_to_display()$weight
        weight <- format(weight, big.mark = " ")
        
        length <- data_to_display()$length
        width <- data_to_display()$width
        
        ship_id <- data_to_display()$ship_id
        
        flag <- data_to_display()$flag
        flag <- tolower(flag)
        
        flag_icon <- tags$img(
            src = paste0(
                "https://raw.githubusercontent.com/lipis/flag-icon-css/master/flags/1x1/",
                flag,
                ".svg"
            ),
            alt = flag,
            width = '25px',
            height = '25px',
            style = "border: 1px solid gray;"
        )
        flag_icon <- as.character(flag_icon)
        
        card(class = "fluid", div(
            class = "content",
            div(class = "header", 
                HTML(#flag_icon,
                     input$ship_name_input, 
                     "<small><small>ID:", ship_id, "</small></small>")
            ),
            div(class = "meta", 
                HTML(flag_icon),
                input$ship_type_input
            ),
            div(class = "description", 
                HTML(
                    "Total Distance Travelled: <strong>", total_distance, "</strong>m</br>",
                    "Longest Segment: <strong>", longest_segment, "</strong>m</br>",
                    "<hr>",
                    "Dead Weight: ", weight, "kg</br>",
                    "Length: ", length, "m</br>",
                    "Width: ", width, "m</br>",
                )
            )
        ))
        
        # HTML(
        #     paste0("Total Distance Travelled: ", total_distance,"m<br>",
        #            "Longest Consecutive Segment: ", longest_segment, "m")
        # )
    })
    
    
    
    
    output$plot <- renderEcharts4r({
        req(data_to_display())
        # browser()
        
        max_segment_datetime <- data_to_display()$max_segment_datetime
        max_segment_datetime <- as.POSIXct(max_segment_datetime, origin = "1970-01-01")
        
        data_to_display()$plot_data %>% 
            as.data.frame() %>% 
            mutate(datetime = as.POSIXct(datetime, origin = "1970-01-01")) %>%
            e_chart(datetime) %>% 
            e_line(speed, 
                   symbol = 'none',
                   connectNulls = 'false') %>% 
            e_mark_line(data = list(name = "MAX", xAxis = max_segment_datetime),
                        silent = TRUE,
                        symbol = 'circle',
                        lineStyle = list(color = 'indianred'),
                        label = list(formatter = "Longest Segment\noccured here"),
                        animationDelay = 1000) %>% 
            e_tooltip(trigger = "axis") %>% 
            e_legend(show = F) %>% 
            e_y_axis(name = "Speed, knots",
                     nameLocation = "center",
                     nameGap = 30) %>% 
            e_x_axis(type = "time",
                     name = "DateTime",
                     nameLocation = "center",
                     nameGap = 30) %>% 
            e_grid(left = 50,
                   right = 50,
                   top = 30)
    })
    
    observe({
        input$ship_type_input
        if (!is.null(input$ship_type_input)) {
            vessels <- vessel_by_type %>% 
                filter(ship_type %in% input$ship_type_input) %>% 
                pull(ship_name)
        }

        updateSelectInput(session = session,
                          inputId = "ship_name_input",
                          # label = "ASD",
                          choices = vessels)
        
    })
}