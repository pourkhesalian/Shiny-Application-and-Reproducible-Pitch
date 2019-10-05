#` This is the user interface of the diamond price predictor shiny app
#' This Shiny application is written by Ali Pourkhesalian
#' It is the course project of the Developing Data Products Course
#' The user inputs four characteristics of the diamond and the application predicts the price in USD with the corresponding standard error
#' The application used a dataset whithin R called diamonds
# This is the user interface for the shiny app to determine diamond price based on factors such as carat, cut, color, and clarity a Shiny web application. You can


#loading required libraries
library(shiny)
library(dplyr)
library(ggplot2)

# loading the dataset
data("diamonds")

# extracting diamond characteristics factors from the dataset 
diamond.cut<- sort(unique(diamonds$cut), decreasing = T)
diamond.color <- sort(unique(diamonds$color), decreasing = F)
diamond.clarity <- sort(unique(diamonds$clarity), decreasing = T)

#the interface
shinyUI(
    fluidPage(
        titlePanel("Diamond Value Predictor (USD):"),
                  sidebarLayout(
                      sidebarPanel("Diamond Characteristics:",
                                             selectInput("diamondCut", "Diamond Cut", diamond.cut),
                                             selectInput("diamondColor", "Diamond Color", diamond.color),
                                             selectInput("diamondClarity", "Diamond Clarity", diamond.clarity),
                                             sliderInput("diamondCarat",
                                                         "Diamond Weight in Carats",
                                                         min = .2, 
                                                         max = 2.5,
                                                         value = median(diamonds$carat), 
                                                         step = 0.05),
                                   h4("Predicted Price (USD)"), verbatimTextOutput("predict")
                                   ),
                      mainPanel("The Fitted Model:", plotOutput("distPlot"))
                      )
        )
    )
