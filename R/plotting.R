# Generates plots, epsilon != to use epsilon.
generate_plot <- function(plot_num, epsilon_str = "0") {
  obj <- NULL

  if (epsilon_str == "0") {
    obj <- get_obj()
  } else {
    obj <- get_obj_with_epsilon(epsilon_str)
  }

  if (plot_num == 4) {
    LTOStr <- get_LTO_strength(obj)
    LTOWeak <- get_LTO_weak(obj)


    output$strengthLTO <- renderUI({
      DT::datatable(LTOStr,
        selection = "single",
        rownames = FALSE,
        options = list(
          pageLength = 5,
          searching = FALSE,
          paging = TRUE,
          lengthChange = FALSE,
          info = FALSE,
          ordering = FALSE
        )
      ) %>% formatRound(c("Proportion"), digits = 4)
    })
    output$weaknessLTO <- renderUI({
      DT::datatable(LTOWeak,
        selection = "single",
        rownames = FALSE,
        options = list(
          pageLength = 5,
          searching = FALSE,
          paging = TRUE,
          lengthChange = FALSE,
          info = FALSE,
          ordering = FALSE
        )
      ) %>% formatRound(c("Proportion"), digits = 4)
    })
  }

  autoplot(obj, plottype = plot_num, epsilon = as.numeric(epsilon_str)) + theme_pander(boxes = TRUE, gc = "lightgray")
}


generate_heatmap <- function() {
  modout <- get_modout()
  obj <- heatmaps_crm(modout)
  autoplot(obj) + theme_pander(boxes = TRUE, gc = "lightgray")
}

generate_paras_table <- function() {
  modout <- get_modout()
  paras <- get_paras()
  return(paras)
}

generate_anom_table <- function() {
  modout <- get_modout()
  cbind.data.frame(
    anomalousness = modout$anomalous,
    consistency = modout$consistency,
    difficulty_limit = modout$difficulty_limit
  )
}

generate_goodness <- function() {
  goodModel <- get_mod_good()
  autoplot(goodModel) + theme_pander(boxes = TRUE, gc = "lightgray")
}


generate_model_eff <- function(plotType) {
  modelEff <- get_mod_eff()
  autoplot(modelEff, plottype = plotType) + theme_pander(boxes = TRUE, gc = "lightgray")
}

# Create Boxplots
generate_anom_boxplot <- function(algoName) {
  modout <- get_modout()
  anomDT <- cbind.data.frame(
    anomalousness = modout$anomalous,
    consistency = modout$consistency,
    difficulty_limit = modout$difficulty_limit
  )

  anomDT_longdf <- reshape2::melt(as.matrix(anomDT), value.name = "Score", varnames = c("Algorithm", "Attribute"))

  diff_limit_longdf <- anomDT_longdf %>% dplyr::filter(Attribute == "difficulty_limit")
  consistency_longdf <- anomDT_longdf %>% dplyr::filter(Attribute == "consistency")

  interest_diff <- diff_limit_longdf %>% dplyr::filter(Algorithm == algoName)
  interest_consist <- consistency_longdf %>% dplyr::filter(Algorithm == algoName)

  dl_plot <- ggplot(diff_limit_longdf, aes(Score, "")) +
    geom_boxplot() +
    geom_point(
      data = diff_limit_longdf,
      aes(x = Score, y = ""),
      color = "#868788", size = 4, alpha = 0.30
    ) +
    geom_point(
      data = interest_diff,
      aes(x = Score, y = ""),
      color = "#007ba7", size = 5, alpha = 0.55
    ) +
    ggtitle("Difficulty Limit") +
    theme_pander(boxes = TRUE, gc = "lightgray") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1), axis.title.y = element_blank())

  consist_plot <- ggplot(consistency_longdf, aes(Score, "")) +
    geom_boxplot() +
    geom_point(
      data = consistency_longdf,
      aes(x = Score, y = ""),
      color = "#868788", size = 4, alpha = 0.30
    ) +
    geom_point(
      data = interest_consist,
      aes(x = Score, y = ""),
      color = "#007ba7", size = 5, alpha = 0.55
    ) +
    ggtitle("Consistency") +
    theme_pander(boxes = TRUE, gc = "lightgray") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1), axis.title.y = element_blank())

  manual_plot3 <- ggarrange(consist_plot, dl_plot, ncol = 1, nrow = 2)
  return(manual_plot3)
}

# Create graph for single Algo
# Autoplot Type 1
generate_plot_1 <- function() {
  dfl <- get_long_obj()
  manual_plot1 <- ggplot(dfl, aes(Latent_Trait, value)) +
    geom_point(aes(color = Algorithm)) +
    xlab("Problem Difficulty") +
    ylab("Performance") +
    theme_pander(boxes = TRUE, gc = "lightgray") +
    theme_bw() +
    theme(legend.position = "right", legend.box = "vertical")

  highlightPlot1 <- plot1 + gghighlight(Algorithm == "NB", keep_scales = TRUE, unhighlighted_params = list(color = "black"))
}

generate_spline_plot <- function(algoName, se = TRUE) {
  latenttrait <- Latent_Trait <- value <- Algorithm <- NULL
  dfl <- get_long_obj()

  g1 <- ggplot(dfl, aes(Latent_Trait, value)) +
    geom_smooth(aes(color = Algorithm), se = se, method = "gam", formula = y ~ s(x, bs = "cs")) +
    xlab("Problem Difficulty") +
    ylab("Performance") +
    theme_bw() +
    theme_pander(boxes = TRUE, gc = "lightgray") +
    theme(legend.position = "right", legend.box = "vertical")

  g2 <- g1 + gghighlight(Algorithm == algoName, unhighlighted_params = list(color = "black"))
  return(g2)
}

generate_splines <- function(se = TRUE) {
  latenttrait <- Latent_Trait <- value <- Algorithm <- NULL
  dfl <- get_long_obj()

  g1 <- ggplot(dfl, aes(Latent_Trait, value)) +
    geom_smooth(aes(color = Algorithm), se = se, method = "gam", formula = y ~ s(x, bs = "cs")) +
    xlab("Problem Difficulty") +
    ylab("Performance") +
    theme_bw() +
    theme_pander(boxes = TRUE, gc = "lightgray") +
    theme(legend.position = "right", legend.box = "vertical")

  return(g1)
}
