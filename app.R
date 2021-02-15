library(shiny)
library(elo)
library(tidyverse)
library(shinydashboard)
library(readr)

df <- read_csv("https://raw.githubusercontent.com/andrew-couch/Tidy-Tuesday/master/TidyTuesdayUFCDashboard/elo.csv")

elo_df <- read_csv("https://raw.githubusercontent.com/andrew-couch/Tidy-Tuesday/master/TidyTuesdayUFCDashboard/elo_df.csv")


ui <- fluidPage(
    
    # Application title
    titlePanel("Old Faithful Geyser Data"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
