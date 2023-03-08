# app/logic/utilizacion_de_quirofanos/tabla.R

box::use(
  reactable,
  MASS,
  shiny[h3, moduleServer, NS, tagList],
  dplyr,
  utils,
  echarts4r,
  scales
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  
  tagList(
    
    reactable$reactableOutput(ns("tabla"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    
    output$tabla<-reactable$renderReactable({
      
      xlsx::read.xlsx(file="app/logic/data/set_de_datos.xlsx",sheetIndex = 2, rowIndex = 1:12, colIndex= 1:11
                      , as.data.frame = TRUE, header = TRUE) |>
        dplyr::mutate_if(is.numeric, ~ dplyr::case_when(. < 2 ~ round(., 2), TRUE ~ ceiling(.))) |> 
        dplyr::mutate_at(7:11, scales::percent) |>
        reactable::reactable(searchable = TRUE, minRows = 10) 
          
    })
    
  })
}