### loading the data ###

library(rio);library(janitor);library(tidymodels)

DataChurn=import("https://lange-analytics.com/AIBook/Data/TelcoChurnData.csv") %>%
  clean_names("upper_camel") %>%
  select(Churn,Gender,SeniorCitizen,Tenure,MonthlyCharges) %>%
  mutate(Churn=factor(Churn, levels=c("Yes","No"))) 
head(DataChurn)

# Check if data are complete:
DataIncompl=DataChurn %>% 
  filter(!complete.cases(DataChurn))
print(DataIncompl)
## You will fix the above problem later in the script

### Generate training and testing data
set.seed(789)
Split3070=initial_split(DataChurn, prop=0.7,strata =Churn)

DataTrain=training(Split3070)
DataTest=testing(Split3070)


### Create recipe:
### Use step_naomit() to delete incomplete data
### use step_dummy to turn Gender into dummy
### use all available predictor variables 
set.seed(789)
RecipeChurn=recipe(Churn ~ ., data=DataTrain) %>% 
  step_naomit() %>% 
  step_dummy(Gender)


### Create model design for logistic regression
### Use logistic_reg() from the "glm" package
ModelDesignLogisticRegr= logistic_reg() %>% 
  set_engine("glm") %>% 
  set_mode("classification")

### create a workflow by adding the model and the recipe and
### fit() the workflow to the data
### There are no hyper-parameters to tune.
### Substitute the ... below
WFModelChurn=workflow() %>% 
  add_recipe(RecipeChurn) %>% 
  add_model(ModelDesignLogisticRegr) %>% 
  fit(DataTrain)
print(WFModelChurn)


### Predict the testing data and then augment the predictions to 
### DataTest
DataTestWithPred=augment(WFModelChurn, new_data = DataTest)
view(DataTestWithPred)

### Substitute the ... below
### Look at the confusion matrix, the accuracy, sensitivity and specificity.
### What do you think about the results and why?
### Hint: calculate the column sums in the confusion matrix. What do they 
### tell you?
conf_mat(DataTestWithPred, truth = Churn, estimate = .pred_class)
accuracy(DataTestWithPred, truth = Churn, estimate = .pred_class)
sensitivity(DataTestWithPred, truth = Churn, estimate = .pred_class)
specificity(DataTestWithPred, truth = Churn, estimate = .pred_class)



