library(rio)
library(tidyverse)

############ script100 ##################
VecMyData=c(0,9,10,11,NA,100)

? mean()

# Explain the following results
mean(VecMyData)
mean(na.rm=TRUE, x=VecMyData)
mean(VecMyData,1/5,TRUE)

############ script200 ##################

DataTitanic=import("https://ai.lange-analytics.com/data/Titanic.csv")
View(DataTitanic)



# select only variables for the name, the sex, and the age of passenger
DataNameSexAge=select(...)
View(DataNameSexAge)

# select all variables but without the passengers name
DataAllButName=select(...)
View(DataAllButName)

# select only variables for the name, the sex, and the age of passenger
# but rename the variable Name to FullName
DataNameSexAge=select(...)
View(DataNameSexAge)

# filter for passengers that survived
DataSurv=filter(...)
View(DataSurv)

# filter for passengers 21 or younger
DataYoung=filter(...)
View(DataYoung)

# filter for passengers older than 65
DataOld=filter(...)
View(DataOld)

# calculate (mutate) a new variable FamilyOnBoard (number of family on board)
DataFamily=mutate(...)
View(DataFamily)

# use as.logical() that transforms the existing variable Survived into a logic variable
DataSurvLogical=mutate(...)
View(DataSurvLogical)

############ script300 ##################

# Use Piping to create a data frame DataFemale from DataTitanic
# and select only variables Survived Sex, and Age
# filter for females and filter for passengers younger than 65
# use as.logical() and mutate Survived variable into logic type

DataFemale=DataTitanic %>% 
           ...
View(DataFemale)

# Use Piping to create a data frame DataFemale from DataTitanic
# and select only variables Survived Sex, and Age
# filter for females and filter for passengers younger than 65
# use as.logical() and mutate Survived variable into logic type

DataMale=DataTitanic %>% 
         ...
View(DataMale)

# Use the Survived variable to calculate the mean survival rate
# for male and female passengers
