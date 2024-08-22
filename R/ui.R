#Shiny Packages
library(shiny)
library(shinyjs)
library(shinyWidgets)
library(shiny.router)

#airt 
library(airt)
library(ggplot2)
library(tidyr)
library(gridExtra)

# Styling
library(bslib)
library(thematic)
library(ggthemes)
library(DT)

# Used for formatting the custom plots
library(reshape2)
library(gghighlight)
library(dplyr)
library(ggpubr)

# UI imports to make everything cleaner
source("./ui_files/presentation_core.R", local = TRUE)
source("./ui_files/dashboard_core.R", local = TRUE)
source("./ui_files/ui_components/navbar.R", local = TRUE)



ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  setBackgroundColor(color = "#f5f5f5", shinydashboard = FALSE),
  
  title = "AIRT Shiny App",
  navbar,
  
  router_ui(
    route("/", presentation_page),
    route("dashboard", dashboard_page)
  )
)
