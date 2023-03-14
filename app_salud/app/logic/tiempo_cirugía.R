# app/logic/tiempo_cirugía.R

box::use(
  reactable,
  MASS,
  shiny[h3, moduleServer, NS, tagList,selectInput,reactive,observe,HTML,p,renderText, textOutput],
  shiny,
  dplyr,
  utils,
  echarts4r,
  pool
)

#box::use(
#  app/global)

#pool<-global$pool


#' @export
ui_1 <- function(id) {
  ns <- NS(id)
  
    tagList(
    selectInput(ns("selector_1"),"Seleccion de especialidad",choices = c("Cirugía general"="Cirugía general","Neurocirugía"="Neurocirugía","Cirugía cardiovascular"="Cirugía cardiovascular")),
    echarts4r$echarts4rOutput(ns("histograma")))
    
    
    
}

#' @export
ui_2 <- function(id) {
  ns <- NS(id)
  
  tagList(shiny$textOutput(ns("media")))
}

#tiempo<-xlsx::read.xlsx(file="app/logic/data/set_de_datos_1.xlsx",sheetIndex = 2, rowIndex = 1:150, colIndex= 1:2
#                        , as.data.frame = TRUE, header = TRUE)

#tiempo_cirugía<-dplyr::tbl(pool,"datos_tiempo_cirugía")

#xlsx::write.xlsx(x = tiempo_cirugía,file = "app/logic/data/datos_tiempo_cirugía_bd.xlsx",row.names = FALSE)

tiempo_cirugía<-xlsx::read.xlsx(file="app/logic/data/datos_tiempo_cirugía_bd.xlsx",sheetIndex = 1, rowIndex = 1:150, colIndex= 1:2
                              , as.data.frame = TRUE, header = TRUE)

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$media<- shiny$renderText({ 
      media<-subset(tiempo_cirugía,Especialidad=="Neurocirugía") |>
        dplyr::summarise(mean = mean(Minutos))
      media[1,1]
    })
    
    output$histograma<-echarts4r$renderEcharts4r({ 
         
          subset(tiempo_cirugía,Especialidad==input$selector_1) |>
          echarts4r::e_charts() |>
          echarts4r::e_histogram(Minutos) |>
          echarts4r::e_theme("walden")|>
          echarts4r::e_tooltip(trigger = "axis",axisPointer = list(type = "shadow"))
    })
    
   
  }) 
  }

