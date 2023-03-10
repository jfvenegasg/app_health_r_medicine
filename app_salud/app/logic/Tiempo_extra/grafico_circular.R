# app/logic/Tiempo_extra/grafico_circular.R

box::use(
  reactable,
  MASS,
  shiny[h3, moduleServer, NS, tagList,selectInput],
  dplyr,
  utils,
  echarts4r
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    echarts4r$echarts4rOutput(ns("grafico_circular"))
    
  )
  
}



#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$grafico_circular<- echarts4r$renderEcharts4r({ 
      xlsx::read.xlsx(file="app/logic/data/set_de_datos_1.xlsx",sheetIndex = 7, rowIndex = 275:279, colIndex= 5:6
                      , as.data.frame = TRUE, header = FALSE) |> 
        echarts4r::e_chart(X5) |>
        echarts4r::e_pie(X6, radius = c("40%", "70%")) |>
        echarts4r::e_theme("walden")|>
        echarts4r::e_labels(show = TRUE,
                 formatter = "{d}%",
                 position = "inside")|>
      echarts4r::e_tooltip(trigger = "item",axisPointer = list(type = "shadow"),formatter = echarts4r::e_tooltip_pie_formatter("percent"))
      
      
    })
    
    
    
  })
}