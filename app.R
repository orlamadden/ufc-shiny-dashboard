library(shiny)
library(elo)
library(tidyverse)
library(shinydashboard)
library(readr)

# datasets used
df <- read_csv("https://raw.githubusercontent.com/andrew-couch/Tidy-Tuesday/master/TidyTuesdayUFCDashboard/elo.csv")
elo_df <- read_csv("https://raw.githubusercontent.com/andrew-couch/Tidy-Tuesday/master/TidyTuesdayUFCDashboard/elo_df.csv")

create_elo_data <- function(k) {

    temp_df <- elo.run(winner ~ fighter + opponent, k = 20,
            data = elo_df %>% arrange(fighter, date)) %>%
            as_tibble() %>%
            cbind(elo_df %>% arrange(fighter, date) %>% select(match_id)) %>%
            select(team.A, team.B, elo.A, elo.B, match_id)
    
    rbind(temp_df %>% select_at(vars(contains(".A"), contains("match_id"))) %>%
        rename_all(.funs = function(x) str_replace(x, ".A", "")),
        temp_df %>% select_at(vars(contains(".B"), contains("match_id"))) %>%
        rename_all(.funs = function(x) str_replace(x, ".B", ""))) %>%
        rename("fighter" = "team") %>%
        left_join(df %>% select(fighter, date, weight_class, match_id),
              by = c("fighter", "match_id"))

}

create_elo_data(20) %>% colnames()

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
            tabItem(tabName = "weight_class_tab",
                    box(plotOutput("elo_timeseries")),
                    box(tableOutput("top_5_table")),
                    box(sliderInput(inputId = "v_k_1",
                                    label = "K for ELO",
                                    min = 1,
                                    max = 100,
                                    value = 20))
                    ),
            tabItem(tabName = "head_tab")
        )
    )
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$top_5_table <- renderTable({
        
        table_df <- create_elo_data(input$v_k_1)
        
        table_df %>%
            group_by(fighter) %>%
            arrange(desc(elo)) %>%
            slice(1) %>%
            ungroup() %>%
            top_n(elo, n = 5) %>%
            arrange(desc(elo)) %>%
            select(fighter, elo) %>%
            mutate(rank = row_number())
            
    })
    
    output$elo_timeseries <- renderPlot({
        elo_timeseries_df <- create_elo_data(input$v_k_1)
        
        top_5_fighters <- elo_timeseries_df %>%
            group_by(fighter) %>%
            arrange(desc(elo)) %>%
            slice(1) %>%
            ungroup() %>%
            top_n(elo, n = 5) %>%
            select(fighter)
        
        ggplot(data = elo_timeseries_df, aes(x = date, y = elo)) + 
            geom_point() + 
            geom_point(data = elo_timeseries_df %>% filter(fighter %in% top_5_fighters$fighter),
                       aes(x = date, y = elo, color = fighter)) +
            theme(legend.position = "top")
        
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
