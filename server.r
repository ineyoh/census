library(shiny)
library(shinydashboard)
library(shinyjs)
library(leaflet)
library(ggmap)

# ==== function allowing geolocalisation
jsCode <- '
shinyjs.geoloc = function() {
    navigator.geolocation.getCurrentPosition(onSuccess, onError);
    function onError (err) {
        Shiny.onInputChange("geolocation", false);
    }
    function onSuccess (position) {
        setTimeout(function () {
            var coords = position.coords;
            console.log(coords.latitude + ", " + coords.longitude);
            Shiny.onInputChange("geolocation", true);
            Shiny.onInputChange("lat", coords.latitude);
            Shiny.onInputChange("long", coords.longitude);
        }, 5)
    }
};
'

register_google(key = "AIzaSyCheEjvViqFWET60ZFk_SYueQX3Rk9z5SE", write = TRUE)

shinyServer(function(input, output){
  
  output$histogram <- renderPlot({
    hist(rnorm(input$test))
  })
  
  #output$value <- renderText({input$mapInput})
  
    output$map <- renderLeaflet({
      # Get latitude and longitude
    if(input$target_zone=="Bamako"){
      ZOOM=2
      LAT=0
      LONG=0
    }else{
      target_pos=geocode(input$target_zone)
      LAT=target_pos$lat
      LONG=target_pos$lon
      ZOOM=20
    }
      # Plot it!
      leaflet() %>%
      addTiles() %>%
      setView(lng=LONG, lat=LAT, zoom=ZOOM ) %>%
      addProviderTiles("OpenStreetMap_Mapnik") 
      })
        
    
    # Find geolocalisation coordinates when user clicks
    observeEvent(input$geoloc, {
      js$geoloc()
    })
    
   
    # zoom on the corresponding area
    observe({
      if(!is.null(input$lat)){
        map <- leafletProxy("map")
        dist <- 0.2
        lat <- input$lat
        lng <- input$long
        map %>% fitBounds(lng - dist, lat - dist, lng + dist, lat + dist)
      }
    })
})
