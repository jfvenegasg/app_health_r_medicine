# app/logic/calendario_semanal.R

box::use(
  reactable,
  MASS,
  shiny[h3, moduleServer, NS, tagList],
  shiny,
  dplyr,
  utils,
  toastui,
  htmltools
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    h3("Calendario"),
    toastui$calendarOutput(ns("calendario"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$calendario <- toastui$renderCalendar(
      toastui::calendar(toastui::cal_demo_data("week"), view = "week", defaultDate = Sys.Date()) |> 
        toastui::cal_week_options(
          startDayOfWeek = 1,
          workweek = TRUE
        ) |> 
        toastui::cal_props(toastui::cal_demo_props()) |>

      toastui::cal_schedules(
        title = "My schedule",
        start = format(Sys.Date(), "%Y-%m-03 00:00:00"),
        end = format(Sys.Date(), "%Y-%m-17 00:00:00")
      ))
    
  })
}