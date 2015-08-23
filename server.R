require(datasets)
require(gridExtra)
require(ggplot2)
require(dplyr)
require(knitr)




server <- function(input, output) {
        
#          
        output$help1 <- renderText({ includeText("text3.txt")})
        output$norm <- renderPlot({
                  if(input$select=="dose"){
                          g <- ggplot(ToothGrowth, aes(x=factor(dose), y=len))      
                  }else
                {g <- ggplot(ToothGrowth, aes(x=factor(supp), y=len))}
                p <- g + geom_boxplot(stat="boxplot", outlier.colour = "red", outlier.size = 3,
                                      alpha=0.2) + geom_point()
                        
                        labs(title = paste("Tooth Growth verses", "input$select"), 
                             x=input$select, y = "Tooth Length")
                p
        })
        output$value <- renderPrint({ input$select })
        output$sample1 <- renderPlot({
                plotsimulations <<- function(samplesize, lambda) {
                        set.seed(10)
                        nosim <- 1000  
                        cfunc <- function(x, n) sqrt(n) * (mean(x) - (1/lambda)) / (1/lambda) 
                        dat <<- data.frame(
                                x= c(apply(matrix(sample(rexp(samplesize,lambda), nosim * samplesize, replace = TRUE), 
                                                  nosim), 1, mean, samplesize)), # 1000 simualations replaced cfunc with mean
                                size = factor(rep(samplesize))
                        )
                        dat <<- dat %>%
                                mutate(meansample = mean(x), varsample = var(x), sdsample = sd(x) )
                        
                        # calculate histogram binwidth based on Freedman-Diaconis 
                        xbin<- range(dat$x)/nclass.FD(dat$x)*0.8
                        
                        # geom_text(aes(label= paste("mean =", round(mean(x,na.rm=T),3))),x = 1, y = 0.5, size=4)
                        g <- ggplot(dat, aes(x = x, fill=size )) + geom_histogram( binwidth=xbin[2],
                                                                                   fill="#6BAED6",
                                                                                   col="#08306B",
                                                                                   alpha = .5,aes(y = ..density..)  ) + 
                                
                                geom_density(alpha=0.2) + geom_vline(aes(xintercept=mean(x, na.rm=T)), linetype="dashed", colour="red", size=1) + 
                                
                                geom_text(aes(label= paste("mean =", round(mean(x,na.rm=T),3),"\n",
                                                           "var =", round(var(x,na.rm=T),3), "\n",
                                                           "sd =", round(sd(x,na.rm=T),3))),
                                          x = round(mean(dat$x,na.rm=T),1), y = 0.5, size=4)
                        g <- g + stat_function(fun = dnorm, size = 2) + labs(title = paste("Figure 1: Simulation of Averages of", samplesize,
                                                                                           "Random Samples \n From The Exponential Distribution") )
                        
                        g
                }
                
                plotsimulations(input$num, input$numlambda)
        })
        output$stats <- renderPrint({
                paste( "Sample size =" , input$num, " mean =", round(mean(dat$x),2), "Expected mean(1/lambda) =", 1/input$numlambda)
                       
        })
        
}
