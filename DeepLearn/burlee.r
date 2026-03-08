library(tidymodels); library(rio);library(janitor)
library(brulee)
set.seed(888)
DataDiamonds=diamonds%>% 
  sample_n(1000) %>%
  clean_names("upper_camel") %>%
  select(Price,Cut,Color,Clarity,Carat) %>% 
  mutate(Cut=as.integer(Cut),Color=as.integer(Color),
         Clarity=as.integer(Clarity))

set.seed(888)
Split70=DataDiamonds %>%
  initial_split(prop = 0.7, strata = Price, breaks = 5)
DataTrain=training(Split70)
DataTest=testing(Split70)
head(DataTrain)

RecipeDiamonds=recipe(Price ~ ., data = DataTrain) %>%
  step_normalize(all_predictors())
print(RecipeDiamonds)

ModelDesignNN= mlp(hidden_units = 10, dropout = 0.2, epochs = 100) %>% 
  set_engine("brulee") %>%
  set_mode("regression")
print(ModelDesignNN)

WFModelNN=workflow() %>% 
  add_model(ModelDesignNN) %>% 
  add_recipe(RecipeDiamonds) %>%
  fit(DataTrain)

print(WFModelNN)




DataTestWithPred=augment(WFModelNN, new_data=DataTest)
metrics(DataTestWithPred, truth = Price, estimate = .pred)
