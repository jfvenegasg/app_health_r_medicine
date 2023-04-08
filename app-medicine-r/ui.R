#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(htmlwidgets)
library(dplyr)
library(openxlsx)
library(echarts4r)
library(utils)
library(bs4Dash)
library(reactable)
library(MASS)
library(config)
library(htmltools)
library(lubridate)
library(shinyWidgets)
library(shinycssloaders)
library(reticulate)


ui <-  dashboardPage(

  dashboardHeader(title = "Sistema de gestion HCM",rightUi = dropdownMenu(
    badgeStatus = "danger",
    type = "messages",
    messageItem(
      inputId = "triggerAction1",
      message = "Mensaje 1",
      from = "Juan Venegas",
      image = "https://adminlte.io/themes/v3/dist/img/user3-128x128.jpg",
      time = "Hoy",
      color = "lime"
    )
  ),leftUi = tagList(
    dropdownMenu(
      badgeStatus = "info",
      type = "notifications",
      notificationItem(
        inputId = "triggerAction2",
        text = "Error!",
        status = "danger"
      )
    ),
    dropdownMenu(
      badgeStatus = "info",
      type = "tasks",
      taskItem(
        inputId = "triggerAction3",
        text = "My progreso",
        color = "orange",
        value = 10
      )
    ))),
  dashboardSidebar(side = "top", visible = FALSE, status = "teal",
                   sidebarMenu(
                     id = "sidebar",
                     menuItem("Inicio",tabName = "menu1",
                              icon=icon("laptop-medical"),
                              selected = TRUE),
                     
                     bs4Dash::menuItem("Reporte quirófanos",tabName="menu2",
                                       icon=icon("check-square")),
                     bs4Dash::menuItem("Análisis suspenciones",tabName="menu3",
                                       icon=icon("user-doctor"),
                                       bs4Dash::menuSubItem(text = "Suspenciones por causa",tabName ="menu3_1" ,icon =icon("user-doctor") ),
                                       bs4Dash::menuSubItem(text = "Suspenciones por especialidad",tabName = "menu3_2",icon =icon("user-doctor") )),
                     bs4Dash::menuItem("Hospitalización domiciliaria",tabName="menu4",
                                       icon=icon("house")),
                     bs4Dash::menuItem("Dias de estadia",tabName="menu5",
                                       icon=icon("bed-pulse"))
                   ),
                   actionButton(
                     "sign_out",
                     "Sign Out",
                     icon = icon("sign-out-alt"),
                     class = "pull-right",selected = FALSE)
                   
                   
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "menu1",
              fluidRow(width=12, imageOutput("myImage")),
              # Boxes need to be put in a row (or column)
              fluidRow(width=12,
                       bs4Dash::infoBox(bs4Dash::bs4Ribbon(text = "Nuevo",color = "lightblue"),width = 6,title = shiny::h3("Reporte quirófanos", style = 'font-size:30px'),subtitle="Este menú contiene estadísticas de ocupación de quirófanos", 
                                        icon=shiny::icon("arrow-pointer"), tabName = "menu5_1",color = "lightblue",fill=FALSE, iconElevation = 2,elevation = 2),
                       bs4Dash::infoBox(bs4Dash::bs4Ribbon(text = "Nuevo",color = "lightblue"),width = 6,title = shiny::h3("Análisis tiempo real vs programado", style = 'font-size:30px'),subtitle="Datos acerca de las cirugías que exceden el tiempo programdo", 
                                        icon=shiny::icon("arrow-pointer"), tabName = "menu5_2",color = "lightblue",fill=FALSE, iconElevation = 2,elevation = 2)),
              fluidRow(width=12,
                       bs4Dash::infoBox(width = 6,title = shiny::h3("Duración cirugías", style = 'font-size:30px'),subtitle="Datos históricos de la duración de distintos tipos de cirugías", 
                                        icon=shiny::icon("arrow-pointer"), tabName = "menu5_3",color = "lightblue",fill=FALSE, iconElevation = 2,elevation = 2),
                       bs4Dash::infoBox(width = 6,title = shiny::h3("Análisis suspenciones", style = 'font-size:30px'),subtitle="Se presentan datos acerca de las causas de suspención de cirugías", 
                                        icon=shiny::icon("arrow-pointer"), tabName = "menu5_4",color = "lightblue",fill=FALSE, iconElevation = 2,elevation = 2))
      ), 
      
      
      
      
      tabItem(tabName = "menu2",
              
              fluidRow(width=12,
                       box(width = 9,title = "Utilización de quirófanos",closable = FALSE,elevation = 2, echarts4rOutput("grafico"),
                           status = "lightblue",headerBorder = FALSE,collapsible = FALSE),
                       
                       bs4Dash:: column(width = 3,
                                        valueBox(width = 12,subtitle = "Promedio porcentaje de ocupación quirófanos",value = shiny::h3(textOutput("utilización_quirófanos"), style = 'font-size:27px'),color = "teal",icon = icon("check")),
                                        valueBox(width = 12,subtitle = "Horas programadas respecto a las habilitadas",value = shiny::h3(textOutput("programadas_habilitadas"), style = 'font-size:27px'),color = "teal",icon = icon("check")),
                                        valueBox(width = 12,subtitle = "Horas ocupadas respecto a las programadas",value = shiny::h3(textOutput("ocupadas_programadas"), style = 'font-size:27px'),color = "teal",icon = icon("check"))),
                      
              )),
      
      tabItem(tabName = "menu3_1",
              fluidRow(width=12,
                       box(echarts4rOutput("grafico_barra"),title= "Motivos de suspención por mes",width=9,headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2,status = "lightblue"),
                       bs4Dash::column(width=3,
                                       valueBox(width = 12,value = shiny::h3("42%", style = 'font-size:27px'),color = "teal",subtitle="Suspenciones debido a la causal paciente",
                                                icon = icon("check")),valueBox(width = 12,value=shiny::h3("23%", style = 'font-size:27px'),color = "teal",subtitle="Suspenciones debido a la causal equipo quirúrgico",icon = icon("check")))),
              fluidRow(width=12,
                       box(echarts4rOutput("grafico_sankey"),title= "Desgloce motivos de suspención cirugías",width=12,height="620px",headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2, status = "lightblue")),
              fluidRow(width=12,
                       box(width=6,echarts4rOutput("grafico_pareto_1"),title= "Grafico de Pareto del % de total 15 Años Y Más",headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2),
                       box(width=6,echarts4rOutput("grafico_pareto_2"),title= "Grafico de Pareto del % de total Suspensiones totales",headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2),
                       box(width=12,echarts4rOutput("grafico_pareto_causas"),height = "650px",title= "Gráfico pareto de las causas de suspención",headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2))
              
      ),
      tabItem(tabName = "menu3_2",
              fluidRow(width=12,
                       box(echarts4rOutput("grafico_circular1"),title= "Distribución suspenciones por tipo de cirugía",width=6,height="400px",reorder= TRUE,headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2, status = "lightblue"),
                       box(echarts4rOutput("grafico_circular2"),title= "Distribución suspenciones por especialidad",width=6,height="400px",reorder= TRUE,headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2, status = "lightblue")),
              fluidRow(width=12,
                       box(echarts4rOutput("grafico_susp_esp"),title= "Cantidad de suspenciones por especialidad y tipo de cirugía",width=12,height="400px",headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2, status = "lightblue"))
              
              
      ),
      tabItem(tabName = "menu4",
              fluidRow(width=12,
                       box(width=9,echarts4rOutput("grafico_hospitalizacion"),headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2,title = "Hospitalización domiciliaria",status = "lightblue"),
                       bs4Dash:: column(width = 3,
                                        valueBox(width = 12,subtitle = "Promedio porcentaje de ocupación quirófanos",value = shiny::h3("60%", style = 'font-size:27px'),color = "teal",icon = icon("check")),
                                        valueBox(width = 12,subtitle = "Horas programadas respecto a las habilitadas",value = shiny::h3("79%", style = 'font-size:27px'),color = "teal",icon = icon("check")),
                                        valueBox(width = 12,subtitle = "Horas ocupadas respecto a las programadas",value = shiny::h3("80%", style = 'font-size:27px'),color = "teal",icon = icon("check"))))
              
      ),
      tabItem(tabName = "menu5",
              fluidRow(width=12,
                       box(width=9,echarts4rOutput("dias_estada_mensual"),headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2, height = "560px",title = "Días de estadia y pacientes intervenidos por mes",status = "lightblue"),
                       column(width = 3,
                              box(width = 12,headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2, status = "lightblue",selectInput("selector_1","Seleccion de especialidad",
                                                                                                                         choices = c("Cirugía general"="CIRUGÍA GENERAL","Cirugía cardiovascular"="CIRUGÍA CARDIOVASCULAR",
                                                                                                                                     "Cirugía máxilofacial"="CIRUGÍA MÁXILOFACIAL", "Cirugía tórax"="CIRUGÍA TÓRAX", "Traumatología"="TRAUMATOLOGÍA"
                                                                                                                                     , "Neurocirugía"="NEUROCIRUGÍA", "Otorrinolaringología"="OTORRINOLARINGOLOGÍA", "Oftalmología"="OFTALMOLOGÍA"
                                                                                                                                     , "Obstetricia y ginecología"="OBSTETRICIA Y GINECOLOGÍA", "Ginecología"="GINECOLOGÍA", "Urología"="UROLOGÍA"
                                                                                                                                     , "Resto especialdiades"="RESTO ESPECIALIDADES", "Todas"="TODAS"))),
                              valueBox(width = 12,subtitle = "Días totales de estadía",value = shiny::h3(textOutput("dias_totales_especialidad"), style = 'font-size:27px'),color = "teal",icon = icon("check")),
                              valueBox(width = 12,subtitle = "Pacientes intervenidos totales",value = shiny::h3(textOutput("pacientes_totales_especialidad"), style = 'font-size:27px'),color = "teal",icon = icon("check")),
                              valueBox(width = 12,subtitle = "Días de estadía promedio por paciente",value = shiny::h3(textOutput("días_de_estada_especialidad"), style = 'font-size:27px'),color = "teal",icon = icon("check")))),
                       
                       
              fluidRow(width=12,                
                       box(width=9,echarts4rOutput("dias_estada_especialidad"),headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2, height = "560px", title = "Días de estadía y pacientes intervenidos por especialidad",status = "lightblue"),
                       column(width = 3,
                              box(width = 12,headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2,status = "lightblue",selectInput("selector_2","Seleccion de mes", choices = c("Enero"="enero","Febrero"="febrero",
                                                                                                                                                                      "Marzo"="marzo", "Abril"="abril", "Mayo"="mayo", "Junio"="junio", "Julio"="julio", "Agosto"="agosto"
                                                                                                                                                                      , "Septiembre"="septiembre", "Octubre"="obtubre", "Noviembre"="noviembre" , "Diciembre"="diciembre", "Año 2022"="año 2022"))),
                              valueBox(width = 12,subtitle = "Días totales de estadía",value = shiny::h3(textOutput("dias_totales_mes"), style = 'font-size:27px'),color = "teal",icon = icon("check")),
                              valueBox(width = 12,subtitle = "Pacientes intervenidos totales",value = shiny::h3(textOutput("pacientes_totales_mes"), style = 'font-size:27px'),color = "teal",icon = icon("check")),
                              valueBox(width = 12,subtitle = "Días de estadía promedio por paciente",value = shiny::h3(textOutput("días_de_estada_mes"), style = 'font-size:27px'),color = "teal",icon = icon("check")))),
              
      )
      
      
      
    )
    
  ))

   