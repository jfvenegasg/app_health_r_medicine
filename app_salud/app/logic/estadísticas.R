# app/logic/estadísticas.R

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
    
    echarts4r$echarts4rOutput(ns("grafico1"))
  ) 
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$grafico1<- echarts4r$renderEcharts4r({ 
                  xlsx::read.xlsx(file="app/logic/data/set_de_datos_1.xlsx",sheetIndex = 1, rowIndex = 1:13, colIndex= c(1,4)
                      , as.data.frame = TRUE, header = TRUE) |> 
        echarts4r::e_charts(Mes,stack="grp") |> echarts4r::e_bar(Porcentaje.de.horas.mensuales.de.Quirófanos.en.trabajo,name="Porcentaje de uso de quirofanos")   
      
                
                  
    })

  })
}