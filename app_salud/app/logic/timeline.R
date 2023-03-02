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
    h3("Seguimiento agenda"),
    timevis$timevisOutput(ns("chart"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$chart <- timevis$renderTimevis(
      # Datasets are the only case when you need to use :: in `box`.
      # This issue should be solved in the next `box` release.
        
      
      data.frame(
        id      = 1:4,
        content = c("Item one", "Item two",
                    "Ranged item", "Item four"),
        start   = c("2016-01-10", "2016-01-11",
                    "2016-01-20", "2016-02-14 15:00:00"),
        end     = c(NA, NA, "2016-02-04", NA)
      ) |>
      
      timevis::timevis()
      
      
            # # rhino::rhinos |>
      #   echarts4r$group_by(Species) |>
      #  echarts4r$e_x_axis(x1)
      # echarts4r$e_tooltip()
    )
  })
}