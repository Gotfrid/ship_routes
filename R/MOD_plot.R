library(shiny)

plot_ui <- function(id) {
  ns <- NS(id)
  echarts4rOutput(ns("plot"), height = "279px", width = "100%")
}

plot_server <- function(id, plot_data) {
  moduleServer(
    id = id,
    module = function(input, output, session) {
      output$plot <- renderEcharts4r({
        req(plot_data)

        if (plot_data$status == "fail") {
          return()
        }


        df <- as.data.frame(plot_data$plot_data) %>%
          mutate(date = as.character(as.Date.POSIXct(datetime))) %>%
          group_by(date) %>%
          tally()

        df %>%
          e_chart(date) %>%
          e_bar(n, name = "N") %>%
          e_tooltip(trigger = "item") %>%
          e_legend(show = F) %>%
          e_x_axis(
            type = "category",
            name = "Date",
            nameLocation = "center",
            nameGap = 30,
            axisLabel = list(rotate = 0)
          ) %>%
          e_grid(
            left = 45,
            right = 10,
            top = 50
          ) %>%
          e_color("#0079c9")
      })
    }
  )
}
