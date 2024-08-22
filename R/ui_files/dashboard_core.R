source("./ui_files/ui_components/main_body_dashboard.R", local = TRUE)
source("./ui_files/ui_components/sidebar_dashboard.R", local = TRUE)
source("./ui_files/ui_components/options_dashboard.R", local = TRUE)
source("./ui_files/ui_components/header_dashboard.R", local = TRUE)

dashboard_page <- div(div(
  class = "parent_grid",
  div(class = "header_grid grid_container", header),
  div(class = "sidebar_grid grid_container", hidden(div(id = "sidebar", sidebar))),
  div(class = "main_grid grid_container", main_dash),
  div(class = "options_grid grid_container", hidden(div(id = "options", options)))
), )