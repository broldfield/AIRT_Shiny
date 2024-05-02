getData <- reactive({
  df <- ""
  if (userUpload()) {
    df <- uploadedCsv()

    # If the user selects to invert the data, we will multiply the data by -1 and add the max value to it.
    if (invertDf() == TRUE) {
      max_val <- max(df)
      maxItem(max_val)
      df <- df * (-1)
      df <- df + (max_val)
      return(df)
    }

    # Reset max_val to 1 when input isn't selected
    maxItem(1)

    return(df)
  } else {
    df <- switch(csvChoice(),
      "Anomaly" = Anomaly,
      "MaxCut" = MaxCut,
      "TimeSeriesForecasting" = TimeSeriesForecasting,
      "Clustering" = Clustering,
      Classification
    )

    # If the user selects to invert the data, we will multiply the data by -1 and add the max value to it.
    if (invertDf() == TRUE) {
      max_val <- max(df)
      maxItem(max_val)
      df <- df * (-1)
      df <- df + (max_val)
      return(df)
    }

    # Reset max_val to 1 when input isn't selected
    maxItem(1)

    return(df)
  }
})

uploadedCsv <- reactive({
  csv <- read.csv(input$upload$datapath)
})

getParas <- reactive({
  modout <- getModout()
  paras <- modout$model$param
})

getObj0Per <- reactive({
  df <- getData()
  modout <- getModout()
  scale <- scaleSelected()
  scaleMethod <- scaleMethod()
  max_val <- maxItem()

  obj <- latent_trait_analysis(
    df,
    paras = modout$model$param,
    epsilon = 0,
    scale = scale,
    scale.method = scaleMethod,
    max.item = max_val
  )
  return(obj)
})

getObj1Per <- reactive({
  df <- getData()
  modout <- getModout()
  scale <- scaleSelected()
  scaleMethod <- scaleMethod()
  max_val <- maxItem()

  obj <- latent_trait_analysis(
    df,
    paras = modout$model$param,
    epsilon = 0.01,
    scale = scale,
    scale.method = scaleMethod,
    max.item = max_val
  )
  return(obj)
})

getObj3Per <- reactive({
  df <- getData()
  modout <- getModout()
  scale <- scaleSelected()
  scaleMethod <- scaleMethod()
  max_val <- maxItem()

  obj <- latent_trait_analysis(
    df,
    paras = modout$model$param,
    epsilon = 0.03,
    scale = scale,
    scale.method = scaleMethod,
    max.item = max_val
  )
  return(obj)
})

getModout <- reactive({
  df <- getData()
  modout <- cirtmodel(df, scale = scaleSelected(), scale.method = scaleMethod(), max.item = maxItem())
  return(modout)
})

getModGood <- reactive({
  modGood <- model_goodness_crm(getModout())
})

getModEff <- reactive({
  modeleff <- effectiveness_crm(getModout())
})

getLongObj <- reactive({
  obj <- getObj0Per()
  dfl <- obj$longdf
})

getColNames <- function() {
  df <- getData()
  return(colnames(df))
}
