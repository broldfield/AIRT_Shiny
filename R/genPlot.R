# Generates plots, epsilon != to use epsilon.
generatePlot <- function(plotNum, epsilonIn = "0") {
  obj <- NULL
  obj <- switch(epsilonIn,
    "0" = getObj0Per(),
    "0.01" = getObj1Per(),
    "0.03" = getObj3Per(),
    getObj0Per()
  )

  autoplot(obj, plottype = plotNum, epsilon = as.numeric(epsilonIn)) + theme_pander(boxes = TRUE, gc = "lightgray")
}


generateHeatMap <- function() {
  modout <- getModout()
  obj <- heatmaps_crm(modout)
  autoplot(obj) + theme_pander(boxes = TRUE, gc = "lightgray")
}

generateParasTable <- function() {
  modout <- getModout()
  paras <- getParas()
  return(paras)
}

generateAnomTable <- function() {
  modout <- getModout()
  cbind.data.frame(
    anomalousness = modout$anomalous,
    consistency = modout$consistency,
    difficulty_limit = modout$difficulty_limit
  )
}

generateGoodness <- function() {
  goodModel <- getModGood()
  autoplot(goodModel) + theme_pander(boxes = TRUE, gc = "lightgray")
}


generateModelEff <- function(plotType) {
  modelEff <- getModEff()
  autoplot(modelEff, plottype = plotType) + theme_pander(boxes = TRUE, gc = "lightgray")
}

# Create Boxplots
generateAnomBoxplot <- function(algoName) {
  modout <- getModout()
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
generatePlot1 <- function() {
  dfl <- getLongObj()
  manual_plot1 <- ggplot(dfl, aes(Latent_Trait, value)) +
    geom_point(aes(color = Algorithm)) +
    xlab("Problem Difficulty") +
    ylab("Performance") +
    theme_pander(boxes = TRUE, gc = "lightgray") +
    theme_bw() +
    theme(legend.position = "right", legend.box = "vertical")

  highlightPlot1 <- plot1 + gghighlight(Algorithm == "NB", keep_scales = TRUE)
}

generateSplinePlot <- function(algoName) {
  latenttrait <- Latent_Trait <- value <- Algorithm <- NULL
  dfl <- getLongObj()

  g1 <- ggplot(dfl, aes(Latent_Trait, value)) +
    geom_smooth(aes(color = Algorithm), se = TRUE, method = "gam", formula = y ~ s(x, bs = "cs")) +
    xlab("Problem Difficulty") +
    ylab("Performance") +
    theme_bw() +
    theme_pander(boxes = TRUE, gc = "lightgray") +
    theme(legend.position = "bottom", legend.box = "horizontal")

  g2 <- g1 + gghighlight(Algorithm == algoName)
  return(g2)
}

# Not used ATM
generateStrTable <- function() {
  obj2 <- getObj5Per()
  datatable(obj2$strengths$proportions)
}

# Manually recreating Plots 1 and 3 for.
