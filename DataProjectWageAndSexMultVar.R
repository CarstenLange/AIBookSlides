library(wooldridge)
library(ggdag)
library(tidymodels)
library(janitor)
DAGMine=dagify(Wage ~ Tenure + Educ + SexFem,
       Educ~ParentEduc,
       latent = "ParentEduc",
       exposure = "SexFem",
       outcome = "Wage"
)

ggdag(DAGMine)

DataWageOrg=wage1 
         
        

library(ggdag)
smoking_ca_dag <- dagify(cardiacarrest ~ cholesterol,
                         cholesterol ~ smoking + weight,
                         smoking ~ unhealthy,
                         weight ~ unhealthy,
                         labels = c(
                           "cardiacarrest" = "Cardiac\n Arrest",
                           "smoking" = "Smoking",
                           "cholesterol" = "Cholesterol",
                           "unhealthy" = "Unhealthy\n Lifestyle",
                           "weight" = "Weight"
                         ),
                         latent = "unhealthy",
                         exposure = "smoking",
                         outcome = "cardiacarrest"
)

ggdag(smoking_ca_dag)


DataWage=DataWageOrg |>
         clean_names("upper_camel") |> 
         select(Wage, SexFem=Female, Educ, Exper, Tenure, Nonwhite) |> 
         mutate(RaceWhite=1-Nonwhite, NonWhite=NULL)

library(SmartEDA)
ExpReport(DataWage, op_file = "EDAReport")


DataWage=DataWageOrg |> 
  select()

library(corrplot)
CorMatrix <-cor(DataWage) 
corrplot(CorMatrix)
