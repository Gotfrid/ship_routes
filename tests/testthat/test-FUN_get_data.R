setwd("../../")

test_that("we get correct data inside the app", {
  type <- "Cargo"
  name <- "KONYA"

  result <- get_data(type, name)
  normal_result <- as.data.frame(result$map_points)
  reordered_result <- normal_result %>%
    arrange(datetime)

  expect_is(result, "list")
  expect_equal(length(result), 15)
  expect_identical(normal_result, reordered_result)

  expect_is(result$total_distance, "numeric")
  expect_equal(round(result$total_distance, 0), 42589)
  expect_equal(round(result$line$distance, 0), 1300)
})
