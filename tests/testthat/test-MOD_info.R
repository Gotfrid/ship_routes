test_that("info box says sorry on wrong input", {
  testServer(info_server, args = list(info_data = list(status = "fail")), {
    expect_true(
      grepl('<div class="header">Sorry!</div>', output$info_box$html)
    )
  })
})


info_data <- list(
  status = "ok",
  total_distance = 100,
  line = list(distance = 50),
  total_obs = 2,
  # weight = 1,
  length = 2,
  width = 3,
  ship_id = 111,
  flag = "PL",
  name = "One",
  type = "Cargo"
)

expected_html <-
  '<div class="ui card fluid">
  <div class="content">
    <div class="header">One <small><small>ID: 111 </small></small></div>
    <div class="meta">
      <em data-emoji="flag_pl"></em>
      Cargo, PL
    </div>
    <div class="description">Travelled:  <strong> 100 </strong>m</br> Longest Segment:  <strong> 50 </strong>m</br> <small><em> Based on 2 unique points </em></small></br> <hr> Dead Weight:  NULL kg</br> Length:  2 m</br> Width:  3 m</br></div>
  </div>
</div>'

test_that("info box displays correct data", {
  testServer(info_server, args = list(info_data = info_data), {
    expect_identical(output$info_box$html, HTML(expected_html))
  })
})
