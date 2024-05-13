library(tidyverse)
library(stringr)
library(ggplot2)
youtube_data <- read.csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vTDMq3r1wrqP8y2-8-QbdacsrMReIT5jQR_VgE0zG3NlKRVw89GY_UtiOdA2O6plbREAvYNFKUpQgvT/pub?output=csv")

custom_palette <- c("#104176", "#5ebccf", "skyblue")


#Three different combination of ggplot/ combination of different variable
#Three different geom plot
#plots are informative(use of titles, labels , captions)
#Manipulate the data usnign mutate(), arrange(), slice(), str_detect(), str_count(), str_sub()
#One plot needs to use data frame created using group_by() and summarise()

#Geom_line of average view count in between each year/ geom_line

engagerate_data <- youtube_data %>%
  mutate(engage_rate = ifelse( viewCount > median(viewCount),
                               "high",
                               "low")) %>%
  mutate(year_released = datePublished %>% str_sub(1,4) %>% parse_number()) %>%
  count(engage_rate,year_released) 

engagerate_plot <- ggplot(data = engagerate_data) +
  geom_line(aes(x = year_released,
                y = n,
                colour = engage_rate)) +
  scale_colour_manual(values= custom_palette)+
  labs(x = "Year",
       y = "Count of variable",
       title = "High vs low view count per year") +
    theme_minimal() + 
    theme(panel.background = element_rect(fill = "white"),
          plot.background = element_rect(fill = "white"))+
  theme(plot.title = element_text(face = "bold", size = 14),
        axis.text = element_text(size = 10),
        axis.title = element_text(size = 12, face = "bold"),
        legend.position = "none")
    
engagerate_plot
ggsave("test1.png", engagerate_plot,width= 6, heigh= 4)

# title word track count

track_word_count <- youtube_data %>%
  select(title) %>%
  separate_rows(title, sep= " ") %>%
  mutate(clean_word= str_to_lower(title) %>%
           str_remove_all("[[:punct:]]")) %>%
  filter(!clean_word == "") %>%
  group_by(clean_word) %>%
  summarise(n= n()) %>%
  arrange(desc(n)) %>%
  slice(1:10) %>%
  ungroup()

word_track<-ggplot(data= track_word_count,
  aes(x= reorder(clean_word, -n),
             y= n)) +
  geom_col(fill = "blue") +
  geom_text(aes(label= clean_word),
            colour = "blue",
            size = 4,
            position = position_nudge(y= 6)) +
  geom_text(aes(label= n),
            position = position_nudge(y=-5),
            colour = "white",
            size = 5) +
  labs( x= "Word in title",
        y= "Appearance in title",
        title= "Count of word repition in title")+
  theme_minimal()

ggsave("test2.png", word_track)



#Geom jitter of the channels  and thier video legnths
idk <- ggplot( data= youtube_data,
               aes(x= duration/60,
                   y= channelName,
                   colour= channelName))+
  geom_jitter(height= 0.2) +
  geom_boxplot(fill= "transparent") +
  labs( x= "video lenght(min)",
        y= "Channel Name",
        title= "Comparison of video length between two channel") +
  guides(colour = "none") 

idk
  
ggsave("test4.png",idk)

#Mean duration of the video

mean_data_duration<- youtube_data$duration %>% mean(na.rm=TRUE)

test5<- ggplot()+
  geom_density(data= youtube_data,
               aes(x= duration)) +
  geom_vline(xintercept = mean_data_duration,
             colour= "#51087E",
             size=2)+
  lab( x= "length of the video",
       title = "Mean vlalue of the each chanles video length")

test5
ggsave("test5.png", test5, width= 6, heigh= 4)
#Seasonal video view count/ geom jitter

Season_data <- youtube_data %>%
  mutate(season_num= datePublished %>% str_sub(6,7)) %>%
  mutate(season_type = case_when(
    str_detect(season_num, "01|02|03") ~"spring",
    str_detect(season_num, "4|5|6") ~"summer",
    str_detect(season_num, "7|8|9") ~"authum",
    str_detect(season_num, "10|11|12") ~"winter",
    TRUE ~ "other"
  )) #if i changed the str_sub into a integer when using the str_detect function number between spring and winter overlap
#thus i had to not change the string into integer and instead used as string

mean_viewdata <- Season_data %>%
  group_by(season_type) %>%
  summarise(mean_view= mean(viewCount, na.rm=TRUE))

season_plot<- ggplot() +
  geom_jitter(data= Season_data,
              aes(x= viewCount, y= season_type),
              height =0.2)+
  geom_point(data = mean_viewdata,
             aes(x = mean_view, y= season_type),
             colour = "#104176",
             size = 5,
             shape = 17)+
  labs( x= "view counts",
        y= "season_type",
        title = "View count depending on the seasonal change")+
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 14),
        axis.text = element_text(size = 10),
        axis.title = element_text(size = 12, face = "bold"),
        legend.position = "none") +
  scale_color_manual(values = custom_palette)+
  theme(panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white"))

season_plot
ggsave("test3.png", season_plot,width= 6, heigh= 4)

# Comparison between duration over the course of the year

year_data <- youtube_data %>%
  mutate(year_num= datePublished %>% str_sub(1,4)) %>%
  group_by(year_num,channelName) %>%
  summarise(total_duration = sum(duration)) 



test7 <- ggplot(data = year_data,
                aes(x = total_duration,
                    y = reorder(year_num, -total_duration),
                    fill = channelName)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Total duration of YouTube videos over years",
       x = "Total duration (in seconds)",
       y = "Year",
       fill = "Channel Name") +
  scale_fill_manual(values = custom_palette) +
  facet_wrap(~channelName, scales = "free_y") +
  theme_minimal() +
  theme(panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white"))+
  theme(plot.title = element_text(face = "bold", size = 14),
        axis.text = element_text(size = 10),
        axis.title = element_text(size = 12, face = "bold"),
        legend.position = "none")
test7

ggsave("test7.png",test7, width=6, height=4)

