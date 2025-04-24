library(rio);library(janitor);library(tidyverse)
DataHouses =
import("https://ai.lange-analytics.com/data/HousingData.csv") |>
clean_names("upper_camel") |>
select(Price, Sqft=SqftLiving)

# Original Analysis
set.seed(7771)
Data100Houses=sample_n(DataHouses,100)

ModelOLSOrg=lm(Price~Sqft, data=Data100Houses)
print(ModelOLSOrg)

# Drawing 10,000 samples running 10,000 OLS Regressiosn

Beta0=c()
Beta1=c()

set.seed(111)


for (i in 1:10000) {
DataTrain=sample_n(Data100Houses,100,replace = TRUE)

ModelOLS=lm(Price~Sqft, data=DataTrain)

Beta0=append(Beta0,ModelOLS$coefficients[[1]])
Beta1=append(Beta1,ModelOLS$coefficients[[2]])
}


library(TeachHist) 


DataBeta1=tibble(Beta1=Beta1)
View(DataBeta1)
TeachHistDens(PlotData = DataBeta1, BinWidth = 0.5)

confint(ModelOLSOrg)
TeachHistDens(PlotData = DataBeta1, BinWidth = 0.5, VLine1=179, VLine2=300)
