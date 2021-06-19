setwd("../../")
test_that("dropmenu module generates some ui", {
    testServer(".", {
        ui <- dropdownSelect_ui("test")
        expect_true(grepl("display: grid;", ui))
        expect_true(grepl('id="test-type_selection"', ui))
        expect_true(grepl('id="test-name_selection"', ui))
        expect_true(grepl('<div class="item" data-value="Pleasure">Pleasure</div>', ui))
        expect_true(grepl('<div class="item" data-value="Tanker">Tanker</div>', ui))
    })
})


app <- ShinyDriver$new(path = ".")


test_that("ship name options are updated with type selection", {
    testServer(dropdownSelect_server, args = list(id = "test"), {
        
        session$setInputs(type_selection = "Cargo")
        new_options <- name_options()[1:2]
        
        # i dont know how to actually check whether
        # input options change reactively
        expect_equal(new_options, c("KONYA", "KAROLI"))
    })
})
app$stop()
