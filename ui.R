#Shiny topics lecture

shinyUI(dashboardPage(
    dashboardHeader(title = 'Hotel Shiny Project'),
    dashboardSidebar(
        sidebarUserPanel('Hotel Dataset', #Seattle U logo against name
                         image = 'https://img.freepik.com/free-photo/hotel-bell_1203-2898.jpg?size=626&ext=jpg&ga=GA1.2.1165230996.1611879625'),
   
        
    # icons found at https://fontawesome.io/icons
    sidebarMenu(
        menuItem('Introduction', tabName = 'intro', icon = icon('info')),
        menuItem('Hotel Revenue',tabName = 'rev', icon = icon('money-bill-wave')), 
        menuItem('Guest Attributes',tabName = 'guest', icon = icon('hotel')),
        menuItem('Data',tabName = 'data', icon = icon('database')),
        menuItem('About Me', tabName = 'me', icon = icon('portrait'))
        
    )),
    dashboardBody(
        tabItems(
            tabItem(tabName = 'intro',
                    fluidPage(
                        fluidRow(column(offset = 2, width = 8, h1(tags$b('Introduction'),
                                                                  align = 'center'))),
                        br(),
                        
                        fluidRow(column(width = 12,box(
                            p('For my project, I found a dataset of hotel reservations on 
                              Kaggle, which can be found',
                              tags$a(href = 'https://kaggle.com/jessemostipak/hotel-booking-demand','here.'),
                             'The dataset was for two hotels in Portugal: a resort hotel in Algarve,
                             and a city hotel in Lisbon.'),
                            br(),
                            p('The purpose of these analyses was to:'))
                            )),
                        fluidRow(column(width = 6,
                            img(src = 'https://image.freepik.com/free-photo/view-ponta-da-piedade-sunrise-algarve-portugal_268835-310.jpg',
                                                   height = 300, width = 400)),
                            column(width = 6,
                            img(src = 'https://img.freepik.com/free-photo/rossio-square-with-wavy-pattern-lisbon-portugal_218319-1161.jpg',
                                height = 300, width = 400)))
                        
                        
                        
                        )
                    ),
                    
            tabItem(tabName = 'rev',
                    fluidPage(
                        fluidRow(column(offset = 2, width = 8,
                                        box(width = 12,h1(tags$b('Revenue by Hotel Type'), 
                                                          br()),
                                            align = 'center', background = 'navy')
                                                          
                                        )),
                        fluidRow(
                            tabBox(width = 6,
                                   tabPanel('City Revenue',plotOutput('monthly_cityrev'))),
                            tabBox(width = 6,
                                   tabPanel('Resort Revenue',plotOutput('monthly_resrev')))
                        ))),
            
            tabItem(tabName = 'guest',
                    fluidPage(
                    fluidRow(h1('Guest info go here')),
                    fluidRow(
                        tabBox(width = 12,
                               tabPanel('Guest Nationalities',plotOutput('guest_10')))
                    ))),
            tabItem(tabName = 'data',
                    fluidRow(h1('DataFrame goes here'))),
            tabItem(tabName = 'me',
                    fluidPage(
                        fluidRow(p(tags$a(href = 'github.com/pizacd','LinkedIn'))),
                        br(),
                        fluidRow(p(tags$a(href = 'linkedin.com/douglas-pizac-ms','GitHub')))
                        )
                    )
            )
                                        
        )
    )
)
     



