
get_data <- function(type, name) {
    # startup check
    if (is.null(name) || is.null(type) || name == "" || type == "") {
        return()
    }
    
    # this is a workaround, when type is changed, but the name is still from old type
    # and DB gets an apriori wrong query 
    applicable_names <- vessel_by_type %>%
        filter(ship_type == type) %>%
        pull(ship_name)

    if (!name %in% applicable_names) {
        return()
    }
    
    # get the data from local DB
    s <- get_db_data(
            db_path = "data/DB.db",
            sql = "select * from ships where ship_type = ? and SHIPNAME = ?",
            variables = list(type, name)
    )
    
    if (nrow(s) < 2) {
        return(list(status = "fail"))
    }
    
    geo <- s %>%
        mutate(date = as.Date(date, origin = "1970-01-01")) %>%
        st_as_sf(coords = c("LON", "LAT"), crs = 4326)
    
    lines <- geo %>% 
        # group_by(date) %>%
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
        # data is pre-sorted by datetime, so i pick the last element
        tail(n = 1)
    
    points <- suppressWarnings(st_cast(longest_segment, "POINT"))
    points$label <- c("Start", "End")
    
    max_segment_datetime <- s %>% 
        filter(LON == st_coordinates(points)[2,1] &
                   LAT == st_coordinates(points)[2,2]) %>% 
        pull(DATETIME) %>% 
        max(na.rm = TRUE)
    
    total_distance <- sum(segments$distance)
    
    return(
        list(
            type = type,
            name = name,
            line = longest_segment,
            points = points,
            total_distance = total_distance,
            total_obs = nrow(geo),
            ship_id = s$SHIP_ID[1],
            width = s$WIDTH[1],
            length = s$LENGTH[1],
            weight = s$DWT[1],
            flag = s$FLAG[1],
            max_segment_datetime = max_segment_datetime,
            plot_data = list(
                datetime = s$DATETIME,
                speed = s$SPEED,
                course = s$COURSE
            ),
            map_points = list(
                lng = s$LON,
                lat = s$LAT,
                datetime = s$DATETIME
            ),
            status = "ok"
        )
    )
    
}
