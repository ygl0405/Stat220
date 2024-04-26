library(tidyverse)
library(jsonlite)
json_data <- fromJSON("pixabay_data.json")
pixabay_photo_data <- json_data$hits

# function required to use
# filter (), mutate(), select ()
# mutate(), create 3 new varaibles, 2 categorical variable and 1 numeric variable

selected_photos_1 <- pixabay_photo_data %>%
  slice(c(1:55)) %>% #new data frame that contains around 50 photos
  select(previewURL, pageURL, views, downloads, likes) # use select() function that include preview URL and pageURL

selected_photos_2 <- pixabay_photo_data %>%
  filter(likes >50 & views >= median(views)) %>%
  select(previewURL, pageURL, views, downloads, likes, tags) %>%
  mutate(img_pop= ifelse(likes > 100, "P", "NP")) %>%
  mutate(view_count= ifelse(views > mean(views), "High", "Low")) %>%
  mutate(num_tags= str_count(tags, ", ")+1)

write_csv(selected_photos_2, "selected_photos.csv")

#Summary values 
selected_photos_2 %>%
  group_by(likes) %>%
  summarise(mean.likes)

mean.likes<- selected_photos_2$likes %>% mean(na.rm = TRUE)

median.views <- selected_photos_2$views %>% median(na.rm =TRUE)

pop_count <- selected_photos_2 %>%
  group_by(img_pop) %>%
  summarise(num_p= n())

HL_count <- selected_photos_2 %>%
  group_by(view_count) %>%
  summarise(num_HL=n())

downloads_by_category <- selected_photos_2 %>%
  group_by(tags) %>%
  summarise(Totaldownloads = sum(downloads)/10000) %>%
  arrange()

popularity_count <- selected_photos_2 %>%
  group_by(tags) %>%
  summarise(count=n())

highest_download <- max(photo_data$downloads)


tag_popularity <- selected_photos_2 %>%
  separate_rows(tags, sep = ", ") %>%
  mutate(tags = trimws(tags)) #split the individual words and create new column for each word in dataest

word_popularity <- tag_popularity %>%
  group_by(tags, img_pop) %>%
  summarise(count= n() > 5) #separte values for the count of popularity with higher than 5

img_urls <- selected_photos_2$previewURL %>% na.omit()

image_read(img_urls) %>%
  image_join() %>%
  image_scale(400) %>%
  image_animate(fps=1) %>%
  image_write("my_photos.gif")

#Creative R code


view_count_table <- table(photo_data$view_count)
pie(view_count_table, labels = paste(names(view_count_table), ": ", view_count_table), main = "Distribution of View count")

sorted <- photo_data%>%
  arrange(desc(views))

top3 <- sorted %>%
  group_by(img_pop) %>%
  slice(1:3)

observ_img <-ggplot(top3, aes(x= views, y= likes, color= img_pop)) +
  geom_point(size=3) +
  facet_wrap(~img_pop, ncol=1) +
  labs(title= "Top 3 observation by img popularity",
       x = "views",
       y= "likes",
       color = "Img popularity") +
  theme_minimal()
