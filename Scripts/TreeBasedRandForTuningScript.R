## Loading the R Packages and the Data 
library(tidymodels);library(rio)
# library(ranger) not needed but needs to be installed.

DataVax=import("https://lange-analytics.com/AIBook/Data/DataVax.rds") %>%   
  select(County, State, PercVacFull, PercRep,
         PercAsian, PercBlack, PercHisp,
         PercYoung25, PercOld65, PercFoodSt, Population) %>% 
         mutate(Population= frequency_weights(Population))


# Creating training and testing datasets
set.seed(2021)
Split85=DataVax %>% initial_split(prop = 0.85,
                                  strata = PercVacFull,
                                  breaks = 3)

DataTrain=training(Split85) %>% select(-County, -State)
DataTest=testing(Split85) %>% select(-County, -State)

# Creating ModelDesign and indicate hyper-parameters to tune
ModelDesignRandFor=rand_forest(trees = 1000, mtry = tune(), min_n = tune()) %>% 
  set_engine("ranger", ) %>% 
  set_mode("regression")

# Creating Recipe
RecipeVax=recipe(PercVacFull~., data=DataTrain)


# Adding ModelDesign and Recipe to workflow, but no fitting
WfModelVax=workflow() %>% 
  add_model(ModelDesignRandFor) %>% 
  add_recipe(RecipeVax) %>% 
  add_case_weights(Population)


# Define Folds
set.seed(2021)
FoldsVax= DataTrain %>%
  vfold_cv(v = 10, strata = PercVacFull, breaks = 5)

# Determine hyper-parameter combinations to evaluate

ParGridVax=expand.grid(mtry=c(2,3,5),min_n=c(3, 5, 10, 30))
print(ParGridVax)

# Tuning the workflow
set.seed(2021)
TuneResultsVax=tune_grid(WfModelVax, 
                              resamples=FoldsVax,
                              grid=ParGridVax, 
                              metrics = metric_set(rsq,mae),
                              control = control_grid(verbose = TRUE))

# Visualize tuning results
autoplot(TuneResultsVax)

# Pick best hyper-parameters (same as default was)
BestParVax=select_best(TuneResultsVax, metric="mae")
print(BestParVax)

# Add the best hyper-parameters (BestParVax) to the previously defined workflow 
# and fit() with training data
set.seed(2021)
BestWFModelVax=finalize_workflow(WfModelVax,BestParVax) %>% 
  fit(DataTrain)

# Assess prediction performance with testing data
DataTestWithPred=augment(BestWFModelVax, new_data=DataTest)
metrics(DataTestWithPred, truth = PercVacFull, estimate = .pred)
