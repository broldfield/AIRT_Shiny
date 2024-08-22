output$downlBtn <- downloadHandler(
       filename = "airt-data.tar",
       content = function(file) {
              tmpDir <- tempdir()
              setwd(tempdir())

              withProgress(message = "Creating File...", {
                     disable("downlBtn")

                     ggsave("Plot 1 - Merged.png",
                            plot = generate_plot(1, "0"),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )
                     incProgress(0.1)
                     ggsave("Plot 2 - Seperate.png",
                            plot = generate_plot(2, "0"),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )
                     incProgress(0.1)
                     ggsave("Plot 3 - Spline.png",
                            plot = generate_plot(3, "0"),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )
                     incProgress(0.1)
                     ggsave("Plot 4 - Epsilon 0.png",
                            plot = generate_plot(4, "0"),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )
                     incProgress(0.1)
                     ggsave("Plot 4 - Epsilon 0.01.png",
                            plot = generate_plot(4, "0.01"),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )
                     ggsave("Plot 4 - Epsilon 0.03.png",
                            plot = generate_plot(4, "0.03"),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )
                     incProgress(0.1)
                     ggsave("Heat Map.png",
                            plot = generate_heatmap(),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )
                     incProgress(0.1)
                     ggsave("Goodness.png",
                            plot = generate_goodness(),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )
                     incProgress(0.1)
                     ggsave("Model Eff 1.png",
                            plot = generate_model_eff(2),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )
                     incProgress(0.1)
                     ggsave("Model Eff 2.png",
                            plot = generate_model_eff(3),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )
                     incProgress(0.1)
                     ggsave("Model Eff 3.png",
                            plot = generate_model_eff(3),
                            height = 1080,
                            width = 1920,
                            units = "px",
                            device = "png"
                     )

                     incProgress(0.1)
                     write.csv(generate_paras_table(), "IRT_Params.csv")
                     write.csv(generate_anom_table(), "AIRT_Attributes.csv")

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
