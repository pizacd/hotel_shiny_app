

# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  
  output$monthly_cityrev <- renderPlot(
    hotels %>% filter(hotel == 'City Hotel') %>% group_by(season, arrival_date_year) %>%
      ggplot(aes(x = season, y = stay_revenue)) +
      ylim(0, 1500) + ylab('Revenue per stay, USD') +
      ggtitle('Distribution of City Revenue by Season') +
      
      geom_boxplot(aes(fill = season)) +
      facet_wrap( ~ arrival_date_year) +
      theme(plot.title = element_text(hjust = 0.5))
  )
  
 
  output$monthly_resrev <- renderPlot(hotels %>% filter(
    hotel == 'Resort Hotel') %>% group_by(season, arrival_date_year) %>% 
      ggplot(aes(x = season, y = stay_revenue)) +
      ylim(0,1500)+ ylab('Revenue per stay, USD') +
      ggtitle('Distribution of Resort Revenue by Season') +
      
      geom_boxplot(aes(fill = season)) + 
      facet_wrap(~arrival_date_year) + theme(plot.title = 
                                               element_text(hjust = 0.5))) 
  
  output$guest_10 <- renderPlot(hotels %>% group_by(country_name) %>%
                                  summarise(Num_guests=n()) %>% 
                                  arrange(desc(Num_guests)) %>% 
                                  top_n(10) %>% ggplot(aes(x = country_name,
                                                           y = Num_guests)) +
                                  geom_col(aes(fill = country_name)) +
                                  xlab('Country of Origin') + 
                                  ylab('Number of Guests') + coord_flip()) 

    })


