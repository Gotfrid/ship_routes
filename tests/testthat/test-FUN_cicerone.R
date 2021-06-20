setwd("../../")

test_that("tutorial works as expected", {
  # init the app
  app <- ShinyDriver$new(".")

  # there should be tutorial running
  tutorial_title <- app$findElement(".driver-popover-title")
  title_text <- tutorial_title$getText()

  # close app
  app$finalize()
  rm(app)

  # test
  expect_equal(title_text, "Welcome!")
})
