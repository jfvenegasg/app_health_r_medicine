# app/logic/Tiempo_extra/grafico_tiempoExtra.R

box::use(
  reactable,
  MASS,
  shiny[h3, moduleServer, NS, tagList],
  dplyr,
  utils,
  echarts4r
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    echarts4r$echarts4rOutput(ns("grafico"))
    
  )
  
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$grafico<- echarts4r$renderEcharts4r({ 
      xlsx::read.xlsx(file="app/logic/data/set_de_datos_1.xlsx",sheetIndex = 7, rowIndex = 152:165, colIndex= 4:5
                      , as.data.frame = TRUE, header = TRUE) |> 
        echarts4r::e_chart(Mes) |>
        echarts4r::e_bar(Tiempo.adicional, name = "Tiempo adicional") |>
        echarts4r::e_tooltip(trigger = "axis",axisPointer = list(type = "shadow"))
      
      
    })
    
    
    
  })
}