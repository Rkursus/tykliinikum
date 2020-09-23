library(shiny)
library(ggplot2)

# Andmete laadimine
load("//domenis.ut.ee/DFS/Downloads/klumiste/Downloads/test.RData")
students$sport <- factor(students$sport)
  


# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Hello Shiny!"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      selectInput(inputId = "health",
                  label = "Tervise kategooria:",
                  choices = c("All", levels(students$health)),
                  selected = 'All'),
      
      radioButtons(inputId = 'valik',
                   label = 'Lisa regressioonsirge:',
                   choices = c('Jah', 'Ei'),
                   )
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      h2('Tudengite andmed'),
      
      # Output: Histogram ----
      plotOutput(outputId = "joonis1"),
      
      plotOutput(outputId = "joonis2")
      
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot ---
  # ----
  
  
  
  output$joonis1 <- renderPlot({
    
    x <- students
    
    if(input$health != 'All'){
      x = students[students$health == input$health, ]
    }
    
    ilma_na <- complete.cases(x[,c("sport", "weight", "gender")])
    ggplot(x[ilma_na,], aes(x = sport, y = weight, colour = gender)) + 
      geom_boxplot() +
      labs(title = 'Kaalu jaotus spordiharjumuste gruppides')
    
  })
  
  output$joonis2 <- renderPlot({
    
    x <- students
    
    if(input$health != 'All'){
      x = students[students$health == input$health, ]
    }
    
    joonis2 <- ggplot(x, aes(x = DVR, y = age)) + 
      geom_point() +
      labs(title = 'Vererõhu ja vanuse hajuvusdiagramm')
    
    if(input$valik == 'Jah'){
     joonis2 <- joonis2 + geom_smooth(method = 'lm', se = F)
    }
    
    joonis2
    
  })

}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
