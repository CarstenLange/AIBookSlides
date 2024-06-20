library(rio)
library(janitor)
library(tidymodels)
# Loading the Data and 
# select() variables Survived, Pclass, Sex, Age, FareInPounds
# use as.factor() to make Survived a factor variable
DataTitanic=import("https://lange-analytics.com/AIBook/Data/TitanicDataCl.csv") %>% 
   select(Survived, Pclass, Sex, Age, FareInPounds) %>% 
   mutate(Survived=as.factor(Survived))

# Splitting the data
set.seed(777)
Split70=initial_split(DataTitanic, prop = 0.7, strata = Survived)
DataTrain=training(Split70)
DataTest=testing(Split70)
head(DataTrain)

# Create a Recipe and use all predictor variables
# make variable Sex a dummy variable
RecipeTitanic=recipe(Survived~., data=DataTrain) %>% 
  step_dummy(Sex)

# Create a ModelDesign for nearest_neighbors() from package "kknn"
# Choose k=3 (neighbors=3) for now
ModelDesignKNN= nearest_neighbor(neighbors = 3) %>%
  set_engine("kknn") %>%
  set_mode("classification")

# Create a Workflow Model
# fit() the workflow model with the training data
set.seed(777)
WFModelTitanic=workflow() %>% 
  add_recipe(RecipeTitanic) %>% 
  add_model(ModelDesignKNN) %>% 
  fit(DataTrain)

# augment() DataTest with predictions
DataTestWithPred=augment(WFModelTitanic, new_data=DataTest)
head(DataTestWithPred)

# Print the confusion matrix 
conf_mat(DataTestWithPred, truth = Survived, estimate = .pred_class)

# Calculate accuracy(), sensitivity(), specificity(),  by hand and with R

accuracy(DataTestWithPred, truth = Survived, estimate = .pred_class)
sensitivity(DataTestWithPred, truth = Survived, estimate = .pred_class)
specificity(DataTestWithPred, truth = Survived, estimate = .pred_class)

###################################################
############# tune() for k, i.e. neighbors ########
###################################################

# Modify ModelDesign (hint: copy and paste from your code above)
# Don't forget to add tune()
# Don't forget to execute

ModelDesignKNN= nearest_neighbor(neighbors = tune()) %>%
  set_engine('kknn') %>%
  set_mode('classification')

# Modify WFModel (hint: copy and paste from your code above)
# Don't forget to delete fit()
# Don't forget to execute


WFModelTitanic=workflow() %>% 
  add_recipe(RecipeTitanic) %>% 
  add_model(ModelDesignKNN)

# Create tibble with the hyper-parameters you like to check (neighbor=c(1,2,3,5,7,10,20))
# Hyperparameter needs to be named neighbors 
ParGridTitanic=tibble(neighbors=c(1,2,3,5,7,10,20))
print(ParGridTitanic)

# Create 10 Folds and stratify for Survived
set.seed(777)
FoldsTitanic=vfold_cv(v=10, data = DataTrain, strata = Survived)
print(FoldsTitanic)

# tune_grid()
set.seed(777)
TuneResultsTitanic=tune_grid(WFModelTitanic, resamples = FoldsTitanic, grid = ParGridTitanic, 
                             metrics =metric_set(accuracy, specificity, sensitivity),
                      control = control_grid(verbose = TRUE))

# Not relevant for midterm or final
# plots are based on avg Validation from Folds not on DataTest
autoplot(TuneResultsTitanic)


# Select the best hyper-parmeter from tuning results
BestHyperParTitanic= select_best(TuneResultsTitanic, "accuracy")
print(BestHyperParTitanic)

# Use the best hyper-parameters to create the final (best) model workflow
# and fit() the training data
BestWFModelTitantic=finalize_workflow(WFModelTitanic, BestHyperParTitanic) %>% 
  fit(DataTrain)
print(BestWFModelTitantic)

# augment() DataTest with predictions
# Hint: copy and paste from code above
DataTestWithPred=augment(BestWFModelTitantic, new_data=DataTest)
head(DataTestWithPred)

# Print the confusion matrix 
# Hint: copy and paste from code above
conf_mat(DataTestWithPred, truth = Survived, estimate = .pred_class)


# Calculate accuracy(), sensitivity(), specificity()
# Hint: copy and paste from code above

accuracy(DataTestWithPred, truth = Survived, estimate = .pred_class)
sensitivity(DataTestWithPred, truth = Survived, estimate = .pred_class)
specificity(DataTestWithPred, truth = Survived, estimate = .pred_class)
