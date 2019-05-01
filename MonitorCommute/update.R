library(rvest)
library(tidyverse)
library(lubridate)

source('TimeMyTrip.R')

df<-read.csv('df.csv',stringsAsFactors = FALSE)
update<-function(){
  now <- as.character(now())
  rows<-nrow(df)+1
  direction<- ifelse(am(as_datetime(now)), "NB","SB")
  routeTime<-TimeMyTrip(direction)
  df[rows,]<-c(now, direction, routeTime)
  return(df)
}

df<-update()
write.csv(df, 'df.csv', row.names=FALSE)
#quit(save="no")
