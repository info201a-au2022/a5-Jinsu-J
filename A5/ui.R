#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
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
                max = max_year,
                value = c(min_year, max_year),
                step = 1)
    ),
  mainPanel(
    plotlyOutput("bar"),
    )
  )
)