library(tidyverse)
library(rvest)

#minister selected: "Hon Shane Jones"
#Releases (1) "Report provides insights into marine recovery"
#Report consist usage of many quotation mark 
#frequent word used in "cyclones", "marine ecosystems"and "fishery managers".
#Report length is pretty consistent with few lines in each paragraph and have consistent format across the report
#Not much use of specific symbols in the report

#Releases (2) "Low gas production threatens energy security"
#Key terms such as "gas production" and "investment confidence" are repeated in the report
#Sentiment within the report are critical and urgent due to words used such as "terrible threat", "threat to economies"
#The length of each paragraph consistent throughout the report it has moderate length of lines
#minimal use of symbols and punctuation used in the report


url <- "https://www.beehive.govt.nz/minister/hon-shane-jones"

pages <- read_html(url) %>%
  html_elements(".release__wrapper") %>%
  html_elements("h2") %>%
  html_elements("a") %>%
  html_attr("href") %>%
  paste0("https://www.beehive.govt.nz", .)

page_url <- pages[1]

page <- read_html(page_url)

release_title <- page %>%
  html_elements("h1") %>%
  html_text2()

release_content <- page %>%
  html_elements(".prose") %>%
  html_text2() %>%
  str_replace_all("\n", " ")


tib_data <- tibble(release_title, release_content)

get_release <- function(page_url){
  Sys.sleep(2)
  print(page_url)
  page <- read_html(page_url)
  
  release_title <- page %>%
    html_elements("h1") %>%
    html_text2()
  
  release_content <- page %>%
    html_elements(".prose") %>%
    html_text2()
  
  
  tibble_data <- tibble(release_title, release_content)
  
}

release_data <- map_df(pages, get_release)

#average word length in the release_title/ word length in title 
mean_word_length_title <- mean(str_count(release_data$release_title, "\\w+")) %>%
  round(1)

#average word length in the release content
mean_word_length_content <- mean(str_count(release_data$release_content, "\\w+")) %>%
  round(1)

#most common word in release content
top_words_use_content <- release_data$release_content %>%
  str_split("\\s+") %>%
  unlist() %>%
  table() %>% #gives frequency as output
  sort(decreasing= TRUE) %>%
  names() %>% #corresponding value of each count
  head(10) # top 10 character vector
  
#Count of unique words in release content
unique_word_release_content <- release_data$release_content %>%
  str_split("\\w+") %>%
  unlist() %>%
  unique() %>%
  length()
  
