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
      
      MASS::Cars93[1:20] |>
      reactable::reactable(searchable = TRUE, minRows = 10, columns = list(
        Price = reactable::colDef(
          style = function(value) {
            if (value > 22) {
              color <- "#008000"
            } else if (value < 22) {
              color <- "#e00000"
            } else {
              color <- "#777"
            }
            list(color = color, fontWeight = "bold")
          }
        ),Manufacturer = reactable::colDef(
          sticky = "left",
          style = list(backgroundColor = "#f7f7f7"),
          headerStyle = list(backgroundColor = "#f7f7f7")
        ),
        Model = reactable::colDef(
          sticky = "left",
          style = list(backgroundColor = "#f7f7f7"),
          headerStyle = list(backgroundColor = "#f7f7f7")
        )
      ),
      resizable = TRUE,
      wrap = FALSE,
      bordered = TRUE
      )
      )
    
  })
}