
library(tidyverse)
library(rvest)

#My data context is weather data for specific city in New zealand

#Information from the webpages that might be useful to scrape:
# windspeed, forecast for the next few days, humidity
# Weather condition

#Wesites for web scrapping
#Metservice(https://www.metservice.com/national) 
#The policy states that the information from the site observational data is a open acess data
#No robots.txt disallows for web scrapping
#Weatherwatch("https://www.weatherwatch.co.nz/")
#No specific restriction about web scrapping and data colleciton from the stie
#No robots.txt disallows for web scrapping

url <- "https://www.weatherwatch.co.nz/forecasts/Auckland"

page <- read_html(url)

#Weather info
weather_info<- page %>%
  html_elements(".jsx-3024714417.details.grid-item.grid-width-2") %>%
  html_elements("span.jsx-3024714417.figure") %>%
  html_text2() 

#humidity
humidity<- weather_info[4]

#wind_speed
wind_speed<- weather_info[2]

#wearther_pressure
Pressure<- weather_info[5]

#Since all the weather information are int group as classfied in the same div class
#with same span so i had to specifty the number in the vector to assign the each value

#city temperature
city_temp <- page %>%
  html_element(".temp") %>%
  html_text2()

output<- paste("Humidity:", humidity, "\n",
               "Wind speed:", wind_speed, "\n",
               "Wind pressure:", Pressure, "\n",
               "City temperature", city_temp, "\n"
               )

cat(output)




