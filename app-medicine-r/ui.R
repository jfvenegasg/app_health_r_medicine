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
library(shiny.i18n)
source("traductor.R")

ui <-  dashboardPage(

  dashboardHeader(title = i18n$t("Sistema de gestion HCM")),
  dashboardSidebar(side = "top", visible = FALSE, status = "teal",
                   sidebarMenu(
                     id = "sidebar",
                     menuItem(i18n$t("Inicio"),tabName = "menu1",
                              icon=icon("laptop-medical"),
                              selected = TRUE),
                     
                     bs4Dash::menuItem(i18n$t("Reporte quirófanos"),tabName="menu2",
                                       icon=icon("check-square")),
                     bs4Dash::menuItem(i18n$t("Análisis suspensiones"),tabName="menu3",
                                       icon=icon("user-doctor"),
                                       bs4Dash::menuSubItem(text = i18n$t("Suspensiones por causa"),tabName ="menu3_1" ,icon =icon("user-doctor") ),
                                       bs4Dash::menuSubItem(text = i18n$t("Susp. por especialidad"),tabName = "menu3_2",icon =icon("user-doctor") )),
                     bs4Dash::menuItem(i18n$t("Hospitalización domiciliaria"),tabName="menu4",
                                       icon=icon("house")),
                     bs4Dash::menuItem(i18n$t("Dias de estadía"),tabName="menu5",
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
      tabItem(tabName = "menu1",imageOutput("myImage"),
         # Boxes need to be put in a row (or column)
              fluidRow(width=12,
                       bs4Dash::infoBox(width = 12,title = shiny::h3(i18n$t("Reporte quirófanos"), style = 'font-size:30px'),subtitle=i18n$t("Datos y estadísticas acerca de la programación y ocupación de quirófanos"), 
                                        icon=shiny::icon("arrow-pointer"), tabName = "menu2",color = "lightblue",fill=FALSE, iconElevation = 2,elevation = 2)),
              fluidRow(width=12,
                       bs4Dash::infoBox(width = 6,title = shiny::h3(i18n$t("Suspensiones por causa"), style = 'font-size:30px'),subtitle=i18n$t("Datos y estadísticas sobre las causas que generan suspensiones de cirugías"), 
                                        icon=shiny::icon("arrow-pointer"), tabName = "menu3_1",color = "lightblue",fill=FALSE, iconElevation = 2,elevation = 2),
                       bs4Dash::infoBox(width = 6,title = shiny::h3(i18n$t("Suspensiones por especialidad"), style = 'font-size:30px'),subtitle=i18n$t("Datos y estadísticas sobre la cantidad de suspensiones por especialidad"), 
                                        icon=shiny::icon("arrow-pointer"), tabName = "menu3_2",color = "lightblue",fill=FALSE, iconElevation = 2,elevation = 2)),
              fluidRow(width=12,
                       bs4Dash::infoBox(width = 6,title = shiny::h3(i18n$t("Hospitalización domiciliaria"), style = 'font-size:30px'),subtitle=i18n$t("Datos y estadísticas acerca de la programación y utilización de cupos de hospitalización domiciliaria"), 
                                        icon=shiny::icon("arrow-pointer"), tabName = "menu4",color = "lightblue",fill=FALSE, iconElevation = 2,elevation = 2),
                       bs4Dash::infoBox(width = 6,title = shiny::h3(i18n$t("Días de estadía"), style = 'font-size:30px'),subtitle=i18n$t("Datos y estadísticas acerca de los días de estadía de los pacientes según tipo de cirugía y mes"), 
                                        icon=shiny::icon("arrow-pointer"), tabName = "menu5",color = "lightblue",fill=FALSE, iconElevation = 2,elevation = 2))
      ), 
      
      
      
      
      tabItem(tabName = "menu2",
              
              fluidRow(width=12,
                       box(width = 9,title = i18n$t("Utilización de quirófanos"),closable = FALSE,elevation = 2, echarts4rOutput("grafico"),
                           status = "lightblue",headerBorder = FALSE,collapsible = FALSE),
                       
                       bs4Dash:: column(width = 3,
                                        valueBox(width = 12,subtitle = i18n$t("Porcentaje promedio de ocupación quirófanos"),value = shiny::h3(textOutput("utilización_quirófanos"), style = 'font-size:27px'),color = "teal",icon = icon("check")),
                                        valueBox(width = 12,subtitle = i18n$t("Horas programadas respecto a las habilitadas"),value = shiny::h3(textOutput("programadas_habilitadas"), style = 'font-size:27px'),color = "teal",icon = icon("check")),
                                        valueBox(width = 12,subtitle = i18n$t("Horas ocupadas respecto a las programadas"),value = shiny::h3(textOutput("ocupadas_programadas"), style = 'font-size:27px'),color = "teal",icon = icon("check"))),
                      
              )),
      
      tabItem(tabName = "menu3_1",
              fluidRow(width=12,
                       box(echarts4rOutput("grafico_barra"),title= i18n$t("Motivos de suspensión por mes"),width=9,headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2,status = "lightblue"),
                       bs4Dash::column(width=3,
                                       valueBox(width = 12,value = shiny::h3(textOutput("susp_totales"), style = 'font-size:27px'),color = "teal",subtitle=i18n$t("Suspensiones totales año 2022"),icon = icon("check")),
                                       valueBox(width = 12,value = shiny::h3(textOutput("porcentaje_paciente"), style = 'font-size:27px'),color = "teal",subtitle=i18n$t("Suspensiones debido a la causal paciente"),icon = icon("check")),
                                       valueBox(width = 12,value=shiny::h3(textOutput("porcentaje_equipo"), style = 'font-size:27px'),color = "teal",subtitle=i18n$t("Suspensiones debido a la causal equipo quirúrgico"),icon = icon("check")))),
              fluidRow(width=12,
                       box(echarts4rOutput("grafico_sankey"),title= i18n$t("Desgloce motivos de suspensión cirugías"),width=12,height="620px",headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2, status = "lightblue")),
              fluidRow(width=12,
                       box(width=6,echarts4rOutput("grafico_pareto_1"),title= i18n$t("Grafico de Pareto de causales; pacientes 15 Años Y Más"),headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2),
                       box(width=6,echarts4rOutput("grafico_pareto_2"),title= i18n$t("Grafico de Pareto de causales; todas las edades"),headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2),
                       box(width=12,echarts4rOutput("grafico_pareto_causas"),height = "650px",title= i18n$t("Gráfico pareto de los motivos de suspensión"),headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2))
              
      ),
      tabItem(tabName = "menu3_2",
              fluidRow(width=12,
                       box(echarts4rOutput("grafico_circular1"),title= i18n$t("Distribución suspensiones por tipo de cirugía"),width=6,height="400px",reorder= TRUE,headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2, status = "lightblue"),
                       box(echarts4rOutput("grafico_circular2"),title= i18n$t("Distribución suspensiones por especialidad"),width=6,height="400px",reorder= TRUE,headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2, status = "lightblue")),
              fluidRow(width=12,
                       box(echarts4rOutput("grafico_susp_esp"),title= i18n$t("Cantidad de Suspensiones por especialidad y tipo de cirugía"),width=12,height="400px",headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2, status = "lightblue"))
              
              
      ),
      tabItem(tabName = "menu4",
              fluidRow(width=12,
                       box(width=9,echarts4rOutput("grafico_hospitalizacion"),headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2,title = i18n$t("Cupos programados y utilizados de hospitalización domiciliaria"),status = "lightblue"),
                       bs4Dash:: column(width = 3,
                                        valueBox(width = 12,subtitle = i18n$t("Cupos programados totales 2022"),value = shiny::h3(textOutput("cupos_programados_totales"), style = 'font-size:27px'),color = "teal",icon = icon("check")),
                                        valueBox(width = 12,subtitle = i18n$t("Cupos utilizados totales 2022"),value = shiny::h3(textOutput("cupos_utilizados_totales"), style = 'font-size:27px'),color = "teal",icon = icon("check")),
                                        valueBox(width = 12,subtitle = i18n$t("Cupos utilizados/cupos programados"),value = shiny::h3(textOutput("cupos_utilizados_vs_programados"), style = 'font-size:27px'),color = "teal",icon = icon("check"))))
              
      ),
      tabItem(tabName = "menu5",
              fluidRow(width=12,
                       box(width=9,echarts4rOutput("dias_estada_mensual"),headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2, height = "560px",title = i18n$t("Días de estadia y pacientes intervenidos por mes"),status = "lightblue"),
                       column(width = 3,
                              box(width = 12,headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2, status = "lightblue",selectInput("selector_1",i18n$t("Seleccion de especialidad"),
                                                                                                                         if(i18n$get_translation_language()=="es"){
                                                                                                                           choices = c("Cirugía general"="CIRUGÍA GENERAL","Cirugía cardiovascular"="CIRUGÍA CARDIOVASCULAR",
                                                                                                                                     "Cirugía máxilofacial"="CIRUGÍA MÁXILOFACIAL", "Cirugía tórax"="CIRUGÍA TÓRAX", "Traumatología"="TRAUMATOLOGÍA"
                                                                                                                                     , "Neurocirugía"="NEUROCIRUGÍA", "Otorrinolaringología"="OTORRINOLARINGOLOGÍA", "Oftalmología"="OFTALMOLOGÍA"
                                                                                                                                     , "Obstetricia y ginecología"="OBSTETRICIA Y GINECOLOGÍA", "Ginecología"="GINECOLOGÍA", "Urología"="UROLOGÍA"
                                                                                                                                     , "Resto especialdiades"="RESTO ESPECIALIDADES", "Todas"="TODAS")}
                                                                                                                         else{choices = c("General Surgery"="General Surgery","cardiovascular surgery"="cardiovascular surgery",
                                                                                                                                          "Maxillofacial Surgery"="CIRUGÍA MÁXILOFACIAL", "Chest surgery"="CIRUGÍA TÓRAX", "Traumatology"="TRAUMATOLOGÍA"
                                                                                                                                          , "Neurosurgery"="Neurosurgery", "Otorhinolaryngology"="Otorhinolaryngology", "Ophthalmology"="Ophthalmology"
                                                                                                                                          , "Obstetrics and gynecology"="Obstetrics and gynecology", "Gynecology"="Gynecology", "Urology"="Urology"
                                                                                                                                          , "Other specialties"="Other specialties", "All")}
                                                                                                                           )),
                              valueBox(width = 12,subtitle = i18n$t("Días totales de estadía"),value = shiny::h3(textOutput("dias_totales_especialidad"), style = 'font-size:27px'),color = "teal",icon = icon("check")),
                              valueBox(width = 12,subtitle = i18n$t("Pacientes intervenidos totales"),value = shiny::h3(textOutput("pacientes_totales_especialidad"), style = 'font-size:27px'),color = "teal",icon = icon("check")),
                              valueBox(width = 12,subtitle = i18n$t("Días de estadía promedio por paciente"),value = shiny::h3(textOutput("días_de_estada_especialidad"), style = 'font-size:27px'),color = "teal",icon = icon("check")))),
                       
                       
              fluidRow(width=12,                
                       box(width=9,echarts4rOutput("dias_estada_especialidad"),headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2, height = "560px", title = i18n$t("Días de estadía y pacientes intervenidos por especialidad"),status = "lightblue"),
                       column(width = 3,
                              box(width = 12,headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2,status = "lightblue",selectInput("selector_2",i18n$t("Selección de mes"), 
                                                                                                                                                      if(i18n$get_translation_language()=="es"){
                                                                                                                                                        choices = c("Enero"="enero","Febrero"="febrero",
                                                                                                                                                                      "Marzo"="marzo", "Abril"="abril", "Mayo"="mayo", "Junio"="junio", "Julio"="julio", "Agosto"="agosto"
                                                                                                                                                                      , "Septiembre"="septiembre", "Octubre"="obtubre", "Noviembre"="noviembre" , "Diciembre"="diciembre", "Año 2022"="año 2022")}
                                                                                                                                                      else{choices = c("January","February","March", "April", "May", "June", "July", "August"
                                                                                                                                                                       , "September", "October", "November" , "December", "Year 2022")}
                                                                                                                                                      )),
                              valueBox(width = 12,subtitle = i18n$t("Días totales de estadía"),value = shiny::h3(textOutput("dias_totales_mes"), style = 'font-size:27px'),color = "teal",icon = icon("check")),
                              valueBox(width = 12,subtitle = i18n$t("Pacientes intervenidos totales"),value = shiny::h3(textOutput("pacientes_totales_mes"), style = 'font-size:27px'),color = "teal",icon = icon("check")),
                              valueBox(width = 12,subtitle = i18n$t("Días de estadía promedio por paciente"),value = shiny::h3(textOutput("días_de_estada_mes"), style = 'font-size:27px'),color = "teal",icon = icon("check")))),
              
      )
      
      
      
    )
    
  ))

   