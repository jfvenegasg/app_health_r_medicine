# app/logic/Tiempo_extra/grafico_circular.R

box::use(
  reactable,
  MASS,
  shiny[h3, moduleServer, NS, tagList,selectInput],
  dplyr,
  utils,
  echarts4r
)

#box::use(
#  app/global)

#pool<-global$pool


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    echarts4r$echarts4rOutput(ns("grafico_circular2"))
    
  )
  
}


#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$grafico_circular2<- echarts4r$renderEcharts4r({ 
      xlsx::read.xlsx(file="app/logic/data/datos_porcentaje_tiempo_extra_bd.xlsx",sheetIndex = 1, rowIndex = 7:11, colIndex= 1:2
                      , as.data.frame = TRUE, header = FALSE) |> 
        echarts4r::e_chart(X1) |>
        echarts4r::e_pie(X2, radius = c("40%", "70%")) |>
        echarts4r::e_theme("walden")|>
        echarts4r::e_labels(show = TRUE,
                            formatter = "{d}%",
                            position = "inside")|>
        echarts4r::e_tooltip(trigger = "item",axisPointer = list(type = "shadow"),formatter = echarts4r::e_tooltip_pie_formatter("percent"))
      
      
    })
    
    
    
  })
}