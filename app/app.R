#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

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
            textInput("lname",
                      label = "Name", 
                      placeholder = "Last Name"),
            selectInput("dept",
                        label = "Department",
                        selected = NULL,
                        choices = sort(unique(df_app$Department), decreasing = FALSE),
                        multiple = TRUE),
            sliderInput("range", 
                        label = "Salary Range",
                        min = 0, max = max(df_app$`Salary`), value = c(0, 0)),
            actionButton("search", "Search"),
            actionButton("clear", "Clear Results")
            ),
        mainPanel(
            dataTableOutput("mytable"),
            textOutput("selected_var"),
            textOutput("min_max")
        )
    )
)

server <- function(input, output) {
    
    output$mytable <- renderDataTable(
        datatable(df_app, 
                  options = list(
                   
                      pageLength = 30, lengthChange = FALSE, searching = FALSE),
                  rownames = FALSE,
                  selection = 'none'
                  ) %>% 
            formatCurrency("Salary")
        )
    
    # 
    # output$mytable = renderDataTable(
    #     datatable(df_app %>% formatCurrency("Salary"),
    #     options = list(pageLength = 30, lengthChange = FALSE),
    #     rownames = FALSE)
    # )
}    
    
#     # reactive expression
#     text_reactive <- eventReactive( input$search, {
#         input$dept
#     })
#     
#     # text output
#     output$selected_var <- renderText({
#         text_reactive()
#     })
# }




# Run the application 
shinyApp(ui = ui, server = server)
