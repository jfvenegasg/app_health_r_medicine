# app/logic/timeline.R

box::use(
  timevis,
  shiny[h3, moduleServer, NS, tagList],
  dplyr,
  utils
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
   
    timevis$timevisOutput(ns("chart"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$chart <- timevis$renderTimevis(
      # Datasets are the only case when you need to use :: in `box`.
      # This issue should be solved in the next `box` release.
        
      
      
      
      
      timevis::timevis(data = data.frame(
        id = 1:11,
        content = c("Operación 1", "Operación 2",
                    "Operación 3", "Operación 4", "Operación 5",
                    "Operación 6", "Operación 7", "Operación 8", "Operación 9", "Operación 10",
                    "Operación 11"),
        start = c(Sys.Date(),  Sys.Date()-1,Sys.Date()+1, Sys.Date()-1, Sys.Date()+2,
                  Sys.Date()+2,Sys.Date()+3, Sys.Date()-1,Sys.Date()+3, Sys.Date()+1,
                  Sys.Date()),
        end   = c(Sys.Date()+2,Sys.Date()+2,Sys.Date()+3, Sys.Date()+4, Sys.Date()+4,
                  Sys.Date()+5,Sys.Date()+6, Sys.Date()+2,Sys.Date()+5, Sys.Date()+5,
                  Sys.Date()+6),
        group = c(rep("Pabellon 1", 3), rep("Pabellon 2", 3), rep("Pabellon 3", 5)),
        type = c(rep("range", 11))
      ),       
              groups = data.frame(id = c("Pabellon 1", "Pabellon 2", "Pabellon 3","Pabellon 4","Pabellon 5"),
                                  content = c("Pabellon 1", "Pabellon 2", "Pabellon 3","Pabellon 4","Pabellon 5"))) 
     
            # # rhino::rhinos |>
      #   echarts4r$group_by(Species) |>
      #  echarts4r$e_x_axis(x1)
      # echarts4r$e_tooltip()
    )
  })
}