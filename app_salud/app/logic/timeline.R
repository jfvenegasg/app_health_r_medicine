# app/logic/timeline.R

box::use(
  timevis,
  shiny[h3, moduleServer, NS, tagList,selectInput,reactive,observe,HTML,p],
  dplyr,
  utils,
  base,
  htmltools
)
box::use(
   app/logic/pabellon[pabellon],
 )

#source("app_salud/app/logic/pabellon.R")


#' @export
ui <- function(id) {
  
  ns <- NS(id)
  tagList(
    selectInput(ns("selector_1"),"Seleccion de especialidad",choices = c("Cirugia general"="esp1","Cirugia Pediatrica"="esp2")),
    
    timevis$timevisOutput(ns("chart"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    #pab<-pabellon(especialidad = reactive(get(input$selector_1)))
    
    output$chart <- timevis$renderTimevis(
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