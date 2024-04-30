## installing and loading packages
install.packages("tidyverse")
library(tidyverse)
install.packages("ggplot2")
library(ggplot2)
install.packages("lubridate")
library(lubridate)
install.packages("janitor")
library(janitor)
install.packages("dplyr")
library(dplyr)

##importing files
activity1 <- read_csv("dailyActivity_merged_3.12.16-4.11.16.csv")
weight1 <- read_csv("weightLogInfo_merged_3.12.16-4.11.16.csv")
activity2 <- read_csv("dailyActivity_merged_4.12.16-5.12.16.csv")
sleep <- read_csv("sleepDay_merged_4.12.16-5.12.16.csv")
weight2 <- read_csv("weightLogInfo_merged_4.12.16-5.12.16.csv")

##merging files
compare_df_cols_same(activity1, activity2)
compare_df_cols_same(weight1, weight2)
activity <- merge(activity1, activity2, all = TRUE)
weight <- merge(weight1, weight2, all = TRUE)
activity_sleep <- merge(x = activity, y = sleep, by.x = c("Id", "ActivityDate"), by.y = c("Id", "SleepDay"))
activity_weight <- merge(x = activity, y = weight, by.x = c("Id", "ActivityDate"), by.y = c("Id", "Date"))
average <- activity_sleep %>% group_by(Id) %>% 
  summarise (avgSteps = mean(TotalSteps), avgDistance = mean(TotalDistance), avgCalories = mean(Calories), avgSedentary = mean(SedentaryMinutes), avgSleep = mean(TotalMinutesAsleep))

##summarizing data
length(unique(activity$Id))
length(unique(sleep$Id))
length(unique(activity_sleep$Id))
length(unique(average$Id))

activity %>% select(TotalSteps, TotalDistance, Calories, SedentaryMinutes) %>% summary()
sleep %>% select(TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed) %>% summary()


##formatting data

sleep$SleepDay <- as.POSIXct(sleep$SleepDay,format='%m/%d/%y')
sleep$SleepDay <- format(sleep$SleepDay, format="%m/%d/%Y")

activity$ActivityDate <-as.POSIXct(activity$ActivityDate,format='%m/%d/%y')
activity$ActivityDate <- format(activity$ActivityDate, format="%m/%d/%Y")

activity_sleep = subset(activity_sleep, select = -c(SedentaryActiveDistance))

##exporting data
write.csv(acvitity, "activity")
write.csv(activity_sleep, "activity_sleep")
write.csv(average, "average")

##plotting data
ggplot(data=activity, aes(x = TotalSteps, y = Calories)) + geom_point() + geom_smooth()
ggplot(data = activity_sleep, aes(x =TotalMinutesAsleep, y =Calories)) + geom_point() + geom_smooth()
ggplot(data = average, aes(x = avgSleep, y = avgSteps)) + geom_point() + geom_smooth()
ggplot(data = average, aes(x = avgSedentary, y = avgSleep)) + geom_point() + geom_smooth()


