# app/main.R

box::use(
  app/logic/timeline,
  app/logic/tabla_profesionales,
  app/logic/mapa_de_calor,
  app/logic/calendario_semanal,
  app/logic/utilizacion_de_quirofanos/grafico,
  app/logic/utilizacion_de_quirofanos/tabla,
  app/logic/tiempo_cirugía,
  app/logic/carga_imagen,
  app/logic/analisis_de_suspensiones/grafico_barra,
  app/logic/analisis_de_suspensiones/grafico_sankey,
  app/logic/Tiempo_extra/grafico_tiempoExtra,
  app/logic/Tiempo_extra/grafico_horizontal)

box::use(
  htmltools,
  bs4Dash,
  timevis,
  reactable,
  shiny[moduleServer, NS, fluidRow, icon, h1,h2,tags,observeEvent,renderPrint,actionButton],
  shiny,
  bs4Dash[
    dashboardPage,
    dashboardHeader, dashboardBody, dashboardSidebar,
    sidebarMenu, menuItem,box,tabItem,tabItems,valueBox],
  utils,
  calheatmapR,
  dplyr,
  toastui,
  highcharter,
  config,
  polished,
  shinyWidgets,
  shinycssloaders,
  echarts4r)



#' @export
ui <- function(id) {
  ns <- NS(id)
  dashboardPage(
    dashboardHeader(title = "Sistema de gestion HBV"),
    dashboardSidebar(side = "top", visible = FALSE,
                     sidebarMenu(
                       id = "sidebar",
                       menuItem("Inicio",tabName = "menu1",
                                icon=icon("laptop-medical"),
                                selected = TRUE),
                       # menuItem("Horario pabellones",tabName = "menu2",
                       #          icon=icon("eye")),
                       # menuItem("Verificación de horario",tabName="menu3",
                       #          icon=icon("hospital")),
                       # menuItem("Estadisticas operaciones",tabName="menu5",
                       #           icon=icon("notes-medical"),
                       bs4Dash::menuItem("Reporte quirófanos",tabName="menu5_1",
                                         icon=icon("check-square")), 
                       bs4Dash::menuItem("Tiempo real vs programado",tabName="menu5_2",
                                         icon=icon("chart-line")),
                       bs4Dash::menuItem("Duración cirugíass",tabName="menu5_3",
                                         icon=icon("user-doctor")),
                    bs4Dash::menuItem("Análisis suspenciones",tabName="menu5_4",
                                         icon=icon("user-doctor"))),
                     actionButton(
                       "sign_out",
                       "Sign Out",
                       icon = icon("sign-out-alt"),
                       class = "pull-right",selected = FALSE)
                     
                     
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "menu1",
                fluidRow(width=12, carga_imagen$ui(ns("myImage"))),
                # Boxes need to be put in a row (or column)
                fluidRow(width=12,
                         bs4Dash::infoBox(bs4Dash::bs4Ribbon(text = "Nuevo",color = "primary"),width = 6,title = shiny::h3("Reporte quirófanos", style = 'font-size:30px'),subtitle="Este menú contiene estadísticas de ocupación de quirófanos", 
                                          icon=shiny::icon("arrow-pointer"), tabName = "menu5_1",color = "purple",fill=FALSE, iconElevation = 2,elevation = 2),
                         bs4Dash::infoBox(bs4Dash::bs4Ribbon(text = "Nuevo",color = "primary"),width = 6,title = shiny::h3("Análisis tiempo real vs programado", style = 'font-size:30px'),subtitle="Datos acerca de las cirugías que exceden el tiempo programdo", 
                                          icon=shiny::icon("arrow-pointer"), tabName = "menu5_2",color = "purple",fill=FALSE, iconElevation = 2,elevation = 2)),
                fluidRow(width=12,
                         bs4Dash::infoBox(width = 6,title = shiny::h3("Duración cirugías", style = 'font-size:30px'),subtitle="Datos históricos de la duración de distintos tipos de cirugías", 
                                          icon=shiny::icon("arrow-pointer"), tabName = "menu5_3",color = "purple",fill=FALSE, iconElevation = 2,elevation = 2),
                         bs4Dash::infoBox(width = 6,title = shiny::h3("Análisis suspenciones", style = 'font-size:30px'),subtitle="Se presentan datos acerca de las causas de suspención de cirugías", 
                                          icon=shiny::icon("arrow-pointer"), tabName = "menu5_4",color = "purple",fill=FALSE, iconElevation = 2,elevation = 2))
        ), 
        
        
        # tabItem(tabName = "menu2",
        #         fluidRow(width=12,valueBox(width = 3,value=h2(5),color = "primary",subtitle="Pabellones disponibles",icon = icon("check")),
        #                           valueBox(width = 3,value=h2(7),color = "secondary",subtitle="Especialidades disponibles",icon = icon("check")),
        #                           valueBox(width = 3,value=h2(30),color = "success",subtitle="dias disponibles",icon = icon("check")),
        #                           valueBox(width = 3,value=h2(335),color = "warning",subtitle="dias no disponibles",icon = icon("check"))),
        # 
        #         fluidRow(width=12,box(width = 12,title = shiny::h3("Mapa de calor agenda pabellones"),closable = FALSE,elevation = 2, mapa_de_calor$ui(ns("calendarmap")),
        #                               status = "primary",headerBorder = FALSE,collapsible = FALSE,height = "300")),
        #     
        #         fluidRow(width=12,box(width = 12,title = shiny::h3("Calendario"),closable = FALSE,elevation = 2, calendario_semanal$ui(ns("calendario")),
        # 
        #                               status = "info",headerBorder = FALSE,collapsible = FALSE))
        #         
        #         ),
        
        # tabItem(tabName = "menu3",
        #         fluidRow(width=12,timeline$ui(ns("linea_de_tiempo"))),
        #         fluidRow(width=12,box(width=12,title="Linea de tiempo",height = "300",
        #                               status = "primary",headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2))
        #         ),
        
        tabItem(tabName = "menu5_1",
                
                fluidRow(width=12,
                         box(width = 9,title = "Utilización de quirófanos",closable = FALSE,elevation = 2, grafico$ui(ns("grafico")),
                             status = "primary",headerBorder = FALSE,collapsible = FALSE),
                         
                         bs4Dash:: column(width = 3,
                                          valueBox(width = 12,subtitle = "Promedio porcentaje de ocupación quirófanos",value = shiny::h3("60%", style = 'font-size:27px'),color = "purple",icon = icon("check")),
                                          valueBox(width = 12,subtitle = "Horas programadas respecto a las habilitadas",value = shiny::h3("79%", style = 'font-size:27px'),color = "purple",icon = icon("check")),
                                          valueBox(width = 12,subtitle = "Horas ocupadas respecto a las programadas",value = shiny::h3("80%", style = 'font-size:27px'),color = "purple",icon = icon("check"))),
                         
                         
                         box(width = 12,title = "Utilización de quirófanos",closable = FALSE,elevation = 2, tabla$ui(ns("tabla")),
                             status = "primary",headerBorder = FALSE,collapsible = FALSE)
                )),
        
        tabItem(tabName = "menu5_2",
                
                fluidRow(width=12,
                         box(width = 9,title = "Tiempo total adicional", closable = FALSE,elevation = 2, grafico_tiempoExtra$ui(ns("grafico_extra")),
                             status = "primary",headerBorder = FALSE,collapsible = FALSE)),
                fluidRow(width=12,
                         box(width = 9,title = "Tiempo adicional promedio por cirugía", closable = FALSE,elevation = 2, grafico_horizontal$ui(ns("grafico_horizontal")),
                             status = "primary",headerBorder = FALSE,collapsible = FALSE))
        ),
        
        
        tabItem(tabName = "menu5_3",
                
                fluidRow(width=12,
                         box(width = 9,title = "Tiempos históricos de cirugía",closable = FALSE,elevation = 2, tiempo_cirugía$ui(ns("histograma")),
                             status = "primary",headerBorder = FALSE,collapsible = FALSE),
                         bs4Dash::column(width = 3,
                                         valueBox(width = 12,subtitle = "Promedio porcentaje de ocupación quirófanos",value = shiny::h3("60%", style = 'font-size:27px'),color = "primary",icon = icon("check")),
                                         valueBox(width = 12,subtitle = "Horas programadas respecto a las habilitadas",value = shiny::h3("79%", style = 'font-size:27px'),color = "info",icon = icon("check")),
                                         valueBox(width = 12,subtitle = "Horas ocupadas respecto a las programadas",value = shiny::h3("80%", style = 'font-size:27px'),color = "success",icon = icon("check")))
                )),
        
        tabItem(tabName = "menu5_4",
                fluidRow(width=12,box(grafico_barra$ui(ns("grafico_barra")),width=9,headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2),bs4Dash::column(width=3,valueBox(width = 12,value=h2(5),color = "primary",subtitle="Pabellones disponibles",icon = icon("check")),
                                                                                                                                                                             valueBox(width = 12,value=h2(7),color = "secondary",subtitle="Especialidades disponibles",icon = icon("check")))),
                fluidRow(width=12,box(grafico_sankey$ui(ns("grafico_sankey")),width=12,height="900px",headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2)),
                fluidRow(width=12,box(width=6,headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2),
                         box(width=6,headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2))
                
        )
        
        
        
      )
      
    ))
  
  
}

polished::secure_ui(ui)

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    timeline$server("linea_de_tiempo")
    tabla_profesionales$server("tabla_prof")
    mapa_de_calor$server("calendarmap")
    calendario_semanal$server("calendario")
    
    # Utilizacion de quirofanos
    grafico$server("grafico")
    tabla$server("tabla")
    
    # Analisis de suspensiones
    grafico_barra$server("grafico_barra")
    grafico_sankey$server("grafico_sankey")
    
    tiempo_cirugía$server("histograma")
    carga_imagen$server("myImage")
    grafico_tiempoExtra$server("grafico_extra")
    grafico_horizontal$server("grafico_horizontal")

    
    shinyWidgets::show_toast(
      title = "Sistema de gestion HBV",
      text = "Este dashboard es solo una version de prueba",
      type = "info",
      position = "top",
      timer=2000,
      width = "800"
    )
    
  })
  
  
}
polished::secure_server(server)