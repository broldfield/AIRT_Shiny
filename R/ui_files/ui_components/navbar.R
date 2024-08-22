navbar <- div(
  style = "width:100%; margin-left: auto; margin-right: auto; box-shadow: 7px 7px 3px #cdcdcd; overflow: none;",
  navbarPage(
    title = "AIRT",
    collapsible = TRUE,
    tabPanel(
      a(style = "color:rgba(255, 255, 255, 0.65); margin-top: -15px; padding-right:10px; padding-left:10px;", class = "item", href = route_link("/"), "Home"),
    ),
    tabPanel(
      a(style = "color:rgba(255, 255, 255, 0.65);margin-top: -15px; padding-right:10px; padding-left:10px;", class = "item", href = route_link("dashboard"), "Dashboard"),
    ),
    tabPanel(
      title = a(style = "color:rgba(255, 255, 255, 0.65);margin-top: -15px; padding-right:10px;padding-left:10px;",class = "item", href = 'https://sevvandi.github.io/airt/', target = "_blank", "Docs"),
    )
  ),
)