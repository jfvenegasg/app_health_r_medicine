#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
function(input, output, session) {
  
  #### Carga de imagen ####
  output$myImage <- renderImage({
    
    list(src = "modulos/data/imagen_inicio.jpg",
         width = "100%",
         height = 175)
    
  }, deleteFile = F)
  
  #### Reporte quirofanos ####
  
  #grafico utilización de quirofanos
  output$grafico<- renderEcharts4r({ 
    openxlsx::read.xlsx(xlsxFile ="modulos/data/set_de_datos_1.xlsx" ,sheet ="Horas" ,rows = 15:37,cols = 5:7 ) |>
    # xlsx::read.xlsx(file="modulos/data/set_de_datos_1.xlsx",sheetIndex = 4, rowIndex = 15:37, colIndex= 5:7
    #                 , as.data.frame = TRUE, header = TRUE) |> 
    #   echarts4r::group_by(Tipo.de.hora) |>
      echarts4r::e_chart(Mes) |>
      echarts4r::e_bar(Valor) |>
      echarts4r::e_mark_p(type = "line",
                          data = list(yAxis = 0.6), 
                          title = "Line at 50") |>
      echarts4r::e_theme("walden")|> 
      echarts4r::e_tooltip(trigger = "axis",axisPointer = list(type = "shadow"), formatter = "{d}%")
  })
  
  #tabla utilización de quirofanos
  output$tabla<-renderReactable({
    openxlsx::read.xlsx(xlsxFile ="modulos/data/set_de_datos_1.xlsx" ,sheet ="Horas" ,rows = 1:12,cols = 1:12 ) |> 
    # xlsx::read.xlsx(file="modulos/data/set_de_datos_1.xlsx",sheetIndex = 4, rowIndex = 1:12, colIndex= 1:12
    #                 , as.data.frame = TRUE, header = TRUE) |>
    #   dplyr::mutate_if(is.numeric, ~ dplyr::case_when(. < 2 ~ round(., 2), TRUE ~ ceiling(.))) |> 
      dplyr::mutate_at(8:12, scales::percent) |>
      reactable::reactable(searchable = TRUE, minRows = 10) 
    
  })
  
  
  #### Analisis de suspensiones ####
  
  # Tiempo total adicional y de inactividad
  output$grafico_barra<- renderEcharts4r({ 
    suspensiones<-openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_suspensiones_bd.xlsx" ,sheet ="Sheet1" ,rows = 1:146,cols = 1:4 )
    # suspensiones<-xlsx::read.xlsx(file="modulos/data/datos_suspensiones_bd.xlsx",sheetIndex = 1, rowIndex = 1:146, colIndex= 1:4
    #                               , as.data.frame = TRUE, header = TRUE)
    data.frame(suspensiones) |>
      echarts4r::group_by(Causa.de.suspension) |>
      echarts4r::e_chart(Mes) |>
      echarts4r::e_theme("walden")|> 
      echarts4r::e_bar(Valor,stack="Causa.de.suspension") |>
      echarts4r::e_tooltip(trigger = "item",axisPointer = list(type = "shadow"),formatter = echarts4r::e_tooltip_item_formatter("percent"))
  })
  
  # Tiempo adicional y tiempo de inactividad promedio por cirugia
  output$grafico_sankey<- renderEcharts4r({ 
    
    datos_suspensiones_sankey<-openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_suspensiones_sankey_bd.xlsx" ,sheet ="Sheet1" ,rows = 1:36,cols = 1:3 )
    # datos_suspensiones_sankey<-xlsx::read.xlsx(file="modulos/data/datos_suspensiones_sankey_bd.xlsx",sheetIndex = 1, rowIndex = 1:36, colIndex= 1:3
    #                                            , as.data.frame = TRUE, header = TRUE)
    
    data.frame(datos_suspensiones_sankey) |> 
      echarts4r::e_charts() |> 
      echarts4r::e_sankey(source, target, value,layoutIterations = 6) |> 
      echarts4r::e_title("Sankey chart") |>
      echarts4r::e_dims(height = "900px", width = "auto") |>
      echarts4r::e_theme("walden")|> 
      echarts4r::e_tooltip() 
  })
  
  
  
  shinyWidgets::show_toast(
    title = "Sistema de gestion HBV",
    text = "Este dashboard es solo una version de prueba",
    type = "info",
    position = "top",
    timer=2000,
    width = "800"
  )

}
