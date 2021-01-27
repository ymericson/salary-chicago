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
                       column(align="left", 12,
                              p("This website shows salaries for Chicago of Chicago employees in calendar year 2020. 
                                The graph breaks down how the city allocates its salary budget across different departments and jobs.",
                                a("Chicago Data Portal", href="https://data.cityofchicago.org/Administration-Finance/Current-Employee-Names-Salaries-and-Position-Title/xzkq-xp2w/data"),
                                "provides base salary data for each employee by department job titles."),
                                
                              p("Click on any of the cells below to drill deeper, or on the title to go back up a level. 
                                Departments or job titles too small to be displayed are grouped in the OTHER category."),
                              p("The data does not include employees working for Chicago Public Schools, Chicago Transit Authority, METRA, Cook County, or the state of Illinois."),
                              hr()
                        )
                     ),
                      fluidRow(
                        column(12, align="center",
                               includeHTML(here("figures/ChicagoTreemap.html")),
                               hr())
                    ),
                    fluidRow(
                      column(align="left", 10, p("Link to", a("GitHub repository", href="https://github.com/ymericson/salary-chicago")))
                    )
            ),
            tabPanel("Table", 
                      fluidRow(
                        column(id="intro", 12,
                               h2("Summary"),
                               p("The City of Chicago has more than 35,000 employees in 35 different departments.
                                     The table below shows salaries of all municipal employees as of the close of calendar year 2020.
                                     Each record represents the following statistics for every city employee: name,
                                     department, name, and salary/overtime range."),
                               p("Data is provided by the Department of Finance through FOIA request. Download data",
                                 a("here", href="https://github.com/ymericson/salary-chicago/raw/main/data/foia_salary_11092020.csv")),
                               p("Link to", a("GitHub repository", href="https://github.com/ymericson/salary-chicago")),
                               
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
