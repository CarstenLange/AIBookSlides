library(rio);library(janitor);library(tidymodels)
DataHousing =
import("https://ai.lange-analytics.com/data/HousingData.csv") |>
clean_names("upper_camel") |>
select(Price, Sqft=SqftLiving, Grade, Waterfront)

Beta1=c()
Beta2=c()

set.seed(777)


# for (i in 1:10000) {
DataTrain=sample_n(DataHousing,100)

RecipeHouses=recipe(DataTrain, Price~Sqft+Grade) 


ModelDesignHouses=linear_reg() |> 
                     set_engine("lm") |> 
                     set_mode("regression")

WFModelHouses= workflow() |> 
               add_recipe(RecipeHouses) |> 
               add_model(ModelDesignHouses) |> 
               fit(DataTrain)

Results=tidy(WFModelHouses)
print(Results)

Beta1=append(Beta1,Results[[2,2]])
Beta2=append(Beta2,Results[[2,3]])
#}
library(TeachHist) 
DataBeta1=tibble(beta1=Beta1)
TeachHistRelFreq(PlotData = DataBeta1, BinWidth = 0.5)

DataBeta2=tibble(beta2=Beta2)
TeachHistRelFreq(PlotData = DataBeta2, BinWidth = 0.5)

