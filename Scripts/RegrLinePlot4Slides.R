library(tidyverse)
library(rio)
DataMockup=import("https://ai.lange-analytics.com/data/DataStudyTimeMockup.rds") |> 
  mutate(PredGrade=Beta1*StudyTime+Beta2)
plot(ggplot(DataMockup, aes(x=StudyTime,y=Grade)) +
  geom_line(aes(y=PredGrade), color="red", linewidth=2.7)+
  geom_point(size=5, color="blue")+
  geom_point(aes(y=PredGrade), color="black", size=2.7)+
  geom_segment(aes(x = StudyTime, y = PredGrade,
                   xend = StudyTime, yend = Grade),linewidth=1.2)+
  scale_x_continuous("Study Time", breaks=seq(0,8))+
  scale_y_continuous(breaks=seq(0,150,5))+
  expand_limits(x=0,y=0))
  