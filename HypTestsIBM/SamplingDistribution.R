library(rio);library(janitor);library(tidymodels)
library(rio)
library(janitor)
library(tidymodels)
DataSoldiersM=import("https://econ.lange-analytics.com/RData/Datasets/DataUSArmyBodyMeasures.xlsx", sheet="DataMale")|> 
              clean_names("upper_camel") |> 
              select(Height=Heightin, Weight=Weightlbs, Gender)



VecBeta1=c()

set.seed(1111)

RecipeWeightHeight=recipe(DataTrain, Weight~Height) 


ModelDesignLinear=linear_reg() |> 
                     set_engine("lm") |> 
                     set_mode("regression")

for (i in 1:1000) { #Be patient this takes a while
DataTrain=sample_n(DataSoldiersM,100)



WFModelWeightHeight= workflow() |> 
                     add_recipe(RecipeWeightHeight) |> 
                     add_model(ModelDesignLinear) |> 
                     fit(DataTrain)

Results=tidy(WFModelWeightHeight)



VecBeta1=append(VecBeta1,Results[[2,2]])
 }

# See the different values for beta1 estimated for the 1000 Bootstrap samples
# We show only the first 6:
head(VecBeta1)


# The Standard Error for beta1, based on 1000 different betas
print(sd(VecBeta1))

# The Standard  Error that R estimates based on only one(!) sample
# We use the last sample (i=1000), since the results is still stored in Results
print(Results)

# Go back to the slides to see how R estimates the StandardError for Beta1
# Based on only one sample


# Distribution of the Beta1 values from the 1000 Bootstrap samples
library(TeachHist) 
DataBeta1=tibble(VecBeta1=VecBeta1)
TeachHistDens(PlotData = DataBeta1, VLine1 = 0)

# The estimated normal distribution based on the 
# Standard Error and the Beta1 value (used as mean)
# from the sample i=1000 (the last one)

TeachHistDens(Mean =Results[[2,2]], Sd=Results[[2,3]], VLine1 = 0, 
  BinWidth=1, PrintRelFreq = TRUE, SeedValue = 123, NOfSimData=50000)

# ******* The same for a differen Example: Wage
library(wooldridge)

DataWage=wage1 |> 
         clean_names("upper_camel") |> 
         select(Wage, Tenure)

set.seed(777)

VecBeta1=c()
VecBeta2=c()

for (i in 1:1000) { #Be patient, it takes a while
DataTrain=sample_n(DataWage,30)

RecipeWage=recipe(DataTrain, Wage~.) 


WFModelWage= workflow() |> 
             add_recipe(RecipeWage) |> 
             add_model(ModelDesignLinear) |> 
             fit(DataTrain)

Results=tidy(WFModelWage)

#print(Results)

VecBeta1=append(VecBeta1,Results[[2,2]])
 }

print(sd(VecBeta1))


DataBeta1=tibble(VecBeta1=VecBeta1)


TeachHistDens(PlotData = DataBeta1, VLine1 = 0)

# One sample only (Results the last one)

print(Results)

TeachHistDens(Mean =Results[[2,2]], Sd=Results[[2,3]], VLine1 = 0, 
  BinWidth=0.5, PrintRelFreq = TRUE, NOfSimData=50000)


