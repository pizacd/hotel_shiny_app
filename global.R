library(shiny)
library(dplyr)
library(shinydashboard)
library(ggplot2)
library(DT)
library(lubridate)

hotels <- read.csv('hotel_bookings_cleaned.csv')
#Changing date columns to Date class, year to factor
#keep all this in global
hotels$reservation_status_date <- as.Date(hotels$reservation_status_date,'%Y-%m-%d')
hotels$booking_date <- as.Date(hotels$booking_date,'%Y-%m-%d')
hotels$arrival_date_year <- as.factor(hotels$arrival_date_year) 
choice <- colnames(hotels)[-1]

cancel <- hotels %>% filter(is_canceled==1)
no_cancel <- hotels %>% filter(is_canceled ==0)


guest <- hotels %>% 
  select(Cancelled =is_canceled,History = previous_cancellations, 
         Requested = reserved_room_type, Assigned = assigned_room_type)

guest <- guest %>% 
  mutate(Cancelled = ifelse(Cancelled == 1,'Yes','No'),
         RequestedRoom = ifelse(Requested != Assigned,'Same','Not Same'),
         History = ifelse(History >=1, 'Yes','No'))


cancel_results <- chisq.test(x = guest$History, y = guest$Cancelled)
room_results <- chisq.test(x = guest$RequestedRoom, y = guest$Cancelled)






