get_data <- reactive({
  df <- ""
  if (user_upload()) {
    df <- uploaded_csv()

    # If the user selects to invert the data, we will multiply the data by -1 and add the max value to it.
    if (invert_df() == TRUE) {
      max_val <- max(df)
      max_item(max_val)
      df <- df * (-1)
      df <- df + (max_val)
      return(df)
    }

    # Reset max_val to 1 when input isn't selected
    max_item(1)

    return(df)
  } else {
    df <- switch(csv_choice(),
      "Anomaly" = Anomaly,
      "MaxCut" = MaxCut,
      "TimeSeriesForecasting" = TimeSeriesForecasting,
      "Clustering" = Clustering,
      Classification
    )

    # If the user selects to invert the data, we will multiply the data by -1 and add the max value to it.
    if (invert_df() == TRUE) {
      max_val <- max(df)
      max_item(max_val)
      df <- df * (-1)
      df <- df + (max_val)
      return(df)
    }

    # Reset max_val to 1 when input isn't selected
    max_item(1)

    return(df)
  }
})

uploaded_csv <- reactive({
  csv <- read.csv(input$upload$datapath)
})

get_paras <- reactive({
  modout <- get_modout()
  paras <- modout$model$param
})

get_obj <- reactive({
  df <- get_data()
  modout <- get_modout()
  scale <- scale_selected()
  scale_method <- scale_method()
  max_val <- max_item()

  obj <- latent_trait_analysis(
    df,
    paras = modout$model$param,
    epsilon = 0,
    scale = scale,
    scale.method = scale_method,
    max.item = max_val
  )
  return(obj)
})

get_obj_with_epsilon <- function(epsilon_str = "0") {
  df <- get_data()
  modout <- get_modout()
  scale <- scale_selected()
  epsilon <- as.numeric(epsilon_str)
  scale_method <- scale_method()
  max_val <- max_item()

  obj <- latent_trait_analysis(
    df,
    paras = modout$model$param,
    epsilon = epsilon,
    scale = scale,
    scale.method = scale_method,
    max.item = max_val
  )
  return(obj)
}

get_obj1Per <- reactive({
  df <- get_data()
  modout <- get_modout()
  scale <- scale_selected()
  scale_method <- scale_method()
  max_val <- max_item()

  obj <- latent_trait_analysis(
    df,
    paras = modout$model$param,
    epsilon = 0.01,
    scale = scale,
    scale.method = scale_method,
    max.item = max_val
  )
  return(obj)
})

get_obj3Per <- reactive({
  df <- get_data()
  modout <- get_modout()
  scale <- scale_selected()
  scale_method <- scale_method()
  max_val <- max_item()

  obj <- latent_trait_analysis(
    df,
    paras = modout$model$param,
    epsilon = 0.03,
    scale = scale,
    scale.method = scale_method,
    max.item = max_val
  )
  return(obj)
})

get_modout <- reactive({
  df <- get_data()
  modout <- cirtmodel(df, scale = scale_selected(), scale.method = scale_method(), max.item = max_item())
  return(modout)
})

get_mod_good <- reactive({
  modGood <- model_goodness_crm(get_modout())
})

get_mod_eff <- reactive({
  modeleff <- effectiveness_crm(get_modout())
})

get_long_obj <- reactive({
  obj <- get_obj()
  dfl <- obj$longdf
})

get_colnames <- function() {
  df <- get_data()
  return(colnames(df))
}

get_LTO_strength <- function(obj) {
  LTO_Prop_str <- obj$strengths$proportions

  LTO_Prop_str <- LTO_Prop_str[c("Proportion", "algorithm")]

  LTO_Prop_str <- LTO_Prop_str[, c(2, 1)]

  colnames(LTO_Prop_str)[1] <- "Algorithm"

  return(as.data.frame(LTO_Prop_str))
}

get_LTO_weak <- function(obj) {
  LTO_Prop_weak <- obj$weakness$proportions

  LTO_Prop_weak <- LTO_Prop_weak[c("Proportion", "algorithm")]


  LTO_Prop_weak <- LTO_Prop_weak[, c(2, 1)]


  colnames(LTO_Prop_weak)[1] <- "Algorithm"

  return(as.data.frame(LTO_Prop_weak))
}
