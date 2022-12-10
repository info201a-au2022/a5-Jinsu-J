library(shiny)
library(tidyverse)
library(plotly)
library(ggplot2)
library(dplyr)
library(data.table)
library(janitor)

df_1 <- read.csv("owid-co2-data.csv")

countries <- unique(df_1$country)
max_year <- max(df_1$year)
start_year <- 1960
year_1960 <- df_1 %>%
  filter(year >= 1960)

table_search <- df_1 %>%
  group_by(year) %>%
  select(year, country, co2, co2_per_capita, co2_per_gdp, total_ghg)

server <- function(input, output, session) {
  
  output$bar <- renderPlotly({
    selected_country <- input$countries
    if (selected_country != 'Afghanistan') {
      df_2 <- df_1 %>%
        group_by(year) %>%
        select(year, country, co2) %>%
        filter(country == selected_country)
    }
    else {
      df_2 <- df_1 %>%
        group_by(year) %>%
        select(year, country, co2) %>%
        filter(country == "Afghanistan") 
    }
    ggplotly(
      print(ggplot(df_2)) +
        geom_bar(mapping = aes(x = year, y = co2), stat = "identity") +
        labs(title = "Annual production-based emssions of CO2") +
        scale_x_continuous(limits = c(input$year[1], input$year[2]),
                           breaks = seq(start_year, max_year, 3)) +
        ylab("CO2 in million tonnes") +
        theme(axis.text.x = element_text(angle = 50, hjust = 1, size = 5))
    )
    
   })
  
  output$country_name <- renderUI({
    selectInput(
      "country_select",
      "Type the countries you want to compare:",
      choices = as.character(df_1$country),
      multiple = TRUE,
      selected = "Croatia"
    )
  })
  
  output$year_selected <- renderUI({
    sliderInput("inputyear", "Which year:", 
                min = start_year, max = max_year,
                value = c(start_year, max_year), sep = "",)
  })
  
  output$data_cal <- renderUI({
    selectInput(
      "total_mean",
      "Choose type of calculation",
      choices = c("Total", "Mean")
    )
  })
  
  
  data_subset = reactive({
    table_search %>%
    subset(country %in% input$country_select) %>%
    subset(year >= input$inputyear[1] &
             year <= input$inputyear[2])

  })
  
  data_total = reactive({
  selected_cal <- input$total_mean
  if (selected_cal != 'Total'){
    table_search %>%
      subset(country %in% input$country_select) %>%
      subset(year >= input$inputyear[1] &
               year <= input$inputyear[2]) %>%
      adorn_totals(name = "mean") %>%
      mutate(across(where(is.numeric), 
                    ~ replace(., n(), .[n()]/(n()-1))))
    
  } else {
    table_search %>%
      subset(country %in% input$country_select) %>%
      subset(year >= input$inputyear[1] &
               year <= input$inputyear[2]) %>%
      adorn_totals("row")}
    
})
  
  
  output$data_Table <- renderTable(data_subset())
  output$sum_total <- renderTable(data_total())

}

