library(tidymodels)
GradesTable=tibble(Grades=c(120,
120,
120,
120,
120,
118,
118,
117,
117,
115,
115,
113,
112,
110,
108,
106,
104,
101,
98,
95,
85)) |> 
  mutate(Grades=Grades/120)
mean(GradesTable$Grades)
sd(GradesTable$Grades)
library(TeachHist)
TeachHistDens(PlotData = GradesTable, BinWidth = 1.23, PrintZAxis = FALSE)
