# app/logic/timeline.R

box::use(
  timevis,
  shiny[h3, moduleServer, NS, tagList,selectInput,reactive,observe,HTML,p,icon,h2],
  dplyr,
  utils,
  base,
  htmltools,
  shinycssloaders[withSpinner],
  bs4Dash
)
box::use(
   app/logic/pabellon[pabellon])

#source("app_salud/app/logic/pabellon.R")


#' @export
ui <- function(id) {
  
  ns <- NS(id)
  tagList(
    bs4Dash::valueBox(width = 3,value=h2(5),color = "primary",subtitle="Pabellones disponibles",icon = icon("check")),
    bs4Dash::valueBox(width = 3,value=h2(2),color = "secondary",subtitle="Especialidades disponibles",icon = icon("check")),
    bs4Dash::valueBox(width = 3,value=h2(170),color = "success",subtitle="Horas disponibles",icon = icon("check")),
    bs4Dash::valueBox(width = 3,value=h2(200),color = "warning",subtitle="Horas no disponibles",icon = icon("check")),
    selectInput(ns("selector_1"),"Seleccion de especialidad",choices = c("Cirugia general"="esp1","Cirugia Pediatrica"="esp2")),
    
    timevis$timevisOutput(ns("linea_de_tiempo"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    #pab<-pabellon(especialidad = reactive(get(input$selector_1)))
    
    output$linea_de_tiempo <- timevis$renderTimevis(
      # Datasets are the only case when you need to use :: in `box`.
      # This issue should be solved in the next `box` release.
      
      timevis::timevis(data = data.frame(
        id = pabellon(especialidad=input$selector_1)[[1]],
        content  = pabellon(especialidad=input$selector_1)[[2]],
        
        start = pabellon(especialidad=input$selector_1)[[3]],
        
        end   = pabellon(especialidad=input$selector_1)[[4]],
        
        group = c(rep("Pabellon 1", pabellon(especialidad=input$selector_1)[[5]]), rep("Pabellon 2", pabellon(especialidad=input$selector_1)[[5]]), rep("Pabellon 3", pabellon(especialidad=input$selector_1)[[5]])),
        
        type = c(rep("range", pabellon(especialidad=input$selector_1)[[6]]))
        
      ),       
        groups = data.frame(id = c("Pabellon 1", "Pabellon 2", "Pabellon 3","Pabellon 4","Pabellon 5"),
                                  content = c("Pabellon 1", "Pabellon 2", "Pabellon 3","Pabellon 4","Pabellon 5")),
      options = list(selectable=TRUE,editable=list(add=TRUE,updateTime=TRUE,updateGroup=TRUE,remove=TRUE,overrideItems=TRUE),
                     orientation = "top",multiselect=TRUE,clickToUse=TRUE,horizontalScroll=TRUE,zoomKey='altKey',moveable=TRUE)) 
      
      
    )
  })
}