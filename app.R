library(shiny)
library(elo)
library(tidyverse)
library(shinydashboard)
library(readr)

# datasets used
df <- read_csv("https://raw.githubusercontent.com/andrew-couch/Tidy-Tuesday/master/TidyTuesdayUFCDashboard/elo.csv")
elo_df <- read_csv("https://raw.githubusercontent.com/andrew-couch/Tidy-Tuesday/master/TidyTuesdayUFCDashboard/elo_df.csv")


elo.run(winner ~ fighter + opponent, k = 20,
        data = elo_df %>% arrange(fighter, date)) %>%
    as_tibble()

ui <- dashboardPage(
    dashboardHeader(title = "UFC Dashboard"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Weight Class", tabName = "weight_class_tab", icon = icon("dashboard")),
            menuItem("Head to head", tabName = "head_tab", icon = icon("mitten"))
        )
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = "weight_class_tab"),
            tabItem(tabName = "head_tab")
        )
    )
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
