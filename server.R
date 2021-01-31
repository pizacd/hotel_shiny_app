

# Define server logic required to draw a histogram
shinyServer(function(input, output,session){
  ##Introduction
  output$n_guests <- renderPlot(
    hotels %>% ggplot(aes(x = hotel)) +geom_bar(aes(fill = hotel))+
      ggtitle('Number of reservations by hotel type')+
      xlab('Hotel type')+
      theme(plot.title=element_text(size = 15, hjust = 0.5))
  )
  
  output$adr_dist <- renderPlot(
    hotels %>% ggplot(aes(x = adr)) +
      geom_histogram(aes(fill = hotel),binwidth = 25, color = 'gray') +
      xlim(0,600) + ggtitle('Distribution of daily rate by hotel type')+
      xlab('Average daily rate (USD)')+
             theme(plot.title = element_text(size = 15, hjust = 0.5))
  )
  
  
  ##Hotel Revenue##
  
  output$total_rev <- renderPlot(
    hotels %>% group_by(season, arrival_date_year, hotel) %>% 
      summarise(Total_revenue = sum(stay_revenue)) %>% 
      ggplot(aes(x = arrival_date_year, y = Total_revenue)) + 
    geom_col(aes(fill = season),position = 'dodge') + facet_grid(~hotel)+
      ggtitle('Hotel revenue for both properties increasing year-over-year') +
      xlab('Year') + ylab('Total Revenue (USD)') + theme(
        plot.title =element_text(size = 15, hjust = 0.5)
      ))
  
  
  output$stay_rev <- renderPlot(
    hotels %>%  group_by(season, arrival_date_year,hotel) %>%
      ggplot(aes(x = season, y = stay_revenue)) +
      ylim(0, 1500) + ylab('Revenue per stay (USD)') +
      ggtitle('Distribution of Hotel Revenue by Season and Year') +
      geom_boxplot(aes(fill = season)) +
      facet_wrap( ~ arrival_date_year) +
      theme(plot.title = element_text(size = 15, hjust = 0.5)) + 
      facet_grid(hotel~arrival_date_year)
  )
  
  output$loyal_rev <- renderPlot(hotels %>% 
                                   group_by(previous_bookings_not_canceled,hotel) %>% 
                                   summarise(Avg_stay = mean(stay_revenue)) %>% 
                                   ggplot(aes(x = previous_bookings_not_canceled, 
                                              y = Avg_stay)) + 
                                   geom_point(aes(color = hotel),size = 3,alpha =0.6) + 
                                   geom_smooth(aes(color = hotel))+ggtitle(
                                     'Returning guests to resort hotel spend less per stay'
                                   ) + theme(plot.title = element_text(
                                     size = 15,hjust = 0.5)) + 
    xlab('Number of non-cancelled previous visits') + ylab('Average spend per stay'))

  
  ##Guest Information
  output$mode_booking <- renderInfoBox(
    infoBox(title = 'Mode booking date', value = hotels %>% 
              group_by(booking_date) %>% count() %>% arrange(desc(n)) %>% 
              head(1) %>% select(booking_date),color = 'green'
    ))
  
  output$mode_leadtime <- renderInfoBox(
    infoBox(title = 'Mode booking time', paste(value = hotels %>% 
                                                 group_by(lead_time) %>% count() %>% arrange(desc(n)) %>% head(1) %>% 
                                                 select(lead_time),'days'), color = 'green'))
  
  output$max_revenue <- renderInfoBox(
    infoBox(title = 'Most expensive stay', 
            value = paste0('$',hotels %>% filter(
              is_canceled == 0) %>% summarise(max(stay_revenue))), color = 'green'
    )
  )
  

  
  output$guest_10 <- renderPlot(hotels %>% group_by(country_name) %>%
                                  summarise(Num_guests = n()) %>% 
                                  arrange(desc(Num_guests)) %>% head(10) %>% 
                                  ggplot(aes(x = country_name,y = Num_guests)) +
                                  geom_col(aes(fill = country_name)) +
                                  xlab('Country of Origin') + 
                                  ylab('Number of Guests') + coord_flip())
  

  output$booking_method <- renderPlot(hotels %>% 
                                        ggplot(aes(x = market_segment))
                                      +geom_bar(aes(fill = market_segment)) +
                                        ggtitle('Online travel agent most popular booking method') +
                                        xlab('Booking Method') +
                                        theme(plot.title = element_text(size =15, hjust = 0.5)))
  
 
  
  output$city_time <- renderPlot(hotels %>% filter(hotel == 'City Hotel') %>% 
                                   ggplot(aes(x = lead_time, y = adr)) +
                                   geom_point(aes(color = season),alpha =0.05) + 
                                   ylim(0,400) + geom_smooth(aes(
                                     color = season), method = lm, se = F)+
                                   xlab('Days booked in advance')+
                                   ylab('Average daily rate(USD)')
                                 +ggtitle('City hotel rates by days booked in advance')+
                                   theme(plot.title = 
                                           element_text(size = 15, hjust = 0.5)))
  
  output$res_time <- renderPlot(hotels %>% filter(hotel == 'Resort Hotel') %>% 
                                   ggplot(aes(x = lead_time, y = adr)) +
                                   geom_point(aes(color = season),alpha =0.05) + 
                                   ylim(0,400) + geom_smooth(aes(
                                     color = season),method = lm, se = F)+
                                  xlab('Days booked in advance') + 
                                  ylab('Average daily rate (USD)')+
                                  ggtitle('Resort hotel rates by days booked in advance')+
                                  theme(plot.title = 
                                          element_text(size = 15, hjust = 0.5)))
  
  
  
  ##### Cancellations tab #####
  output$lead_cancelations <- renderPlot(cancel %>% summarise(days_between = 
                          reservation_status_date-booking_date)
                                         %>% ggplot(aes(x = days_between)) + 
                            geom_histogram(fill = 'red',color = 'gray',binwidth = 7) + 
                            xlim(0,400) + 
                            ylim(0,5000)+
                            ggtitle('Most Cancellations Occur within One Week of Check-in')+
                            xlab('Days booked in advance')+
                            theme(plot.title = element_text(size = 15, hjust = 0.5)))
  
  output$histobs <- renderTable(cancel_results$observed,width = 6,
                                rownames = F)
  output$histdiff <- renderTable(cancel_results$observed - cancel_results$expected,
                                 width = 6)
  
  output$roomobs <- renderTable(room_results$observed,width = 6,
                                rownames = F)
  output$roomdiff <- renderTable(room_results$observed - room_results$expected,
                                 width = 6)
  ##Data
  output$dataframe <- renderDataTable(
    datatable(hotels,rownames = F, options = list(scrollX = T)))
  
  
 

    })


