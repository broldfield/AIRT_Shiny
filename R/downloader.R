output$downlBtn <- downloadHandler(
       filename = "airt-data.tar",
       content = function(file) {
              tmpDir <- tempdir()
              setwd(tempdir())

              withProgress(message = "Creating File...", {
                     disable("downlBtn")

                     ggsave("Plot 1 - Merged.png",
                            plot = generatePlot(1, "0"),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )
                     incProgress(0.1)
                     ggsave("Plot 2 - Seperate.png",
                            plot = generatePlot(2, "0"),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )
                     incProgress(0.1)
                     ggsave("Plot 3 - Spline.png",
                            plot = generatePlot(3, "0"),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )
                     incProgress(0.1)
                     ggsave("Plot 4 - Epsilon 0.png",
                            plot = generatePlot(4, "0"),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )
                     incProgress(0.1)
                     ggsave("Plot 4 - Epsilon 0.01.png",
                            plot = generatePlot(4, "0.01"),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )
                     ggsave("Plot 4 - Epsilon 0.03.png",
                            plot = generatePlot(4, "0.03"),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )
                     incProgress(0.1)
                     ggsave("Heat Map.png",
                            plot = generateHeatMap(),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )
                     incProgress(0.1)
                     ggsave("Goodness.png",
                            plot = generateGoodness(),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )
                     incProgress(0.1)
                     ggsave("Model Eff 1.png",
                            plot = generateModelEff(2),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )
                     incProgress(0.1)
                     ggsave("Model Eff 2.png",
                            plot = generateModelEff(3),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )
                     incProgress(0.1)
                     ggsave("Model Eff 3.png",
                            plot = generateModelEff(3),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )

                     incProgress(0.1)
                     write.csv(generateParasTable(), "IRT_Params.csv")
                     write.csv(generateAnomTable(), "AIRT_Attributes.csv")

                     enable("downlBtn")

                     tar(
                            tarfile = file,
                            files = c(
                                   "Plot 1 - Merged.png",
                                   "Plot 2 - Seperate.png",
                                   "Plot 3 - Spline.png",
                                   "Plot 4 - Epsilon 0.png",
                                   "Plot 4 - Epsilon 0.01.png",
                                   "Plot 4 - Epsilon 0.03.png",
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
