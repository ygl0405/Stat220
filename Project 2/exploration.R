library(tidyverse)

csv_file <- "C:/Users/yungyu/Desktop/Stat 220/Project 2/💤 (Responses) - Form responses 1.csv"

sleep_data <- read_csv(csv_file) %>%
  rename(age=2,
         occupation=3,
         average_sleep_per_day=4,
         sleep_quality=5,
         bed_go_time=6,
         energy_level=7,
         caffine_consumption=8)

## 2 bar charts and 2 summary values

ggplot(data= sleep_data)+
  geom_bar(aes(x= caffine_consumption, fill = bed_go_time))+
  labs(title= "Caffinated",
       subtitle= "Comparing caffine consumption and time going to bed")


ggplot(data= sleep_data)+
  geom_bar(aes(y= average_sleep_per_day, fill = occupation))+
  labs(title= "Working to sleep",
       subtitle= "Relationship between occupation and sleep per day")

ggplot(data= sleep_data)+
  geom_bar(aes(x= sleep_quality, fill = occupation))+
  facet_wrap(~occupation)+
  ggtitle("Studying different occupation sleep satisfactory")
  


# 2 summary values

#average sleep quality
sum(sleep_data$sleep_quality)/ length(sleep_data$sleep_quality) %>% round(4)

#average consumption of caffinated beverage
sum(sleep_data$caffine_consumption)/ length(sleep_data$caffine_consumption) %>% round(1)

