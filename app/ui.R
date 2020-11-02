library(shiny)
library(DT)
source('filter_var.R')

# Define UI for application that draws a histogram
ui <- fluidPage(
  includeCSS(here::here('salary-treemap', 'app/static/style.css')),
  navbarPage("App Title", 
             tabPanel("Table"),
             tabPanel("Plot", h1('test')),
             tabPanel("etc.")
  ),
  # titlePanel("City of Chicago Employee Salaries"),
  fluidRow(
    column(id="intro", 12,
           h2("Features"),
           p("The City of Chicago has more than 30,000 employees in 35 different departments.
                 The table below shows salaries of every city employee that can be filtered by name,
                 department, name, and salary range."),
           p("Data is taken from", 
             a("Chicago open data portal", 
               href = "https://data.cityofchicago.org/"),
             "and last retrieved on ", format(df_date, format="%B %d %Y"),"."),
           hr()),
    
    # column(12, align="center",
    #        includeHTML("..//ChicagoTreemap.html"),
    #        hr())
  ),
  sidebarLayout(
    sidebarPanel(id="sidebar",
                 helpText("Filter employees with the following:"),
                 uiOutput('clearable_filters'),
                 actionButton("clear_filter", "Clear Filter")
    ),
    mainPanel(
      dataTableOutput("data")
    )
  )
)
