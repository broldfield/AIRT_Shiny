# TODO: Look at how slow re-computing is.

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

  source("plotting.R", local = TRUE)
  source("getters.R", local = TRUE)
  source("validation.R", local = TRUE)
  source("downloader.R", local = TRUE)

  thematic_shiny(font = "Lato")

  # Toggles when user uploads a csv
  user_upload <- reactiveVal(FALSE)
  upload_valid <- reactiveVal(FALSE)

  scale_selected <- reactiveVal(TRUE)
  scale_method <- reactiveVal("single")
  max_item <- reactiveVal(1)
  invert_df <- reactiveVal(FALSE)

  csv_choice <- reactiveVal(0)
  anomal_val <- reactiveVal(0)

  colnames_val <- reactiveVal(0)

  se_ticked <- reactiveVal(TRUE)
  spline_last_clicked <- reactiveVal("Full")

  # Handles Scrolling to Div. Triggered in observes by btns.
  scroll_to <- function(eleId) {
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

  hide_all <- function() {
    hide(selector = "div.hidden")
  }

  observeEvent(input$seCheckBox, {
    if (input$seCheckBox == TRUE) {
      se_ticked(TRUE)
    } else {
      se_ticked(FALSE)
    }
  })

  observeEvent(input$scaleData, {
    hide_all()

    if (input$scaleData == TRUE) {
      scale_selected(TRUE)
    } else {
      scale_selected(FALSE)
    }
  })

  observeEvent(input$invertData, {
    hide_all()

    if (input$invertData == TRUE) {
      invert_df(TRUE)
    } else {
      invert_df(FALSE)
    }
  })

  observeEvent(input$scale_method, {
    hide_all()

    if (input$scale_method == "single") {
      scale_method("single")
    } else {
      scale_method("multiple")
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
    if (csv_choice() == 0 && !user_upload()) {
      showNotification(
        "Must upload a valid file or select an Example.",
        duration = NULL,
        id = "nothingSelected"
      )
      hide_all()
    } else if (user_upload()) {
      # Valid Conditions for using CSV
      if (upload_valid()) {
        withProgress(message = "Computing...", {
          hide_all()

          updateActionButton(session, "compute", label = "Loading")

          disable("compute")
          updateSelectInput(session, "splineSelectAlgo", selected = "")
          updateRadioButtons(session, "epsilonAuto4", selected = "0")
          updateTabsetPanel(session, "auto1And2Tabs", selected = "Merged")
          updateTabsetPanel(session, "Goodness", selected = "goodnessPlot")


          # Update the column names to allow the user to select an algo
          colnames_val(get_colnames())
          updateSelectInput(session, "splineSelectAlgo", choices = c("", colnames_val()))
          incProgress(0.5)



          # Then generate and render the table
          # Pregenerate the Obj and Modout. As it is in compute, whenever compute is called obj will be updated.
          get_obj()
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
      if (csv_choice() != 0 && !user_upload()) {
        withProgress(message = "Computing...", {
          hide_all()
          updateActionButton(session, "compute", label = "Loading...")

          disable("compute")

          updateSelectInput(session, "splineSelectAlgo", selected = "")
          updateRadioButtons(session, "epsilonAuto4", selected = "0")
          updateTabsetPanel(session, "auto1And2Tabs", selected = "Merged")

          # Update the column names to allow the user to select an algo
          colnames_val(get_colnames())
          updateSelectInput(session, "splineSelectAlgo", choices = c("", colnames_val()))

          incProgress(0.5)



          # Then generate and render the table
          # Pregenerate the Obj and Modout. As it is in compute, whenever compute is called obj will be updated.
          get_obj()
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
    hide_all()
    req(uploaded_csv())
    user_upload(TRUE)
    validateCsv()
  })

  # Shows the Paras Table post successful csv upload (or example btn)
  showParas <- function() {
    withProgress(message = "Reading File...", {
      removeNotification("csvValidToast")

      # make sure the column names are updated on re-render.
      colnames_val(get_colnames())
      updateSelectInput(session, "splineSelectAlgo", choices = c("", colnames_val()))

      output$parasTable <- renderUI({
        DT::dataTableOutput(ns("parasDT"))
      })
      incProgress(0.5)

      output$parasDT <- renderDT({
        dt <- generate_paras_table()
        colnames(dt) <- c("Discrimination", "Difficulty", "Scaling")
        datatable(dt, selection = "single") %>%
          formatRound(c("Discrimination", "Difficulty", "Scaling"), digits = 4)
      })

      # use NS to get the ID of anomalDT
      output$anomal <- renderUI({
        DT::dataTableOutput(ns("anomalDT"))
      })

      #
      output$anomalDT <- renderDT(
        datatable(generate_anom_table(), selection = "single") %>% formatRound(c("consistency", "difficulty_limit"), digits = 4)
          %>% formatRound("anomalousness", digits = 0)
      )
      incProgress(0.5)

      scroll_to("downloadDiv")
    })
  }

  observeEvent(input[[ns("parasDT_rows_selected")]], {
    selected_row <- input[[ns("parasDT_rows_selected")]]
  })
  observeEvent(input[[ns("anomalDT_rows_selected")]], {
    selected_row <- input[[ns("anomalDT_rows_selected")]]
    algo <- colnames_val()[selected_row]
    withProgress(message = "Loading...", {
      output$anomBoxplot <- renderUI({
        renderPlot({
          generate_anom_boxplot(algo)
        })
      })
      output$anomBoxplotText <- renderUI({
        HTML(paste("<i>The ", algo, " algorithm is highlighted. A distant mix/max value may distort the plot.</i>"))
      })

      show("anomBoxplotDiv")
      scroll_to("anomBoxplotDiv")
    })
  })




  observeEvent(input$exampleFile, {
    hide_all()

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

    csv_choice(choice)
    user_upload(FALSE)
    # Prevent blank csv from being loaded on startup
  })

  # Anomalousness Table
  observeEvent(input$parasCont, {
    withProgress(message = "Loading...", {
      show("anomDiv")
      scroll_to("anomDiv")
    })
  })

  # Heat Map
  observeEvent(input$anomalCont, {
    withProgress(message = "Loading...", {
      output$heatMap <- renderUI({
        renderPlot({
          generate_heatmap()
        })
      })
      show("heatMapDiv")
    })

    scroll_to("heatMapDiv")
  })

  # Plot Type 1 + 2
  observeEvent(input$heatMapCont, {
    withProgress(message = "Loading...", {
      output$auto1 <- renderUI({
        renderPlot({
          generate_plot(1, epsilon_str = "0")
        })
      })

      incProgress(0.5)
      output$auto2 <- renderUI({
        renderPlot({
          generate_plot(2, epsilon_str = "0")
        })
      })

      incProgress(0.5)

      show("auto1And2Div")
      scroll_to("auto1And2Div")
    })
  })

  # Plot Type 3
  observeEvent(input$auto1And2Cont, {
    withProgress(message = "Loading...", {
      spline_last_clicked("Full")
      output$auto3 <- renderUI({
        renderPlot({
          generate_splines(se_ticked())
        })
      })

      incProgress(1)
      show("auto3Div")
    })

    scroll_to("auto3Div")
  })


  observeEvent(input$splineSelectAlgo, {
    withProgress(message = "Loading...", {
      spline_last_clicked("Select")
      output$auto3 <- renderUI({
        renderPlot({
          generate_spline_plot(input$splineSelectAlgo, se_ticked())
        })
      })
    })
  })

  observeEvent(input$resetSpline, {
    spline_last_clicked("Full")
    output$auto3 <- renderUI({
      renderPlot({
        generate_splines(se_ticked())
      })
    })
  })

  observeEvent(input$seCheckBox, {
    if (spline_last_clicked() == "Full") {
      output$auto3 <- renderUI({
        renderPlot({
          generate_splines(se_ticked())
        })
      })
    } else {
      output$auto3 <- renderUI({
        renderPlot({
          generate_spline_plot(input$splineSelectAlgo, se_ticked())
        })
      })
    }
  })

  # Plot Type 4
  observeEvent(input$auto3Cont, {
    withProgress(message = "Loading...", {
      output$auto4 <- renderUI({
        renderPlot({
          generate_plot(4, epsilon_str = input$epsilonAuto4)
        })
      })
      incProgress(0.5)

      show("auto4Div")
    })
    scroll_to("auto4Div")
  })

  # Goodness Plot + modEff1-3
  observeEvent(input$auto4Cont, {
    withProgress(message = "Loading...", {
      output$goodnessPlot <- renderUI({
        renderPlot({
          generate_goodness()
        })
      })
      incProgress(0.2)
      output$modEff1 <- renderUI({
        renderPlot({
          generate_model_eff(1)
        })
      })
      incProgress(0.2)
      output$modEff2 <- renderUI({
        renderPlot({
          generate_model_eff(2)
        })
      })
      incProgress(0.2)
      output$modEff3 <- renderUI({
        renderPlot({
          generate_model_eff(3)
        })
      })
      incProgress(0.2)

      show("goodnessEffDiv")
      show("downloadDiv")
    })

    scroll_to("goodnessEffDiv")
  })
}
