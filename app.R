library(shiny)
library(elo)
library(tidyverse)
library(shinydashboard)
library(readr)

df <- read_csv("https://raw.githubusercontent.com/andrew-couch/Tidy-Tuesday/master/TidyTuesdayUFCDashboard/elo.csv")

elo_df <- read_csv("https://raw.githubusercontent.com/andrew-couch/Tidy-Tuesday/master/TidyTuesdayUFCDashboard/elo_df.csv")

ui <- dashboardPage(
    dashboardHeader(title = "UFC Dashboard"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Weight Class", tabName = "weight_class_tab", icon = icon("dashboard")),
            menuItem("Head to head", tabName = "head_tab", icon = icon("mitten"))
        )
    ),
    dashboardBody()
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
