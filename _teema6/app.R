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
      
      # Input: Rippmenüü tervisehinnangu valimiseks
      selectInput(inputId = "health",
                  label = "Tervise kategooria:",
                  choices = c("All", levels(students$health)),
                  selected = 'All'),
      
	  # Input: Raadionupp regressioonsirge lisamiseks või eemaldamiseks
      radioButtons(inputId = 'valik',
                   label = 'Lisa regressioonsirge:',
                   choices = c('Jah', 'Ei'),
                   )
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      h2('Tudengite andmed'),
      
      # Output: Karpdiagramm ----
      plotOutput(outputId = "joonis1"),
      
	  # Output: Hajuvusdiagramm ----
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
    
	# Kuna hakkame muutma jooniseid, siis salvestame andmestiku uue objekti all.
    x <- students
    
	# Kui valitud on mõni tervise tase, siis filtreerima andmestiku
    if(input$health != 'All'){
      x = students[students$health == input$health, ]
    }
    
	# Eemaldame puuduvad väärtused
    ilma_na <- complete.cases(x[,c("sport", "weight", "gender")])
	
	# Teeme joonise
    ggplot(x[ilma_na,], aes(x = sport, y = weight, colour = gender)) + 
      geom_boxplot() +
      labs(title = 'Kaalu jaotus spordiharjumuste gruppides')
    
  })
  
  output$joonis2 <- renderPlot({
    
    # Kuna hakkame muutma jooniseid, siis salvestame andmestiku uue objekti all.
    x <- students
    
	# Kui valitud on mõni tervise tase, siis filtreerima andmestiku
    if(input$health != 'All'){
      x = students[students$health == input$health, ]
    }
    
	# Tekitame joonise objekti kus on joonisel ainult punktid...
    joonis2 <- ggplot(x, aes(x = DVR, y = age)) + 
      geom_point() +
      labs(title = 'Vererõhu ja vanuse hajuvusdiagramm')
    
	# ... ja lisame juurde regressioonsirge vastavalt kasutaja sisendile
    if(input$valik == 'Jah'){
     joonis2 <- joonis2 + geom_smooth(method = 'lm', se = F)
    }
    
	# Joonis tuleb ka välja "printida"
    joonis2
    
  })

}

# Käivita Shiny rakendus ----
shinyApp(ui = ui, server = server)
