# app/main.R

box::use(
  app/logic/timeline,
  app/logic/tabla_profesionales,
  app/logic/mapa_de_calor,
  app/logic/calendario_semanal)


box::use(
  htmltools,
  bs4Dash,
  timevis,
  reactable,
  shiny[moduleServer, NS, fluidRow, icon, h1],
  shiny,
  bs4Dash[
    dashboardPage,
    dashboardHeader, dashboardBody, dashboardSidebar,
    sidebarMenu, menuItem,box,tabItem,tabItems,valueBox],
  utils,
  calheatmapR,
  dplyr,
  toastui)



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
                                icon=icon("notes-medical"))
                       
                     )),
    dashboardBody(
      tabItems(
        tabItem(tabName = "menu1",
                
                # Boxes need to be put in a row (or column)
                fluidRow(width=12,box(width = 10,title = "Demanda de atenciones de urgencia por día",closable = FALSE,elevation = 2,
                                      status = "primary",headerBorder = FALSE,collapsible = FALSE)
                )),
        
        
        tabItem(tabName = "menu2",
                fluidRow(width=12,valueBox(width = 3,value=1,color = "primary",subtitle="stat1",icon = icon("check")),
                                  valueBox(width = 3,value=2,color = "primary",subtitle="stat2",icon = icon("check")),
                                  valueBox(width = 3,value=3,color = "primary",subtitle="stat3",icon = icon("check")),
                                  valueBox(width = 3,value=4,color = "primary",subtitle="stat4",icon = icon("check"))),

                fluidRow(width=12,box(width = 12,title = "Mapa de calor",closable = FALSE,elevation = 2, mapa_de_calor$ui(ns("calendarmap")),
                                      status = "primary",headerBorder = FALSE,collapsible = FALSE,height = "300")),
            
                fluidRow(width=12,box(width = 12,title = "Calendario",closable = FALSE,elevation = 2, calendario_semanal$ui(ns("calendario")),

                                      status = "info",headerBorder = FALSE,collapsible = FALSE))
                
                ),
        
        tabItem(tabName = "menu3",
                fluidRow(width=12,timeline$ui(ns("chart")))),
        tabItem(tabName = "menu4",
                fluidRow(width=12,tabla_profesionales$ui(ns("tabla_prof"))))
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
  
  })
}
