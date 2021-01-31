#Hotel shiny dashboard

shinyUI(dashboardPage(
    dashboardHeader(title = 'Hotel Shiny Project'),
    
######## Dashboard Sidebar #########    
    dashboardSidebar(
        sidebarUserPanel('Hotel Dataset', 
                         image = 'https://img.freepik.com/free-photo/hotel-bell_1203-2898.jpg?size=626&ext=jpg&ga=GA1.2.1165230996.1611879625'),
   
    # icons found at https://fontawesome.io/icons
    sidebarMenu(
        menuItem('Introduction', tabName = 'intro', icon = icon('info')),
        menuItem('Hotel Revenue',tabName = 'rev', icon = icon('money-bill-wave')), 
        menuItem('Guest Information',tabName = 'guest', icon = icon('hotel')),
        menuItem('Cancellations',tabName = 'cancel', icon = icon('ban')),
        menuItem('Data',tabName = 'data', icon = icon('database')),
        menuItem('About Me', tabName = 'me', icon = icon('portrait'))
                )
    ),
    
    dashboardBody(tabItems(
        tabItem(
        tabName = 'intro',
        fluidPage(
            fluidRow(column(
                offset = 2,
                width = 8,
                h1(tags$b('Introduction'),
                   align = 'center')
                            )
                    ),
            br(),
        
            fluidRow(column(width = 12, box(width = 12,
                p('For my project, I found a dataset of hotel reservations on
                                  Kaggle, which can be found',
                    tags$a(href = 'https://kaggle.com/jessemostipak/hotel-booking-demand', 'here.'),
                    'The dataset was for two hotels in Portugal: a resort hotel in Algarve (left),
                                 and a city hotel in Lisbon (right) for stays occurring between
                  July 2015 and August 2017.'
                ),
                br(),
                p('The purpose of these analyses was to:',
                    br(),
                    br(),
                    tags$b('1.'), 'Summarize revenue by hotel type, season and year-over-year.',
                    br(),
                    tags$b('2.'), "Gain insight into client base as to where they're from,
                    how they book their stays and how far in advance they book from check-in day.",
                    br(),
                    
                    tags$b('3.'), 'Evaluate the client base that have canceled their stays and determine
                    if there are any underlying factors that contribute to these cancellations.',
                    br(),
                    br(),
                    'With these insights, we can make better data driven decisions such as who/where to
                    send advertisements and deals to increase hotel bookings, 
                    bookings, improve guest retention and increase total revenue.'
                    )
                )
            )
        ),
            fluidRow(column(
                width = 6, align = 'center',
                img(
                    src = 'https://image.freepik.com/free-photo/view-ponta-da-piedade-sunrise-algarve-portugal_268835-310.jpg',
                    height = 300,
                    width = 420
                    )
                            ),
                column(width = 6, align = 'center',
                        img(
                            src = 'https://img.freepik.com/free-photo/rossio-square-with-wavy-pattern-lisbon-portugal_218319-1161.jpg',
                            height = 300,
                            width = 420
                            )
                        )
                    ),
                    fluidRow(box
                             (width = 6,plotOutput('n_guests')
                             ),
                             box(width = 6,plotOutput('adr_dist')
                                )
                             )
                    )
                ), 
    
    
    
    ####### Hotel Revenue tab #########              
            tabItem(tabName = 'rev',
                    fluidPage(
                        fluidRow(column(
                            offset = 2, width = 8,
                                        box(width = 12,
                                            h1(tags$b('Revenue by Hotel Type'), 
                                               br()),
                                            align = 'center', 
                                            background = 'green')
                                        )
                                 ),
                        
                        fluidRow(
                            tabBox(width = 12,
                                   tabPanel('Total Revenue',plotOutput('total_rev')),
                                   tabPanel('Seasonal Revenue',plotOutput('stay_rev')),
                                   tabPanel('Retention Revenue',plotOutput('loyal_rev')
                                            )
                                   )
                            )
                        )
                    ),
            
    
    ###### Guest Information tab ########
    
            tabItem(tabName = 'guest',
                    fluidPage(
                    fluidRow(column(
                        offset = 2, width = 8,
                        box(width = 12,h1(tags$b('Guest Summaries'),
                                          br()),
                            align = 'center', 
                            background = 'purple')
                                    )
                             ),
                    
                    #Infoboxes
                    fluidRow(
                        infoBoxOutput('mode_booking'), 
                        infoBoxOutput('mode_leadtime'),
                        infoBoxOutput('max_revenue')
                        
                            ),
                    fluidRow(
                        selectInput(inputId = 'region', 
                                    label = 'Region filter',
                                    choices = c('All',unique(hotels$region)
                                                ),
                                    selected = 'All')
                            ),
                    br(),
                    fluidRow(
                        tabBox(width = 12,
                               tabPanel('Nationality',
                                        plotOutput('top_10')
                                        ),
                               tabPanel('Booking method',
                                        plotOutput('booking_method')
                                        )
                               )
                            )
                        ),
                   
                    fluidRow(
                        box(width = 6,plotOutput('city_time')),
                        box(width = 6,plotOutput('res_time'))
                            )
                    ),
           
    ######## Cancellations tab #######
    
            tabItem(tabName = 'cancel',
                    fluidPage(
                        fluidRow(
                            column(offset = 2, 
                            width = 8,
                            box(width = 12,
                                h1(tags$b('Cancellation Attributes'), 
                                            br()
                                   ),
                                align = 'center', 
                                background = 'red')
                                    )
                                ),
                       fluidRow(
                           tabBox(width = 12,
                                  tabPanel('Cancellation Window',
                                           plotOutput('lead_cancelations')
                                            ),
                
                                  tabPanel('Cancellation History',
                                           fluidRow(
                                               box(
                                               width = 6, 
                                               align = 'center',
                                               h2('Actual Stays'),
                                               tableOutput('history_obs')
                                                        ),
                                               box(width = 6, 
                                                   align = 'center',
                                                   h3('Actual Stays - Expectation'),
                                                   tableOutput('history_diff')
                                                    )
                                                    ),
                                           fluidRow(column(width = 8,
                                                             p('Upon statistical analysis, we 
                                                               find that a history of cancelling previous stays 
                                                               and cancelling your upcoming/future stay are not independent
                                                               of each other.',
                                                               br(),
                                                               br(),
                                                               'To improve guest retention, hotel management
                                                               could increase attention and improve customer service for guests
                                                               with no history of canceling previous stays compared
                                                               to guests who have canceled before.')
                                                            )
                                                    )
                                            ),
                                  tabPanel('Wrong Room',fluidRow(box(
                                             width = 6, align = 'center',
                                             h2('Actual assignments'),
                                             tableOutput('room_obs')
                                                                    ),
                                         box(width = 6, align = 'center',
                                             h3('Actual assignments - Expectation'),
                                             tableOutput('room_diff')
                                            )
                                         ),
                                         fluidRow(column(width = 8,
                                         p('Being assigned a different room type than
                                           what you requested and cancelling your stay
                                           are not independent of one another.')
                                                        )
                                                    )
                                        )
                            )
                        )
                    )
                ),
            
    
            
    ######### Data tab ##########
    
    tabItem(tabName = 'data',
                    fluidRow(column(offset = 1, width = 12,
                                    h1('Hotel booking dataset')
                                    )
                             ),
                    fluidRow(
                        box(width = 12, background = 'olive',
                            dataTableOutput('dataframe')
                            )
                            )
            ),
            
    
    
    ######## About me tab ########
    
    tabItem(tabName = 'me',
            fluidPage(
                br(),
                br(),
                fluidRow(box(offset = 3, 
                             width = 6,
                             align = 'center',
                             h3(tags$a(href = 'https://github.com/pizacd','LinkedIn')))),
                br(),
                fluidRow(box(offset = 3,
                             width = 6,
                             align = 'center',
                             h3(tags$a(href = 'https://linkedin.com/douglas-pizac-ms','GitHub')
                                )
                            )
                        )
                    )
                )
            )
        )
    )
)
     



