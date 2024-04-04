
output$downlBtn <- downloadHandler(
    filename = "airt-data.tar",
    content = function(file) {
      tmpDir = tempdir()
      setwd(tempdir())
      
      withProgress(message = "Creating File...", {
        ggsave("Plot 1.png",
               plot = generatePlot(1, 0),
               device = "png")
        incProgress(0.1)
        ggsave("Plot 2.png",
               plot = generatePlot(2, 0),
               device = "png")
        incProgress(0.1)
        ggsave("Plot 3.png",
               plot = generatePlot(3, 0),
               device = "png")
        incProgress(0.1)
        ggsave("Plot 4 No Overlap.png",
               plot = generatePlot(4, 0),
               device = "png")
        incProgress(0.1)
        ggsave("Plot 4 Overlap.png",
               plot = generatePlot(4, 2),
               device = "png")
        incProgress(0.1)
        ggsave("Heat Map.png",
               plot = generateHeatMap(),
               device = "png")
        incProgress(0.1)
        ggsave("Goodness.png",
               plot = generateGoodness(),
               device = "png")
        incProgress(0.1)
        ggsave("Model Eff 1.png",
               plot = generateModelEff(2),
               device = "png")
        incProgress(0.1)
        ggsave("Model Eff 2.png",
               plot = generateModelEff(3),
               device = "png")
        incProgress(0.1)
        ggsave("Model Eff 3.png",
               plot = generateModelEff(3),
               device = "png")
        
        incProgress(0.1)
        write.csv(generateParasTable(), "IRT_Params.csv")
        write.csv(generateAnomTable(), "AIRT_Attributes.csv")
        
        tar(
          tarfile = file,
          files = c(
            "Plot 1.png",
            "Plot 2.png",
            "Plot 3.png",
            "Plot 4 Overlap.png",
            "Plot 4 No Overlap.png",
            "IRT_Params.csv",
            "AIRT_Attributes.csv",
            "Heat Map.png",
            "Goodness.png",
            "Model Eff 1.png",
            "Model Eff 2.png",
            "Model Eff 3.png"
          )
        )
      })
    },
  )