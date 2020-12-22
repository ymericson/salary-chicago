library(shiny)
library(DT)
library(here)
source('filter_var.R')

# Define UI for application that draws a histogram
ui <- fluidPage(
  # includeCSS(here::here('salary-treemap', 'app/static/style.css')),
  navbarPage(id='navbar', "City of Chicago Salaries", 
            tabPanel("Graph", 
                      fluidRow(
                        column(12, align="center",
                               includeHTML(here("figures/ChicagoTreemap.html")),
                               hr())
                    )
            ),
            tabPanel("Table", 
                      fluidRow(
                        column(id="intro", 12,
                               h2("Summary"),
                               p("The City of Chicago has more than 30,000 employees in 35 different departments.
                                     The table below shows salaries of every city employee that can be filtered by name,
                                     department, name, and salary range."),
                               hr()
                        ),
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


  ),
)
