library(shinytest)
library(testthat)

# shinytest::installDependencies()

test_dir(
    path = "testthat",
    env = shiny::loadSupport(),
    reporter = c("progress")
)
