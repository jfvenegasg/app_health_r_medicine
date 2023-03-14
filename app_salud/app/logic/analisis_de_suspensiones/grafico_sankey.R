# app/logic/analisis_de_suspensiones/grafico_sankey.R

box::use(
  reactable,
  MASS,
  shiny[h3, moduleServer, NS, tagList],
  dplyr,
  utils,
  echarts4r,
  stats,
  pool
)

#box::use(
#  app/global)

#pool<-global$pool

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    echarts4r$echarts4rOutput(ns("grafico_sankey"))
    
  )
  
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$grafico_sankey<- echarts4r$renderEcharts4r({ 
      
      #datos_suspensiones_sankey<-dplyr::tbl(pool,"sankey_datos_suspensiones")
      
      # Aca estamos guardando la base de datos en un excel para despues leer desde aca
      #xlsx::write.xlsx(x = datos_suspensiones_sankey,file = "app_salud/app/logic/data/datos_suspensiones_sankey_bd.xlsx",row.names = FALSE)
      
      datos_suspensiones_sankey<-xlsx::read.xlsx(file="app/logic/data/datos_suspensiones_sankey_bd.xlsx",sheetIndex = 1, rowIndex = 1:36, colIndex= 1:3
                                    , as.data.frame = TRUE, header = TRUE)
      
      data.frame(datos_suspensiones_sankey) |> 
        echarts4r::e_charts() |> 
        echarts4r::e_sankey(source, target, value,layoutIterations = 6) |> 
        echarts4r::e_title("Sankey chart") |>
        echarts4r::e_dims(height = "900px", width = "auto") |>
        echarts4r::e_theme("walden")|> 
        echarts4r::e_tooltip() 

      
      
      
    })
    
    
    
  })
}