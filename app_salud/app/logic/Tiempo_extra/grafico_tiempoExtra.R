# app/logic/Tiempo_extra/grafico_tiempoExtra.R

box::use(
  reactable,
  MASS,
  shiny[h3, moduleServer, NS, tagList],
  dplyr,
  utils,
  echarts4r,
  pool
)

#box::use(
#  app/global)

#pool<-global$pool

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    echarts4r$echarts4rOutput(ns("grafico_extra"))
    
  )
  
}

#tiempoExtra<-xlsx::read.xlsx(file="app/logic/data/set_de_datos_1.xlsx",sheetIndex = 7, rowIndex = 253:265, colIndex= 4:6
#                             , as.data.frame = TRUE, header = TRUE)
#DBI::dbCreateTable(pool, name = "datos_tiempo_extra", fields = head(tiempoExtra))
#DBI::dbListTables(pool)
#DBI::dbRemoveTable(pool,"datos_tiempo_extra" )
#DBI::dbReadTable(pool, "datos_tiempo_extra")
#DBI::dbAppendTable(conn = pool,name ="datos_tiempo_extra" ,value =tiempoExtra )

#tiempoExtra<-dplyr::tbl(pool,"datos_tiempo_extra")

#xlsx::write.xlsx(x = tiempoExtra,file = "app/logic/data/datos_tiempo_extra_bd.xlsx",row.names = FALSE)



#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$grafico_extra<- echarts4r$renderEcharts4r({ 
      xlsx::read.xlsx(file="app/logic/data/datos_tiempo_extra_bd.xlsx",sheetIndex = 1, rowIndex = 1:13, colIndex= 1:3
                      , as.data.frame = TRUE, header = TRUE) |> 
        echarts4r::e_chart(Mes) |>
        echarts4r::e_bar(Tiempo.adicional, name = "Minutos adicionales") |>
        echarts4r::e_bar(Tiempo.de.inactividad, name = "Minutos de inactividad") |>
        echarts4r::e_theme("walden") |>
        echarts4r::e_tooltip(trigger = "axis",axisPointer = list(type = "shadow"))
      
      
    })
    
    
    
  })
}