library(tidymodels)
DataAnalysis=tibble(x=seq(0,9, by=0.1),y=sin(x+5)+1)
ggplot(DataAnalysis,aes(x,y))+geom_point()
RecipeNN=recipe(y~x,DataAnalysis)
ModelDesignNN=mlp(hidden_units = 3, epochs = 10000) %>% 
              set_engine("nnet") %>% 
              set_mode("regression")
WorkFlowNN=workflow() %>% 
           add_recipe(RecipeNN) %>% 
           add_model(ModelDesignNN) %>% 
           fit(DataAnalysis)
ModelNN=extract_fit_engine(WorkFlowNN)
ModelNN$wts


DataAnalysisWithPred=augment(WorkFlowNN, new_data=DataAnalysis)

ggplot(DataAnalysisWithPred,aes(x,y))+
  geom_point()+
  geom_line(aes(y=.pred))

