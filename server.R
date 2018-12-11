library(shiny)
library(tidyverse)
library(dygraphs)
library(xts)

data <- readRDS("data/data.rds")
xts1 <- xts(data, order.by = data$Year, "%Y/%m/%d")
generations <- readRDS("data/generations.rds")

server <- function(input, output) {
  output$HPplot <- renderDygraph({
    dygraph(xts1, main = "House Price vs Disposable Income (1955-2017)") %>% 
      dySeries("House Price [£]", strokeWidth = 2) %>%
      dySeries("Income", strokeWidth = 2) %>%
      dyRangeSelector()
  })
  
  output$text1 <- renderUI({
    hp <- data %>%
      filter(Year == input$select1) %>%
      select(`House Price [£]`)
    
    dispInc <- data %>%
      filter(Year == input$select1) %>%
      select(Income)
    
    timeToBuyHouse <- round(hp/((dispInc/12)*(input$slider/100)), digits = 1)
    
    list(
      HTML(paste0("<strong>Year:</strong> ", input$select1)),
      br(),
      HTML(paste0("<strong>House Price:</strong> £", round(hp))),
      br(),
      HTML(paste0("<strong>Annual Disposable Income:</strong> £",
                  round(dispInc))),
      br(),
      HTML(paste0("<strong>Monthly Disposable Income:</strong> £",
                  round(dispInc/12))),
      br(),
      HTML(paste0("<strong>Time to pay off house:</strong> ",
                  timeToBuyHouse," Months or ",
                  round(timeToBuyHouse/12, digits = 1),
                  " Years (based on a ",
                  input$slider,
                  "% (£",
                  round((dispInc/12)*(input$slider/100), digits = 1),
                  ") contribution from monthly disposable income)"))
  )})
  
  output$text2 <- renderUI({
    hp <- data %>%
      filter(Year == input$select2) %>%
      select(`House Price [£]`)
    
    dispInc <- data %>%
      filter(Year == input$select2) %>%
      select(Income)
    
    timeToBuyHouse <- round(hp/((dispInc/12)*(input$slider/100)), digits = 1)
    
    list(
      HTML(paste0("<strong>Year:</strong> ", input$select2)),
      br(),
      HTML(paste0("<strong>House Price:</strong> £", round(hp))),
      br(),
      HTML(paste0("<strong>Annual Disposable Income:</strong> £",
                  round(dispInc))),
      br(),
      HTML(paste0("<strong>Monthly Disposable Income:</strong> £",
                  round(dispInc/12))),
      br(),
      HTML(paste0("<strong>Time to pay off house:</strong> ",
                  timeToBuyHouse," Months or ",
                  round(timeToBuyHouse/12, digits = 1),
                  " Years (based on a ",
                  input$slider,
                  "% (£",
                  round((dispInc/12)*(input$slider/100), digits = 1),
                  ") contribution from monthly disposable income)"))
    )})
  
  output$report <- downloadHandler(
    filename = "report.pdf",
    content = function(file) {
      tempReport <- file.path(tempdir(), "report.Rmd")
      file.copy("report.Rmd", tempReport, overwrite = TRUE)
      params <- list(contribution = input$slider)
      
      rmarkdown::render(tempReport, output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv()))
    }
  )
  
  output$data <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(),".csv", sep = "")
    },
    content = function(file) {
      write.csv(data, file)
    }
  )
  
  output$generations <- DT::renderDataTable(generations, 
                                            options = list(dom = "t"),
                                            rownames = F)
}