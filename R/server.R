library(shiny)

load("data/MaxCut.rda")
load("data/Anomaly.rda")
load("data/Classification.rda")
load("data/TimeSeriesForecasting.rda")
load("data/Clustering.rda")

function(input, output, session) {
  # With the DT package, you can use "x_rows_selected" to get the clicked on row.
  # Where x = the renderDT's output ID
  # When using renderDT in a renderUI, you need to use the session$ns to construct the ID
  ns <- session$ns

  source("genPlot.R", local = TRUE)
  source("getters.R", local = TRUE)
  source("validation.R", local = TRUE)
  source("downloader.R", local = TRUE)

  thematic_shiny(font = "Lato")

  # Toggles when user uploads a csv
  userUpload <- reactiveVal(FALSE)
  uploadValid <- reactiveVal(FALSE)

  scaleSelected <- reactiveVal(TRUE)
  scaleMethod <- reactiveVal("single")
  maxItem <- reactiveVal(1)
  invertDf <- reactiveVal(FALSE)

  csvChoice <- reactiveVal(0)
  anomalVal <- reactiveVal(0)

  colNamesVal <- reactiveVal(0)

  # Handles Scrolling to Div. Triggered in observes by btns.
  scrollTo <- function(eleId) {
    string <- paste0(
      "document.getElementById('",
      eleId,
      "').scrollIntoView();"
    )

    # Needs delay to give time for height to adjust for scroll.
    delay(
      100,
      runjs(string)
    )
  }

  hideAll <- function() {
    hide(selector = "div.hidden")
  }

  # Caching increeases memory by wayyyy too much
  # cache <- reactiveValues()

  # # Define a function that gets a value from the cache or calculates it if it's not in the cache
  # generatePlotCached <- function(n, epsilonIn) {
  #   csvName <- csvChoice()
  #   # Create a key for the cache
  #   key <- paste(n, epsilonIn, csvName, sep = "_")

  #   # Check if the value is in the cache
  #   if (key %in% names(cache)) {
  #     # Return the cached value
  #     return(cache[[key]])
  #   } else {
  #     # Calculate the value
  #     value <- generatePlot(n, epsilonIn, csv)

  #     # Store the value in the cache
  #     cache[[key]] <- value

  #     # Return the value
  #     return(value)
  #   }
  # }



  observeEvent(input$scaleData, {
    hideAll()

    if (input$scaleData == TRUE) {
      scaleSelected(TRUE)
    } else {
      scaleSelected(FALSE)
    }
  })

  observeEvent(input$invertData, {
    hideAll()

    if (input$invertData == TRUE) {
      invertDf(TRUE)
    } else {
      invertDf(FALSE)
    }
  })

  observeEvent(input$scaleMethod, {
    hideAll()

    if (input$scaleMethod == "single") {
      scaleMethod("single")
    } else {
      scaleMethod("multiple")
    }
  })

  # Example Table
  dataCols <- colnames(Classification[1:4])
  output$exampleTable <- renderUI({
    renderDataTable(
      datatable(
        Classification[1:5, 1:4],
        rownames = FALSE,
        options = list(
          pageLength = 5,
          searching = FALSE,
          paging = FALSE,
          lengthChange = FALSE,
          info = FALSE,
          ordering = FALSE
        )
      ) %>% formatRound(dataCols, digits = 4)
    )
  })

  observeEvent(input$compute, {
    removeNotification("nothingSelected")
    # Check if User has pressed the button without any inputs.
    if (csvChoice() == 0 && !userUpload()) {
      showNotification(
        "Must upload a valid file or select an Example.",
        duration = NULL,
        id = "nothingSelected"
      )
      hideAll()
    } else if (userUpload()) {
      # Valid Conditions for using CSV
      if (uploadValid()) {
        withProgress(message = "Computing...", {
          hideAll()

          updateActionButton(session, "compute", label = "Loading")

          disable("compute")
          updateSelectInput(session, "splineSelectAlgo", selected = "")
          updateRadioButtons(session, "epsilonAuto4", selected = "0")
          updateTabsetPanel(session, "auto1And2Tabs", selected = "Merged")
          updateTabsetPanel(session, "Goodness", selected = "goodnessPlot")


          # Update the column names to allow the user to select an algo
          colNamesVal(getColNames())
          updateSelectInput(session, "splineSelectAlgo", choices = c("", colNamesVal()))
          incProgress(0.5)



          # Then generate and render the table
          # Pregenerate the Obj and Modout. As it is in compute, whenever compute is called obj will be updated.
          getObj0Per()
          incProgress(0.2)


          showParas()
          incProgress(0.3)
          enable("compute")
          updateActionButton(session, "compute", label = "Compute")


          show("parasDiv")
          show("downloadDiv")
        })
      }
    } else {
      # Valid Conditions for using Example File
      if (csvChoice() != 0 && !userUpload()) {
        withProgress(message = "Computing...", {
          hideAll()
          updateActionButton(session, "compute", label = "Loading...")

          disable("compute")

          updateSelectInput(session, "splineSelectAlgo", selected = "")
          updateRadioButtons(session, "epsilonAuto4", selected = "0")
          updateTabsetPanel(session, "auto1And2Tabs", selected = "Merged")

          # Update the column names to allow the user to select an algo
          colNamesVal(getColNames())
          updateSelectInput(session, "splineSelectAlgo", choices = c("", colNamesVal()))

          incProgress(0.5)



          # Then generate and render the table
          # Pregenerate the Obj and Modout. As it is in compute, whenever compute is called obj will be updated.
          getObj0Per()
          incProgress(0.2)


          showParas()
          incProgress(0.3)
          enable("compute")

          updateActionButton(session, "compute", label = "Compute")


          show("parasDiv")
          show("downloadDiv")
        })
      }
    }
  })

  # Upload csv + Paras Table Need to unlink them
  observeEvent(input$upload, {
    hideAll()
    req(uploadedCsv())
    userUpload(TRUE)
    validateCsv()
  })

  # Shows the Paras Table post successful csv upload (or example btn)
  showParas <- function() {
    withProgress(message = "Reading File...", {
      removeNotification("csvValidToast")

      # make sure the column names are updated on re-render.
      colNamesVal(getColNames())
      updateSelectInput(session, "splineSelectAlgo", choices = c("", colNamesVal()))

      output$parasTable <- renderUI({
        DT::dataTableOutput(ns("parasDT"))
      })
      incProgress(0.5)

      output$parasDT <-
        renderDT(
          datatable(generateParasTable(), selection = "single") %>%
            formatRound(c("a", "b", "alpha"), digits = 4)
        )

      # use NS to get the ID of anomalDT
      output$anomal <- renderUI({
        DT::dataTableOutput(ns("anomalDT"))
      })

      #
      output$anomalDT <- renderDT(
        datatable(generateAnomTable(), selection = "single") %>% formatRound(c("consistency", "difficulty_limit"), digits = 4)
          %>% formatRound("anomalousness", digits = 0)
      )
      incProgress(0.5)

      scrollTo("downloadDiv")
    })
  }

  observeEvent(input[[ns("parasDT_rows_selected")]], {
    selected_row <- input[[ns("parasDT_rows_selected")]]
  })
  observeEvent(input[[ns("anomalDT_rows_selected")]], {
    selected_row <- input[[ns("anomalDT_rows_selected")]]
    algo <- colNamesVal()[selected_row]
    withProgress(message = "Loading...", {
      output$anomBoxplot <- renderUI({
        renderPlot({
          generateAnomBoxplot(algo)
        })
      })
      output$anomBoxplotText <- renderUI({
        HTML(paste("<i>The ", algo, " algorithm is highlighted. A distant mix/max value may distort the plot.</i>"))
      })

      show("anomBoxplotDiv")
      scrollTo("anomBoxplotDiv")
    })
  })




  observeEvent(input$exampleFile, {
    hideAll()

    choice <- switch(input$exampleFile,
      "Select Example File" = 0,
      "Anomaly Detection" = "Anomaly",
      "MaxCut Graph" = "MaxCut",
      "Classification" = "Classification",
      "Time Series Forecasting" = "TimeSeriesForecasting",
      "Clustering" = "Clustering"
    )

    if (input$exampleFile == "Time Series Forecasting") {
      show("invertText")
    } else {
      hide("invertText")
    }

    csvChoice(choice)
    userUpload(FALSE)
    # Prevent blank csv from being loaded on startup
  })

  # Anomalousness Table
  observeEvent(input$parasCont, {
    withProgress(message = "Loading...", {
      show("anomDiv")
      scrollTo("anomDiv")
    })
  })


  # updateSelectInput(session, "anomSelectAlgo", choices = colNamesVal())

  # Heat Map
  observeEvent(input$anomalCont, {
    withProgress(message = "Loading...", {
      output$heatMap <- renderUI({
        renderPlot({
          generateHeatMap()
        })
      })
      show("heatMapDiv")
    })

    scrollTo("heatMapDiv")
  })

  # Plot Type 1 + 2
  observeEvent(input$heatMapCont, {
    withProgress(message = "Loading...", {
      output$auto1 <- renderUI({
        renderPlot({
          generatePlot(1, epsilonIn = "0")
        })
      })

      incProgress(0.5)
      output$auto2 <- renderUI({
        renderPlot({
          generatePlot(2, epsilonIn = "0")
        })
      })

      # Output Options lets you load a plot when it isn't yet rendered. So use it in tabs.
      # outputOptions(output, "auto2", suspendWhenHidden = FALSE)

      incProgress(0.5)

      show("auto1And2Div")
      scrollTo("auto1And2Div")
    })
  })

  # Plot Type 3
  observeEvent(input$auto1And2Cont, {
    withProgress(message = "Loading...", {
      output$auto3 <- renderUI({
        renderPlot({
          generatePlot(3, epsilonIn = "0")
        })
      })

      incProgress(1)
      show("auto3Div")
    })

    scrollTo("auto3Div")
  })


  observeEvent(input$splineSelectAlgo, {
    withProgress(message = "Loading...", {
      output$auto3 <- renderUI({
        renderPlot({
          generateSplinePlot(input$splineSelectAlgo)
        })
      })
    })
  })

  observeEvent(input$resetSpline, {
    output$auto3 <- renderUI({
      renderPlot({
        generatePlot(3, epsilonIn = "0")
      })
    })
  })

  # Plot Type 4
  observeEvent(input$auto3Cont, {
    withProgress(message = "Loading...", {
      output$auto4 <- renderUI({
        renderPlot({
          generatePlot(4, epsilonIn = input$epsilonAuto4)
        })
      })
      incProgress(0.5)

      # outputOptions(output, "auto4Ep", suspendWhenHidden = FALSE)
      show("auto4Div")
    })
    scrollTo("auto4Div")
  })

  # Goodness Plot + modEff1-3
  observeEvent(input$auto4Cont, {
    withProgress(message = "Loading...", {
      output$goodnessPlot <- renderUI({
        renderPlot({
          generateGoodness()
        })
      })
      incProgress(0.2)
      output$modEff1 <- renderUI({
        renderPlot({
          generateModelEff(1)
        })
      })
      incProgress(0.2)
      output$modEff2 <- renderUI({
        renderPlot({
          generateModelEff(2)
        })
      })
      incProgress(0.2)
      output$modEff3 <- renderUI({
        renderPlot({
          generateModelEff(3)
        })
      })
      incProgress(0.2)

      # outputOptions(output, "modEff1", suspendWhenHidden = FALSE)
      # outputOptions(output, "modEff2", suspendWhenHidden = FALSE)
      # outputOptions(output, "modEff3", suspendWhenHidden = FALSE)

      show("goodnessEffDiv")
      show("downloadDiv")
    })

    scrollTo("goodnessEffDiv")
  })
}
