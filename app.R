# Install dulu jika belum
# install.packages(c("shiny", "plotly", "DT"))

library(shiny)
library(plotly)
library(DT)

# Load dataset cuaca
data <- read.csv("weather.csv")

# UI
ui <- fluidPage(
  titlePanel("Aplikasi Visualisasi Data Cuaca Interaktif"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("xvar", "Pilih Variabel X:", choices = names(data)),
      selectInput("yvar", "Pilih Variabel Y:", choices = names(data)),
      radioButtons("plot_type", "Pilih Jenis Visualisasi:",
                   choices = c("Scatter Plot" = "scatter",
                               "Line Plot" = "line",
                               "Bar Plot" = "bar",
                               "Tabel Data" = "table"))
    ),
    
    mainPanel(
      conditionalPanel(
        condition = "input.plot_type != 'table'",
        plotlyOutput("plot_output")
      ),
      conditionalPanel(
        condition = "input.plot_type == 'table'",
        dataTableOutput("table_output")
      )
    )
  )
)

# SERVER
server <- function(input, output) {
  
  output$plot_output <- renderPlotly({
    req(input$xvar, input$yvar)
    
    x <- data[[input$xvar]]
    y <- data[[input$yvar]]
    
    if (input$plot_type == "scatter") {
      plot_ly(data, x = ~x, y = ~y, type = "scatter", mode = "markers")
    } else if (input$plot_type == "line") {
      plot_ly(data, x = ~x, y = ~y, type = "scatter", mode = "lines+markers")
    } else if (input$plot_type == "bar") {
      plot_ly(data, x = ~x, y = ~y, type = "bar")
    }
  })
  
  output$table_output <- renderDataTable({
    datatable(data)
  })
}

# Jalankan aplikasi
shinyApp(ui, server)
