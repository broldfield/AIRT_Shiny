presentation_page <- fluidPage(
  shinyjs::useShinyjs(),
  theme = bs_theme(bootswatch = "cerulean"),
  inlineCSS("p{ max-width: 900px;}"),
  
  # Html Styling
  style = "background-color: #f5f5f5; padding-bottom: 10px; min-height: 100vh;",
  
  # The wild wild world of Html and inline css
  
  
  
  # Middle Column Styling
  div(
    style = "background-color: white ;padding-top: 10px; max-width: 1000px; margin: auto;box-shadow: 7px 7px 3px #cdcdcd;",
    div(
      style = "margin: 15px;",
      div(
        style = "border-bottom-style: solid; border-bottom-color: lightgrey;",
        titlePanel("AIRT App for Algorithm Evaluation")
      ),
      br(),
      div(
        style = "display: flex; justify-content: space-between;",
        div(
          style = "flex: 10;",
          # About Section
          
          h3("About AIRT"),
          p(
            style = "max-width: 90%;",
            "The ",
            em("airt"),
            " R package is used to evaluate the performance of a portfolio of algorithms using ",
            strong("Item Response Theory"),
            " (IRT). ",
            br(),
            "We will look at performance datasets where the performance is a continuous variable, for example, an accuracy measure. ",
          ),
          h5("Citation"),
          p(
            "The airt paper can be found",
            tags$a(href = "https://jmlr.org/papers/v24/20-1318.html", "here"),
            ". If you are using this for academic purposes, the citation can be found below."
          ),
          
          div(
            style = "background-color: #f5f5f5; border-radius: 5px; padding: 10px; margin-bottom: 20px;",
            
            p(
              "Kandanaarachchi, S., & Smith-Miles, K. (2023). Comprehensive algorithm portfolio evaluation using item response theory.",
              em("Journal of Machine Learning Research"),
              ", 24(177), 1-52."
            ),
          ), 
          
          h5("Contributions"),
          p("AIRT Shiny App Creator: Brodie Oldfield (Data61, CSIRO)"),
          p(
            "The University of Melbourne's ",
            tags$a(href = "https://matilda.unimelb.edu.au/matilda/", "MATILDA"),
            " research platform for the example data."
          ),
        ),
        div(
          style = "flex: 4; padding-left: 20px; justify-self: center; padding-right: 10px;",
          img(
            src = "logo.png", alt = "airt logo", height = "250px"
          )
        ),
      ),
      
      
      # Data Format Section
      h3("Data Format"),
      
      # Example Table
      p(
        style = "max-width: 900px;",
        "You can input your performance dataset to the AIRT App. But it has to be in the correct format. We've given an example below of a valid Continous Dataset. The Column Name contains the Algorithm's name, and each Row contains a numeric performance metric. There should be no row names."
      ),
      div(
        style = "margin: auto; max-width: 500px;",
        uiOutput("exampleTable", style = "width: 100%; overflow:none; padding-bottom: 10px;"),
        em("Note: Numerics are displayed to 4 decimal places in tables."),
      ),
      br(),
      
      # Upload Section
      div(
        style = "border-bottom-style: dotted; border-bottom-color: #edebeb; ",
        h3("Input"),
        p(
          "You can upload a csv file or to get started use one of our examples taken from UniMelb's MATILDA platform.",
          br(),
          strong("Scale Data:"), "Data is by default scaled between 0 and 1. Uncheck to disable.",
          br(),
          strong("Invert Data:"), "Inverts the dataset.",
          br(),
          strong("Scale Method:"), "Whether to apply scaling per column or for all data. Disabled when Scale Data is disabled."
        ),
        p("The AIRT App takes good performance to be values that are larger and poor performance to be values that are smaller in your dataset.  If this is not the case, for example, as your performance values you've got time taken to complete the task, or the mean square error, then the values need to be inverted."),
        h5("Modifiers"),
        fluidRow(
          column(
            4,
            checkboxInput("scaleData", "Scale Data", value = TRUE),
          ),
          column(
            4,
            checkboxInput("invertData", "Invert Data", value = FALSE),
          ),
          column(
            4,
            radioButtons(
              "scale_method",
              NULL,
              c(
                "All" = "multiple",
                "By Column" = "single"
              )
            ),
          )
        ),
        h5("Data Selection"),
        div(
          style = "padding-bottom: 30px;",
          fluidRow(
            column(
              4,
              fileInput("upload", NULL, accept = ".csv"),
            ),
            column(
              4,
              selectizeInput(
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
              ),
            )
          ),
          hidden(
            div(
              id = "invertText",
              em("The Time Series Forecasting file should be selected with 'Invert Data' ticked."),
            )
          ),
        ),
        div(
          style = "padding-bottom: 50px;",
          actionButton("compute",
                       style = "margin: 0 auto; display: block; color: #edebeb; border-radius: 2px;",
                       "Compute",
                       class = "btn-primary btn-lg",
          ),
        ),
        br(),
      ),
      br(),
      hidden(
        div(
          id = "downloadDiv",
          class = "hidden",
          style = "padding-bottom: 20px",
          h3("Download"),
          p(
            "Downloads generated Tables and Plot Images. Resets when new data is loaded."
          ),
          downloadButton("downlBtn",
                         "Download.tar",
                         icon = shiny::icon("download")
          ),
        )
      ),
      
      # Paras Table
      hidden(
        div(
          id = "parasDiv",
          class = "hidden",
          style = "padding-bottom: 50px; padding-top: 25px;",
          h3(id = "parasTitle", "Traditional IRT parameters"),
          p(
            style = "max-width: 900px;",
            "This table gives the traditional IRT parameters ",
            em("discrimination, "),
            em("difficulty, "),
            "and a ",
            em("scaling parameter"),
            " for each algorithm."
          ),
          div(
            style = "margin: auto; max-width: 500px ;",
            uiOutput("parasTable", style = "width: 100%; overflow:none; padding-top: 10px; padding-bottom: 10px;"),
          ),
          p(
            style = "max-width: 900px;",
            "These parameters are used to find the AIRT algorithm attributes: ",
            em("anomalousness,"),
            em("consistency,"),
            " and ",
            em("the difficulty limit.")
          ),
          actionButton("parasCont", "Next"),
          br(),
        )
      ),
      
      # Anomaly Table
      hidden(
        div(
          id = "anomDiv",
          class = "hidden",
          style = "padding-bottom: 50px;",
          h3("AIRT Attributes"),
          h5("Anomalous"),
          p(
            "We say an algorithm is anomalous if it excels with difficult problems but struggles with easy problems. Normal or non-anomalous algorithms work the other way, they perform well for easy problems but poorly with difficult problems. The anomalous attribute is set to 1 if the algorithm is anomalous, otherwise it is set to 0."
          ),
          h5("Difficultly limit"),
          p(
            "The difficultly limit attribute tells us the highest difficulty level the algorithm can handle. If an algorithm has a high difficulty limit value, then it can handle very hard problems, while a low value is less performant on harder questions."
          ),
          h5("Consistency"),
          p(
            "The consistency attribute indicates an algorithm's stability. A low consistency algorithm has fluctuating performance while high consistency algorithms give more consistent results, that is, shows limited fluctuations."
          ),
          br(),
          div(
            style = "margin: auto; max-width: 500px ;",
            uiOutput("anomal", style = "width: 100%; overflow:none;"),
            em("Click on a row for more information."),
          ),
          hidden(
            div(
              id = "anomBoxplotDiv",
              class = "hidden",
              style = "margin: auto; max-width: 500px ; padding-top: 10px",
              h5("Boxplot"),
              uiOutput("anomBoxplot", style = "width: 100%; overflow:none;"),
              uiOutput("anomBoxplotText"),
            )
          ),
          actionButton("anomalCont", "Next"),
          br(),
        )
      ),
      
      # Heat Map
      hidden(
        div(
          id = "heatMapDiv",
          class = "hidden",
          style = "padding-bottom: 50px; min-height: 600px;",
          h3("Heat Map"),
          p(
            style = "max-width: 900px;",
            "The Theta (x axis) represents the dataset easiness, and the z (y axis) represents the normalized performance values. The heatmaps show the probability density of the fitted IRT model over Theta and z values for each algorithm."
          ),
          uiOutput("heatMap"),
          p(
            style = "max-width: 900px;",
            "If the line has a positive slope, then the algorithm is not anomalous.",
            br(),
            "The thinner lines are more discriminating algorithms.",
            br(),
            "Algorithms with no or blurry lines are more consistent."
          ),
          actionButton("heatMapCont", "Next"),
        )
      ),
      
      # Plot Type 1 and 2
      hidden(
        div(
          id = "auto1And2Div",
          class = "hidden",
          style = "padding-bottom: 50px; min-height: 600px;",
          h3("Problem Difficulty Space and Algorithm Performance"),
          p(
            "We can look at the algorithm performance with respect to the dataset difficulty, which is called the Latent Trait Analysis."
          ),
          tabsetPanel(
            id = "auto1And2Tabs",
            tabPanel("Merged", uiOutput("auto1")),
            tabPanel("Seperate", uiOutput("auto2"))
          ),
          p(
            "From these plots, we may see that certain algorithms give better performances for different problem difficulty values."
          ),
          actionButton("auto1And2Cont", "Next"),
        )
      ),
      
      # Plot Type 3
      hidden(
        div(
          id = "auto3Div",
          class = "hidden",
          style = "padding-bottom: 50px; min-height: 600px;",
          h3("Splines"),
          p(
            "To get a better sense of which algorithms are better for which difficulty values, we can fit smoothing splines to the above data.",
            "You can select an algorithm from the drop-down box below to see it separately and the checkbox removes the error bands."
          ),
          div(
            style = "display: flex; align-items: flex-end; width: 100%;",
            div(
              style = "",
              selectInput(
                "splineSelectAlgo",
                "Select Algorithm:",
                choices = NULL,
                selectize = TRUE
              )
            ),
            div(
              style = "padding-bottom: 15px; padding-left: 10px; ",
              actionButton("resetSpline", "Reset Selection")
            ),
            div(
              style = "padding-bottom: 15px; padding-left: 10px; justify-self: flex-end; justify-text: flex-end;",
              checkboxInput("seCheckBox", "Show Error Bands", value = TRUE),
              float = "right", align = "right", direction = "rtl"
            )
          ),
          uiOutput("auto3"),
          # create a dropdown menu for the user to select the algorithm
          p(
            "Generally, curves on top signify better algorithms and curves at the bottom signify weaker algorithms. But this is not always straightforward. For some difficulty levels, some algorithms are on top (better) and for some other difficulty levels, others may be on top.",
          ),
          br(),
          actionButton("auto3Cont", "Next"),
          br(),
        )
      ),
      
      # Plot Type 4
      hidden(
        div(
          id = "auto4Div",
          class = "hidden",
          style = "padding-bottom: 50px; min-height: 600px;",
          h3("Strengths and Weaknesses of Algorithms"),
          p(
            "When an algorithm is on the top for a certain difficulty level, we call it a strength of the algorithm. The algorithm is strong for problems of that difficulty level. Similarly, when an algorithm curve is in the bottom it is a weakness.  So, algorithms have different strengths and weaknesses in the problem difficulty spectrum.",
            "To see the best and worst algorithms for a given problem difficulty, the splines above are used to compute the proportion of the Latent Trait Spectrum occupied by each algorithm. This is called the Latent Trait Occupancy (LTO).",
            br(),
            br(),
            "We have a parameter epsilon when we talk about strengths and weaknesses. When epsilon = 0, we only take the topmost curve for each difficulty value. But, this is unrealistic. For certain difficulty values there may be multiple algorithms that are good. We achieve this by giving a little bit of leeway. We make epsilon non-zero."
          ),
          fluidRow(
            column(
              1,
              div(
                style = "height: 100%; display: flex; align-items: center;",
                shinyWidgets::noUiSliderInput(
                  "epsilonAuto4",
                  label = NULL,
                  min = 0,
                  max = 0.1,
                  value = 0,
                  step = 0.01,
                  orientation = "vertical",
                  height = "300px",
                  width = "100px",
                  color = "#007ba7"
                )
              )
            ),
            column(
              10,
              uiOutput("auto4")
            )
          ),
          p(
            "We can see the strengths and weaknesses in this graph. Each algorithm occupies parts of the Problem Difficulty spectrum as shown by a bar. This shows that for some problem difficulty values certain algorithms perform best, or that they are weaker than others (Weakness plot).",
          ),
          p(
            "We can use the strengths and weaknesses to compute the proportion of the Latent Trait Spectrum (problem difficulty spectrum) occupied by each algorithm. This is called the Latent Trait Occupancy (LTO)."
          ),
          div(
            style = "justify-text: left; display:flex; justify-content: center; padding-top: 20px; padding-bottom: 20px;",
            div(
              style = "padding-right: 20px;",
              h5("Strength LTO"),
              uiOutput("strengthLTO")
            ),
            div(
              style = "padding-left: 20px;",
              h5("Weaknesses LTO"),
              uiOutput("weaknessLTO")
            ),
          ),
          actionButton("auto4Cont", "Next"),
        )
      ),
      
      # Goodness and Eff Plots 1-3
      hidden(
        div(
          id = "goodnessEffDiv",
          class = "hidden",
          style = "padding-bottom: 50px; min-height: 600px; padding-top: 5px; border-top-style: dotted; border-top-color: #edebeb;",
          h3(
            style = "",
            "Is this a good model?"
          ),
          h5("Model Goodness Metrics"),
          p(
            "All this is good, but is the fitted IRT model good? To check this, we have a couple of measures."
          ),
          tabsetPanel(
            tabPanel(
              "Goodness",
              uiOutput("goodnessPlot"),
              p(
                "One is the Model Goodness Curve, where we are looking at the distribution of errors - that is, the difference between the predicted and the actual values for different algorithms.",
                br(),
                "The x-axis has the absolute error scaled to [0,1] and the y-axis shows the empirical cumulative distribution of errors for each algorithm. For a given algorithm, a model is well fitted if the curve goes up to 1 on the y-axis quickly.",
                br(),
                " That is, if the Area Under the Curve (AUC) is closer to 1. We can check the AUC and the Mean Square Error (MSE) for these algorithms."
              )
            ),
            tabPanel(
              "Actual",
              uiOutput("modEff1"),
              p(
                "This 'Actual' Plot tells us how well the algorithms actually perform, without fitting an IRT model."
              )
            ),
            tabPanel(
              "Predicted",
              uiOutput("modEff2"),
              p(
                "By using the 'Predicted' Plot, we can get the predicted effectiveness when fitting to the IRT model."
              ),
            ),
            tabPanel(
              "Actual vs Predicted",
              uiOutput("modEff3"),
              p(
                "Here we can see how the actual and the predicted sit together. Here AUPEC means Area Under Predicted Effectiveness Curve and AUAEC means Area Under Actual Effectiveness Curve.",
                br(),
                "The IRT model has fitted the algorithms well if the points are close to the y = x line, shown as a dotted line."
              ),
            )
          ),
        )
      ),
    ),
  ),
)