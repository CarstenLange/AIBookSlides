library(tidymodels);library(rio);library(vip);library(janitor)
library(DALEXtra); library(kableExtra);library(plotly)
set.seed(2021)
DataHousing =
  import("https://lange-analytics.com/AIBook/Data/HousingData.csv")%>%
  clean_names("upper_camel") %>%
  select(Price, Sqft=SqftLiving, Grade, Lot=SqftLot) %>% 
  sample_n(1000)

NewObservation=DataHousing[458,]#15382

set.seed(2021)
Split85=DataHousing %>% initial_split(prop = 0.85,
                                  strata = Price,
                                  breaks = 3)

DataTrain=training(Split85)
DataTest=testing(Split85)

NumberOfCores=parallel::detectCores() 
ModelDesignRandFor=rand_forest() %>% 
  set_engine("ranger", num.threads = NumberOfCores, importance="permutation") %>%   
  set_mode("regression")

RecipeHousing=recipe(Price~., data=DataTrain)

set.seed(2021)
WfModelHousing=workflow() %>% 
  add_model(ModelDesignRandFor)%>% 
  add_recipe(RecipeHousing) %>% 
  fit(DataTrain)
vip(extract_fit_parsnip(WfModelHousing)) # set importance="purity" in model design 
#  for purity vip

DataTrainPredictorVar=DataTrain %>% 
  select(-Price)
ExplainerRandFor=explain_tidymodels(WfModelHousing, 
                                    data=DataTrainPredictorVar,y=DataTrain$Price,
                                    type="regression", verbose = FALSE,
                                    label = "Housing Shap Values Random Forest")

set.seed(2021)
ShapValues = predict_parts(
  explainer = ExplainerRandFor, 
  new_observation = NewObservation, 
  type = "shap",
  B = 100)# tried 10000 gets theoretical values right on 1000,50,700shap

ShapPlot=plot(ShapValues)
ggplotly(ShapPlot)


AvgPrice=mean(DataTrain$Price)
PredPrice=predict(WfModelHousing, new_data = NewObservation)[[1,1]]

CoalSqft=DataTrain %>% 
  mutate(Sqft=NewObservation$Sqft) %>% 
  predict(WfModelHousing, new_data = .)
CoalSqft=mean(CoalSqft$.pred)

CoalGrade=DataTrain %>% 
  mutate(Grade=NewObservation$Grade) %>% 
  predict(WfModelHousing, new_data = .)
CoalGrade=mean(CoalGrade$.pred)

CoalLot=DataTrain %>% 
  mutate(Lot=NewObservation$Lot) %>% 
  predict(WfModelHousing, new_data = .)
CoalLot=mean(CoalLot$.pred)

CoalSqftGrade=DataTrain %>% 
  mutate(Grade=NewObservation$Grade, 
         Sqft=NewObservation$Sqft) %>% 
  predict(WfModelHousing, new_data = .)
CoalSqftGrade=mean(CoalSqftGrade$.pred)


CoalSqftLot=DataTrain %>% 
  mutate(Sqft=NewObservation$Sqft,  
         Lot=NewObservation$Lot) %>% 
  predict(WfModelHousing, new_data = .)
CoalSqftLot=mean(CoalSqftLot$.pred)

CoalGradeLot=DataTrain %>% 
  mutate(Grade=NewObservation$Grade, 
         Lot=NewObservation$Lot) %>% 
  predict(WfModelHousing, new_data = .)
CoalGradeLot=mean(CoalGradeLot$.pred)


ShapGrade=(CoalGrade - AvgPrice)*1/3+
          (CoalSqftGrade-CoalSqft)*1/6+
          (CoalGradeLot-CoalLot)*1/6+
          (PredPrice-CoalSqftLot)*1/3

ShapGrade

ShapSqft=(CoalSqft - AvgPrice)*1/3+
  (CoalSqftGrade-CoalGrade)*1/6+
  (CoalSqftLot-CoalLot)*1/6+
  (PredPrice-CoalGradeLot )*1/3

ShapSqft

ShapLot=(CoalLot - AvgPrice)*1/3+
  (CoalSqftLot-CoalSqft)*1/6+
  (CoalGradeLot-CoalGrade)*1/6+
  (PredPrice-CoalSqftGrade)*1/3

ShapLot

AvgPrice+ShapSqft+ShapGrade+ShapLot-PredPrice


########## ShapR #################
library(shapr)

ModelRanger=extract_fit_engine(WfModelHousing)

ExplainerShapR=shapr(DataTrainPredictorVar, ModelRanger)

Explanation <- explain(
  NewObservation,
  approach = "empirical",
  explainer = ExplainerShapR,
  prediction_zero = AvgPrice
)
ggplotly(plot(Explanation))
NewObservation
