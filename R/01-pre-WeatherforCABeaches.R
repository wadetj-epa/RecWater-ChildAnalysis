#data file created used by Stata program 01-formatweather.do

#Can you try to find information on  daily precipitation (total), and air temperature (preferably, temperature at like 1:00PM, but also average daily, high and low) for the following places and dates:
# 
#Avalon Beach, CA (Catalina Island): 26jul2007 - 31aug2008
#Doheny Beach, CA: 28may2007  -14sep2008
#Malibu Beach, CA: 23may2009 - 20sep2009
#Mission Bay, CA: 31may2003 - 01sep2003


# went to the following website: https://www.ncdc.noaa.gov/data-access
#clicked on Land Based Station -> Datasets and Products -> Local Climatological Data (LCD)
#Once on the data selection platform, highlight state then chose California
# Then add to cart the weather stations for each of the beaches - based on closest proximity and most complete data
#then when placing the order select Daily averages - deselect hourly averages, then select as CSV, choose dates needed and then hit submit


#Merge together Beach weather data for Tim
library(data.table)
library(dplyr)
library(tidyr)

M <- fread("C:/Users/Administrator/OneDrive/Profile/Desktop/2615069.csv")
A <- fread("C:/Users/Administrator/OneDrive/Profile/Desktop/2615073.csv")
D <- fread("C:/Users/Administrator/OneDrive/Profile/Desktop/2615067.csv")
Mi <- fread("C:/Users/Administrator/OneDrive/Profile/Desktop/2615843.csv")

#Malibu Beach
#LA Airport land weather station was used to pull the data from 23may2009 - 20sep2009
M[M ==""] <- NA
M[M == "NA"] <- NA
m <- subset(M, is.na(M$HourlyDryBulbTemperature))
M <- subset(m[,-c(6:15, 42:124)])
M <- M %>% drop_na(DATE)

M <- M %>% 
  mutate_at(c(4:27), as.numeric)


#Avalon Beach
#Avalon Catalina Airport weather station was used to pull data from 26jul2007 - 31aug2008
A[A ==""] <- NA
A[A == "NA"] <- NA
a <- subset(A, is.na(A$HourlyDryBulbTemperature))
A <- subset(a[,-c(6:15, 42:124)])
A <- A %>% drop_na(DATE)

A <- A %>% 
  mutate_at(c(4:27), as.numeric)

#Doheny Beach
#Oceanside airport weather station was used to pull data from 28may2007  -14sep2008
D[D ==""] <- NA
D[D == "NA"] <- NA
d <- subset(D, is.na(D$HourlyDryBulbTemperature))
D <- subset(d[,-c(6:15, 42:124)])
D <- D %>% drop_na(DATE)

D <- D %>% 
  mutate_at(c(4:27), as.numeric)

#Mission Bay
#San Francisco airport weather station was used to pull data from 31may2003 - 01sep2003
#there is also a weather station in downtown SF but the data coverage is only 6%, SF airport was the closest station with 100% coverage
Mi[Mi ==""] <- NA
Mi[Mi == "NA"] <- NA
mi <- subset(Mi, is.na(Mi$HourlyDryBulbTemperature))
MI <- subset(mi[,-c(6:15, 42:124)])
MI <- MI %>% drop_na(DATE)

MI <- MI %>% 
  mutate_at(c(4:27), as.numeric)

#Merge together beach datasets into one

all <- rbind(M, A, D, MI)


saveRDS(all, file = "C:/Users/Administrator/OneDrive/Profile/Desktop/CAbeachesWeather.RDS") 
