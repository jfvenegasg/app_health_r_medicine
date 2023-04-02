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
    dashboardHeader(title = "Sistema de gestion HBV",rightUi = dropdownMenu(
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
                                         icon=icon("user-doctor")),
                       bs4Dash::menuItem("Hospitalización domiciliaria",tabName="menu4",
                                         icon=icon("user-doctor"))
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
                                          valueBox(width = 12,subtitle = "Promedio porcentaje de ocupación quirófanos",value = shiny::h3("60%", style = 'font-size:27px'),color = "teal",icon = icon("check")),
                                          valueBox(width = 12,subtitle = "Horas programadas respecto a las habilitadas",value = shiny::h3("79%", style = 'font-size:27px'),color = "teal",icon = icon("check")),
                                          valueBox(width = 12,subtitle = "Horas ocupadas respecto a las programadas",value = shiny::h3("80%", style = 'font-size:27px'),color = "teal",icon = icon("check"))),
                         
                         
                         box(width = 12,title = "Utilización de quirófanos",closable = FALSE,elevation = 2, reactableOutput("tabla"),
                             status = "lightblue",headerBorder = FALSE,collapsible = FALSE)
                )),
        
        tabItem(tabName = "menu3",
                fluidRow(width=12,
                         box(echarts4rOutput("grafico_barra"),width=9,headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2,status = "lightblue"),
                         bs4Dash::column(width=3,
                                         valueBox(width = 12,value = shiny::h3("42%", style = 'font-size:27px'),color = "teal",subtitle="Suspenciones debido a la causal paciente",
                                                  icon = icon("check")),valueBox(width = 12,value=shiny::h3("23%", style = 'font-size:27px'),color = "teal",subtitle="Suspenciones debido a la causal equipo quirúrgico",icon = icon("check")))),
                fluidRow(width=12,
                         box(echarts4rOutput("grafico_sankey"),width=12,height="600px",headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2, status = "lightblue")),
                fluidRow(width=12,
                         box(width=6,echarts4rOutput("grafico_pareto_1"),headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2),
                         box(width=6,echarts4rOutput("grafico_pareto_2"),headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2),
                         box(width=12,echarts4rOutput("grafico_pareto_causas"),headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2))
                
        ),
        tabItem(tabName = "menu4",
                fluidRow(width=12,
                         box(width=9,echarts4rOutput("grafico_hospitalizacion"),headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2),
                         bs4Dash:: column(width = 3,
                                          valueBox(width = 12,subtitle = "Promedio porcentaje de ocupación quirófanos",value = shiny::h3("60%", style = 'font-size:27px'),color = "teal",icon = icon("check")),
                                          valueBox(width = 12,subtitle = "Horas programadas respecto a las habilitadas",value = shiny::h3("79%", style = 'font-size:27px'),color = "teal",icon = icon("check")),
                                          valueBox(width = 12,subtitle = "Horas ocupadas respecto a las programadas",value = shiny::h3("80%", style = 'font-size:27px'),color = "teal",icon = icon("check"))))
                
        )
        
        
        
      )
      
    ))
  
  

