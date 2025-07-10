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


# Note, the package brulee needs to be installed before you run the 
# tune_grid() command. library(brulee) is not needed.
# Afterward, when you run tune_grid() th first time you get
# an error message that torch (for PYTorch) is not installed
# All you need to do is to confirm the installation of torch
# and be patient. It takes a while (less than 10 minutes). Do not interrupt,
# before torch is fully installed and you see the ppromp "<"

set.seed(888)
TuneResultsDiamonds=tune_grid(WFModelNN,  resamples=FoldsDiamonds, 
                              grid=ParGridDiamonds, 
                              metrics = metric_set(rsq,mae),
                              control = control_grid(verbose = TRUE)) 

# Above, the control argument "control = control_grid(verbose = TRUE)"
# enables reporting to the console. It has no other function.
# You can ommit it. Then it is just not as entertaining.

print(TuneResultsDiamonds)

BestParNN=select_best(TuneResultsDiamonds,metric="mae")
print(BestParNN)

set.seed(888)
BestWFModelNN=finalize_workflow(WFModelNN,BestParNN) %>% 
  fit(DataTrain)
print(BestWFModelNN)

DataTestWithPred=augment(BestWFModelNN, new_data=DataTest)
metrics(DataTestWithPred, truth = Price, estimate = .pred)
