library(shiny)

plot_ui <- function(id) {
    ns <- NS(id)
    echarts4r::echarts4rOutput(ns("plot"))
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
                
                max_segment_datetime <- as.POSIXct(
                    plot_data$max_segment_datetime,
                    origin = "1970-01-01"
                )
                
                plot_data$plot_data %>% 
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
                             nameGap = 30,
                             axisLabel = list(rotate = 30)) %>% 
                    e_grid(left = 50,
                           right = 60,
                           top = 50)
            })
        }
    )
}
