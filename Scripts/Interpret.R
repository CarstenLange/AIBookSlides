library(tidymodels);library(rio);library(vip)
library(DALEXtra); library(kableExtra);library(plotly)
DataVaxFull=import("https://www.lange-analytics.com/AIBook/Data/DataVax.rds") %>% 
  mutate(RowNum=row.names(.))
# View DataVaxFull and find the rownumber for the observation you are interested in.
# E.g., the rownumber for Orange County, CA is 141
# enter it as below

RowNumber=141

DataVax= DataVaxFull%>%   
  select(PercVacFull, PercRep,
         PercAsian, PercBlack,PercHisp,
         PercYoung25, PercOld65, 
         PercFoodSt, Population) %>% 
  mutate(Population=frequency_weights(Population))
set.seed(2021)
Split85=DataVax %>% initial_split(prop = 0.85,
                                  strata = PercVacFull,
                                  breaks = 3)

DataTrain=training(Split85)
DataTest=testing(Split85)

NumberOfCores=parallel::detectCores() 
ModelDesignRandFor=rand_forest() %>% 
  set_engine("ranger", num.threads = NumberOfCores, importance="permutation") %>%   
  set_mode("regression")

RecipeVax=recipe(PercVacFull~., data=DataTrain)

set.seed(2021)
WfModelVax=workflow() %>% 
  add_model(ModelDesignRandFor)%>% 
  add_recipe(RecipeVax) %>% 
  add_case_weights(Population) %>% 
  fit(DataTrain)
vip(extract_fit_parsnip(WfModelVax)) # set importance="purity" in model design 
                                     #  for purity vip

DataTrainPredictorVar=DataTrain %>% 
  select(-PercVacFull,-Population)
ExplainerRandFor=explain_tidymodels(WfModelVax, 
                            data=DataTrainPredictorVar,y=DataTrain$PercVacFull,
                            type="regression", verbose = FALSE,
                            label = "Vaccination Shap Values Random Forest")

set.seed(2021)
StartTime=Sys.time()
ShapValues = predict_parts(
  explainer = ExplainerRandFor, 
  new_observation = DataVax[RowNumber,], 
  type = "shap",
  B = 200)
Sys.time()-StartTime

ShapPlot=plot(ShapValues)
plotly(ShapPlot)

