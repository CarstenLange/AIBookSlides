library(tidymodels); library(rio);library(janitor)
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

ModelDesignNN= mlp(hidden_units = tune(), dropout = tune(), epochs = 100) %>% 
  set_engine("brulee") %>%
  set_mode("regression")
print(ModelDesignNN)

WFModelNN=workflow() %>% 
  add_model(ModelDesignNN) %>% 
  add_recipe(RecipeDiamonds)
print(WFModelNN)



HiddenUnits=c(10, 20, 50)
DropOut=c(0, 0.25)
ParGridDiamonds=expand.grid(hidden_units=HiddenUnits,dropout=DropOut)
print(ParGridDiamonds)

set.seed(888)
FoldsDiamonds= DataTrain %>%
  vfold_cv(v = 7, strata = Price, breaks = 5)
print(FoldsDiamonds)

# The control argument "control = control_grid(verbose = TRUE)"
# enables reporting to the console. It has no other function.
# You can ommit it. Then it is just not as entertaining.
set.seed(888)
TuneResultsDiamonds=tune_grid(WFModelNN,  resamples=FoldsDiamonds, 
                              grid=ParGridDiamonds, 
                              metrics = metric_set(rsq,mae),
                              control = control_grid(verbose = TRUE)) 
print(TuneResultsDiamonds)

ontrol = control_grid(verbose = TRUE)

BestParNN=select_best(TuneResultsDiamonds,"mae")
print(BestParNN)

set.seed(888)
BestWFModelNN=finalize_workflow(WFModelNN,BestParNN) %>% 
  fit(DataTrain)
print(BestWFModelNN)

DataTestWithPred=augment(BestWFModelNN, new_data=DataTest)
metrics(DataTestWithPred, truth = Price, estimate = .pred)
