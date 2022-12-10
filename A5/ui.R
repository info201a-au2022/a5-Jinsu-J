
library(shiny)
library(shinythemes)
library(plotly)
library(data.table)
source("server.R")

fpage <- tabPanel(
  "introductory: Annual CO2 emissions",
  titlePanel(
    "Navigate annual CO2 emission from various countries"
  ),
  sidebarLayout(
  sidebarPanel(
    selectInput("countries", "Select a country",
                choices = countries,
                ),
   sliderInput("year", "Year Range",
                min = start_year,
                max = max_year,
                value = c(start_year, max_year),
                sep = ""),
   ),
  mainPanel(
    plotlyOutput("bar"),
    h4(p("This visualization shows the amount of CO2 emission from each
         country in different time period. Users can learn the values of 
         each country's co2 emission in the time period that they investigate. 
         To use this page in-depth for learning, you can compare and contrast 
         countries as many as you want in the first page, and can visualize the
         co2 emission from specific country in this page."))
    )
  )
)

searchbar <- tabPanel (
  uiOutput("country_name"),
  sidebarLayout(
    sidebarPanel(
  uiOutput("year_selected"),
  uiOutput("data_cal")
    ),
  mainPanel(
    tabsetPanel(
    tabPanel("Calculation", tableOutput("sum_total"))
    ),
  )))


ui <- navbarPage(
  title = "Investigate CO2 emission",
  theme = shinytheme("cyborg"),
  searchbar,
  fpage
)

shinyApp(ui = ui, server = server)
