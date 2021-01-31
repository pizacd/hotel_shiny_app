# Hotel shiny app server
shinyServer(function(input, output){
  
  
  ### Introduction tab outputs ###
  
  
  #Bar chart for number of reservations by hotel
  output$n_guests <- renderPlot(
    hotels %>% ggplot(aes(x = hotel)) + geom_bar(aes(fill = hotel)) +
      ggtitle('Number of reservations by hotel type') +
      xlab('Hotel type') +
      theme(plot.title = element_text(size = 15, hjust = 0.5))
  )
  
  #Histogram of average daily rate distribution by hotel
  output$adr_dist <- renderPlot(
    hotels %>% ggplot(aes(x = adr)) +
      geom_histogram(aes(fill = hotel), binwidth = 25, color = 'gray') +
      xlim(0, 600) + ggtitle('Distribution of daily rate by hotel type') +
      xlab('Average daily rate (USD)') +
      theme(plot.title = element_text(size = 15, hjust = 0.5))
  )
  
  
  ### Hotel Revenue tab outputs ###
  
  
  # Revenue bar chart organized by hotel, season and year
  output$total_rev <- renderPlot(
    hotels %>% group_by(season, arrival_date_year, hotel) %>%
      summarise(Total_revenue = sum(stay_revenue) / 1e6) %>%
      ggplot(aes(x = arrival_date_year, y = Total_revenue)) +
      geom_col(aes(fill = season), position = 'dodge') + facet_grid( ~ hotel) +
      ggtitle('Hotel revenue for both properties increasing year-over-year') +
      xlab('Year') + ylab('Total Revenue (in millions USD)') + 
      theme(plot.title =element_text(size = 15, hjust = 0.5))
  )
  
  # Histogram of distribution of revenue per stay by hotel, season and year
  output$stay_rev <- renderPlot(
    hotels %>%  group_by(season, arrival_date_year, hotel) %>%
      ggplot(aes(x = season, y = stay_revenue)) +
      ylim(0, 1500) + ylab('Revenue per stay (USD)') +
      ggtitle('Per stay revenue by season and year') +
      geom_boxplot(aes(fill = season)) +
      facet_wrap(~ arrival_date_year) +
      theme(plot.title = element_text(size = 15, hjust = 0.5)) +
      facet_grid(hotel ~ arrival_date_year)
  )
  
  # Scatter plot of days from booking to check-in by average daily rate
  output$loyal_rev <- renderPlot(
    hotels %>%
      group_by(previous_bookings_not_canceled, hotel) %>%
      summarise(Avg_stay = mean(stay_revenue)) %>%
      ggplot(aes(x = previous_bookings_not_canceled,
                 y = Avg_stay)) +
      geom_point(aes(color = hotel), size = 3, alpha =0.6) +
      geom_smooth(aes(color = hotel)) + 
      ggtitle('Returning guests to resort hotel spend less per stay') + 
      theme(plot.title = element_text(size = 15, hjust = 0.5)) +
      xlab('Number of non-canceled previous visits') + 
      ylab('Average spend per stay')
  )
  
  
  
  ### Guest Information tab outputs ###
  
  
  #info box for most common date bookings were made
  output$mode_booking <- renderInfoBox(
    infoBox(
      title = 'Mode booking date',
      value = hotels %>%
        group_by(booking_date) %>% count() %>% 
        arrange(desc(n)) %>%
        head(1) %>% select(booking_date),
      #subtitle is how many bookings were made on that day
      subtitle = paste((
        hotels %>%
          group_by(booking_date) %>%
          count() %>% arrange(desc(n)) %>%
          head(1)
      )$n,
      'bookings'
      ),
      color = 'green'
    )
  )
  
  #info box of the most occurring time period between booking and check-in
  output$mode_leadtime <- renderInfoBox(infoBox(
    title = 'Booking days ahead',
    paste(
      value = hotels %>%
        group_by(lead_time) %>%
        count() %>%
        arrange(desc(n)) %>%
        head(1) %>%
        select(lead_time),
      'days'
    ),
    #subtitle is how many bookings were made in that time period
      subtitle = paste((
        hotels %>% group_by(lead_time) %>%
          count() %>% arrange(desc(n)) %>% head(1)
      )$n,
      'bookings'
      ),
      color = 'green'
    )
  )
  
  output$max_revenue <- renderInfoBox(
    infoBox(title = 'Most expensive stay', 
            value = paste0('$',hotels %>% filter(
              is_canceled == 0) %>% summarise(max(stay_revenue))),
            subtitle = paste('Stay length:', hotels %>% filter(
              is_canceled ==0, stay_revenue == max(stay_revenue)) %>% 
                select(total_nights), 'nights'),color = 'green'
    )
  )
  # updates origin country and booking method plots by selected region
  selected_region <- reactive({
    subgroup = hotels %>% select(country_name,market_segment,region)
    
    #filters dataframe by region if selected input is not 'All'
    if(input$region !='All'){
      subgroup = subgroup %>% filter(region == input$region)}else{
        subgroup = subgroup %>% filter(region %in% unique(region)
        )
      }
    }
  )

  # Bar plot of top ten most occurring guest nationalities
  # calls selected_region reactive function to filter by region input
  output$top_10 <- renderPlot(
    selected_region() %>%
      group_by(country_name) %>%
      summarise(Num_guests = n()) %>%
      arrange(desc(Num_guests)) %>% head(10) %>%
      ggplot(aes(
        x = reorder(country_name, Num_guests, max),
        y = Num_guests
      )) +
      geom_col(aes(fill = country_name)) +
      xlab('Country of origin') +
      ylab('Number of reservations') +
      ggtitle('Top 10 guest countries of origin') +
      theme(plot.title = element_text(size = 15, hjust = 0.5)) +
      coord_flip()
  )
  
  # Bar plot of most used booking methods
  # calls selected_region reactive function to filter by region input
  output$booking_method <- renderPlot(
    selected_region() %>%
      group_by(market_segment) %>%
      summarise(Count = n()) %>%
      ggplot(aes(
        x = reorder(market_segment, Count, min),
        y = Count)) +
      geom_col(aes(fill = market_segment)) +
      ggtitle('Most popular booking methods') +
      xlab('Booking Method') +
      theme(plot.title =
              element_text(size = 15, hjust = 0.5)
    )
  )
  
  # Scatter plot w/ trend line for city average daily rates vs days booked in advance
  output$city_time <-
    renderPlot(
      hotels %>% filter(hotel == 'City Hotel') %>%
        ggplot(aes(x = lead_time, y = adr)) +
        geom_point(aes(color = season), alpha =0.03) +
        ylim(0, 400) + 
        geom_smooth(aes(color = season), method = lm, se = F) +
        xlab('Days booked in advance') +
        ylab('Average daily rate(USD)') +
        ggtitle('City hotel rates by days booked in advance') +
        theme(plot.title =
                element_text(size = 15, hjust = 0.5)
      )
    )
  
  # Scatter plot w/ trend line for resort average daily rates vs days booked in advance
  output$res_time <-
    renderPlot(
      hotels %>% filter(hotel == 'Resort Hotel') %>%
        ggplot(aes(x = lead_time, y = adr)) +
        geom_point(aes(color = season), alpha =0.03) +
        ylim(0, 400) + 
        geom_smooth(aes(color = season), method = lm, se = F) +
        xlab('Days booked in advance') +
        ylab('Average daily rate (USD)') +
        ggtitle('Resort hotel rates by days booked in advance') +
        theme(plot.title =
                element_text(size = 15, hjust = 0.5)
      )
    )
  
  
  
  ### Cancellations tab ###
  
  
  #Scatter plot with trend line for days booked in advance by cancellation window
  output$lead_cancelations <-
    renderPlot(
      cancel %>% group_by(hotel, lead_time) %>%
        summarise(cancel_window = mean(arrival_date - reservation_status_date)) %>%
        ggplot(aes(x = lead_time, 
                   y = as.numeric(cancel_window)
                  )
              ) +
        geom_point(aes(color = hotel), alpha = 0.8) + 
        xlim(0, 30) + ylim(0, 25) +
        geom_smooth(se = F) + 
        xlab('Number of days booked in advance') +
        ylab('Average days between cancellation and check-in') +
        ggtitle('Linear relationship between when you book and when you cancel') +
        theme(plot.title = element_text(size = 15, hjust = 0.5)
              )
            )
                                         
                                         
  # Chi square table for history of cancellations vs current cancellation                                   
  output$history_obs <- renderTable(cancel_results$observed,
                                    width = 6,
                                    rownames = F)
  
  # Chi square table for difference between actual observations and expectations
  output$history_diff <-
    renderTable(cancel_results$observed - cancel_results$expected,
                width = 6)
  
  # Chi square table for getting/not getting your room request vs current cancellation                                   
  output$room_obs <- renderTable(room_results$observed, 
                                 width = 6,
                                 rownames = F)
  # Chi square table for difference between actual observations and expectations
  output$room_diff <-
    renderTable(room_results$observed - room_results$expected,
                width = 6)
  
  
  
  ### Data tab ###
  
  
  #Creates a table of the entire hotel dataset
  output$dataframe <- renderDataTable(
    datatable(hotels,rownames = F, options = list(scrollX = T)
              )
    )
  }
)


