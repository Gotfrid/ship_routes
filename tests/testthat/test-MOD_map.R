
test_that("map module instatiates the map", {
    testServer(map_server, {
        expect_true(grepl('[57.65783,11.75497]', 
                          output$map))
    })
})
