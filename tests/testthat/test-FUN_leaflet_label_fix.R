test_that("unix dates are formatted for humans on leaflet legend", {
    unix_datetime = c(1481674147, 1481674148)
    
    pal <- colorNumeric("viridis", c(1481674147:1481674150))
    
    map_original <- leaflet() %>% 
        addLegend(pal = pal,
                  values = unix_datetime,
                  labFormat = myLabelFormat()
        ) %>% 
        as.character() %>% 
        .[1]
    
    map_formatted <- leaflet() %>% 
        addLegend(pal = pal,
                  values = unix_datetime,
                  labFormat = myLabelFormat(dates = TRUE)
        ) %>% 
        as.character() %>% 
        .[1]

    # i had hard time finding the difference, but
    # unformatted dates are actually formatted numbers,
    # so they contain ',', whiles formatted dates are
    # represented purely with numbers
    expect_false(grepl("1481674147", map_original))
    expect_true(grepl("1481674147", map_formatted))

})
