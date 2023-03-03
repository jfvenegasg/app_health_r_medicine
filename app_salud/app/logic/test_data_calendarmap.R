data<-list(1, 10, 100,20,40,50,500,10,60,7,59)
names(data)<-c(as.numeric(as.POSIXct("2001-01-01")),
               as.numeric(as.POSIXct("2001-01-02")),
               as.numeric(as.POSIXct("2001-01-03")),
               as.numeric(as.POSIXct("2001-01-20")),
               as.numeric(as.POSIXct("2001-03-21")),
               as.numeric(as.POSIXct("2001-03-22")),
               as.numeric(as.POSIXct("2001-05-15")),
               as.numeric(as.POSIXct("2001-05-17")),
               as.numeric(as.POSIXct("2001-06-06")),
               as.numeric(as.POSIXct("2001-06-07")),
               as.numeric(as.POSIXct("2001-08-01")))

saveRDS(data, file="app_salud/app/logic/data/data.RData")
data<-readRDS("app/logic/data/data.RData")

calheatmapR::calheatmapR(data) |> 
  calheatmapR::chDomain(domain = "month", subDomain = "day", start = "2000-12-01", range = 12,cellSize = 20,gutter = 10)
