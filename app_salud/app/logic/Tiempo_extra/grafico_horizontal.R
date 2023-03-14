# app/logic/Tiempo_extra/grafico_horizontal.R

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
    selectInput(ns("selector_2"),"Seleccionar orden",choices = c("Tiempo adicional decreciente"="Tiempo.adicional","Tiempo de inactividad decreciente"="Tiempo.de.inactividad")),
    echarts4r$echarts4rOutput(ns("grafico_horizontal"))
    
  )
  
}
#datos<-xlsx::read.xlsx(file="app/logic/data/set_de_datos_1.xlsx",sheetIndex = 7, rowIndex = 267:272, colIndex= 4:6
#                , as.data.frame = TRUE, header = TRUE)

#DBI::dbCreateTable(pool, name = "datos_tiempo_pomedio_extra", fields = head(datos))
#DBI::dbListTables(pool)
#DBI::dbRemoveTable(pool,"datos_tiempo_pomedio_extra" )
#DBI::dbReadTable(pool, "datos_tiempo_pomedio_extra")
#DBI::dbAppendTable(conn = pool,name ="datos_tiempo_pomedio_extra" ,value =datos )

#datos<-dplyr::tbl(pool,"datos_tiempo_pomedio_extra")

#xlsx::write.xlsx(x = datos,file = "app/logic/data/datos_tiempo_pomedio_extra_bd.xlsx",row.names = FALSE)

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$grafico_horizontal<- echarts4r$renderEcharts4r({ 
      xlsx::read.xlsx(file="app/logic/data/datos_tiempo_pomedio_extra_bd.xlsx",sheetIndex = 1, rowIndex = 1:6, colIndex= 1:3
                      , as.data.frame = TRUE, header = TRUE)|> 
        #dplyr::arrange(input$selector_2)|>
        dplyr::arrange(Tiempo.adicional)|>
        echarts4r::e_chart(Especialidad) |>
        echarts4r::e_bar(Tiempo.adicional, name = "Minutos adicionales promedio") |>
        echarts4r::e_bar(Tiempo.de.inactividad, name = "Minutos de inactividad promedio") |>
        echarts4r::e_labels(position = "right") |>
        echarts4r::e_flip_coords() |>
        echarts4r::e_y_axis(splitLine = list(show = FALSE)) |>
        echarts4r::e_theme("walden")|>
        echarts4r::e_tooltip(trigger = "axis",axisPointer = list(type = "shadow"))
        
    
      
    })
    
    
    
  })
}