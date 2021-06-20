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

test_that("dropdown server is reactive towards type_selection", {
  testServer(dropdownSelect_server, {

    # initially, there are no name options
    expect_length(name_options(), 0)

    # however we set inputs and things change
    session$setInputs(type_selection = "Tanker")
    expect_equal(name_options()[1:3], c("PALLAS GLORY", "FURE FLADEN", "BESIKTAS ICELAND"))

    session$setInputs(type_selection = "Cargo")
    expect_equal(name_options()[1:3], c("KONYA", "KAROLI", "POLA MUROM"))
  })
})

# # to properly test reactivity, one has to change
# # shiny.semantic::selectInputs to shiny::selectInputs
# # because in semantic, inputs are hidden.
# # i think phantom JS does not run Shiny binding scripts...
# test_that("ship name options are updated with type selection", {
#     testServer(dropdownSelect_server, {
#
#         # init app
#         app <- ShinyDriver$new(path = ".")
#         Sys.sleep(2)
#
#         # test init values
#         initial_type <- app$getValue("dropdown_menus-type_selection")
#         initial_name <- app$getValue("dropdown_menus-name_selection")
#
#         expect_equal(initial_type, "Tanker")
#         expect_equal(initial_name, "PALLAS GLORY")
#
#
#         # change type and expect both type and name to change
#         app$setValue("dropdown_menus-type_selection", "Cargo")
#         changed_type <- app$getValue("dropdown_menus-type_selection")
#         changed_name <- app$getValue("dropdown_menus-name_selection")
#
#         expect_equal(changed_type, "Cargo")
#         expect_equal(changed_name, "KONYA")
#
#         # close the app
#         app$finalize(); rm(app)
#     })
# })
