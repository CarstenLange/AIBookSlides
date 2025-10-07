library(rio)
library(janitor)
library(tidymodels)
library(TeachHist)
DataSoldiersM=import("https://econ.lange-analytics.com/RData/Datasets/DataUSArmyBodyMeasures.xlsx", sheet="DataMale")|> 
  clean_names("upper_camel") |> 
  select(Height=Heightin, Weight=Weightlbs, Gender)
DataSoldiersF=import("https://econ.lange-analytics.com/RData/Datasets/DataUSArmyBodyMeasures.xlsx", sheet="DataFemale")|> 
  clean_names("upper_camel") |> 
  select(Height=Heightin, Weight=Weightlbs, Gender)

DataSoldiers=merge(DataSoldiersF, DataSoldiersM, all=TRUE)
print(DataSoldiersF)
print(DataSoldiersM)
print(DataSoldiers)

## Plot Height Male and Female Point Plot 

ggplot(DataSoldiers, aes(x=Gender, y=Height, color=Gender))+
  geom_point()

## Plot Height Male and Female Jitter Plot


ggplot(DataSoldiers, aes(x=Gender, y=Height, color=Gender))+
  geom_jitter()

## Plot Height Male and Female Jitter Plot alpha=0.1)

ggplot(DataSoldiers, aes(x=Gender, y=Height, color=Gender))+
  geom_jitter(alpha=0.2)



## Height Regression

RecipeHeightGender=recipe(DataSoldiers, Height~Gender) |> 
                   step_dummy(Gender)

ModelDesignLinear=linear_reg() |> 
                  set_engine("lm") |> 
                  set_mode("regression")

WFModelStudyTime= workflow() |> 
                  add_recipe(RecipeHeightGender) |> 
                  add_model(ModelDesignLinear) |> 
                  fit(DataSoldiers)
tidy(WFModelStudyTime)


## Mean Heights


MeanHeightF=mean(DataSoldiersF$Height)
MeanHeightM=mean(DataSoldiersM$Height)
cat("Mean Height Female:",MeanHeightF)
cat("Mean Height Male:",MeanHeightM)


## Plotting the Means


ggplot()+
  geom_vline(xintercept=MeanHeightF, color="red", size=2)+
  geom_vline(xintercept=MeanHeightM, color="blue", size=2)



## Including the Data


ggplot(DataSoldiersF, aes(x=Height, y=c(1:1986)))+
  geom_point(color="red")+
  geom_point(data=DataSoldiersM, mapping=aes(x=Height, y=c(1:4082)),color="blue")+
  geom_vline(xintercept=MeanHeightF, color="red", size=2)+
  geom_vline(xintercept=MeanHeightM, color="blue", size=2)


# We need a way to measure the Spread and find a way to show the distribution.

## Female Height Spread


ggplot(DataSoldiersF, aes(x=Height, y=c(1:1986)))+
  geom_point(color="red")+
  geom_vline(xintercept=MeanHeightF, size=2)


## Male Height Spread


ggplot(DataSoldiersM, aes(x=Height, y=c(1:4082)))+
  geom_point(color="blue")+
  geom_vline(xintercept=MeanHeightM, size=2)+
  geom_vline(xintercept=MeanHeightF, size=2, color="red")

## Measuring Female Height Spread for a small sample


ggplot(DataSoldiersF[2:4,], aes(x=Height, y=c(1:3)))+
  geom_vline(xintercept=mean(DataSoldiersF[2:4,]$Height), size=2)+
  geom_point(color="red", size=3)

## How much do the variables spread

## Female: Showing a Frequency Plot

library(TeachHist)
mean(DataSoldiersF$Height)
sd(DataSoldiersF$Height)

TeachHistRelFreq(PlotData = DataSoldiersF["Height"])

## Showing a Density Plot (calculate area under the curve)

library(TeachHist)
TeachHistDens(PlotData = DataSoldiersF["Height"], PlotNormCurv = FALSE)

## Showing a Density Plot with Normal Curve

library(TeachHist)
mean(DataSoldiersF$Height)
sd(DataSoldiersF$Height)
TeachHistDens(PlotData = DataSoldiersF["Height"])

## Two curves


# Function to generate normal density
normal_density <- function(x, mean, sd) {
  return (dnorm(x, mean = mean, sd = sd))
}

# Create a data frame with x values
x_values <- seq(50, 100, by = 0.1)
data <- data.frame(x = x_values)

# Plotting two normal curves
ggplot(data, aes(x = x)) +
  stat_function(fun = normal_density, args = list(mean = mean(DataSoldiersM$Height), sd=sd(DataSoldiersM$Height)), color = "blue", linetype = "dashed") +
  stat_function(fun = normal_density, args = list(mean = mean(DataSoldiersF$Height), sd=sd(DataSoldiersF$Height)), color = "red", linetype = "dashed") +
  labs(title = "Two Normal Curves",
       x = "X-axis",
       y = "Density") 

