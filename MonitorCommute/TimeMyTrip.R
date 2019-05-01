

TimeMyTrip<-function(direction){
  webpage <- read_html("https://dotfeeds.state.ma.us/api/RealTimeTrafficAccessiblePage/Index")
  
  tbls <- html_nodes(webpage, "table")
  table<-tbls %>% html_table(fill = TRUE)
  traffic<-as.data.frame(table[[1]])
  
  Rt24<-traffic %>% filter(startsWith(Routes,'Rt. 24'))# pull out the Rt. 24 data
  Rt24 <- Rt24 %>% mutate(Routes = str_replace_all(Routes, "  ", " "))
  rm(webpage, tbls, table, traffic)
  TravelTimeSecs<-function(TravelTimeWords){
    min <- as.numeric(str_match(TravelTimeWords,"\\d+"))
    seconds<-as.numeric(str_match(TravelTimeWords,"\\min:?\\s*(\\d+)")[,2])+(min*60)
    return(seconds)}
  
  Rt24<-Rt24[-1,]
  colnames(Rt24)[2]<-'TravelTime'
  Rt24<-Rt24 %>% mutate(timeSecs = TravelTimeSecs(TravelTime))
  

    NBroute<-c("Rt. 24 NB after Exit 18A to Rt. 27 in Brockton to Rt. 24 NB after Exit 19B to Harrison Blvd in Avon", 
               "Rt. 24 NB after Exit 19B to Harrison Blvd in Avon to Rt. 24 SB before Exit 20B to 139 in Randolph",
               "Rt. 24 SB before Exit 20B to 139 in Randolph to Rt. 24 before Exit 21B to I-93 in Randolph")
    NBtrip<-Rt24 %>% filter(Routes %in% NBroute) 
    NBtrip <- sum(NBtrip$timeSecs)


SBroute<-c("Rt. 24 NB after Exit 19B to Harrison Blvd in Avon to Rt. 24 NB after Exit 18A to Rt. 27 in Brockton",
          "Rt. 24 SB before Exit 20B to 139 in Randolph to Rt. 24 NB after Exit 19B to Harrison Blvd in Avon",
                 "Rt. 24 before Exit 21B to I-93 in Randolph to Rt. 24 SB before Exit 20B to 139 in Randolph")
      SBtrip<-Rt24 %>% filter(Routes %in% SBroute) 
      SBtrip<-sum(SBtrip$timeSecs)
    trip = ifelse(direction == "NB", NBtrip, SBtrip)
      return(trip)
      }
#rm(Rt24, NBroute, SBroute, TravelTimeSecs)
