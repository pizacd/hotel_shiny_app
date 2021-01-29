library(shiny)
library(dplyr)
library(shinydashboard)
library(ggplot2)
library(DT)
library(lubridate)
library(plotly)


#read in data after setting working directory to file location
hotels <- read.csv('./hotel_bookings.csv')

#Remove extraneous columns from dataframe
hotels <- hotels %>% select(-arrival_date_week_number,
                             -meal,-distribution_channel,
                             -agent,-company,-required_car_parking_spaces,
                             -total_of_special_requests)
#Calculate total nights for each stay
hotels <- hotels %>% mutate(total_nights = stays_in_week_nights+stays_in_weekend_nights)

# Derive season based on which month the reservation is
hotels <- hotels %>% mutate(
  season = case_when(arrival_date_month %in% c('December','January','February') ~'Winter',
                     arrival_date_month %in% c('March','April','May')~'Spring',
                     arrival_date_month %in% c('June','July','August')~'Summer',
                     arrival_date_month %in% c('September','October','November')~'Fall'))

#Changing date columns to Date class, year to factor

hotels$reservation_status_date <- as.Date(hotels$reservation_status_date,'%Y-%m-%d')
hotels$arrival_date_year <- as.factor(hotels$arrival_date_year)
hotels <- hotels %>% mutate(stay_revenue = total_nights*adr)
choice <- colnames(hotels)[-1]

ggplotly(hotels %>% group_by(season, arrival_date_year) %>% 
  ggplot(aes(x = season, y = stay_revenue)) + 
  geom_boxplot(aes(fill = season)) + 
  facet_wrap(~arrival_date_year)) 


g <- hotels %>% group_by(country) %>% 
  summarise(Total_rev = sum(stay_revenue)) %>% arrange(desc(Total_rev)) %>% 
  head(10) %>% ggplot(aes(x = country, y = Total_rev)) + geom_col(aes(fill = country),
                                                                   position = 'dodge')
 ggplotly(g)   
 
 h <- hotels %>% group_by(arrival_date_year,arrival_date_month,hotel) %>% 
   summarise(Med_adr = median(adr)) %>% ggplot(aes(x = arrival_date_month, y = Med_adr)) + 
   geom_col(aes(fill = hotel),position = 'dodge') + ylab('Median ADR') +
   xlab(NULL) + 
   facet_grid(rows = vars(arrival_date_year)) + coord_flip()
 ggplotly(h)  
 