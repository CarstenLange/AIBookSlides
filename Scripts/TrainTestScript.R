######## Script 100 #################
######################################


########## Load Data ################

library(tidymodels); library(rio); library(janitor)

DataHousing = import("https://ai.lange-analytics.com/data/HousingData.csv")%>%
  clean_names("upper_camel") %>%
  select(Price, Sqft=SqftLiving)

########## Generate DataTrain and Data Test #############################

set.seed(777)
Split001=DataHousing %>% 
  initial_split(prop = 0.001, strata = Price, breaks = 5) 
DataTrain=training(Split001)
DataTest=testing(Split001)

##########  OLS as Benchmark  ################## 

ModelDesignLinRegr=linear_reg() %>% 
  set_engine("lm") %>% 
  set_mode("regression")

RecipeHousesBenchmOLS=recipe(Price ~ Sqft, data=DataTrain)

##########  Recipe for Polynomial Regression  ##################
##########  Generating the Data  ##################


RecipeHousesPolynomOLS=recipe(Price ~ ., data=DataTrain) %>% 
  step_mutate(Sqft2=Sqft^2,Sqft3=Sqft^3,Sqft4=Sqft^4,Sqft5=Sqft^5)

######## Fitted Workflow OLS Benchmark #######
WFModelHousesBenchmOLS=workflow() %>% 
  add_model(ModelDesignLinRegr) %>% 
  add_recipe(RecipeHousesBenchmOLS) %>% 
  fit(DataTrain)

######## Fitted Workflow Polynomial (degree=5) #######

WFModelHousesPolynomOLS=workflow() %>% 
  add_model(ModelDesignLinRegr) %>% 
  add_recipe(RecipeHousesPolynomOLS) %>% 
  fit(DataTrain)

##### Comparing Training Results of Fitted Models #############

# Regular OLS:
tidy(WFModelHousesBenchmOLS)
glance(WFModelHousesBenchmOLS)

# Polynomial (degree=5):
tidy(WFModelHousesPolynomOLS)
glance(WFModelHousesPolynomOLS)

####### Comparing Performance on Testing Data #######


# Regular OLS:
DataTestWithPredBenchmOLS=augment(WFModelHousesBenchmOLS, DataTest)
metrics(DataTestWithPredBenchmOLS, truth = Price, estimate = .pred)


# Polynomial (degree=5):
DataTestWithPredPolynomOLS=augment(WFModelHousesPolynomOLS, DataTest)
metrics(DataTestWithPredPolynomOLS, truth = Price, estimate = .pred)

# Back to Presentation

######################################
######### Script 200 #################
######################################


# Step 1:  training and testing data

library(tidymodels); library(rio); library(janitor)

DataHousing =
  import("https://ai.lange-analytics.com/data/HousingData.csv")%>%
  clean_names("upper_camel") %>%
  select(Price, Sqft=SqftLiving)

set.seed(987)

Split80=DataHousing %>% 
  initial_split(prop = 0.8, strata = Price, breaks = 5) 
DataTrain=training(Split80)
DataTest=testing(Split80) 


# Step 2: Create Recipe. Mark hyper-parameter with tune()
RecipeHousesPolynomOLS=recipe(Price ~ ., data=DataTrain) %>% 
  step_poly(Sqft, degree = tune(), options = list(raw = TRUE))

# Step 3: Create model design

ModelDesignLinRegr=linear_reg() %>% 
  set_engine("lm") %>% 
  set_mode("regression")

# Step 4: Create Workflow
TuneWFModelHouses=workflow() %>% 
  add_model(ModelDesignLinRegr) %>% 
  add_recipe(RecipeHousesPolynomOLS)

# Step 5: 
ParGridHouses=tibble(degree=c(1:10))
print(ParGridHouses)

# Step 6:
set.seed(987)
FoldsHouses=vfold_cv(DataTrain, v=4, strata = Price)

# Step 7: Tuning the model !!!

TuneResultsHouses=tune_grid(TuneWFModelHouses,  resamples=FoldsHouses, 
                            grid=ParGridHouses, 
                            metrics = metric_set(rmse,rsq,mae))

# Step 8: Extract best hyper parameters

BestHyperPara=select_best(TuneResultsHouses, "rmse")
print(BestHyperPara)

# Step 9: Finalize workflow with best parameters and train it

BestWFModelHouses=TuneWFModelHouses %>% 
  finalize_workflow(BestHyperPara) %>% 
  fit(DataTrain)
print(BestWFModelHouses)

# Step 10 Predict and calculate metrics based on testing data:

DataTestWithPredBestModel=augment(BestWFModelHouses,DataTest)

metrics(DataTestWithPredBestModel, truth = Price, estimate = .pred)

