setwd("../../")

test_that("data file exists", {
    
    files <- list.files("data")
    
    # expect initial data to be present
    expect_true("ships.csv" %in% files)
    
    # expect prepared data to be present
    expect_true("DB.db" %in% files)
})

test_that("DB has expected columns", {
    
    con <- dbConnect(RSQLite::SQLite(), "data/DB.db")
    fields <- dbListFields(con, "ships")
    dbDisconnect(con)
    
    # Port is intentionally changed to port_unicode
    # other columns changed to lower - this is known beh.
    expected_fields <- c("LAT", "LON", "SPEED", "COURSE", "HEADING",
                         "DESTINATION", "FLAG", "LENGTH", "SHIPNAME",
                         "SHIPTYPE", "SHIP_ID", "WIDTH", "DWT", 
                         "DATETIME", "PORT", "date", "week_nb", 
                         "ship_type", "port_unicode", "is_parked")
    expect_equal(fields, expected_fields)
})
