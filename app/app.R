library(shiny)
library(DT)

# Define UI for application that draws a histogram
ui <- fluidPage(
    tags$head(tags$style(
        HTML('
        #sidebar {
            background-color: #e4ebf5;
        }
        body, label, input, button, select, body div p { 
            font-family: "Helvetica";
            font-size: 13px;
        }
        #data tr:hover {
            background-color: #e6f0ff
        }
        #htmlwidget_container text {
            font-size: 12px;
        }
        .navbar {
            font-size: 16px;
        }
        #intro div p {
            font-size: 126px;
        }
            ')
    )),
    navbarPage("App Title",
               tabPanel("Table"),
               tabPanel("Plot"),
               tabPanel("Table")
    ),
    titlePanel("City of Chicago Employee Salaries"),
    fluidRow(
        column(id="intro", 12,
               h2("Features"),
               p("The City of Chicago has more than 30,000 employees in 35 different departments.
                 The table below shows salaries of every city employee that can be filtered by name,
                 department, name, and salary range."),
               p("Data is taken from", 
                 a("Chicago open data portal", 
                   href = "https://data.cityofchicago.org/"),
                 "and last retrieved on ", format(Sys.Date(), format="%B %d %Y"),".")),

        column(12, align="center",
               includeHTML("..//ChicagoTreemap.html"),
               hr())
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

filter_var <- function(x, val) {
    if (is.numeric(val)) {
        x >= val[1] & x <= val[2]
    } else if (length(val) != 0) {
        x %in% val
    } else {
        TRUE
        }
} 

server <- function(input, output, session) {
    selected <- reactive({
        str_detect(str_split_fixed(df_app$Name, ",", 2)[,1], str_to_title(input$name)) &
        filter_var(df_app$deptFreq, input$dept) &
        filter_var(df_app$Job, input$job) &    
        filter_var(df_app$Salary, input$range)
    })
    output$data <- renderDataTable(datatable(df_app[selected(),] %>% select("Name", "Department", "Job", "Salary"),
                                             options = list(pageLength = 25,
                                                            lengthChange = FALSE,
                                                            searching = FALSE),
                                             rownames = FALSE,
                                             selection = 'none'
                                             ) %>%
                                       formatCurrency("Salary") 
    )
    output$clearable_filters <- renderUI({
        times <- input$clear_filter
        div(id=letters[(times %% length(letters)) + 1],
            textInput("name",
                      label = "Name", 
                      placeholder = "Last Name"),
            selectInput("dept",
                        label = "Department",
                        selected = NULL,
                        choices = sort(unique(df_app$deptFreq), decreasing = FALSE),
                        multiple = TRUE),
            selectInput("job",
                        label = "Job Title",
                        selected = NULL,
                        choices = sort(unique(df_app$Job), decreasing = FALSE),
                        multiple = TRUE),
            uiOutput("secondSelection"),
            sliderInput("range", 
                        label = "Salary Range",
                        min = 0, max = max(df_app$`Salary`), 
                        value = c(0, max(df_app$`Salary`))))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
