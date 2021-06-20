library(shiny)

info_ui <- function(id) {
  ns <- NS(id)
  uiOutput(ns("info_box"))
}

info_server <- function(id, info_data) {
  moduleServer(
    id = id,
    module = function(input, output, session) {
      output$info_box <- renderUI({
        if (info_data$status == "fail") {
          ui_element <- card(div(
            class = "content",
            div(class = "header", "Sorry!"),
            div(class = "meta", "Not enough information found"),
            div(
              class = "description",
              HTML(
                "Please, try visiting this page later, ",
                "when we aquire more info on this vessel.<br><br>",
                "Thank you!"
              )
            )
          ))
          return(ui_element)
        }
        total_distance <- info_data$total_distance
        total_distance <- format(round(total_distance, 0), big.mark = " ")

        longest_segment <- info_data$line$distance
        longest_segment <- format(round(longest_segment, 1), big.mark = " ")

        total_observations <- info_data$total_obs

        weight <- info_data$weight
        weight <- format(weight, big.mark = " ")

        length <- info_data$length
        width <- info_data$width

        ship_id <- info_data$ship_id

        flag <- info_data$flag
        flag_fomantic <- tags$em(
          `data-emoji` = paste0("flag_", tolower(flag))
        )

        card(
          class = "fluid",
          div(
            class = "content",
            div(
              class = "header",
              HTML(
                info_data$name,
                "<small><small>ID:",
                ship_id,
                "</small></small>"
              )
            ),
            div(
              class = "meta",
              flag_fomantic,
              paste0(info_data$type, ", ", flag)
            ),
            div(
              class = "description",
              HTML(
                "Travelled: ",
                "<strong>", total_distance, "</strong>m</br>",
                "Longest Segment: ",
                "<strong>", longest_segment, "</strong>m</br>",
                "<small><em>",
                "Based on", total_observations, "unique points",
                "</em></small></br>",
                "<hr>",
                "Dead Weight: ", weight, "kg</br>",
                "Length: ", length, "m</br>",
                "Width: ", width, "m</br>",
              )
            )
          )
        )
      })
    }
  )
}
