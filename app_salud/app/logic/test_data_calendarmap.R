data<-floor(rnorm(n = 31,mean = 20))
names(data)<-c(as.numeric(as.POSIXct("2023-01-01")),
               as.numeric(as.POSIXct("2023-01-02")),
               as.numeric(as.POSIXct("2023-01-03")),
               as.numeric(as.POSIXct("2023-01-20")),
               as.numeric(as.POSIXct("2023-02-01")),
               as.numeric(as.POSIXct("2023-02-02")),
               as.numeric(as.POSIXct("2023-02-03")),
               as.numeric(as.POSIXct("2023-02-20")),
               as.numeric(as.POSIXct("2023-03-21")),
               as.numeric(as.POSIXct("2023-03-22")),
               as.numeric(as.POSIXct("2023-04-06")),
               as.numeric(as.POSIXct("2023-04-15")),
               as.numeric(as.POSIXct("2023-04-17")),
               as.numeric(as.POSIXct("2023-05-01")),
               as.numeric(as.POSIXct("2023-05-07")),
               as.numeric(as.POSIXct("2023-06-06")),
               as.numeric(as.POSIXct("2023-06-07")),
               as.numeric(as.POSIXct("2023-06-17")),
               as.numeric(as.POSIXct("2023-07-01")),
               as.numeric(as.POSIXct("2023-07-17")),
               as.numeric(as.POSIXct("2023-09-01")),
               as.numeric(as.POSIXct("2023-09-06")),
               as.numeric(as.POSIXct("2023-09-07")),
               as.numeric(as.POSIXct("2023-10-01")),
               as.numeric(as.POSIXct("2023-10-06")),
               as.numeric(as.POSIXct("2023-10-07")),
               as.numeric(as.POSIXct("2023-10-17")),
               as.numeric(as.POSIXct("2023-11-01")),
               as.numeric(as.POSIXct("2023-11-06")),
               as.numeric(as.POSIXct("2023-11-07")),
               as.numeric(as.POSIXct("2023-12-01")))

saveRDS(data, file="app_salud/app/logic/data/data.RData")
data<-readRDS("app_salud/app/logic/data/data.RData")

calheatmapR::calheatmapR(data) |> 
  calheatmapR::chDomain(domain = "month", subDomain = "day", start = "2023-01-01", range = 12,cellSize = 20,gutter = 10)
