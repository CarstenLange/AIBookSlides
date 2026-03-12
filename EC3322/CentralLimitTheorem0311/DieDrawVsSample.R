library(tidyverse)
library(TeachHist)

PopMean=sum(1,2,3,4,5,6)/6
PopVar=sum((1-PopMean)^2,(2-PopMean)^2,(3-PopMean)^2,
           (4-PopMean)^2,(5-PopMean)^2,(6-PopMean)^2)/6
PopSd=sqrt(PopVar)

set.seed(800)
NData=100
MyData=tibble(DieResult=sample(c(1:6),NData,replace = TRUE))
#View(MyData)
mean(MyData$DieResult)
sd(MyData$DieResult)

TeachHistCounts(PlotData = MyData, BinWidth = 1/sd(MyData$DieResult), XAxisMax = 2.2, PrintZAxis = FALSE)


##########################################
NumberOfSamples=700
NInEachSample=100
MySamples=tibble(DieRoll=c(1:NInEachSample))
#Takes a while. Be patient
for (i in c(1:NumberOfSamples)) {
  MySamples=MySamples%>%mutate(!!paste("Sample",i,sep=""):=sample(MyData$DieResult,NInEachSample,replace = TRUE)) 
}

View(MySamples)



AllSamplesMeans=colMeans(MySamples)[-1]
View(tibble(AllSamplesMeans))

TeachHistDens(PlotData = tibble(SampleMeans=AllSamplesMeans), PlotNormCurv = FALSE,
         PrintDensities = FALSE)


EstMeanOfSamplesMeans= mean(AllSamplesMeans)
cat(" Theoretical Sampling Mean:", PopMean, "\n",
    "Empirical Sampling Mean:", mean(AllSamplesMeans))

PopSd # just for review
(EstStandardErrorOfSampleMeans=
    sd(AllSamplesMeans))
(TheoreticalStandardErrorOfSampleMeans=
                       PopSd/sqrt(NInEachSample))
cat("Theoretical Standard Deviation:",
    PopSd)
cat("Estimated Standard Error of Sample Means:",
    EstStandardErrorOfSampleMeans) 
cat("Theoretical Standard Error of Sample Means:", 
    PopSd/sqrt(NInEachSample))

TeachHistDens(PlotData = tibble(SampleMeans=AllSamplesMeans), PlotNormCurv = TRUE,
         PrintDensities = FALSE)

