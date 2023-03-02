# app/logic/tabla_profesionales.R

box::use(
  reactable,
  MASS,
  shiny[h3, moduleServer, NS, tagList],
  dplyr,
  utils
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    h3("Seguimiento agenda"),
    reactable$reactableOutput(ns("tabla_prof"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$tabla_prof <- reactable$renderReactable(
      
      MASS::Cars93[1:20, c("Manufacturer", "Model", "Type", "AirBags", "Price")] |>
      
      reactable::reactable(searchable = TRUE, minRows = 10)
      
          )
  })
}