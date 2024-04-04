library(shiny)
library(shinyjs)

library(devtools)
install_github("sevvandi/airt")

library(airt)
library(ggplot2)
library(tidyr)
library(gridExtra)

library(bslib)
library(thematic)
library(ggthemes)
library(DT)



fluidPage(
  shinyjs::useShinyjs(),
  theme = bs_theme(bootswatch = "cerulean"),
  
  # Html Styling
  style = "background-color: #f5f5f5; padding-bottom: 10px; min-height: 100vh;",
  
  # The wild wild world of Html and inline css
  
  # Nav Bar styling
  div(
    style = " margin-bottom: -30px; width:100%; max-width: 1500px;margin-left: auto; margin-right: auto; box-shadow: 7px 7px 3px #cdcdcd;  overflow: none;",
    navbarPage(
      title = "AIRT",
      collapsible = TRUE,
      tabPanel(
        title = HTML(
          "</a></li><li><a href='https://sevvandi.github.io/airt/' target='_blank'>Docs"
        ),
        style = "margin: 30px 30px;"
      ),
    ),
    
  ),
  
  # Middle Column Styling
  div(
    style = "background-color: white ;padding-top: 10px; max-width: 1000px; margin: auto;box-shadow: 7px 7px 3px #cdcdcd;",
    div(
      style = "margin: 15px;",
      div(style = "border-bottom-style: solid; border-bottom-color: lightgrey;",
          titlePanel("AIRT Processor")),
      
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
            " package is used to evaluate the performance of a portfolio of algorithms using ",
            strong("Item Response Theory") ,
            " (IRT). ",
            br(),
            "AIRT currently fits to two data models: Continuous and Polytomous (categorical).",
            br(),
            "This application processes a .csv portfolio of algorithms and presents analysis for Continuous datasets."
          ),
          h5("Contributions"),
          p("AIRT Shiny App Creator: Brodie Oldfield (Data61, CSIRO)"),
          p(
            "The University of Melbourne's ",
            tags$a(href = "https://matilda.unimelb.edu.au/matilda/" , "MATILDA"),
            " research platform for the example data."
          ),
          
          
          
        ),
        div(style = "flex: 4; padding-left: 20px; justify-self: center; padding-right: 10px;",
            img(
              src = "logo.png", alt = "airt logo", height = "250px"
            )),
      ),
      
      
      # Data Format Section
      h3("Data Format"),
      
      # Example Table
      p(
        style = "max-width: 900px;",
        "Below is an example of a valid Continuous Dataset. The Column Name contains the Algorithm's name, and each Row contains a numeric performance metric without a Row Name."
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
          "Upload .csv or use an example file.",
          br(),
          "Uncheck Scale Data when data is Time (seconds)."
        ),
        
        
        fluidRow(column(
          4,
          checkboxInput("scaleData", "Scale Data", value = TRUE),
        ),
        column(4,
               radioButtons(
                 "scaleMethod",
                 NULL,
                 c("By Column" = "single",
                   "All" = "multiple")
               ),)),
        
        div(style = "padding-bottom: 30px;",
            fluidRow(
              column(4,
                     
                     fileInput("upload", NULL, accept = ".csv"),),
              column(4,
                     selectizeInput(
                       "exampleFile",
                       NULL,
                       choices = c(
                         "Select Example File",
                         "Anomaly Detection",
                         "MaxCut Graph",
                         "Classification"
                       ),
                     ),)
            ), ),
        div(
          style = "padding-bottom: 50px;",
          actionButton("compute",
                       style = "margin: 0 auto; display: block; color: #edebeb; border-radius: 2px;",
                       "Compute",
                       class = "btn-primary btn-lg", ),
        ),
        br(),
      ),
      br(),
      
      hidden(
        div(
          id = "downloadDiv",
          style = "padding-bottom: 20px",
          h3("Download"),
          p(
            "Downloads generated Tables and Plot Images. Resets when new data is loaded."
          ),
          downloadButton("downlBtn",
                         "Download.tar",
                         icon = shiny::icon("download")),
        )
      ),
      
      # Paras Table
      hidden(
        div(
          id = "parasDiv",
          style = "padding-bottom: 50px; padding-top: 25px;",
          
          h3(id = "parasTitle", "Algorithm Performance Data"),
          
          p(
            style = "max-width: 900px;",
            "This table displays traditional IRT parameters for each algorithm, where ",
            em("a"),
            " denotes discrimination, ",
            em("b"),
            " denotes difficulty, and ",
            em("alpha"),
            "  is a scaling parameter."
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
          style = "padding-bottom: 50px;",
          h3("AIRT Attributes"),
          p(
            "If an algorithm is anomalous then the anomalousness attribute is 1."
          ),
          div(
            style = "margin: auto; max-width: 500px ;",
            uiOutput("anomal", style = "width: 100%; overflow:none;"),
          ),
          actionButton("anomalCont", "Next"),
          br(),
        )
      ),
      
      # Heat Map
      hidden(
        div(
          id = "heatMapDiv",
          style = "padding-bottom: 50px; min-height: 600px;",
          h3("Heat Map"),
          p(
            style = "max-width: 900px;",
            "The Theta (x axis) represents the dataset easiness and the z (y axis) represents the normalized performance values. The heatmaps show the probability density of the fitted IRT model over Theta and z values for each algorithm."
          ),
          uiOutput("heatMap"),
          p(
            style = "max-width: 900px;",
            "If the line has a positive slope, then the algorithm is not anomalous.",
            br(),
            "The thinner lines are more discriminating.",
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
          style = "padding-bottom: 50px; min-height: 600px;",
          h3("Problem Difficulty Space and Algorithm Performance"),
          p(
            "We can look at the algorithm performance with respect to the dataset difficulty, which is called the Latent Trait Analysis."
          ),
          tabsetPanel(
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
          style = "padding-bottom: 50px; min-height: 600px;",
          h3("Spline"),
          p(
            "To get a better sense of which algorithms are better for which difficulty values, we can fit smoothing splines to the above data."
          ),
          uiOutput("auto3"),
          
          actionButton("auto3Cont", "Next"),
          br(),
        )
      ),
      
      # Plot Type 4
      hidden(
        div(
          id = "auto4Div",
          style = "padding-bottom: 50px; min-height: 600px;",
          h3("Strengths and Weaknesses of Algorithms"),
          p(
            "To see the best and worst algorithms for a given problem difficulty, the splines above are used to compute the proportion of the Latent Trait Spectrum occupied by each algorithm. This is called the Latent Trait Occupancy (LTO)."
          ),
          tabsetPanel(
            tabPanel("No Overlap", uiOutput("auto4")),
            tabPanel("Overlap", uiOutput("auto4Ep"))
          ),
          p(
            "We can see the Latent Trait Occupancy in this graph. Each algorithm occupies parts of the Latent Trait Spectrum as shown by a bar. This shows that for some dataset easiness values certain algorithms perform best in that difficulty, or that they are weaker than others.",
            br(),
            "In the 'Overlap' tab we may see that some algorithms have overlapping strengths at the same problem difficulty."
          ),
          actionButton("auto4Cont", "Next"),
        )
      ),
      
      # Goodness and Eff Plots 1-3
      hidden(
        div(
          id = "goodnessEffDiv",
          style = "padding-bottom: 50px; min-height: 600px;",
          h2(style = "color: black;",
             "Is this a good model?"),
          h3("Model Goodness Metrics"),
          p(
            "All this is good, but is the fitted IRT model good? To check this, we have a couple of measures."
          ),
          tabsetPanel(
            tabPanel(
              "Goodness",
              uiOutput("goodnessPlot"),
              p(
                "One is the Model Goodness Curve, where we are looking at the distribution of errors - that is, the difference between the predicted and the actual values for different algorithms."
                ,
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
                "Here we can see how the actual and the predicted sit together. Here AUPEC means Area Under Predicted Effectiveness Curve and AUAEC means Area Under Actual Effectiveness Curve." ,
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
