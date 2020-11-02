library(shiny)
library(DT)
source('filter_var.R')

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