# app/main.R

box::use(
  app/logic/timeline,
  app/logic/tabla_profesionales,
  app/logic/mapa_de_calor,
  app/logic/calendario_semanal,
  app/logic/estadísticas)


box::use(
  htmltools,
  bs4Dash,
  timevis,
  reactable,
  shiny[moduleServer, NS, fluidRow, icon, h1,h2],
  shiny,
  bs4Dash[
    dashboardPage,
    dashboardHeader, dashboardBody, dashboardSidebar,
    sidebarMenu, menuItem,box,tabItem,tabItems,valueBox],
  utils,
  calheatmapR,
  dplyr,
  toastui,
  highcharter)



#' @export
ui <- function(id) {
  ns <- NS(id)
  dashboardPage(
    dashboardHeader(title = "Dashboard"),
    dashboardSidebar(side = "top", visible = FALSE,
                     sidebarMenu(
                       id = "sidebar",
                       menuItem("Inicio",tabName = "menu1",
                                icon=icon("laptop-medical")),
                       menuItem("Verificación de horario",tabName = "menu2",
                                icon=icon("eye"),
                                selected = TRUE),
                       menuItem("Seguimiento",tabName="menu3",
                                icon=icon("hospital")),
                       menuItem("Profesionales",tabName="menu4",
                                icon=icon("user-doctor")),
                       menuItem("Estadisticas operaciones",tabName="menu5",
                                icon=icon("notes-medical"),
                                bs4Dash::menuSubItem("Reporte quirófanos",tabName="menu5_1",
                                            icon=icon("check-square"),
                                            selected = FALSE), 
                                bs4Dash::menuSubItem("Análisis supenciones",tabName="menu5_2",
                                            icon=icon("chart-line"),
                                            selected = FALSE),
                                bs4Dash::menuSubItem("Duración cirugías",tabName="menu5_3",
                                            icon=icon("chart-line"),
                                            selected = FALSE))
                       
                     )),
    dashboardBody(
      tabItems(
        tabItem(tabName = "menu1",
                
                # Boxes need to be put in a row (or column)
                fluidRow(width=12,box(width = 10,title = "Demanda de atenciones de urgencia por día",closable = FALSE,elevation = 2,
                                      status = "primary",headerBorder = FALSE,collapsible = FALSE)
                )),
        
        
        tabItem(tabName = "menu2",
                fluidRow(width=12,valueBox(width = 3,value=h2(5),color = "primary",subtitle="Pabellones disponibles",icon = icon("check")),
                                  valueBox(width = 3,value=h2(7),color = "secondary",subtitle="Especialidades disponibles",icon = icon("check")),
                                  valueBox(width = 3,value=h2(30),color = "success",subtitle="dias disponibles",icon = icon("check")),
                                  valueBox(width = 3,value=h2(335),color = "warning",subtitle="dias no disponibles",icon = icon("check"))),

                fluidRow(width=12,box(width = 12,title = "Mapa de calor",closable = FALSE,elevation = 2, mapa_de_calor$ui(ns("calendarmap")),
                                      status = "primary",headerBorder = FALSE,collapsible = FALSE,height = "300")),
            
                fluidRow(width=12,box(width = 12,title = "Calendario",closable = FALSE,elevation = 2, calendario_semanal$ui(ns("calendario")),

                                      status = "info",headerBorder = FALSE,collapsible = FALSE))
                
                ),
        
        tabItem(tabName = "menu3",
                fluidRow(width=12,timeline$ui(ns("chart")),
                fluidRow(width=12,box(width=12,title="Linea de tiempo",height = "300",
                                      status = "primary",headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2)))),
        tabItem(tabName = "menu4",
                fluidRow(width=12,valueBox(width = 3,value=h2(5),color = "primary",subtitle="Pabellones disponibles",icon = icon("check")),
                         valueBox(width = 3,value=h2(7),color = "secondary",subtitle="Especialidades disponibles",icon = icon("check")),
                         valueBox(width = 3,value=h2(30),color = "success",subtitle="dias disponibles",icon = icon("check")),
                         valueBox(width = 3,value=h2(335),color = "warning",subtitle="dias no disponibles",icon = icon("check"))),
                fluidRow(width=12,box(width=6,title="Tabla profesionales",height = "600",tabla_profesionales$ui(ns("tabla_prof"))),
                                  box(width=6,title="Tabla pabellon",height = "600"))),
        tabItem(tabName = "menu5_1",
                
                fluidRow(width=12,box(width = 10,title = "Utilización de quirófanos",closable = FALSE,elevation = 2, estadísticas$ui(ns("grafico1")),
                                      status = "primary",headerBorder = FALSE,collapsible = FALSE)
                ))
      )
      
      
    ))
  
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    timeline$server("chart")
    tabla_profesionales$server("tabla_prof")
    mapa_de_calor$server("calendarmap")
    calendario_semanal$server("calendario")
    estadísticas$server("grafico1")
  
  })
}
