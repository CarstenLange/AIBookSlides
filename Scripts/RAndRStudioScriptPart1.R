############ script100 ##################
1+2 # Use Shift Enter to execute in console
A=1+2 #Use Shift Enter to execute in console
print(A) # prints content from A to the console
12*15 # is not assigned to anything. Output goes (prints) to the console
A # is not assigned to anything. Output goes (prints) to the console

### Exercise: Calculate the sum of A and VarTest and assign to R object ResultTest
### ResultTest=A+VarTest
VarTest=11 #Use Shift Enter to execute in console

ResultTest= ...
print(...)# ResultTest



### "<-" (assign) vs. "="
### Same result! "<-" mathematically correct, but "=" is shorter
A<-10
A<-A+20
print(A)

A=10
A=A+20
print(A)

############ script200 ##################

### numerical ###
A=2
B=3
str(A) # str() returns structure of a variable
str(B) # str() returns structure of a variable

A=as.integer(2)
B=as.integer(3)
str(A) # str() returns structure of a variable
str(B) # str() returns structure of a variable

C=1.823
str(C) # str() returns structure of a variable
print(C)
C=as.integer(C)
print(C)
str(C)

print(A*C)
A^B

### Character

MyText="Hello world!"
print(MyText)

MyText=Hello # Triggers Error

# Exercise: use your own first and last name
FirstName= ...
LastName= ...
cat(FirstName, LastName) # R adds a space automatically

### Logic

#Exercise: Change these values and see how results change.
ConcertIsGood=FALSE 
CompanyIsGood=TRUE

# Results (compare with truth table in the book)
EveningAmazing=ConcertIsGood & CompanyIsGood
cat("Is the evening amazing?", EveningAmazing)

EveningGood=ConcertIsGood | CompanyIsGood # | stands for "or"
cat("Is the evening good?", EveningGood)

############ script300 ##################

# Add a value for each of the single data types
# S1: numerical, S2: character, S3=Integer, S4=Logic
S1= ...
S2= ...
S3= ...
S4= ...

# Think about 3 of your friends and create the related vector objects

VecFirstNames= ...
VecAge= ...
VecIsBestFriend= ... #use logic vector

AvgFriendAge= ...
NumberOfBestFriends= ...

# Download the Titatic Dataset
library(rio)
library(tidyverse)
DataTitanic=import("https://ai.lange-analytics.com/data/Titanic.csv") %>% 
             mutate(Survived=as.logical(Survived))
str(DataTitanic)

# View the Titanic Dataset

#Extract the Passenger Age as a Vector

VecAge= ...
print(VecAge)

# Calculate the Average Passenger Age

MeanPassAge= ...

# How many survived

NumSurv= ...

# How many died?

NumDied= ...

# How many passengers total

NumPass= ...


############ script400 ##################

library(rio)
library(tidyverse)
DataTitanic=import("https://ai.lange-analytics.com/data/Titanic.csv") 

# Did older people pay a higher fare on the Titanic


ModelTitanicLM=lm(FareInPounds~Age, data = DataTitanic)
summary(ModelRegr)

# Doing the same with the tidymodelsway (don't worry will be introduced next chapter in detail)
library(tidymodels)
ModelTitanicTM = linear_reg() %>% 
                 set_engine("lm") %>% 
                 set_mode("regression") %>% # not needed because linear_reg cannot run classification
                 fit(FareInPounds~Age,DataTitanic)
tidy(ModelTitanicTM)
