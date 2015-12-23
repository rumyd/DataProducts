library(shiny)

shinyUI(pageWithSidebar(
    
    #Application Title
    headerPanel("Central Limit Theorem Demo"),
    
    sidebarPanel(numericInput("samplesize", "Sample Size :", value = 40, 
                              min = 20, max = 60, step = 5),
                 br(),
                 sliderInput("nosims", "No. of simulations", min = 600, 
                              max = 2000,value = 1000, step = 100),
                 
                 br(),
                 
                 
                # adding the new div tag to the sidebar            
                 tags$div(class="header", checked=NA,
                          tags$b("Brief description of how to use this app :"),
                          tags$br(),
                          tags$p("This demo is to demostrate concept of Central Limit Theorem
                                in Statistics, which states that the sampling distribution of 
                                the sampling means approaches normal distribution, as the sample
                                size gets larger, irrespective of the type of population distribution."),
                          tags$p("In the app, select any combination of sample size and no. of 
                                 simulations, the histogram on the right will dynamicaly change 
                                 for the exponentials, but you will find that the mean of the sample
                                 averages for mean and variance is very close to theoretical mean and 
                                 variance and also the distribution of sample averages is fairly normal."),
                          tags$p("For further documentation of the app "),
                          tags$a(href="http://rpubs.com/rumyd/136733", "Click Here!")
                 )
                 ),
    
    mainPanel(
               plotOutput("plotmean"),
               
               tableOutput("table1"))
               
))