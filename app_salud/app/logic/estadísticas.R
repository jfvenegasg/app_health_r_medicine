# app/logic/estadísticas.R

box::use(
  reactable,
  MASS,
  shiny[h3, moduleServer, NS, tagList],
  dplyr,
  utils,
  highcharter
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    highcharter$highchartOutput(ns("grafico1"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$grafico1<- highcharter$renderHighchart({ 
                  xlsx::read.xlsx(file="app/logic/data/set_de_datos_1.xlsx",sheetIndex = 1, rowIndex = 1:13, colIndex= c(1,4)
                      , as.data.frame = TRUE, header = TRUE) |> 
                  highcharter::hchart("column", highcharter::hcaes(x = "Mes", y = "Porcentaje.de.horas.mensuales.de.Quirófanos.en.trabajo")) |>
                  highcharter::hc_xAxis(title = list(text = "Mes")) |>  
                  highcharter::hc_yAxis(title = list(text = "Porcentaje de ocupación de quirófanos")) 
                
                  
    })

  })
}