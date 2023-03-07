# app/logic/estadísticas.R

box::use(
  reactable,
  MASS,
  shiny[h3, moduleServer, NS, tagList,selectInput,reactive,observe,HTML,p],
  dplyr,
  utils,
  highcharter
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    selectInput(ns("selector_1"),"Seleccion de especialidad",choices = c("Cirugía general"="Cirugía general","Neurocirugía"="Neurocirugía","Cirugía cardiovascular"="Cirugía cardiovascular")),
    highcharter$highchartOutput(ns("histograma"))
  )
}

tiempo<-xlsx::read.xlsx(file="app/logic/data/set_de_datos_1.xlsx",sheetIndex = 2, rowIndex = 1:150, colIndex= 1:2
                        , as.data.frame = TRUE, header = TRUE)

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$histograma<- highcharter::renderHighchart({
      highcharter::hchart(subset(tiempo,Especialidad==input$selector_1)[,2], type = "area", name = "Demanda")
    })
      
    
  })
}
