library(magick)

intro <- "An exploration into my two old favourite walkthrough gaming youtube channel.Looking at how each channel's video uploding pattern reflect toward view count" %>%
  str_wrap(40)

#Introduction

radbrad<- image_read("https://pbs.twimg.com/profile_images/1292342941764263936/Es2p6I8x_400x400.jpg") %>%
  image_scale(200)

tetra<- image_read("https://yt3.googleusercontent.com/8IKNyWgh2PYtd1zECK1ik3JZeH_Soh8kmQTYHQfv_0Puf6YksKL6XebkIVugw_L9rS1zGeYm=s900-c-k-c0x00ffffff-no-rj") %>%
  image_scale(200)


channel_img<- image_append(c(radbrad, tetra)) %>%
  image_scale(600)
channel_img

word_box<- image_blank(color= "skyblue", width= 600, height = 400) %>%
  image_annotate(text= intro,
                 size= 20,
                 gravity= "center")

frame1<- image_append(c(channel_img,word_box)) %>%
  image_scale(1200)
frame1

#Average view count per year
paragraph1<- "Realationship between sesonal change and it's view count appear to show it's peak on winter" %>%
  str_wrap(40)

word2_box<- image_blank(color= "skyblue", width= 600, height = 400) %>%
  image_annotate(text= paragraph1,
                 size = 20,
                 gravity= "center")
plot2<- image_read("test3.png") %>%
  image_scale(600)

frame2<- image_append(c(plot2,word2_box)) %>%
  image_scale(1200)
frame2


#Seasonal view count

paragraph2<- "looking at video length in between each year, generally both channel tend to increase their video length as year goes by" %>%
  str_wrap(40)

word3_box<- image_blank(color= "skyblue", width= 600, height = 400) %>%
  image_annotate(text= paragraph2,
                 size = 20,
                 gravity= "center")
plot3<- image_read("test7.png") %>%
  image_scale(600)

frame3<- image_append(c(plot3,word3_box)) %>%
  image_scale(1200)
frame3


#Total duration of youtube over year 
paragraph3<- "Both channel had steady view count before 2020. After 2020 had both channel's peak of view count" %>%
  str_wrap(40)

word4_box<- image_blank(color= "skyblue", width= 600, height = 400) %>%
  image_annotate(text= paragraph3,
                 size = 20,
                 gravity= "center")
plot3<- image_read("test1.png") %>%
  image_scale(600)

frame4<- image_append(c(plot3,word4_box)) %>%
  image_scale(1200)
frame4


#Wraps up the story with conclusion
paragraph3<- "Overall, i learned that both channel gains most view in winter and given visualization, longer the video gets more view count it gains. Thus there exist relation betwen video uploading pattern and viewership " %>%
  str_wrap(40)

word4_box<- image_blank(color= "skyblue", width= 1200, height = 400) %>%
  image_annotate(text= paragraph3,
                 size = 20,
                 gravity= "center")

frame5<- word4_box

#Putting the frames in order
frames<- c(rep(frame1,5), rep(frame2,5), rep(frame3,5), rep(frame4,5), rep(frame5,5)) %>%
  image_animate(fps=1) %>%
  image_write("data_story.gif") 


