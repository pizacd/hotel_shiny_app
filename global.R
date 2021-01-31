## Global script for hotel app

#Import required libraries
library(shiny)
library(dplyr)
library(shinydashboard)
library(ggplot2)
library(DT)
library(lubridate)


# Read in cleaned csv file (cleaned with preprocessing.R)
hotels <- read.csv('hotel_bookings_cleaned.csv')


#Changing date columns to Date class, year to a factor
hotels$reservation_status_date <- as.Date(hotels$reservation_status_date,'%Y-%m-%d')
hotels$booking_date <- as.Date(hotels$booking_date,'%Y-%m-%d')
hotels$arrival_date <- as.Date(hotels$arrival_date,'%Y-%m-%d')
hotels$arrival_date_year <- as.factor(hotels$arrival_date_year) 

#create subset of data by which reservations were canceled
cancel <- hotels %>% filter(is_canceled==1)


# select four columns from the data as a subset for two chi square tests
guest <- hotels %>% 
  select(Canceled =is_canceled,History = previous_cancellations, 
         Requested = reserved_room_type, Assigned = assigned_room_type)

# creating three new columns to use as parameters for chi square tests
guest <- guest %>% 
  mutate(Canceled = ifelse(Canceled == 1,'Yes','No'),
         RequestedRoom = ifelse(Requested == Assigned,'Same','Not Same'),
         History = ifelse(History >=1, 'Yes','No'))

# chi square results for cancellation history and canceling upcoming stay
cancel_results <- chisq.test(x = guest$History, y = guest$Canceled)

# chi square results for room assignment and canceling upcoming stay
room_results <- chisq.test(x = guest$RequestedRoom, y = guest$Canceled)


