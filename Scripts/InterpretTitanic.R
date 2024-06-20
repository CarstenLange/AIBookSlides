library(tidymodels);library(rio);library(vip);library(janitor)
library(DALEXtra); library(kableExtra);library(plotly)
DataTitanic=import("https://lange-analytics.com/AIBook/Data/TitanicDataCl.csv") %>% 
  select(Survived, Sex, Age, Class=Pclass) %>% 
  mutate(Survived=as.factor(Survived))

NewObservation=DataTitanic[123,]#15382

set.seed(2021)
Split85=DataTitanic %>% initial_split(prop = 0.85,
                                  strata = Survived,
                                  breaks = 3)

DataTrain=training(Split85)
DataTest=testing(Split85)

NumberOfCores=parallel::detectCores() 
ModelDesignRandFor=rand_forest() %>% 
  set_engine("ranger", num.threads = NumberOfCores, importance="permutation") %>%   
  set_mode("classification")

RecipeHousing=recipe(Survived~., data=DataTrain)

set.seed(2021)
WfModelHousing=workflow() %>% 
  add_model(ModelDesignRandFor)%>% 
  add_recipe(RecipeHousing) %>% 
  fit(DataTrain)
vip(extract_fit_parsnip(WfModelHousing)) # set importance="purity" in model design 
#  for purity vip

DataTrainPredictorVar=DataTrain %>% 
  select(-Survived)
ExplainerRandFor=explain_tidymodels(WfModelHousing, 
                                    data=DataTrainPredictorVar,y=DataTrain$Survived,
                                    type="classification", verbose = FALSE,
                                    label = "Titanic Shap Values Random Forest")

set.seed(2021)
ShapValues = predict_parts(
  explainer = ExplainerRandFor, 
  new_observation = NewObservation, 
  type = "shap",
  B = 66)

ShapPlot=plot(ShapValues)
ggplotly(ShapPlot)


AvgSurvived=mean(DataTrain$Survived)
PredSurvived=predict(WfModelHousing, new_data = NewObservation)[[1,1]]

CoalSex=DataTrain %>% 
  mutate(Sex=NewObservation$Sex) %>% 
  predict(WfModelHousing, new_data = .)
CoalSex=mean(CoalSex$.pred)

CoalAge=DataTrain %>% 
  mutate(Age=NewObservation$Age) %>% 
  predict(WfModelHousing, new_data = .)
CoalAge=mean(CoalAge$.pred)

CoalClass=DataTrain %>% 
  mutate(Class=NewObservation$Class) %>% 
  predict(WfModelHousing, new_data = .)
CoalClass=mean(CoalClass$.pred)

CoalSexAge=DataTrain %>% 
  mutate(Age=NewObservation$Age, 
         Sex=NewObservation$Sex) %>% 
  predict(WfModelHousing, new_data = .)
CoalSexAge=mean(CoalSexAge$.pred)


CoalSexClass=DataTrain %>% 
  mutate(Sex=NewObservation$Sex,  
         Class=NewObservation$Class) %>% 
  predict(WfModelHousing, new_data = .)
CoalSexClass=mean(CoalSexClass$.pred)

CoalAgeClass=DataTrain %>% 
  mutate(Age=NewObservation$Age, 
         Class=NewObservation$Class) %>% 
  predict(WfModelHousing, new_data = .)
CoalAgeClass=mean(CoalAgeClass$.pred)


ShapAge=(CoalAge - AvgSurvived)*1/3+
          (CoalSexAge-CoalSex)*1/6+
          (CoalAgeClass-CoalClass)*1/6+
          (PredSurvived-CoalSexClass)*1/3

ShapAge
