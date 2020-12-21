library(shiny)
library(here)

port <- Sys.getenv('PORT')
shiny::runApp(
  appDir = here("app/"),
  host = '0.0.0.0',
  port = as.numeric(port)
)