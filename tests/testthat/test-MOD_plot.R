




test_that("plot module does not create the plot if status fail", {
    plot_data_fail = list(status = "fail")
    expected_fail <- '"x":null'
    testServer(plot_server, args = list(plot_data = plot_data_fail), {
        expect_true(grepl(expected_fail, output$plot))
    })
})



test_that("plot module creates the plot if status ok", {
    plot_data_ok = list(
        status = "ok",
        max_segment_datetime = 1481674147,
        plot_data = list(
            datetime = c(1481674146, 1481674147, 1481674148),
            speed = c(100, 101, 97)
        )
    )
    expected_ok <- '"value":\\["2016-12-14 03:09:07","101"\\]'
    testServer(plot_server, args = list(plot_data = plot_data_ok), {
        expect_true(grepl(expected_ok, output$plot))
    })
})
