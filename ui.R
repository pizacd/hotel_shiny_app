#Shiny topics lecture
library(DT)
library(shiny)
library(shinydashboard)

shinyUI(dashboardPage(
    dashboardHeader(title = 'Hotel Shiny Project'),
    dashboardSidebar(
        sidebarUserPanel('Hotel Dataset', #Seattle U logo against name
                         image = 'https://img.freepik.com/free-photo/hotel-bell_1203-2898.jpg?size=626&ext=jpg&ga=GA1.2.1165230996.1611879625'),
   
        
    # icons found at https://fontawesome.io/icons
    sidebarMenu(
        menuItem('Introduction', tabName = 'intro', icon = icon('info')),
        menuItem('Hotel Revenue',tabName = 'rev', icon = icon('money-bill-wave')), 
        menuItem('Data',tabName = 'data', icon = icon('database')),
        menuItem('About Me', tabName = 'me', icon = icon('portrait'))
    ),
    selectizeInput('selected',
                   'Select Item to Display',
                   choice)
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = 'intro',
                    fluidRow(h1('Intro goes here'))),
            tabItem(tabName = 'rev',
                    fluidRow(h1('map goes here'))),
            tabItem(tabName = 'data',
                    fluidRow(h1('DataFrame goes here'))),
            tabItem(tabName = 'me',
                    fluidRow(h1('Link in bio'))) #output$bio
        )
        
    ))
)


