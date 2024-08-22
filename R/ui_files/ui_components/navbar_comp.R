# Nav Bar styling
navbar_comp <- div(
  style = "width:100%; margin-left: auto; margin-right: auto; box-shadow: 7px 7px 3px #cdcdcd; overflow: none;",
  navbarPage(
    title = "AIRT",
    collapsible = TRUE,
    tabPanel(
      title = HTML(
        "</a></li><li><a href='https://sevvandi.github.io/airt/' target='_blank'>Docs"
      ),
      style = "margin: 30px 30px;"
    ),
  ),
)