library(kableExtra);library(tidymodels); library(rio); library(janitor)
DataYachts=import("https://ai.lange-analytics.com/data/DataYachts.csv")|> 
  mutate(YachtNum=Yacht, Yacht=as.factor(Yacht)) 
ModelDesignLogRegr=logistic_reg() |>
  set_engine("glm") |>
  set_mode("classification")

RecipeYachts=recipe(Yacht~Income, data = DataYachts)

set.seed(123)
WFYachts=workflow() |> 
  add_model(ModelDesignLogRegr) |> 
  add_recipe(RecipeYachts) |> 
  fit(DataYachts)

b1=tidy(WFYachts)[[2,2]]
b2=tidy(WFYachts)[[1,2]]

ModelDesignLinRegr=linear_reg() |>
  set_engine("lm") 

RecipeYachtsLin=recipe(YachtNum~Income, data = DataYachts)

WFYachtsLin=workflow() |> 
  add_model(ModelDesignLinRegr) |> 
  add_recipe(RecipeYachtsLin) |> 
  fit(DataYachts)

b1lin=tidy(WFYachtsLin)[[2,2]]
b2lin=tidy(WFYachtsLin)[[1,2]]

ggplot(aes(x=Income,y=YachtNum),data=DataYachts)+
geom_function(fun=function(x) 1/(1+exp(-b1*x-b2)), color="magenta", size=1.7)+
geom_function(fun=function(x) b1lin*x+b2lin, color="blue", size=1.7)+
geom_point(size=1.5, color=ifelse(DataYachts$Income==45,"red","cyan"))+
scale_x_continuous(limits = c(-50,500), breaks = seq(0,500,50))+ 
  scale_y_continuous(limits = c(0,1.2), breaks = seq(0,1.25,0.25))

