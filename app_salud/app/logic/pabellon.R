# app/logic/pabellon.R

box::use(
  lubridate)


#' @export
pabellon <- function(especialidad) {
  
  if(especialidad=="esp1"){
    
    contenido<-c("Operación 1","Operación 3", "Operación 5","Operación 7", "Operación 9","Operación 11")
    inicio<-c(lubridate::ymd_hms(Sys.time()) ,
              lubridate::ymd_hms(Sys.time()+lubridate::hours(3)),
              lubridate::ymd_hms(Sys.time()+lubridate::hours(6)),
              lubridate::ymd_hms(Sys.time()+lubridate::hours(9)),
              lubridate::ymd_hms(Sys.time()+lubridate::hours(12)),
              lubridate::ymd_hms(Sys.time()+lubridate::hours(15)))
    
    fin<-c(lubridate::ymd_hms(Sys.time()+lubridate::hours(3)),
           lubridate::ymd_hms(Sys.time()+lubridate::hours(6)),
           lubridate::ymd_hms(Sys.time()+lubridate::hours(9)),
           lubridate::ymd_hms(Sys.time()+lubridate::hours(12)),
           lubridate::ymd_hms(Sys.time()+lubridate::hours(15)),
           lubridate::ymd_hms(Sys.time()+lubridate::hours(18)))
  id<-1:6
  group<-2
  type<-6
  }else if(especialidad=="esp2"){
  
  contenido<-c("Operación 2","Operación 4","Operación 6","Operación 8","Operación 10","Operación 12")
  inicio<-c(lubridate::ymd_hms(Sys.time()+lubridate::hours(3)), 
            lubridate::ymd_hms(Sys.time()+lubridate::hours(9)),
            lubridate::ymd_hms(Sys.time()+lubridate::hours(15)),
            lubridate::ymd_hms(Sys.time()+lubridate::hours(21)),
            lubridate::ymd_hms(Sys.time()+lubridate::hours(27)),
            lubridate::ymd_hms(Sys.time()+lubridate::hours(32)))
  
  fin<-c(lubridate::ymd_hms(Sys.time()+lubridate::hours(6)),
         lubridate::ymd_hms(Sys.time()+lubridate::hours(12)),
         lubridate::ymd_hms(Sys.time()+lubridate::hours(18)),
         lubridate::ymd_hms(Sys.time()+lubridate::hours(24)),
         lubridate::ymd_hms(Sys.time()+lubridate::hours(30)),
         lubridate::ymd_hms(Sys.time()+lubridate::hours(36)))
  id<-1:6
  group<-2
  type<-6
  }else{}
  pab<-list(id,contenido,inicio,fin,group,type)
  
  
  return(pab)
}