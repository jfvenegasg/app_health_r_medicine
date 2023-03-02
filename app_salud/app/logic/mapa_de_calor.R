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
      
      names(list(1, 10, 100)) |> c(as.numeric(as.POSIXct("2001-01-01")), as.numeric(as.POSIXct("2001-01-02")), as.numeric(as.POSIXct("2001-01-03"))) |>       
      calheatmapR::calheatmapR() |> 
          calheatmapR::chDomain(domain = "month", subDomain = "day", start = "2000-12-01", range = 12,cellSize = 20,gutter = 10)
      

    )
  })
}