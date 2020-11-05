library(shiny)
library(DT)
source('filter_var.R')

# Define UI for application that draws a histogram
ui <- fluidPage(
  # includeCSS(here::here('salary-treemap', 'app/static/style.css')),
  navbarPage(id='navbar', "City of Chicago Salaries", 
             tabPanel("Table", 
                      fluidRow(
                        column(id="intro", 12,
                               h2("Summary"),
                               p("The City of Chicago has more than 30,000 employees in 35 different departments.
                                     The table below shows salaries of every city employee that can be filtered by name,
                                     department, name, and salary range."),
                               p("Data is taken from", 
                                 a("Chicago open data portal", 
                                   href = "https://data.cityofchicago.org/"),
                                 "and last retrieved on ", format(df_date, format="%B %d %Y"),"."),
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
             
            ),             
            tabPanel("Graph", 
                      fluidRow(
                        column(12, align="center",
                               includeHTML("..//d3tree2.html"),
                               hr())
                    )
            )

  ),
)
