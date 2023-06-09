#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
#source("traductor.R")

# Define server logic required to draw a histogram
function(input, output, session) {
  
  #### Carga de imagen ####
  output$myImage <- renderImage({
    
    list(src = "modulos/data/imagen_de_inicio.png")
    
  }, deleteFile = F)
  
  #### Mensaje emergente ####
  shinyWidgets::show_toast(
    title = i18n$t("Sistema de gestion HCM"),
    text = i18n$t("Este dashboard es solo una version de prueba"),
    type = "info",
    position = "top",
    timer=2000,
    width = "800"
  )
  
  #### Reporte quirofanos ####
  
data<-openxlsx::read.xlsx(xlsxFile ="modulos/data/set_de_datos_1.xlsx" ,sheet ="Horas" ,rows = 15:37,cols = 5:7)
data$Mes<-i18n$t(data$Mes)
data$Tipo.de.hora<-i18n$t(data$Tipo.de.hora)
  #grafico utilización de quirofanos
  output$grafico<- renderEcharts4r({ 
    data |>
      echarts4r::group_by(Tipo.de.hora) |>
      echarts4r::e_chart(Mes) |>
      echarts4r::e_bar(Valor) |>
      echarts4r::e_mark_p(type = "line",
                          serie_index = 1,
                          data = list(yAxis = aggregate(Valor ~ Tipo.de.hora, data, mean)[1,2]), 
                          title = "Line at 50") |>
      echarts4r::e_mark_p(type = "line",
                          serie_index = 2,
                          data = list(yAxis = aggregate(Valor ~ Tipo.de.hora, data, mean)[2,2]), 
                          title = "Line at 50") |>
      echarts4r::e_theme("walden")|> 
      echarts4r::e_tooltip(trigger = "axis",axisPointer = list(type = "shadow"), formatter = "{d}%")
  })
  
  quirofanos<-openxlsx::read.xlsx(xlsxFile ="modulos/data/set_de_datos_1.xlsx" ,sheet ="Horas" ,rows = 15:37,cols = 5:7 ) 
  
  x<-mean(quirofanos$Valor[quirofanos$Tipo.de.hora=="% trabajo respecto a habilitado"])
  x<-sprintf("%0.2f%%", x*100)
  output$utilización_quirófanos<-renderText({x})
  
  y<-mean(quirofanos$Valor[quirofanos$Tipo.de.hora=="% programado respecto a habilitado"])
  y<-sprintf("%0.2f%%", y*100)
  output$programadas_habilitadas<-renderText({y})
  
  z<-mean(quirofanos$Valor[quirofanos$Tipo.de.hora=="% trabajo respecto a habilitado"])/mean(quirofanos$Valor[quirofanos$Tipo.de.hora=="% programado respecto a habilitado"])
  z<-sprintf("%0.2f%%", z*100)
  output$ocupadas_programadas<-renderText({z})
  

  
  #### Analisis de suspensiones por causa####
  suspensiones<-openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_suspensiones_bd.xlsx" ,sheet ="Sheet1" ,rows = 1:145,cols = 1:4 )
  suspensiones$Mes<-i18n$t(suspensiones$Mes)
  suspensiones$Causa.de.suspension<-i18n$t(suspensiones$Causa.de.suspension)
  suspensiones<-subset(suspensiones, Descripcion=="% de total Suspensiones totales junto con Causas De Suspensión Atribuibles A:") 
  
output$grafico_barra<- renderEcharts4r({ 
     suspensiones<-openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_suspensiones_bd.xlsx" ,sheet ="Sheet1" ,rows = 1:145,cols = 1:4 )
     suspensiones$Mes<-i18n$t(suspensiones$Mes)
     suspensiones$Causa.de.suspension<-i18n$t(suspensiones$Causa.de.suspension)
     suspensiones<-subset(suspensiones, Descripcion=="% de total Suspensiones totales junto con Causas De Suspensión Atribuibles A:")
  
      suspensiones |>
      echarts4r::group_by(Causa.de.suspension) |>
      echarts4r::e_chart(Mes) |>
      echarts4r::e_theme("walden")|> 
      echarts4r::e_bar(Valor,stack="Causa.de.suspension") |>
      echarts4r::e_tooltip(trigger = "item",axisPointer = list(type = "shadow"),formatter = echarts4r::e_tooltip_item_formatter("percent"))
  })
  
  a<-mean(suspensiones$Valor[suspensiones$Causa.de.suspension==i18n$t("PACIENTE")])
  a<-sprintf("%0.2f%%", a*100)
  output$porcentaje_paciente<-renderText({a})
  
  b<-mean(suspensiones$Valor[suspensiones$Causa.de.suspension==i18n$t("EQUIPO QUIRÚRGICO")])
  b<-sprintf("%0.2f%%", b*100)
  output$porcentaje_equipo<-renderText({b})

  
datos_suspensiones_sankey<-openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_suspensiones_sankey_bd.xlsx" ,sheet ="Sheet1" ,rows = 1:35,cols = 1:3 )
datos_suspensiones_sankey$source<-i18n$t(datos_suspensiones_sankey$source)
datos_suspensiones_sankey$target<-i18n$t(datos_suspensiones_sankey$target)
  
  output$grafico_sankey<- renderEcharts4r({ 
    data.frame(datos_suspensiones_sankey) |> 
      echarts4r::e_charts() |> 
      echarts4r::e_sankey(source, target, value,layoutIterations = 6) |> 
      echarts4r::e_dims(height = "600px", width = "auto") |>
      echarts4r::e_theme("walden")|> 
      echarts4r::e_tooltip() 
  })
  
  output$susp_totales<-renderText({sum(datos_suspensiones_sankey[6:34,]$value)})
  
  # Grafico de pareto % de total 15 Años Y Más junto con Causas De Suspensión
  
suspensiones<-openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_suspensiones_bd.xlsx" ,sheet ="Sheet1" ,rows = 1:145,cols = 1:4 )
suspensiones<-suspensiones |> mutate(Valor_anual = Valor/12)
suspensiones$Causa.de.suspension<-i18n$t(suspensiones$Causa.de.suspension)
  
  output$grafico_pareto_1<- renderEcharts4r({ 
    
    suspensiones_15<-aggregate(Valor_anual ~ Causa.de.suspension + Descripcion,subset(suspensiones,Descripcion=="% de total 15 Años Y Más junto con Causas De Suspensión Atribuibles A:"), sum)
    
    suspensiones_15<-suspensiones_15 |>  arrange(desc(Valor_anual)) 
    
    suspensiones_15 |>
      mutate(acumulado = cumsum(Valor_anual)) |>
      e_charts(Causa.de.suspension) |>
      e_bar(Valor_anual, name = i18n$t("Porcentaje anual")) |>
      e_line(acumulado, y_index = 1, name = i18n$t("Acumulado")) |>
      e_tooltip(trigger = "axis")  |>
      e_theme("walden")|>
      e_x_axis(axisLabel = list(interval = 0, rotate = 45, fontSize=9)) |> 
      e_grid(bottom="120")|>
      e_mark_line(data = list(yAxis = 0.80),
                  y_index = 1, 
                  symbol = "none", 
                  lineStyle = list(type = 'solid'), 
                  title = "")
    
    
  })
  
  # Grafico de pareto % de total Suspensiones totales junto con Causas De Suspensión
  
  output$grafico_pareto_2<- renderEcharts4r({ 
    
    suspensiones_total<-aggregate(Valor_anual ~ Causa.de.suspension + Descripcion,subset(suspensiones,Descripcion=="% de total Suspensiones totales junto con Causas De Suspensión Atribuibles A:"), sum)
    
    suspensiones_total<-suspensiones_total |>  arrange(desc(Valor_anual))
    
    suspensiones_total |>
      mutate(acumulado = cumsum(Valor_anual)) |>
      e_charts(Causa.de.suspension) |>
      e_bar(Valor_anual, name = i18n$t("Porcentaje anual")) |>
      e_line(acumulado, y_index = 1, name = i18n$t("Acumulado")) |>
      e_tooltip(trigger = "axis")  |>
      e_theme("walden")|>
      e_x_axis(axisLabel = list(interval = 0, rotate = 45, fontSize=9)) |> 
      e_grid(bottom="120")|>
      e_mark_line(data = list(yAxis = 0.80),
                  y_index = 1, 
                  symbol = "none", 
                  lineStyle = list(type = 'solid'), 
                  title = "") 
    
    
  })
  
  # Grafico de pareto causas de suspension
  
  causas_suspensiones<-openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_suspensiones_sankey_bd.xlsx" ,sheet ="Sheet1" ,rows = 1:35,cols = 1:4 )
  causas_suspensiones$source<-i18n$t(causas_suspensiones$source)
  causas_suspensiones$target<-i18n$t(causas_suspensiones$target)
  
  output$grafico_pareto_causas<- renderEcharts4r({ 
    causas_suspensiones<-causas_suspensiones[6:35,] |>  arrange(desc(porcentaje))
    causas_suspensiones |>
      mutate(acumulado = cumsum(porcentaje)) |>
      e_charts(target) |>
      e_bar(porcentaje, name = i18n$t("Porcentaje anual")) |>
      e_line(acumulado, y_index = 1, name = i18n$t("Acumulado")) |>
      e_tooltip(trigger = "axis")  |>
      e_x_axis(axisLabel = list(interval = 0, rotate = 45, fontSize=9)) |> 
      e_grid(bottom="250")|>
      e_theme("walden") |>
      echarts4r::e_dims(height = "600px") |>
      e_mark_line(data = list(yAxis = 0.80),
                  y_index = 1, 
                  symbol = "none", 
                  lineStyle = list(type = 'solid'),
                  title="")
    
    
    
  })
  
  #### Hospitalización domiciliaria ####
  
  # Grafico hospitalizacion domiciliaria
  
  data_hospitalizacion<-openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_hospitalizacion_domiciliaria.xlsx" ,sheet ="Sheet1" ,rows = 1:13,cols = 1:3 )
  data_hospitalizacion$Componentes<-i18n$t(data_hospitalizacion$Componentes)
  
  output$grafico_hospitalizacion<- renderEcharts4r({ 
    data_hospitalizacion |>
      echarts4r::e_chart(Componentes) |>
      echarts4r::e_theme("walden")|> 
      echarts4r::e_bar(Número.cupos.programados, name = i18n$t("Número de cupos programados")) |>
      echarts4r::e_bar(Número.cupos.utilizados, name = i18n$t("Número de cupos utilizados")) |>
      echarts4r::e_mark_p(type = "line",
                          serie_index = 1,
                          data = list(yAxis = mean(data_hospitalizacion$Número.cupos.programados)), 
                          title = "Line at 50") |>
      echarts4r::e_mark_p(type = "line",
                          serie_index = 2,
                          data = list(yAxis = mean(data_hospitalizacion$Número.cupos.utilizados)), 
                          title = "Line at 50") |>
      echarts4r::e_tooltip(trigger = "item",axisPointer = list(type = "shadow"))
  })
  
  output$cupos_programados_totales<-renderText(sum(data_hospitalizacion$Número.cupos.programados))
  output$cupos_utilizados_totales<-renderText(sum(data_hospitalizacion$Número.cupos.utilizados))
  
  c<-sum(data_hospitalizacion$Número.cupos.utilizados)/sum(data_hospitalizacion$Número.cupos.programados)
  c<-sprintf("%0.2f%%", c*100)
  output$cupos_utilizados_vs_programados<-renderText(c)  
  


  #### Análisis de suspensiones por especialidad ####
  susp_esp<-data.frame(openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_supensiones_por_especialidad.xlsx" ,sheet ="Hoja1" ,rows = 1:73,cols = 13:15 )) 
  susp_esp$Tipo<-i18n$t(susp_esp$Tipo)
  susp_esp$Especialidad<-i18n$t(susp_esp$Especialidad)
  
  output$grafico_susp_esp<- renderEcharts4r({ 
    susp_esp |>
    data.frame(susp_esp) |>
      echarts4r::group_by(Tipo) |>
      echarts4r::e_chart(Especialidad) |>
      echarts4r::e_theme("walden")|> 
      echarts4r::e_bar(cantidad,stack="Tipo", name= i18n$t("Cantidad")) |>
      echarts4r::e_flip_coords() |>
      e_grid(left = "15%")|>
      echarts4r::e_tooltip(trigger = "item",axisPointer = list(type = "shadow"))
})



output$grafico_circular1<- renderEcharts4r({ 
  susp_esp<-data.frame(openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_supensiones_por_especialidad.xlsx" ,sheet ="Hoja1" ,rows = 1:73,cols = 13:15 )) 
  susp_esp$Tipo<-i18n$t(susp_esp$Tipo)
  susp_esp$Especialidad<-i18n$t(susp_esp$Especialidad)
  
  aggregate(cantidad ~ Tipo, data=susp_esp,FUN = sum) |> 
    echarts4r::e_chart(Tipo) |>
    echarts4r::e_pie(cantidad, radius = c("40%", "70%"), name= i18n$t("Cantidad")) |>
    echarts4r::e_theme("walden")|>
    echarts4r::e_labels(show = TRUE,
                        formatter = "{d}%",
                        position = "inside")|>
    echarts4r::e_tooltip(trigger = "item",axisPointer = list(type = "shadow"))
})

output$grafico_circular2<- renderEcharts4r({ 
  susp_esp<-data.frame(openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_supensiones_por_especialidad.xlsx" ,sheet ="Hoja1" ,rows = 1:73,cols = 13:15 )) 
  susp_esp$Tipo<-i18n$t(susp_esp$Tipo)
  susp_esp$Especialidad<-i18n$t(susp_esp$Especialidad)
  
  aggregate(cantidad ~ Especialidad, data=susp_esp,FUN = sum) |> 
    dplyr::arrange(Especialidad)|>
    echarts4r::e_chart(Especialidad) |>
    echarts4r::e_pie(cantidad, radius = c("40%", "70%"),legend = TRUE, name= i18n$t("Cantidad")) |>
    echarts4r::e_theme("walden")|>
    echarts4r::e_labels(show = TRUE,
                        formatter = "{d}%",
                        position = "inside")|>
    echarts4r::e_legend(type="scroll") |>
    echarts4r::e_tooltip(trigger = "item",axisPointer = list(type = "shadow"))
})



#### días de estada ####

# en el ui incluir: selectInput("selector_1","Seleccion de especialidad",
# choices = c("Cirugía general"="CIRUGÍA GENERAL","Cirugía cardiovascular"="CIRUGÍA CARDIOVASCULAR",
#"Cirugía máxilofacial"="CIRUGÍA MÁXILOFACIAL", "Cirugía tórax"="CIRUGÍA TÓRAX", "Traumatología"="TRAUMATOLOGÍA"
#, "Neurocirugía"="NEUROCIRUGÍA", "Otorrinolaringología"="OTORRINOLARINGOLOGÍA", "Oftalmología"="OFTALMOLOGÍA"
#, "Obstetricia y ginecología"="OBSTETRICIA Y GINECOLOGÍA", "Ginecología"="GINECOLOGÍA", "Urología"="UROLOGÍA"
# , "Resto especialdiades"="RESTO ESPECIALIDADES")),

dias_estada<-data.frame(openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_dias_estada.xlsx" ,sheet ="Hoja1" ,rows = 1:169,cols = c(1,2,3,4,9) ))
dias_estada$Especialidad<-i18n$t(dias_estada$Especialidad)
dias_estada$Mes<-i18n$t(dias_estada$Mes)
dias_estada1<-subset(dias_estada, !(Mes %in% c("Año 2022")))

output$dias_estada_mensual<- renderEcharts4r({ 
      #subset(dias_estada,Especialidad=="CIRUGÍA GENERAL") |> 
      subset(dias_estada1,Especialidad==input$selector_1) |>
      echarts4r::e_chart(Mes) |>
      echarts4r::e_bar(Dias.de.estada.prequirurgicos.totales,name = i18n$t("Días de estadía prequirurgicos totales")) |>
      echarts4r::e_bar(Pacientes.intervenidos.totales.,name = i18n$t("Pacientes intervenidos totales")) |>
      echarts4r::e_line(Dias.de.estada.promedio, y_index =1,name = i18n$t("Días de estadía promedio por paciente")) |> 
      echarts4r::e_theme("walden")|>
      echarts4r::e_x_axis(axisLabel = list(interval = 0, rotate = 45, fontSize=10)) |>
      echarts4r::e_dims(height = "500px") |>
      echarts4r::e_grid(bottom="100")|>
      echarts4r::e_tooltip(trigger = "axis",axisPointer = list(type = "shadow"))
})

output$dias_totales_especialidad<- renderText({ sum(dias_estada$Dias.de.estada.prequirurgicos.totales[dias_estada$Especialidad==input$selector_1])
  })
output$pacientes_totales_especialidad<- renderText({ sum(dias_estada$Pacientes.intervenidos.totales.[dias_estada$Especialidad==input$selector_1])
  })
output$días_de_estada_especialidad<- renderText({ mean(dias_estada$Dias.de.estada.promedio[dias_estada$Especialidad==input$selector_1]) 
  })

  

# en el ui incluir: selectInput("selector_2","Seleccion de especialidad", choices = c("Enero"="enero","Febrero"="febrero",
#"Marzo"="marzo", "Abril"="abril", "Mayo"="mayo", "Junio"="junio", "Julio"="julio", "Agosto"="agosto"
#, "Septiembre"="septiembre", "Octubre"="obtubre", "Noviembre"="noviembre" , "Diciembre"="diciembre")),

dias_estada2<-subset(dias_estada, !(Especialidad %in% c("TODAS")))

output$dias_estada_especialidad<- renderEcharts4r({ 
  dias_estada<-data.frame(openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_dias_estada.xlsx" ,sheet ="Hoja1" ,rows = 1:169,cols = c(1,2,3,4,9) ))
  dias_estada$Especialidad<-i18n$t(dias_estada$Especialidad)
  dias_estada$Mes<-i18n$t(dias_estada$Mes)
  dias_estada1<-subset(dias_estada, !(Mes %in% c("Año 2022")))
  
      dias_estada2<-subset(dias_estada, !(Especialidad %in% c("TODAS")))
  
        #subset(dias_estada,Mes=="enero") |> 
      subset(dias_estada2,Mes==input$selector_2) |>
      dplyr::arrange(Dias.de.estada.promedio)|>
      echarts4r::e_chart(Especialidad) |>
      echarts4r::e_bar(Dias.de.estada.prequirurgicos.totales,name = i18n$t("Días de estadía prequirurgicos totales")) |>
      echarts4r::e_bar(Pacientes.intervenidos.totales., name = i18n$t("Pacientes intervenidos totales")) |>
      echarts4r::e_line(Dias.de.estada.promedio, y_index =1,name = i18n$t("Días de estadía promedio por paciente")) |> 
      echarts4r::e_theme("walden")|> 
      echarts4r::e_x_axis(axisLabel = list(interval = 0, rotate = 45, fontSize=9)) |>
      echarts4r::e_dims(height = "500px") |>
      echarts4r::e_grid(bottom="100")|>
      echarts4r::e_tooltip(trigger = "axis",axisPointer = list(type = "shadow"))
})

output$dias_totales_mes<- renderText({ sum(dias_estada$Dias.de.estada.prequirurgicos.totales[dias_estada$Mes==input$selector_2])
})
output$pacientes_totales_mes<- renderText({ sum(dias_estada$Pacientes.intervenidos.totales.[dias_estada$Mes==input$selector_2])
})
output$días_de_estada_mes<- renderText({ mean(dias_estada$Dias.de.estada.promedio[dias_estada$Mes==input$selector_2]) 
})


}