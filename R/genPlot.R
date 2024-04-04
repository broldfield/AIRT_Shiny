 # Generates plots, epsilon != to use epsilon.
  generatePlot = function(plotNum, epsilonIn) {
    if (epsilonIn == 0) {
      obj = getObj0Per()
    } else {
      obj = getObj5Per()
    }
    
        autoplot(obj, plottype = plotNum, epsilon = epsilonIn) + theme_pander(boxes = TRUE, gc = "lightgray")
  }
  
  
  generateHeatMap = function() {
    modout = getModout()
    obj = heatmaps_crm(modout)
        autoplot(obj) + theme_pander(boxes = TRUE, gc = "lightgray")
  }
  
  generateParasTable = function() {
    modout = getModout()
    paras = getParas()
    return(paras)
  }
  
  generateAnomTable = function() {
    modout = getModout()
          cbind.data.frame(
            anomalousness = modout$anomalous,
            consistency = modout$consistency,
            difficulty_limit = modout$difficulty_limit
        )
  }
  
  generateGoodness = function() {
    goodModel = getModGood()
        autoplot(goodModel) + theme_pander(boxes = TRUE, gc = "lightgray")
  }
  
 
  generateModelEff = function(plotType) {
    modelEff = getModEff()
        autoplot(modelEff, plottype = plotType) + theme_pander(boxes = TRUE, gc = "lightgray")
  }
  
  # Not used ATM
  generateStrTable = function() {
    obj2 = getObj5Per()
      datatable(obj2$strengths$proportions)
  }