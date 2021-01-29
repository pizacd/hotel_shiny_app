library(shiny)
library(dplyr)
library(shinydashboard)
library(ggplot2)
library(DT)
library(lubridate)

hotels <- read.csv('./hotel_bookings.csv')

#Calculate total nights for each stay
hotels <- hotels %>% mutate(total_nights = stays_in_week_nights+stays_in_weekend_nights)

# Derive season based on which month the reservation is
hotels <- hotels %>% mutate(
  season = case_when(arrival_date_month %in% c('December','January','February') ~'Winter',
                     arrival_date_month %in% c('March','April','May')~'Spring',
                     arrival_date_month %in% c('June','July','August')~'Summer',
                     arrival_date_month %in% c('September','October','November')~'Fall'))


hotels <- hotels %>% mutate(stay_revenue = total_nights*adr)
choice <- colnames(hotels)[-1]

hotels %>% group_by(season, arrival_date_year) %>% 
  ggplot(aes(x = season, y = stay_revenue)) + 
  geom_boxplot(aes(fill = season)) + 
  facet_wrap(~arrival_date_year) +coord_flip()
