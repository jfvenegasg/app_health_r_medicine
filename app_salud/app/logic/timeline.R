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
        start = c("2023-03-06 07:30:00",  "2023-03-04 07:30:00","2023-03-05 07:30:00", "2023-03-07 07:30:00", "2023-03-08 07:30:00",
                  "2023-03-09 07:30:00","2023-03-03 07:30:00", "2023-03-04 07:30:00","2023-03-07 07:30:00", "2023-03-06 07:30:00",
                  "2023-03-06 07:30:00"),
        end   = c("2023-03-06 10:30:00",  "2023-03-04 13:30:00","2023-03-05 14:30:00", "2023-03-07 09:30:00", "2023-03-08 18:30:00",
                  "2023-03-09 12:30:00","2023-03-03 18:30:00", "2023-03-04 19:30:00","2023-03-07 14:30:00", "2023-03-06 15:30:00",
                  "2023-03-06 17:30:00"),
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