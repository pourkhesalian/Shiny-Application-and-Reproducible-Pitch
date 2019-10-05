#` This is the server of the diamond price predictor shiny app
#' This Shiny application is written by Ali Pourkhesalian
#' It is the course project of the Developing Data Products Course
#' The user inputs four characteristics of the diamond and the application predicts the price in USD with the corresponding standard error
#' The application used a dataset whithin R called diamonds
# This is the user interface for the shiny app to determine diamond price based on factors such as carat, cut, color, and clarity a Shiny web application. You can


#loading libraries
library(shiny)
library(ggplot2)
library(curl)
library(dplyr)

#server
shinyServer(
    function(input, output) {
        data("diamonds")
        output$distPlot <- renderPlot({
            diamond.filtered <- diamonds %>%
                filter(cut == input$diamondCut,
                       color == input$diamondColor,
                       clarity == input$diamondClarity)
#the plot            
             plot(x= diamond.filtered$carat, 
                      y= diamond.filtered$price, 
                      col='blue',
                      xlab = 'Diamond Weight (Carat)',
                      ylab = 'Diamond Price (USD)')
            lines(diamond.filtered$carat, 
                  fitted(
                      lm(price~carat, 
                            data = diamond.filtered))
                  , col='red')
            points(x= input$diamondCarat, 
                   y= predict(
                       lm(price~carat,
                          data=diamond.filtered),
                       newdata= data.frame(
                           carat = input$diamondCarat)),
                   col='black',
                   pch=3,
                   lwd=4)

    }, height = 500)
    
#the model
    output$predict <- renderPrint({
        diamond.filtered <- subset( diamonds, 
                                    cut == input$diamondCut &
                                    color == input$diamondColor &
                                    clarity == input$diamondClarity)
        fit <- lm(price~carat,
                  data=diamond.filtered)
        pricePredict <- predict(fit, 
                                newdata= data.frame(
                                    carat = input$diamondCarat))
        tolerance<-round(
            (predict(fit, 
                     newdata= data.frame(carat = input$diamondCarat), 
                     interval="predict")[3]-
            predict(fit, newdata= data.frame(carat = input$diamondCarat),
                    interval="predict")[2])/2, 2)
         cat(
             paste(
                 round(
                     pricePredict,2)
                 ,"\u00b1",tolerance 
                 )
             )
         }
        )
    
}
)