#import necessary libraries
library(tidyverse)
library(lubridate)
library(skimr)
library(janitor)
library(dplyr)

#importing data from Kaggle
April20_rides <- read_csv("202004-divvy-tripdata.csv")
May20_rides <- read_csv("202005-divvy-tripdata.csv")
June20_rides <- read_csv("202006-divvy-tripdata.csv")
July20_rides <- read_csv("202007-divvy-tripdata.csv")
August20_rides <- read_csv("202008-divvy-tripdata.csv")
September20_rides <- read_csv("202009-divvy-tripdata.csv")
October20_rides <- read_csv("202010-divvy-tripdata.csv")
November20_rides <- read_csv("202011-divvy-tripdata.csv")
December20_rides <- read_csv("202012-divvy-tripdata.csv")

#comparing column names to ensure all data is saved with the same names
colnames(April20_rides)
colnames(May20_rides)
colnames(June20_rides)
colnames(July20_rides)
colnames(August20_rides)
colnames(September20_rides)
colnames(October20_rides)
colnames(November20_rides)
colnames(December20_rides)

#looking at structure of the data and finding discrepancies with formatting
str(April20_rides)
str(May20_rides)
str(June20_rides)
str(July20_rides)
str(August20_rides)
str(September20_rides)
str(October20_rides)
str(November20_rides)
str(December20_rides)

compare_df_cols(April20_rides,May20_rides,June20_rides,July20_rides,August20_rides,September20_rides,October20_rides,
                November20_rides,December20_rides,return = "mismatch")

#cleaning data by changing all formatting to the same for stacking
April20_rides <- mutate(April20_rides, end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))
May20_rides <- mutate(May20_rides, end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))
June20_rides <- mutate(June20_rides, end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))
July20_rides <- mutate(July20_rides, end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))
August20_rides <- mutate(August20_rides, end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))
September20_rides <- mutate(September20_rides, end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))
October20_rides <- mutate(October20_rides, end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))
November20_rides <- mutate(November20_rides, end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))
December20_rides <- mutate(December20_rides, end_station_id = as.character(end_station_id),start_station_id = as.character(start_station_id))

compare_df_cols(April20_rides,May20_rides,June20_rides,July20_rides,August20_rides,September20_rides,October20_rides,
                November20_rides,December20_rides,return = "mismatch")


#stacking data into one data set
alltrips <- bind_rows(April20_rides,May20_rides,June20_rides,July20_rides,August20_rides,September20_rides,October20_rides,
                      November20_rides,December20_rides)

#cleaning data to necessary information and inspecting new data set
alltrips <- alltrips %>% 
  select(-c(start_lat,start_lng,end_lat,end_lng))

colnames(alltrips)

head(alltrips)

str(alltrips)

summary(alltrips)

skim(alltrips)

#adding columns for individual month, date, year and day of week
alltrips$date <- as.Date(alltrips$started_at)
alltrips$month <- format(as.Date(alltrips$date),'%m')
alltrips$day <- format(as.Date(alltrips$date),'%d')
alltrips$year <- format(as.Date(alltrips$date),'%y')
alltrips$day_of_week <- format(as.Date(alltrips$date),'%A')

#converting ride_length from factor to numeric
alltrips$ride_length <- difftime(alltrips$ended_at,alltrips$started_at)
is.factor(alltrips$ride_length)
alltrips$ride_length <- as.numeric(as.character(alltrips$ride_length))
is.factor(alltrips$ride_length)
is.numeric(alltrips$ride_length)

skim(alltrips$ride_length)

#remove data that are negative integers
alltrips2 <- alltrips[!(alltrips$ride_length<0),]
skim(alltrips2)
summary(alltrips2$ride_length)

#export to csv
write.csv(alltrips2,"cycledata.csv")

