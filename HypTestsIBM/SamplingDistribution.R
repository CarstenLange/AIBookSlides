library(rio);library(janitor);library(tidymodels)
DataHousing =
import("https://ai.lange-analytics.com/data/HousingData.csv") |>
clean_names("upper_camel") |>
select(Price, Sqft=SqftLiving, Grade, Waterfront)

Beta1=c()
Beta2=c()

set.seed(111)


for (i in 1:10000) {
DataTrain=sample_n(DataHousing,30)

RecipeHouses=recipe(DataTrain, Price~Sqft) 


ModelDesignLinear=linear_reg() |> 
                     set_engine("lm") |> 
                     set_mode("regression")

WFModelHouses= workflow() |> 
               add_recipe(RecipeHouses) |> 
               add_model(ModelDesignLinear) |> 
               fit(DataTrain)

Results=tidy(WFModelHouses)
# print(Results)


Beta1=append(Beta1,Results[[2,2]])
 }

library(TeachHist) 
DataBeta1=tibble(beta1=Beta1)
TeachHistRelFreq(PlotData = DataBeta1, BinWidth = 0.5)
TeachHistDens(PlotData = DataBeta1)

# ************ Wage Example ***********
  
Beta1=c()
Beta2=c()

set.seed(111)
library(wooldridge)
DataWage=wage1 |> 
         clean_names("upper_camel") |>
         select(Wage, Exper, Educ, Tenure)


for (i in 1:200) {
DataTrain=sample_n(DataWage,42)

RecipeWage=recipe(DataTrain, Wage~Tenure) 




WFModelWage= workflow() |> 
               add_recipe(RecipeWage) |> 
               add_model(ModelDesignLinear) |> 
               fit(DataTrain)

Results=tidy(WFModelWage)
# print(Results)


Beta1=append(Beta1,Results[[2,2]])
 }

DataBeta1=tibble(beta1=Beta1)
TeachHistRelFreq(PlotData = DataBeta1, BinWidth = 0.5)
TeachHistDens(PlotData = DataBeta1)

# ******* Only one sample

set.seed(7788)
DataTrain=sample_n(DataWage,30)

RecipeWage=recipe(DataTrain, Wage~Tenure) 




WFModelWage= workflow() |> 
             add_recipe(RecipeWage) |> 
             add_model(ModelDesignLinear) |> 
             fit(DataTrain)

ResultsOnlySample=tidy(WFModelWage)

print(ResultsOnlySample)

MeanBeta1=ResultsOnlySample[[2,2]]
SDEBeta1=ResultsOnlySample[[2,3]]

TeachHistDens(Mean =MeanBeta1, Sd=SDEBeta1, VLine1 = 0 )
