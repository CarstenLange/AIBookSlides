library(rio);library(janitor);library(tidymodels)
DataHouses =
import("https://ai.lange-analytics.com/data/HousingData.csv") |>
clean_names("upper_camel") |>
select(Price, Sqft=SqftLiving, Grade, Waterfront)

VecBeta1=c()
VecBeta2=c()

set.seed(111)


for (i in 1:100) {
DataTrain=sample_n(DataHouses,100)

RecipeHouses=recipe(DataTrain, Price~Sqft) 


ModelDesignLinear=linear_reg() |> 
                     set_engine("lm") |> 
                     set_mode("regression")

WFModelHouses= workflow() |> 
               add_recipe(RecipeHouses) |> 
               add_model(ModelDesignLinear) |> 
               fit(DataTrain)

Results=tidy(WFModelHouses)


VecBeta1=append(VecBeta1,Results[[2,2]])
 } # end of loop

StErrorBeta1=sd(VecBeta1)
cat("Standart Error from 100 Bootstrap samples:", StErrorBeta1)

ModelLastSampleFromBS=extract_fit_engine(WFModelHouses)
#Results from last simulated Bootstrap model (i=100)
summary(ModelLastSampleFromBS)

 
         
ggplot(PlotData, aes(x=Sqft,y=Price))+
  geom_point(alpha=0.1)


library(sandwich)
library(lmtest)
coeftest(ModelLastSampleFromBS,vcov=vcovHC(ModelLastSampleFromBS, type="HC4"))



library(TeachHist) 
DataBeta1=tibble(VecBeta1=VecBeta1)
TeachHistCounts(PlotData = DataBeta1, BinWidth = 0.5)
TeachHistRelFreq(PlotData = DataBeta1, BinWidth = 0.5)
TeachHistDens(PlotData = DataBeta1)
