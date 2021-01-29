library(shiny)
library(dplyr)
library(shinydashboard)
library(ggplot2)
library(DT)
library(lubridate)
library(plotly)

hotels <- read.csv('hotel_bookings_cleaned.csv')
#Changing date columns to Date class, year to factor
#keep all this in global
hotels$reservation_status_date <- as.Date(hotels$reservation_status_date,'%Y-%m-%d')
hotels$arrival_date_year <- as.factor(hotels$arrival_date_year) #keep in global
choice <- colnames(hotels)[-1]



