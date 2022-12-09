library(shiny)
library(tidyverse)
library(plotly)
library(ggplot2)

df_1 <- read.csv("owid-co2-data.csv")

countries <- unique(df_1$country)
min_year <- min(df_1$year)
max_year <- max(df_1$year)

shinyServer(function(input, output) {
  

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')

    })

})
