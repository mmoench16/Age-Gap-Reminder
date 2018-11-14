library(shiny)
library(dygraphs)

data <- readRDS("data/data.rds")

ui <- fluidPage(
  htmlTemplate("index.html",
               plot = dygraphOutput("HPplot"),
               select1 = selectInput("select1",
                                     label = h4("Select Year"),
                                     choices = as.list(data$Year),
                                     selected = "1960"),
               select2 = selectInput("select2",
                                     label = h4("Select Year"),
                                     choices = as.list(data$Year),
                                     selected = "2017-01-01"),
               slider = sliderInput("slider",
                                    label = h4("Contribution"),
                                    min = 1,
                                    max = 100,
                                    value = 20, width = "100%"),
               text1 = htmlOutput("text1"),
               text2 = htmlOutput("text2"),
               reportButton = downloadButton("report", "Download PDF"),
               dataButton = downloadButton("data", "Download Data")
               )
)


