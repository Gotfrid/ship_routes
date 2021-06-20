setwd("../../")

test_that("leaflet proxy ads and removes data from the map", {
  testServer(".", {
    map_data_fail <- list(status = "fail")
    map_data_ok <- list(
      map_points = list(
        lng = c(0, 1, 2),
        lat = c(1, 2, 1),
        datetime = c(1481674147, 1481674148, 1481674149)
      ),
      points = st_as_sf(data.frame(
        x = c(0, 1), y = c(1, 4),
        label = c("Start", "End")
      ),
      coords = c("x", "y")
      ),
      line = st_sfc(st_linestring(x = matrix(c(0, 1, 2, 3), nrow = 2))),
      status = "ok"
    )

    map_with_data <- map_proxy("map", map_data_ok)
    map_clean <- map_proxy("map", map_data_fail)

    # we expect that map with data has limits - do to the data
    # whereas clean map has empty limits - due to no data
    expect_is(map_with_data$x, "list")
    expect_is(map_clean$x, "list")

    expect_equal(map_with_data$x, list(limits = list(lat = c(1, 4), lng = c(0, 2))))
    expect_equal(length(map_clean$x), 0)
  })
})
