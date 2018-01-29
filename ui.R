
#####actual set up of page
fluidPage(
  
  titlePanel("Deskpro Issues"),
  sidebarLayout(
    sidebarPanel(
      selectInput("selection", "Choose a service:",
                  choices = Deskpro$Service),
      actionButton("update", "Change"),
      hr(),
      sliderInput("freq",
                  "Minimum Frequency:",
                  min = 1,  max = 50, value = 15),
      sliderInput("max",
                  "Maximum Number of Words:",
                  min = 1,  max = 300,  value = 100)
    ),
    #conditionalPanel(
    # 'input.dataset === "Deskpro"',
    # helpText("Click the column header to sort a column."),
    
    mainPanel(
      plotOutput("plot", "800px", "600px")##,
     # mainPanel(
        #plotOutput("words_Plot"),
       # mainPanel(
        #  tabsetPanel(
        #    id = 'Deskpro',
        #    tabPanel("Deskpro", DT::dataTableOutput("mytable1"))
            
          )
        )
      )
   # )  
  #)
#)

