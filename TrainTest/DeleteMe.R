## Polynomial Regression (degree=5) vs. Regular OLS

### Aproximation of the Training Data

```{r}
ModelDesignLinRegr=linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression")

RecipeHousesBenchmOLS=recipe(Price ~ Sqft, data=DataTrain)

RecipeHousesPolynomOLS=recipe(Price ~ ., data=DataTrain) |> 
  step_mutate(Sqft2=Sqft^2,Sqft3=Sqft^3,Sqft4=Sqft^4,Sqft5=Sqft^5)

######## Fitted Workflows
WFModelHousesBenchmOLS=workflow() |> 
  add_model(ModelDesignLinRegr) |> 
  add_recipe(RecipeHousesBenchmOLS) |> 
  fit(DataTrain)

WFModelHousesPolynomOLS=workflow() |> 
  add_model(ModelDesignLinRegr) |> 
  add_recipe(RecipeHousesPolynomOLS) |> 
  fit(DataTrain)

####### Generating Predictions #######

DataTrainWithPredBenchmOLS=augment(WFModelHousesBenchmOLS, DataTrain)
DataTrainWithPredPolynomOLS=augment(WFModelHousesPolynomOLS, DataTrain)

DataTestWithPredBenchmOLS=augment(WFModelHousesBenchmOLS, DataTest)
DataTestWithPredPolynomOLS=augment(WFModelHousesPolynomOLS, DataTest)

########## Polynomial degree 10

RecipeHousesPolynom10OLS=recipe(Price ~ ., data=DataTrain) |> 
  step_poly(Sqft, degree = 10, options = list(raw = TRUE))
  
  
WFModelHousesPolynom10OLS=workflow() |> 
  add_model(ModelDesignLinRegr) |>            
  add_recipe(RecipeHousesPolynom10OLS) |> 
  fit(DataTrain)

DataTrainWithPredPolynom10OLS=augment(WFModelHousesPolynom10OLS, DataTrain)
DataTestWithPredPolynom10OLS=augment(WFModelHousesPolynom10OLS, DataTest)
```
