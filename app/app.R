#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("App"),
    
    sidebarLayout(
        sidebarPanel(
            helpText("Filter employees with the following:"),
            
            textInput("lname",
                      label = "Name", 
                      placeholder = "Last Name"),
            selectInput("department",
                        label = "Department",
                        selected = NULL,
                        choices = sort(unique(df_app$Department), decreasing = FALSE),
                        multiple = TRUE),
            sliderInput("salary", 
                        label = "Salary Range",
                        min = 0, max = max(df_app$`Annual Salary`), value = c(0, 0))
        ),
         
        mainPanel()
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$selected_var <- renderText({ 
        paste("You have selected", input$var)
    })
    
    output$min_max <- renderText({ 
        paste("You have chosen a range that goes from",
              input$range[1], "to", input$range[2])
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
