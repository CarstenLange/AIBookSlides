library(tidymodels)
library(janitor)

DataMPG=mpg |>
        clean_names("upper_camel") |> 
        select(MPG=Hwy, Displ) |> 
        mutate(LnDispl=log(Displ))

ggplot(DataMPG, aes(x=Displ, y=MPG))+
      geom_point()+
      geom_smooth(method="lm")

ModelMPGOrg=lm(MPG~Displ,DataMPG)
summary(ModelMPGOrg)

############# 

ggplot(DataMPG, aes(x=LnDispl, y=MPG))+
  geom_point()

ggplot(DataMPG, aes(x=LnDispl, y=MPG))+
  geom_point()+
  geom_smooth(method="lm")

ModelMPGLn=lm(MPG~LnDispl,DataMPG)
summary(ModelMPGLn)
