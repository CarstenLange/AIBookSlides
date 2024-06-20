library(tidyverse); library(rio);library(janitor)
DataWine=import("https://lange-analytics.com/AIBook/Data/WineData.rds") %>% 
  clean_names("upper_camel") %>% 
  select(WineColor,Sulfur=TotalSulfurDioxide,Acidity) %>% 
  mutate(WineColor=as.factor(WineColor))
View(DataWine)