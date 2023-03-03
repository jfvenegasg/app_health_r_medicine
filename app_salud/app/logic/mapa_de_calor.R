# app/logic/mapa_de_calor.R

box::use(
  shiny[h3, moduleServer, NS, tagList],
  dplyr,
  utils,
  calheatmapR
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    h3("Seguimiento agenda"),
    calheatmapR$calheatmapROutput(ns("calendarmap"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$calendarmap <- calheatmapR$renderCalheatmapR(
      
    
      
      calheatmapR::calheatmapR(data = readRDS("app/logic/data/data.RData")) |> 
          calheatmapR::chDomain(domain = "month", subDomain = "day", start = "2000-12-01", range = 12,cellSize = 22,gutter = 10,margin = 25)
      

    )
  })
}