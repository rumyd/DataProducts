library(shiny)
library(ggplot2)


#Define server logic to plot selected variable to mpg 
shinyServer(function(input, output) {
    lambda <- 0.2    # Constant Rate parameter for exponential distribution
    no_sims <- reactive({ input$nosims  # no. of selected simulations for demo
        })
    n <- reactive(
        {input$samplesize # sample size selected for demo
        })
    
    rnexp <- reactive({
        rexp(no_sims(), lambda) # generate random exponentials with rate 0.2  
    })
    
    # Use replicate function to create a dataset with no_sims rows and n columns 
    # representing random draw of n samples of random exponentials
    smexp <- reactive({
        t(replicate(no_sims(), rexp(n(), lambda))) 
    })
    
    # Get the mean and variance of the samples for each of the simulations
    smean <- reactive({
        data.frame(Mean = apply(smexp(), 1, mean))
    })
    svar <- reactive({
        data.frame(Variance = apply(smexp(), 1, var)) 
    })
    
    # Calculate the averages of both means and variances of the samples
    smeanvar <<- reactive({
        data.frame(Mean = c(mean(rowMeans(smexp())), 1/lambda), 
                           Variance = c(mean(apply(smexp(), 1, var)), 1/lambda^2))
        })
    

#     # Output plot for theoretical and sample means
        output$plotmean <- renderPlot({
            
            
            gmean <- ggplot(smean(), aes(x = Mean))
            gmean <- gmean + geom_histogram(color="black", fill = "lightblue3", binwidth=lambda,  
                                            aes(y = ..density..))
            gmean <- gmean + geom_density(color = "black", size = 1) 
            gmean <- gmean + geom_vline(data = smeanvar(), aes(xintercept = smeanvar()[1,1],
                                            color = "Average of Sample Means", 
                                            linetype = "Average of Sample Means"), 
                                        size = .5, show_guide = TRUE)
            gmean <- gmean + geom_vline(data = smeanvar(), aes(xintercept = smeanvar()[2,1], 
                                            color = "Theoretical Mean",
                                            linetype = "Theoretical Mean"), 
                                        size = .5, show_guide = TRUE)
            gmean <- gmean + scale_colour_manual( name = "Means", 
                                                  values=c("Average of Sample Means"="black","Theoretical Mean"= "orange" )) 
            gmean <- gmean + scale_linetype_manual( name = " Means", 
                                                    values=c("Average of Sample Means"="solid","Theoretical Mean"= "dashed" ), 
                                                    guide = FALSE)
            gmean <- gmean + ylab("Density") + xlab("Sample Means") + ggtitle("Distribution of Sample Means")
            
            gmean
        })
            
# Output the averages of mean and variances from samples and compare to theoretical            
    output$table1 <- renderTable({
        tableview <- smeanvar()
        rownames(tableview) <-  c("Sample", "Theoretical")
        head(tableview)
        
    })

})