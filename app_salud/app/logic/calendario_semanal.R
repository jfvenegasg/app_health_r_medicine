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

#> Warning: `bindFillRole()` only works on htmltools::tag() objects (e.g., div(), p(), etc.), not objects of type 'shiny.tag.list'. 

server <- function(id) {
  moduleServer(id, function(input, output, session) {
  
  output$calendario <- toastui::renderCalendar({
    toastui::calendar(toastui::cal_demo_data("week"), view = "week",
      defaultDate = Sys.Date(),
      navigation = TRUE,
      isReadOnly = FALSE,
      useCreationPopup = TRUE) |>
      toastui::cal_week_options(
        startDayOfWeek = 1,
        workweek = TRUE) |>
      toastui::cal_props(toastui::cal_demo_props())
  })
  
  shiny::observeEvent(input$calendario_add, {
    utils::str(input$calendario_add)
    toastui::cal_proxy_add("calendario", input$calendario_add)
  })
  
  shiny::observeEvent(input$calendario_update, {
    utils::str(input$calendario_update)
    toastui::cal_proxy_update("calendario", input$calendario_update)
  })
  
  shiny::observeEvent(input$calendario_delete, {
    utils::str(input$calendario_delete)
    toastui::cal_proxy_delete("calendario", input$calendario_delete)
  })
  
})}

if (interactive())
  shiny::shinyApp(ui = ui, server = server)


