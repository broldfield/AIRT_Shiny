# AIRT Shiny

This is a Shiny Application for the AIRT R Package. AIRT Shiny should be plug and play with shinyapps.io

## Modifying Code

### Adding a new Example csv.

Adding a new CSV requires code to be appended in a couple of files:
Firstly convert the CSV file to an RDA file and place it in ./R/data. This can be done by:

```R
MyNewFile <- read.csv("MyNewFile.csv")
save(MynewFile, file = "MyNewFile.rda")
```

Next, in the ./R/ui.R file, search for `exampleFile` and in the choices set add in the name of the file E.G.

```R
choices = c(
    "Select Example File",
    "Anomaly Detection",
    "MaxCut Graph",
    "Classification",
    "Time Series Forecasting", # <- Comma
    # Add in File Name here. Remember to add the comma above
    "My New File"
),
```

Next, in ./R/server.R, at the top of the function load in the file using:

```R
load("data/MyNewFile.rda")
```

Search for `input$exampleFile` and in the choice, add in the New File. On the left hand add in the name you used in the UI section E.G. `"My New File"`, and on the right hand add in the name you saved the rda as in step 1 E.G. `"MyNewFile"`.

```R
choice = switch(
    input$exampleFile,
    "Select Example File" = 0,
    "Anomaly Detection" = "Anomaly",
    "MaxCut Graph" = "MaxCut",
    "Classification" = "Classification",
    "Time Series Forecasting" = "TimeSeriesForecasting", # <- Comma
    # Add in section below
    "My New File" = "MyNewFile"
    )
```

Copy the Right hand side that you added in above, then move to ./R/getters.R, search for `switch(csvChoice())`. In the switch statement, add in what you copied and on the right hand side add in what you saved the data as when saving to rda.
