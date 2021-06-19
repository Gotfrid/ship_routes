setwd("../../")

test_that("data is queried correctly from local db", {
    
    db_path <- "data/DB.db"
    sql_statement <- "select * from ships where ship_type = ? and SHIPNAME = ? limit 5"
    variables <- c("Cargo", "KONYA")
    
    df <- get_db_data(db_path, sql_statement, variables)
    
    # correct dimensions
    expect_equal(nrow(df), 5)
    expect_equal(length(df), 20)
    
    # only one ship in results
    expect_equal(length(unique(df$ship_type)), 1)
    expect_equal(length(unique(df$SHIPNAME)), 1)
    
    # the one ship is as expected
    expect_equal(df$ship_type[1], "Cargo")
    expect_equal(df$SHIPNAME[1], "KONYA")
    
    # numeric geo data - this is important for sf
    expect_is(df$LAT, "numeric")
    expect_is(df$LON, "numeric")
})
