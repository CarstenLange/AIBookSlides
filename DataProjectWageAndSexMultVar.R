library(wooldridge)
library(ggdag)
library(tidymodels)
library(janitor)
dagify(cardiacarrest ~ cholesterol,
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
