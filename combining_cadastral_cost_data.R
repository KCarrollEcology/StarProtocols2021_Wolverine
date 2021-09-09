library(sp)
library(rgdal)
library(GISTools)
library(spdep)
library(dplyr)

### this code combines same owner cost data for parcels in the study area


mt<- st_read("D:/PrivateLand.shp")
#summary(mt)
#plot(mt)

mt$new <- paste(mt$OwnerName, mt$OwnerCity, sep = "_")
mt2 <- as(mt, "Spatial")
#mt3 <- as(mt, "ppp")

head(mt, n =5)

aggcost <- aggregate(mt$TotalValue~mt$new, FUN = sum)
aggcost$new<-aggcost$`mt$new`
aggcost$TotalValue2<-aggcost$`mt$TotalValue`
aggcost<-aggcost[3-4]
aggcost<-aggcost[2-3]
aggcost$PotentialEasem <- aggcost$TotalValue2*0.5+5000

newMT<- merge(mt, aggcost, by="new")

test<-distinct(newMT)

newMT2 <- aggregate(newMT$PotentialEasem~newMT$new, FUN = mean)
newMT2$new<-newMT2$`newMT$new`
newMT2$PotentialEasem<-newMT2$`newMT$PotentialEasem`
newMT2<-newMT2[3-4]
newMT2<-newMT2[2-3]


newMT3<- merge(mt2, newMT2, by="new")

test<- newMT3[which(!duplicated(newMT3$new)), ]

head(newMT3, n =5)


writeOGR(obj=test, dsn="D:/PotentialEasem.shp", layer="PotentialEasem", driver="ESRI Shapefile")

writeOGR(obj=newMT3, dsn="D:/PotentialEasem_duplicates.shp", layer="PotentialEasem", driver="ESRI Shapefile")


