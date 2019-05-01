library(rvest)
library(tidyverse)
library(lubridate)
library(rsconnect)

source('~/Desktop/GitHub/TimeMyTrip.R')
rsconnect::setAccountInfo(name='sbhagerty',
                          token='8DF16A95505B86E8B86F7A5DD42DC08C',
                          secret='beUwzrpebEXtwVWAYbaTle9sjT4FnWPbWtdxqd8l')
update<-function(){
  now <- as.character(now())
  rows<-nrow(df)+1
  direction<- ifelse(am(as_datetime(now)), "NB","SB")
  routeTime<-TimeMyTrip(direction)
  df[rows,]<-c(now, direction, routeTime)
  return(df)
}

df<-update()
