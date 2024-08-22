sidebar <- div (class = "grid_element",
                h2("Sidebar"),
                selectizeInput(
                  "sidebarPlotSelect",
                  "Plot: ",
                  choices = c(
                    " ",
                    "Heatmap",
                    "Problem Diff - Merged",
                    "Problem Diff - Sep",
                    "Splines",
                    "Strength and Weakness",
                    "Model Goodness - Goodness",
                    "Model Goodness - Actual",
                    "Model Goodness - Predicted",
                    "Model Goodness - A vs P"
                  ),
                )
              )