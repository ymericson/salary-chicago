library(shiny)
library(DT)

# Define UI for application that draws a histogram
ui <- fluidPage(
    tags$head(tags$style(
        HTML('
        #sidebar {
            background-color: #e6f0ff;
            }
        body, label, input, button, select { 
            font-family: "Calibri";
            font-size: 13px;
            }
        #mytable tr:hover {
            background-color: #e6f0ff
            }
            ')
    )),
    titlePanel("App"),
    sidebarLayout(
        sidebarPanel(id="sidebar",
            helpText("Filter employees with the following:"),
            textInput("name",
                      label = "Name", 
                      placeholder = "Last Name"),
            selectInput("dept",
                        label = "Department",
                        selected = NULL,
                        choices = sort(unique(df_app$Department), decreasing = FALSE),
                        multiple = TRUE),
            sliderInput("range", 
                        label = "Salary Range",
                        min = 0, max = max(df_app$`Salary`), 
                        value = c(0, max(df_app$`Salary`))),
            actionButton("clear", "Clear")
            ),
        mainPanel(
            textOutput("name"),
            textOutput("range"),
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
        filter_var(df_app$Department, input$dept) &
        filter_var(df_app$Salary, input$range)
    })
    output$data <- renderDataTable(datatable(df_app[selected(),],
                                             options = list(pageLength = 25,
                                                            lengthChange = FALSE,
                                                            searching = FALSE),
                                             rownames = FALSE,
                                             selection = 'none'
                                             ) %>%
                                       formatCurrency("Salary") 
    )
    output$name <- renderText({ input$name })
}



# Run the application 
shinyApp(ui = ui, server = server)
