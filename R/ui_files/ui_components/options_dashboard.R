options <- div(
  class = "grid_element",
  h2("Options"),
  p("Move the bar to change the eplison value."),
  div(
    style = "height: 100%; display: flex; align-items: center;",
    shinyWidgets::noUiSliderInput(
      "dashSliderSW",
      label = NULL,
      min = 0,
      max = 0.1,
      value = 0,
      step = 0.01,
      orientation = "horizontal",
      height = "10px",
      width = "1000px",
      color = "#007ba7"
    )
  )
)