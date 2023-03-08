# app/logic/utilizacion_de_quirofanos/grafico.R

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
                  xlsx::read.xlsx(file="app/logic/data/set_de_datos.xlsx",sheetIndex = 2, rowIndex = 15:59, colIndex= 1:3
                      , as.data.frame = TRUE, header = TRUE) |> 
                  echarts4r::group_by(Tipo.de.hora) |>
                  echarts4r::e_chart(Mes) |>
                  echarts4r::e_bar(Valor, stack = "Tipo.de.hora") |>
        echarts4r::e_tooltip(trigger = "axis",axisPointer = list(type = "shadow"))

                
                  
    })
    
   

  })
}