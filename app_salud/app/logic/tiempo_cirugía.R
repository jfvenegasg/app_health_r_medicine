# app/logic/tiempo_cirugía.R

box::use(
  reactable,
  MASS,
  shiny[h3, moduleServer, NS, tagList,selectInput,reactive,observe,HTML,p],
  dplyr,
  utils,
  echarts4r
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    selectInput(ns("selector_1"),"Seleccion de especialidad",choices = c("Cirugía general"="Cirugía general","Neurocirugía"="Neurocirugía","Cirugía cardiovascular"="Cirugía cardiovascular")),
    echarts4r$echarts4rOutput(ns("histograma"))
  )
}

tiempo<-xlsx::read.xlsx(file="app/logic/data/set_de_datos_1.xlsx",sheetIndex = 2, rowIndex = 1:150, colIndex= 1:2
                        , as.data.frame = TRUE, header = TRUE)

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$histograma<-
      
      echarts4r$renderEcharts4r({ 
        xlsx::read.xlsx(file="app/logic/data/set_de_datos_1.xlsx",sheetIndex = 2, rowIndex = 1:150, colIndex= 1:2
                        , as.data.frame = TRUE, header = TRUE) |>
          echarts4r::group_by(Especialidad==input$selector_1)
          echarts4r::e_charts() |>
          echarts4r::e_histogram(Minutos) |>
          echarts4r::e_tooltip(trigger = "axis",axisPointer = list(type = "shadow"))
    })
      
    
  })
}
