# app/main.R

# box::use(
#   app/logic/plot_map[plot_leaflet_map],
#   app/logic/e_chart,
#   app/logic/high_1)

box::use(
  shiny[moduleServer, NS, fluidRow, icon, h1],
  bs4Dash[
    dashboardPage,
    dashboardHeader, dashboardBody, dashboardSidebar,
    sidebarMenu, menuItem,box,tabItem,valueBox],
  leaflet[
    leafletOutput, renderLeaflet,
    leaflet, setView, addTiles
  ],
  echarts4r,
  utils,
  highcharter,
  bs4Dash)



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
                                icon=icon("laptop-medical"),
                                selected = TRUE),
                       menuItem("Seguimiento",tabName="menu3",
                                icon=icon("hospital")),
                       menuItem("Profesionales",tabName="menu4",
                                icon=icon("hospital")),
                       menuItem("Estadisticas operaciones",tabName="menu5",
                                icon=icon("hospital"))
                       
                     )),
    dashboardBody(
      tabItem(
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
                fluidRow(width=12,box(width = 12,title = "Mapa de calor",closable = FALSE,elevation = 2,
                                      status = "primary",headerBorder = FALSE,collapsible = FALSE)),
                fluidRow(width=12,box(width = 12,title = "Calendario",closable = FALSE,elevation = 2,
                                      status = "info",headerBorder = FALSE,collapsible = FALSE))
                
                )
      )
      
      
    ))
  # dashboardPage(
  #   dashboardHeader(left = h1("Dashboard salud")),
  #   dashboardSidebar(sidebarMenu(
  #     menuItem(tabName = "panel 1", text = "panel_1"),
  #     menuItem(tabName = "panel 2", text = "panel_2"),
  #     menuItem(tabName = "panel 3", text = "panel_3"),
  #     menuItem(tabName = "panel 4", text = "panel_4")
  #   ), side = "top", visible = FALSE),
  #   dashboardBody(
  #     # fluidRow(width=12,
  #     #          box(high_1$ui(ns("chart1")),width=12)
  #     # ),
  #     
  #     # fluidRow(box(e_chart$ui(ns("chart")),width=12)),
  #      fluidRow(width=12,
  #               box(leafletOutput(ns("main_map")),width=12))
  #     
  #     
  #   )
  # )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # output$main_map <- renderLeaflet({ 
    #   
    #   plot_leaflet_map(z=12)  })
    
    # e_chart$server("chart")
    # high_1$server("chart1")
  })
}
