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

# Drawing 10,000 samples running 10,00 OLS Regressiosn

Beta2=c()

set.seed(123)


for (i in 1:10000) {
DataTrain=sample_n(DataHousing,100)

ModelOLS=lm(Price~Sqft, data=DataTrain)

Beta1=append(Beta1,ModelOLS$coefficients[[1]])
Beta2=append(Beta2,ModelOLS$coefficients[[2]])
}

print(Beta2)
library(TeachHist) 


DataBeta2=tibble(beta2=Beta2)
TeachHistRelFreq(PlotData = DataBeta2, BinWidth = 0.5)

confint(ModelOLSOrg)
