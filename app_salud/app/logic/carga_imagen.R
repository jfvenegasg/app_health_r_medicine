# app/logic/carga_imagen.R

box::use(
  shiny[h3, moduleServer, NS, tagList],
  shiny,
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
     shiny::imageOutput(ns("myImage"))
    
  ) 
}


#' @export

#> Warning: `bindFillRole()` only works on htmltools::tag() objects (e.g., div(), p(), etc.), not objects of type 'shiny.tag.list'. 

server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$myImage <- shiny::renderImage({
      
      list(src = "app/logic/data/imagen_inicio.jpg",
           width = "100%",
           height = 175)
      
    }, deleteFile = F)

  })}

if (interactive())
  shiny::shinyApp(ui = ui, server = server)