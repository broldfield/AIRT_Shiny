# TODO: Convert showParas to a function so that it gets updated on reload.

library(shiny)

function(input, output, session) {
  load("data/MaxCut.rda")
  load("data/Anomaly.rda")
  load("data/Classification.rda")
  
  source("genPlot.R", local = TRUE)
  source("getters.R", local = TRUE)
  source("validation.R", local = TRUE)
  source("downloader.R", local = TRUE)
  
  thematic_shiny(font = "Lato")
  
  # Toggles when user uploads a csv
  userUpload = reactiveVal(FALSE)
  uploadValid = reactiveVal(FALSE)
  
  scaleSelected = reactiveVal(TRUE)
  scaleMethod = reactiveVal("single")
  
  csvChoice = reactiveVal(0)
  
  # Handles Scrolling to Div. Triggered in observes by btns.
  scrollTo = function(eleId) {
    string = paste0("document.getElementById('",
                    eleId,
                    "').scrollIntoView();")
    
    # Needs delay to give time for height to adjust for scroll.
    delay(200,
          runjs(string))
  }
  
  observeEvent(input$scaleData, {
    if (input$scaleData == TRUE) {
      scaleSelected(TRUE)
    } else {
      scaleSelected(FALSE)
    }
  })
  
  observeEvent(input$scaleMethod, {
    if (input$scaleMethod == "single") {
      scaleMethod("single")
    } else {
      scaleMethod("multiple")
    }
  })
  
  # Example Table
  dataCols = colnames(Classification[1:4])
  output$exampleTable = renderUI({
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
      ) %>% formatRound(dataCols , digits = 4)
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
    } else if (userUpload()) {
      # Valid Conditions for using CSV
      if (uploadValid()) {
        showParas()
        show("parasDiv")
        show("downloadDiv")
      }
      
    } else {
      # Valid Conditions for using Example File
      if (csvChoice() != 0 && !userUpload()) {
        showParas()
        show("parasDiv")
        show("downloadDiv")
      }
    }
    
  })
  
  # Upload csv + Paras Table Need to unlink them
  observeEvent(input$upload, {
    req(uploadedCsv())
    userUpload(TRUE)
    validateCsv()
  })
  
  # Shows the Paras Table post successful csv upload (or example btn)
  showParas = reactive({
    withProgress(message = "Reading File...", {
      removeNotification("csvValidToast")
      
      output$parasTable = renderUI({
        renderDataTable(datatable(generateParasTable())  %>% formatRound(c("a", "b", "alpha"), digits = 4))
      })
      incProgress(0.5)
      
      output$anomal = renderUI({
        renderDataTable(
          datatable(generateAnomTable()) %>% formatRound(c(
            "consistency", "difficulty_limit"
          ), digits = 4)
          %>% formatRound("anomalousness", digits = 0)
        )
      })
      incProgress(0.5)
      show("parasDiv")
      show("downloadDiv")
      
      scrollTo("downloadDiv")
    })
  })
  
  # Example Parse + Paras Table Need to unlink them
  observeEvent(input$exampleFile, {
    choice = switch(
      input$exampleFile,
      "Select Example File" = 0,
      "Anomaly Detection" = "Anomaly",
      "MaxCut Graph" = "MaxCut",
      "Classification" = "Classification"
    )
    
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
  
  # Heat Map
  observeEvent(input$anomalCont, {
    withProgress(message = "Loading...", {
      output$heatMap = renderUI({
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
      output$auto1 = renderUI({
        renderPlot({
          generatePlot(1, epsilonIn = 0)
        })
      })
      
      incProgress(0.5)
      output$auto2 = renderUI({
        renderPlot({
          generatePlot(2, epsilonIn = 0)
        })
      })
      
      # Output Options lets you load a plot when it isn't yet rendered. So use it in tabs.
      outputOptions(output, "auto2", suspendWhenHidden = FALSE)
      
      incProgress(0.5)
      
      show("auto1And2Div")
      scrollTo("auto1And2Div")
    })
  })
  
  # Plot Type 3
  observeEvent(input$auto1And2Cont, {
    withProgress(message = "Loading...", {
      output$auto3 = renderUI({
        renderPlot({
          generatePlot(3, epsilonIn = 0)
        })
      })
      
      incProgress(1)
      show("auto3Div")
    })
    
    scrollTo("auto3Div")
  })
  
  # Plot Type 4 No Epsilon + with
  observeEvent(input$auto3Cont, {
    withProgress(message = "Loading...", {
      output$auto4 = renderUI({
        renderPlot({
          generatePlot(4, epsilonIn = 0)
        })
      })
      incProgress(0.5)
      output$auto4Ep = renderUI({
        renderPlot({
          generatePlot(4, epsilonIn = 2)
        })
      })
      incProgress(0.5)
      
      outputOptions(output, "auto4Ep", suspendWhenHidden = FALSE)
      show("auto4Div")
    })
    scrollTo("auto4Div")
  })
  
  # Goodness Plot + modEff1-3
  observeEvent(input$auto4Cont, {
    withProgress(message = "Loading...", {
      output$goodnessPlot = renderUI({
        renderPlot({
          generateGoodness()
        })
      })
      incProgress(0.2)
      output$modEff1 = renderUI({
        renderPlot({
          generateModelEff(1)
        })
      })
      incProgress(0.2)
      output$modEff2 = renderUI({
        renderPlot({
          generateModelEff(2)
        })
      })
      incProgress(0.2)
      output$modEff3 = renderUI({
        renderPlot({
          generateModelEff(3)
        })
      })
      incProgress(0.2)
      
      outputOptions(output, "modEff1", suspendWhenHidden = FALSE)
      outputOptions(output, "modEff2", suspendWhenHidden = FALSE)
      outputOptions(output, "modEff3", suspendWhenHidden = FALSE)
      
      show("goodnessEffDiv")
      show("downloadDiv")
    })
    
    scrollTo("goodnessEffDiv")
  })
}
