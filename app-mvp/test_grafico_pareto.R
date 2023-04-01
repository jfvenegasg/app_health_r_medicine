suspensiones<-openxlsx::read.xlsx(xlsxFile ="modulos/data/datos_suspensiones_bd.xlsx" ,sheet ="Sheet1" ,rows = 1:146,cols = 1:4 )

suspensiones<-suspensiones |> mutate(Valor_anual = Valor/12)

suspensiones_15<-aggregate(Valor_anual ~ Causa.de.suspension + Descripcion,subset(suspensiones,Descripcion=="% de total 15 Años Y Más junto con Causas De Suspensión Atribuibles A:"), sum)

suspensiones_total<-aggregate(Valor_anual ~ Causa.de.suspension + Descripcion,subset(suspensiones,Descripcion=="% de total Suspensiones totales junto con Causas De Suspensión Atribuibles A:"), sum)

suspensiones_15<-suspensiones_15 |>  arrange(desc(Valor_anual))

suspensiones_total<-suspensiones_total |>  arrange(desc(Valor_anual))


suspensiones_15 |>
mutate(acumulado = cumsum(Valor_anual)) |>
e_charts(Causa.de.suspension) |>
e_bar(Valor_anual) |>
e_line(acumulado, y_index = 1) |>
e_tooltip(trigger = "axis")  |>
  e_axis_labels(y = "Valor", x = "Suspensiones") |>
  e_title("Grafico de Pareto del % de total 15 Años Y Más") |>
  e_mark_line(data = list(yAxis = 0.80),
              y_index = 1, 
              symbol = "none", 
              lineStyle = list(type = 'solid'), 
              title = "80% threshold")

suspensiones_total |>
  mutate(acumulado = cumsum(Valor_anual)) |>
  e_charts(Causa.de.suspension) |>
  e_bar(Valor_anual) |>
  e_line(acumulado, y_index = 1) |>
  e_tooltip(trigger = "axis")  |>
  e_axis_labels(y = "Valor", x = "Suspensiones") |>
  e_title("Grafico de Pareto del % de total Suspensiones totales") |>
  e_mark_line(data = list(yAxis = 0.80),
              y_index = 1, 
              symbol = "none", 
              lineStyle = list(type = 'solid'), 
              title = "80% threshold")

#### Carga causas de suspensiones ####
library(echarts4r)
library(dplyr)

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
  e_mark_line(data = list(yAxis = 0.80),
              y_index = 1, 
              symbol = "none", 
              lineStyle = list(type = 'solid'), 
              title = "80% threshold")




# Data4Pareto <- data.frame(
#   KPI = c("Price", "Delivery","Quality","Packaging", "Support"),
#   Complaints= c(15,100,15,120,20)) 
# 
# Data4Pareto |>
#   arrange(desc(Complaints)) |>
#   mutate(cumm.perc. = (cumsum(Complaints)/sum(Complaints) * 100)) |>
#   e_charts(KPI) |>
#   e_bar(Complaints) |>
#   e_line(cumm.perc., y_index = 1) |>
#   e_axis_labels(y = "Complaints", x = "KPI") |>
#   e_mark_line(data = list(yAxis = 80),
#               y_index = 1, 
#               symbol = "none", 
#               lineStyle = list(type = 'solid'), 
#               title = "80% threshold") |>
#   e_tooltip(trigger = "axis")|>
#   e_title("Pareto Chart") |>
#   e_legend(FALSE) |>
#   e_theme("chalk")
