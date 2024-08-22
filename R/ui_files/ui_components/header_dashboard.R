header <- div(
  class = "grid_element",
  h2("Input"),
  br(),
  fluidRow(
    column(width = 3, fileInput("upload", NULL, accept = ".csv"), ),
    column(width = 3, selectizeInput(
      "exampleFile",
      NULL,
      choices = c(
        "Select Example File",
        "Anomaly Detection",
        "MaxCut Graph",
        "Classification",
        "Time Series Forecasting",
        "Clustering"
      ),
    ), ),
    column(width = 2, checkboxInput("scaleData", "Scale Data", value = TRUE), ),
    column(
      width = 2,
      checkboxInput("invertData", "Invert Data", value = FALSE),
    ),
    column(width = 2, radioButtons(
      "scale_method",
      NULL,
      c("All" = "multiple", "By Column" = "single")
    )),
  ),
  div(
    class = "header_compute",
    actionButton("computeDash", style = "margin: 0 auto; display: block; color: #edebeb; border-radius: 2px;", "Compute", class = "btn-primary btn-lg", ),
  ),
  br(),
  em("After selecting a dataset and pressing compute, select a plot type on the sidebar to the right.")
)
