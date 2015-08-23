library(shiny)

ui <- navbarPage(title = "Sample Plots", 
                 tabPanel(title = "Help File",
                          verbatimTextOutput("help1")         
                           
                 ),          
                 
                 tabPanel(title = "Tooth Growth",
                          
                          plotOutput("norm"),
                          helpText( strong(h3((" In the Select Box select dose or supp to display boxplot")))),
                          selectInput("select", label = h4("Select box"), 
                                      choices = c("dose" = "dose", "supp" = "supp")), 
                                      
                          hr(),
                          fluidRow(column(3, verbatimTextOutput("value"))) 
                 ),
                 tabPanel(title = "Exponential Simulation - CLT",
                          helpText(em("As sample size increases the output will look like a normal distribution with 
                                      mean equal to 1/Lambda \n. Plot may take a few seconds to display")),
                          plotOutput("sample1"),
                          helpText(em("below is the expected mean and calculated mean for The Exponential Distribution")),
                          verbatimTextOutput("stats"),
                          helpText(em("Using the slider select the sample size and lambda to run an Simulation of the exponential distribution.")),
                          sliderInput(inputId = "num", 
                                      label = "Select Sample Size", 
                                      value = 40, min = 5, max = 100),
                          sliderInput(inputId = "numlambda", 
                                      label = "Select lambda", 
                                      value = 0.2, min = 0.05, max = 1)
                 )
                 
                 
)