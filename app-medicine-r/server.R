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
    
    list(src = "modulos/data/imagen_de_inicio.png")
    
  }, deleteFile = F)
  
  #### Reporte quirofanos ####
  
  #grafico utilización de quirofanos
  output$grafico<- renderEcharts4r({ 
    openxlsx::read.xlsx(xlsxFile ="modulos/data/set_de_datos_1.xlsx" ,sheet ="Horas" ,rows = 15:37,cols = 5:7 ) |>
    # datos<-pd$read_excel('modulos/data/set_de_datos_1.xlsx',sheet_name ="Horas")
    # datos<-datos[15:36,5:7]
    # datos |>
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
  

  
  #### Analisis de suspensiones por causa####
  
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
      echarts4r::e_dims(height = "600px", width = "auto") |>
      echarts4r::e_theme("walden")|> 
      echarts4r::e_tooltip() 
  })
  
  # Grafico de pareto % de total 15 Años Y Más junto con Causas De Suspensión
  
  output$grafico_pareto_1<- renderEcharts4r({ 
    
    suspensiones<-openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_suspensiones_bd.xlsx" ,sheet ="Sheet1" ,rows = 1:146,cols = 1:4 )
    
    suspensiones<-suspensiones |> mutate(Valor_anual = Valor/12)
    
    suspensiones_15<-aggregate(Valor_anual ~ Causa.de.suspension + Descripcion,subset(suspensiones,Descripcion=="% de total 15 Años Y Más junto con Causas De Suspensión Atribuibles A:"), sum)
    
    suspensiones_15<-suspensiones_15 |>  arrange(desc(Valor_anual))
    
    suspensiones_15 |>
      mutate(acumulado = cumsum(Valor_anual)) |>
      e_charts(Causa.de.suspension) |>
      e_bar(Valor_anual) |>
      e_line(acumulado, y_index = 1) |>
      e_tooltip(trigger = "axis")  |>
      e_axis_labels(y = "Valor", x = "Suspensiones") |>
      e_title("Grafico de Pareto del % de total 15 Años Y Más") |>
      e_theme("walden")|>
      e_mark_line(data = list(yAxis = 0.80),
                  y_index = 1, 
                  symbol = "none", 
                  lineStyle = list(type = 'solid'), 
                  title = "Umbral al 80% ")
    
    
  })
  
  # Grafico de pareto % de total Suspensiones totales junto con Causas De Suspensión
  
  output$grafico_pareto_2<- renderEcharts4r({ 
    
    suspensiones<-openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_suspensiones_bd.xlsx" ,sheet ="Sheet1" ,rows = 1:146,cols = 1:4 )
    
    suspensiones<-suspensiones |> mutate(Valor_anual = Valor/12)
    
    suspensiones_total<-aggregate(Valor_anual ~ Causa.de.suspension + Descripcion,subset(suspensiones,Descripcion=="% de total Suspensiones totales junto con Causas De Suspensión Atribuibles A:"), sum)
    
    suspensiones_total<-suspensiones_total |>  arrange(desc(Valor_anual))
    
    suspensiones_total |>
      mutate(acumulado = cumsum(Valor_anual)) |>
      e_charts(Causa.de.suspension) |>
      e_bar(Valor_anual) |>
      e_line(acumulado, y_index = 1) |>
      e_tooltip(trigger = "axis")  |>
      e_axis_labels(y = "Valor", x = "Suspensiones") |>
      e_title("Grafico de Pareto del % de total Suspensiones totales") |>
      e_theme("walden")|>
      e_mark_line(data = list(yAxis = 0.80),
                  y_index = 1, 
                  symbol = "none", 
                  lineStyle = list(type = 'solid'), 
                  title = "Umbral al 80% ") 
    
    
  })
  
  # Grafico de pareto causas de suspension
  
  output$grafico_pareto_causas<- renderEcharts4r({ 
    
    causas_suspensiones<-openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_suspensiones_sankey_bd.xlsx" ,sheet ="Sheet1" ,rows = 1:36,cols = 1:3 )
    causas_suspensiones<-causas_suspensiones[6:35,] |>  arrange(desc(value))
    
    
    causas_suspensiones |>
      mutate(acumulado = cumsum(value)) |>
      e_charts(target) |>
      e_bar(value) |>
      e_line(acumulado, y_index = 1) |>
      e_tooltip(trigger = "axis")  |>
      e_axis_labels(y = "Valor", x = "Causas") |>
      e_title("Grafico de Pareto de las causas de suspensión") |>
      e_theme("walden") |>
      e_mark_line(data = list(yAxis = 0.80),
                  y_index = 1, 
                  symbol = "none", 
                  lineStyle = list(type = 'solid'), 
                  title = "80% threshold")
    
    
    
  })
  
  #### Hospitalización domiciliaria ####
  
  # Grafico hospitalizacion domiciliaria
  
  output$grafico_hospitalizacion<- renderEcharts4r({ 
    
    data_hospitalizacion<-openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_hospitalizacion_domiciliaria.xlsx" ,sheet ="Sheet1" ,rows = 1:13,cols = 1:3 )
    
    data_hospitalizacion |>
      #echarts4r::group_by(Causa.de.suspension) |>
      echarts4r::e_chart(Componentes) |>
      echarts4r::e_theme("walden")|> 
      echarts4r::e_bar(Número.cupos.programados) |>
      echarts4r::e_bar(Número.cupos.utilizados) |>
      e_axis_labels(y = "Cupos", x = "Meses") |>
      e_title("Hospitalización domiciliaria") |>
      echarts4r::e_tooltip(trigger = "item",axisPointer = list(type = "shadow"))
  })
    
  
  
    
  shinyWidgets::show_toast(
    title = "Sistema de gestion HBV",
    text = "Este dashboard es solo una version de prueba",
    type = "info",
    position = "top",
    timer=2000,
    width = "800"
  )


  #### Análisis de suspensiones por especialidad ####
  
output$grafico_susp_esp<- renderEcharts4r({ 
susp_esp<-data.frame(openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_supensiones_por_especialidad.xlsx" ,sheet ="Hoja1" ,rows = 1:73,cols = 13:15 ))
    data.frame(susp_esp) |>
      echarts4r::group_by(Tipo) |>
      echarts4r::e_chart(Especialidad) |>
      echarts4r::e_theme("walden")|> 
      echarts4r::e_bar(cantidad,stack="Tipo") |>
      echarts4r::e_flip_coords() |>
      echarts4r::e_tooltip(trigger = "item",axisPointer = list(type = "shadow"))
})

<<<<<<< HEAD
#  total<-sum(susp_esp$cantidad)
  

  # output$grafico_circular1<- renderEcharts4r({ 
  #   susp_esp<-data.frame(openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_supensiones_por_especialidad.xlsx" ,sheet ="Hoja1" ,rows = 1:73,cols = 13:15 ))
  #   aggregate(cantidad ~ Tipo, data=susp_esp,FUN = sum) |> 
  #     echarts4r::e_chart(Tipo) |>
  #     echarts4r::e_pie(cantidad, radius = c("40%", "70%")) |>
  #     echarts4r::e_theme("walden")|>
  #     echarts4r::e_labels(show = TRUE,
  #                         formatter = "{d}%",
  #                         position = "inside")|>
  #     echarts4r::e_tooltip(trigger = "item",axisPointer = list(type = "shadow"))
  # })
  # 
  # output$grafico_circular2<- renderEcharts4r({ 
  #   aggregate(cantidad ~ Especialidad, data=susp_esp,FUN = sum) |> 
  #     echarts4r::e_chart(Especialidad) |>
  #     echarts4r::e_pie(cantidad, radius = c("40%", "70%"),legend = TRUE) |>
  #     echarts4r::e_theme("walden")|>
  #     echarts4r::e_labels(show = TRUE,
  #                         formatter = "{d}%",
  #                         position = "inside")|>
  #     echarts4r::e_legend(type="scroll") |>
  #     echarts4r::e_tooltip(trigger = "item",axisPointer = list(type = "shadow"))
  # })
=======
#total<-sum(susp_esp$cantidad)

susp_esp<-data.frame(openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_supensiones_por_especialidad.xlsx" ,sheet ="Hoja1" ,rows = 1:73,cols = 13:15 ))
output$grafico_circular1<- renderEcharts4r({ 
  aggregate(cantidad ~ Tipo, data=susp_esp,FUN = sum) |> 
    echarts4r::e_chart(Tipo) |>
    echarts4r::e_pie(cantidad, radius = c("40%", "70%")) |>
    echarts4r::e_theme("walden")|>
    echarts4r::e_labels(show = TRUE,
                        formatter = "{d}%",
                        position = "inside")|>
    echarts4r::e_tooltip(trigger = "item",axisPointer = list(type = "shadow"))
})

output$grafico_circular2<- renderEcharts4r({ 
  aggregate(cantidad ~ Especialidad, data=susp_esp,FUN = sum) |> 
    dplyr::arrange(Especialidad)|>
    echarts4r::e_chart(Especialidad) |>
    echarts4r::e_pie(cantidad, radius = c("40%", "70%"),legend = TRUE) |>
    echarts4r::e_theme("walden")|>
    echarts4r::e_labels(show = TRUE,
                        formatter = "{d}%",
                        position = "inside")|>
    echarts4r::e_legend(type="scroll") |>
    echarts4r::e_tooltip(trigger = "item",axisPointer = list(type = "shadow"))
})
>>>>>>> main


#### días de estada ####

# en el ui incluir: selectInput("selector_1","Seleccion de especialidad",
# choices = c("Cirugía general"="CIRUGÍA GENERAL","Cirugía cardiovascular"="CIRUGÍA CARDIOVASCULAR",
#"Cirugía máxilofacial"="CIRUGÍA MÁXILOFACIAL", "Cirugía tórax"="CIRUGÍA TÓRAX", "Traumatología"="TRAUMATOLOGÍA"
#, "Neurocirugía"="NEUROCIRUGÍA", "Otorrinolaringología"="OTORRINOLARINGOLOGÍA", "Oftalmología"="OFTALMOLOGÍA"
#, "Obstetricia y ginecología"="OBSTETRICIA Y GINECOLOGÍA", "Ginecología"="GINECOLOGÍA", "Urología"="UROLOGÍA"
# , "Resto especialdiades"="RESTO ESPECIALIDADES")),


output$dias_estada_mensual<- renderEcharts4r({ 
  dias_estada<-data.frame(openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_dias_estada.xlsx" ,sheet ="Hoja1" ,rows = 1:145,cols = c(1,2,3,4,9) ))
      #subset(dias_estada,Especialidad=="CIRUGÍA GENERAL") |> 
      subset(dias_estada,Especialidad==input$selector_1) |>
      echarts4r::e_chart(Mes) |>
      echarts4r::e_bar(Dias.de.estada.prequirurgicos.totales,name = "Días de estada prequirurgicos totales") |>
      echarts4r::e_bar(Pacientes.intervenidos.totales.,name = "Pacientes intervenidos totales") |>
      echarts4r::e_line(Dias.de.estada.promedio, y_index =1,name = "Días de estada promedio por paciente") |> 
      echarts4r::e_theme("walden")|> 
      echarts4r::e_tooltip(trigger = "axis",axisPointer = list(type = "shadow"))
})

# en el ui incluir: selectInput("selector_2","Seleccion de especialidad", choices = c("Enero"="enero","Febrero"="febrero",
#"Marzo"="marzo", "Abril"="abril", "Mayo"="mayo", "Junio"="junio", "Julio"="julio", "Agosto"="agosto"
#, "Septiembre"="septiembre", "Octubre"="obtubre", "Noviembre"="noviembre" , "Diciembre"="diciembre")),

output$dias_estada_especialidad<- renderEcharts4r({ 
    dias_estada<-data.frame(openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_dias_estada.xlsx" ,sheet ="Hoja1" ,rows = 1:145,cols = c(1,2,3,4,9)))
      #subset(dias_estada,Mes=="enero") |> 
      subset(dias_estada,Mes==input$selector_2) |>
      dplyr::arrange(Dias.de.estada.promedio)|>
      echarts4r::e_chart(Especialidad) |>
      echarts4r::e_bar(Dias.de.estada.prequirurgicos.totales,name = "Días de estada prequirurgicos totales") |>
      echarts4r::e_bar(Pacientes.intervenidos.totales., name = "Pacientes intervenidos totales") |>
      echarts4r::e_line(Dias.de.estada.promedio, y_index =1,name = "Días de estada promedio por paciente") |> 
      echarts4r::e_theme("walden")|> 
      echarts4r::e_x_axis(axisLabel = list(interval = 0, rotate = 30)) |> 
      echarts4r::e_tooltip(trigger = "axis",axisPointer = list(type = "shadow"))
})

}