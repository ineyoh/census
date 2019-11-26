library(shiny)
library(shinydashboard)
library(shinyjs)
library(leaflet)

header <- dashboardHeader(title = "Montreal Statistics", 
                          dropdownMenu(type = "messages",
                                                   messageItem(
                                                     from = "Census Department",
                                                     message = "Conceptualize the census app"
                                                   ),
                                                   messageItem(
                                                     from = "New User",
                                                     message = "How do I register?",
                                                     icon = icon("question"),
                                                     time = "15:00"
                                                   ),
                                                   messageItem(
                                                     from = "Support",
                                                     message = "The new server is ready.",
                                                     icon = icon("life-ring"),
                                                     time = "2014-12-01"
                                                   )
                       ),
                       dropdownMenu(type = "notifications",
                                    notificationItem(
                                      text = "5 new users today",
                                      icon("users")
                                    ),
                                    notificationItem(
                                      text = "12 items delivered",
                                      icon("truck"),
                                      status = "success"
                                    ),
                                    notificationItem(
                                      text = "Server load at 86%",
                                      icon = icon("exclamation-triangle"),
                                      status = "warning"
                                    )
                       ),
                       dropdownMenu(type = "tasks", badgeStatus = "success",
                                    taskItem(value = 90, color = "green", "Documentation"),
                                    taskItem(value = 17, color = "aqua", "Project X"),
                                    taskItem(value = 75, color = "yellow", "Server deployment"),
                                    taskItem(value = 80, color = "red", "Overall project")
                                    )
)

sidebar <- dashboardSidebar(skin = "black",
                               sidebarMenu(
                                 menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                                 menuItem("Widgets", tabName = "widgets", icon = icon("th"), 
                                          badgeLabel = "new", badgeColor = "green"),
                                 menuItem("Montreal map", tabName = "maps"),
                                 menuItem("Montreal gallery", tabName = "gallery")
                                 )
                             )

body <- dashboardBody(
    tabItems(
      
      tabItem(tabName = "dashboard",
              h1("Census Details"),
              valueBox(10 * 2, "Area Codes Counted", icon = icon("thumbs-up"), color = "green"),
              valueBox(10 * 200, "People paid", icon = icon("credit-card"),  color = "yellow"),
              #tags$br(),  
              valueBox(5 * 2, "Progress", icon = icon("list"), color = "teal")
      ),
      
      tabItem(tabName = "widgets",
              h1("Census Statistics"),
              box(title = "Input", status = "warning", solidHeader = TRUE,
                  "Select a Number", collapsible = TRUE,
                  sliderInput("test", "Population in Montreal", 1, 100, 50),
                  textInput("text", "Text input:")),
              box(title = "Input", background = "olive", solidHeader = TRUE,
                  "View the Output", collapsible = TRUE, 
                  plotOutput("histogram")),
              h4("Download census Data for Montreal"),
              box(absolutePanel(top=745, left=300, actionButton("url", "Download Report", class="btn btn-primary", 
                                                            onclick="window.open('https://www12.statcan.gc.ca/census-recensement/2016
                                                            /dp-pd/prof/details/download-telecharger/comp/GetFile.cfm?Lang=E&FILETYPE=CSV&GEONO=065')")))
              
              # Create a data frame.
              #print(is.data.frame(count))
      ),
      
      tabItem(tabName = "maps",
              # Tell shiny we will use some Javascript
              useShinyjs(),
              extendShinyjs(text = jsCode),
              absolutePanel(top=70, left=300, textInput("target_zone", "Enter a postal code, or name of a place" , "Montreal")),
              br(),
              absolutePanel(top=140, left=300, leafletOutput("map", width = "1200px", height = "600px")),
              #one button and one map
              absolutePanel(top=745, left=300, actionButton("geoloc", "My Location", class="btn btn-primary", onClick="shinyjs.geoloc()"))
      ),
      
    tabItem(tabName = "gallery",
            h1("Montreal Gallery"),
            tags$img(height =300,
                         width = 500,  
                         src = "https://www.mtlblog.com/uploads/284903_03ccde64d3656b89cef0db7f0cdaf20d6cfc70dc.jpg_facebook.jpg"),
            tags$img(height =300, 
                     width = 500,  
                         src = "https://www.mtlblog.com/u/2019/09/10/9bfab897fee050ccc74bde25aa7dd8bc.jpg_1200x630.jpg")
            )
    )
)

#Add all the content into a dashboardPage
dashboardPage(skin = "green", 
               header,
               sidebar,
               body
              )

