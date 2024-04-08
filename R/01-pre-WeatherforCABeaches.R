#data file created used by Stata program 01-formatweather.do

#updated and corrected for Mission Bay
#saved new date file for merging 
#"C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/California Beaches/CAbeachesWeather_corrected.csv"
#updated into github repo

# no longer works, and wrong data for Mission Bay (San Diego, not SF)

# went to the following website: https://www.ncdc.noaa.gov/data-access
#clicked on Land Based Station -> Datasets and Products -> Local Climatological Data (LCD)
#Once on the data selection platform, highlight state then chose California
# Then add to cart the weather stations for each of the beaches - based on closest proximity and most complete data
#then when placing the order select Daily averages - deselect hourly averages, then select as CSV, choose dates needed and then hit submit

rm(list=ls())

library(dplyr)
library(tidyr)

M <- read.csv("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/California Beaches/2615069.csv")
keep<-grep("SOD", M$REPORT_TYPE)
M<-M[keep, ]
A <- read.csv("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/California Beaches/2615073.csv")
keep<-grep("SOD", A$REPORT_TYPE)
A<-A[keep, ]
D <- read.csv("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/California Beaches/2615067.csv")
keep<-grep("SOD", D$REPORT_TYPE)
D<-D[keep, ]
Mi<-read.csv("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/California Beaches/72290023188.csv")
keep<-grep("SOD", Mi$REPORT_TYPE)
Mi<-Mi[keep, ]
Mi$Beach="Mission Bay"

keepvars<-grep("Beach|DATE|REPORT_TYPE|Daily", names(M))
M<-M[, keepvars]
M<-M[, -24]
keepvars<-grep("Beach|DATE|REPORT_TYPE|Daily", names(A))
A<-A[, keepvars]
A<-A[, -24]
keepvars<-grep("Beach|DATE|REPORT_TYPE|Daily", names(D))
D<-D[, keepvars]
D<-D[, -24]
keepvars<-grep("Beach|DATE|REPORT_TYPE|Daily", names(Mi))
Mi<-Mi[, keepvars]

#only keep variables used
A<- A %>%
  select(c(Beach, DATE, DailyAverageDryBulbTemperature, DailyPrecipitation, DailyAverageWindSpeed))

M<- M %>%
  select(c(Beach, DATE, DailyAverageDryBulbTemperature, DailyPrecipitation, DailyAverageWindSpeed))

D<- D %>%
  select(c(Beach, DATE, DailyAverageDryBulbTemperature, DailyPrecipitation, DailyAverageWindSpeed))

Mi<- Mi %>%
  select(c(Beach, DATE, DailyAverageDryBulbTemperature, DailyPrecipitation, DailyAverageWindSpeed))

A$DATE<-substr(A$DATE, 1, 10)
A$DATE<-as.Date(A$DATE)

M$DATE<-substr(M$DATE, 1, 10)
M$DATE<-as.Date(M$DATE)

D$DATE<-substr(D$DATE, 1, 10)
D$DATE<-as.Date(D$DATE)

Mi$DATE<-substr(Mi$DATE, 1, 10)
Mi$DATE<-as.Date(Mi$DATE)



A$DailyAverageDryBulbTemperature
A$DailyAverageWindSpeed
A$DailyPrecipitation

M$DailyAverageDryBulbTemperature
M$DailyAverageWindSpeed
M$DailyPrecipitation

D$DailyAverageDryBulbTemperature
D$DailyAverageWindSpeed
D$DailyPrecipitation

Mi$DailyAverageDryBulbTemperature
Mi$DailyAverageWindSpeed
Mi$DailyPrecipitation

all<-rbind.data.frame(A, D, M, Mi)
#remove characters, replace T precip with 0.001 inch

all$DailyPrecipitation<-ifelse(all$DailyPrecipitation=="T", 0.001, all$DailyPrecipitation)
all$DailyAverageDryBulbTemperature<-gsub("s", "", all$DailyAverageDryBulbTemperature)
all$DailyAverageWindSpeed<-gsub("s", "", all$DailyAverageWindSpeed)
all$DailyPrecipitation<-gsub("s", "", all$DailyPrecipitation)

all<-mutate_at(all, c(3:5), as.numeric)
all$Lag1_ppt <- lag(all$DailyPrecipitation,    1)

saveRDS(all, file = "C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/California Beaches/CAbeachesWeather_corrected.RDS") 
write.csv(all, file = "C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/California Beaches/CAbeachesWeather_corrected.csv", row.names=FALSE)

#old code
#Mi <- fread("C:/Users/Administrator/OneDrive/Profile/Desktop/2615843.csv")

#Malibu Beach
#LA Airport land weather station was used to pull the data from 23may2009 - 20sep2009
#M[M ==""] <- NA
#M[M == "NA"] <- NA
# m <- subset(M, is.na(M$HourlyDryBulbTemperature))
# M <- subset(m[,-c(6:15, 42:124)])
# M <- M %>% drop_na(DATE)
# 
# M <- M %>% 
#   mutate_at(c(4:27), as.numeric)
# 
# M<- subset(M, M$REPORT_TYPE == "SOD")
# 
# table(M$DATE)
# 
# M$Lag1_ppt <-     lag(M$DailyPrecipitation,    1)
# 
# #Avalon Beach
# #Avalon Catalina Airport weather station was used to pull data from 26jul2007 - 31aug2008
# #A[A ==""] <- NA
# #A[A == "NA"] <- NA
# a <- subset(A, is.na(A$HourlyDryBulbTemperature))
# a<- subset(a, a$REPORT_TYPE == "SOD")
# A <- subset(a[,-c(6:15, 42:124)])
# A <- A %>% drop_na(DATE)
# 
# A <- A %>% 
#   mutate_at(c(4:27), as.numeric)
# table(A$DATE)
# 
# A$Lag1_ppt <-     lag(A$DailyPrecipitation,    1)
# 
# 
# #Doheny Beach
# #Oceanside airport weather station was used to pull data from 28may2007  -14sep2008
# D[D ==""] <- NA
# D[D == "NA"] <- NA
# d <- subset(D, is.na(D$HourlyDryBulbTemperature))
# d<- subset(d, d$REPORT_TYPE == "SOD")
# D <- subset(d[,-c(6:15, 42:124)])
# D <- D %>% drop_na(DATE)
# 
# D <- D %>% 
#   mutate_at(c(4:27), as.numeric)
# 
# table(D$DATE)
# 
# D$Lag1_ppt <-     lag(D$DailyPrecipitation,    1)
# 
# #Mission Bay
# #San Francisco airport weather station was used to pull data from 31may2003 - 01sep2003
# #there is also a weather station in downtown SF but the data coverage is only 6%, SF airport was the closest station with 100% coverage
# Mi[Mi ==""] <- NA
# Mi[Mi == "NA"] <- NA
# mi <- subset(Mi, is.na(Mi$HourlyDryBulbTemperature))
# mi<- subset(mi, mi$REPORT_TYPE == "SOD")
# MI <- subset(mi[,-c(6:15, 42:124)])
# MI <- MI %>% drop_na(DATE)
# 
# MI <- MI %>% 
#   mutate_at(c(4:27), as.numeric)keep<-grep("SOD", Mi$REPORT_TYPE)
# 
# table(MI$DATE)
# 
# MI$Lag1_ppt <-     lag(MI$DailyPrecipitation,    1)
# 
# #Merge together beach datasets into one
# 
# all <- rbind(M, A, D, MI)
# 
# 
# saveRDS(all, file = "C:/Users/Administrator/OneDrive/Profile/Desktop/CAbeachesWeather.RDS") 
