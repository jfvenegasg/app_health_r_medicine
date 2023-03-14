# app/logic/analisis_de_suspensiones/grafico_barra.R

box::use(
  reactable,
  MASS,
  shiny[h3, moduleServer, NS, tagList],
  dplyr,
  utils,
  echarts4r,
  pool,
  DBI
)

#box::use(
#  app/global)

#pool<-global$pool


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    echarts4r$echarts4rOutput(ns("grafico_barra"))
    
  )
  
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$grafico_barra<- echarts4r$renderEcharts4r({ 
      
      # xlsx::read.xlsx(file="app/logic/data/set_de_datos_1.xlsx",sheetIndex = 5, rowIndex = 16:160, colIndex= 2:5
      #                 , as.data.frame = TRUE, header = TRUE)  
      
      
      # Aca se lee la tabla suspensiones directamente desde la BD
      #suspensiones<-dplyr::tbl(pool,"datos_suspensiones")
      
      # Aca estamos guardando la base de datos en un excel para despues leer desde aca
      #xlsx::write.xlsx(x = suspensiones,file = "app_salud/app/logic/data/datos_suspensiones_bd.xlsx",row.names = FALSE)
      
      suspensiones<-xlsx::read.xlsx(file="app/logic/data/datos_suspensiones_bd.xlsx",sheetIndex = 1, rowIndex = 1:146, colIndex= 1:4
                                       , as.data.frame = TRUE, header = TRUE)
      data.frame(suspensiones) |>
        echarts4r::group_by(Causa.de.suspension) |>
        echarts4r::e_chart(Mes) |>
        echarts4r::e_theme("walden")|> 
        echarts4r::e_bar(Valor,stack="Causa.de.suspension") |>
        echarts4r::e_tooltip(trigger = "item",axisPointer = list(type = "shadow"),formatter = echarts4r::e_tooltip_item_formatter("percent"))
        

       
      
    })
    
    
    
  })
}