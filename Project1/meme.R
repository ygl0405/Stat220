library(magick)

# first row  
low_quality<- image_read("https://cdn11.bigcommerce.com/s-vlbdy8qi9u/images/stencil/800x800/products/1594/4912/poopie_HiRes__46085.1526327416.jpg?c=2") %>%
  image_blur(10,30) %>%
  image_scale("x500" ) %>%
  image_border("black", "10x10") 

quality144p_text<- image_blank(width = 500,
                               height = 500,
                               color = "#FFFFFF") %>%
  image_annotate(text= "144p",
                 color = "#000000",
                 size= 80,
                 font= "Impact",
                 gravity = "center") %>%
  image_border("black", "10x10")
# second row
mid_quality<- image_read("https://cdn11.bigcommerce.com/s-vlbdy8qi9u/images/stencil/800x800/products/1594/4912/poopie_HiRes__46085.1526327416.jpg?c=2") %>%
  image_scale("x500") %>%
  image_border("black", "10x10")

quality1080p_text<- image_blank(width= 500,
                               height = 500,
                               color = "#FFFFFF") %>%
  image_annotate(text= "1080p",
                 color="#000000",
                 size= 80,
                 font= "Impact",
                 gravity = "center") %>%
  image_border("black", "10x10")

# third row 
high_quality<- image_read("https://cdn11.bigcommerce.com/s-im4uxbqc/images/stencil/1280x1280/products/279/709/IMG_4824_1__38929.1487800696.jpg?c=2") %>%
  image_scale("x373") %>%
  image_border("black", "10x10")

quality4k_text <- image_blank(width = 500,
                              height = 500,
                              color = "#FFFFFF") %>%
  image_annotate(text= "4k",
                 color="#000000",
                 size= 80,
                 font= "Impact",
                 gravity = "center") %>%
  image_border("black", "10x10")

#extra frame
cat_thumb<- image_read("https://i.pinimg.com/736x/93/a1/27/93a127cbbd82c491bfd7cd36a2e81b5b.jpg") %>%
  image_scale("x700")


# putting it all together
first_row<- c(low_quality,quality144p_text) %>%
  image_append()

second_row <- c(mid_quality,quality1080p_text) %>%
  image_append()
third_row <- c(high_quality, quality4k_text) %>%
  image_append()


#Meme putting it all together
meme<-c(first_row, second_row, third_row) %>%
  image_append(stack = TRUE) %>%
  image_write("my_meme.jpg")

#animation putting it all together

frames <- c(low_quality, mid_quality, high_quality, cat_thumb)

animated_gif <- frames %>%
  image_animate(fps=1)

image_write(animated_gif, "my_animated_gif.gif")

