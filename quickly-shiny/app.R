library(shiny)
library(shinythemes)
library(rsconnect)
library(tidyverse)

# Add the fruits and vegetable columns
library(shiny)

quickly_data <- read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vRkm4lglfYFqdJ0M3IO0equXz3NKvW0P4czdAzCCFx691NWtZ_1cR7cW1CxP3jsyKwIKuI9HOZi_ArN/pub?gid=0&single=true&output=csv",
    col_types = cols(.default = col_integer(), Date = col_date("%d/%m/%Y"))
)

quickly_data <- quickly_data %>%
    mutate(Vegetable = Green_lettuce + Red_lettuce + Kang_kong + Corn_kernel + Carrot + Sweet_potato + Dandelion) %>%
    mutate(Fruit = Cherry_tomato + Apple + Avocado + Strawberry + Grape + Blueberry + Mango + Banana + Dragonfruit) %>%
    mutate(All_food = Vegetable + Fruit)

quickly_data$Pooped <- as.factor(quickly_data$Pooped)


# Define UI for app that draws a histogram ----
ui <- fluidPage(
    titlePanel("Quickly's Food Diary"),
    div(img(src = "quickly.png"), style = "text-align: center;"),
    # App title ----
    br(),
    p(),
    sidebarLayout(
        sidebarPanel(
            selectInput(
                "selectedFood",
                "Select the food type",
                choices = rev(colnames(quickly_data)[-1:-2]),
                selected = colnames(quickly_data)[1]
            )
        ),
        mainPanel(
            plotOutput("food_plot")
        )
    )
)


# Define server logic required to draw a histogram ----
server <- function(input, output) {
    output$food_plot <- renderPlot({
        y_axis <- input$selectedFood
        ggplot(quickly_data, aes_string(x = "Date", y = y_axis, fill = "Pooped")) +
            geom_bar(stat = "identity") +
            scale_x_date(date_breaks = "1 week")
    })
}

shinyApp(ui = ui, server = server)