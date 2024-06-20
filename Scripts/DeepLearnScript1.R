library(tidymodels);library(janitor);library(rgl)
#library(webshot)# not sure if it is needed
set.seed(777)
DataDiamonds=diamonds %>%
  clean_names("upper_camel") %>%
  select(Price, Carat, Clarity) %>%
  mutate(Clarity=as.numeric(Clarity)) %>%
  sample_n(500)

set.seed(777)
Split=DataDiamonds %>%
  initial_split(prop = 0.05)
DataTrain=training(Split)
DataTest=testing(Split)

RecipeDiamonds=recipe(Price ~ ., data = DataTrain) %>%
  step_normalize(all_predictors())

ModelDesign= linear_reg() %>%
  set_engine("lm") %>%
  set_mode("regression")

ModelDesign= mlp(hidden_units = 50, epochs = 10000, penalty = 0) %>% # 7 hidden units worked well
  set_engine("nnet") %>%
  set_mode("regression")

WfModelNN=workflow() %>%
  add_model(ModelDesign) %>%
  add_recipe(RecipeDiamonds) %>%
  fit(DataTrain)

DataTrainWithPred=augment(WfModelNN, new_data = DataTrain)
metrics(DataTrainWithPred, truth=Price, estimate = .pred)

DataTestWithPred=augment(WfModelNN, new_data = DataTest)
metrics(DataTestWithPred, truth=Price, estimate = .pred)

#######################
#   Make 3D Plot
#   Source www.r-graphics.org Section 13.8
#######################

#Define some helper functions
# Creates grid to plot
predictgrid <- function(model, xvar, yvar, zvar, res = 32, type = NULL) {
  xrange <- range(DataTrain[[xvar]])
  yrange <- range(DataTrain[[yvar]])

  newdata <- expand.grid(x = seq(xrange[1], xrange[2], length.out = res),
                         y = seq(yrange[1], yrange[2], length.out = res))
  names(newdata) <- c(xvar, yvar)
  newdata[[zvar]] <- predict(model, new_data = newdata, type = type)# tidymodels predict needs new_data=
  newdata
}


# Convert long-style data frame with x, y, and z vars into a list
# with x and y as row/column values, and z as a matrix.
df2mat <- function(p, xvar = NULL, yvar = NULL, zvar = NULL) {
  if (is.null(xvar)) xvar <- names(p)[1]
  if (is.null(yvar)) yvar <- names(p)[2]
  if (is.null(zvar)) zvar <- names(p)[3]

  x <- unique(p[[xvar]])
  y <- unique(p[[yvar]])
  z <- matrix(p[[zvar]], nrow = length(y), ncol = length(x))

  DataList <- list(x, y, z)
  names(DataList) <- c(xvar, yvar, zvar)
  DataList
}

# Function to interleave the elements of two vectors
interleave <- function(v1, v2)  as.vector(rbind(v1,v2))

######
library(rgl)



# Get predicted values and generate 3D Grid

mpgrid_df <- predictgrid(WfModelNN, "Carat", "Clarity", "PredPrice", res = 32) %>%
  mutate(PredPrice=PredPrice$.pred) %>% # mutate is needed because .pred is in a tibble
  mutate(PredPrice=ifelse(PredPrice>16000,16000,PredPrice)) %>%  #only needed for scaling
  mutate(PredPrice=ifelse(PredPrice<0,0,PredPrice)) #only needed for scaling
mpgrid_list <- df2mat(mpgrid_df)


##  Make the plot using the data points. Plot is in separate window OUTSIDE RStudio ###
## Plot without Prediction surface
plot3d(DataTrainWithPred$Carat, DataTrainWithPred$Clarity, DataTrainWithPred$Price,
       xlab = "", ylab = "", zlab = "", axes = FALSE, #ommit this lines and axis are generated
       col="blue", type = "s", size = 0.5, lit = FALSE)

# Add line segments showing the price
segments3d(interleave(DataTrainWithPred$Carat,   DataTrainWithPred$Carat),
           interleave(DataTrainWithPred$Clarity, DataTrainWithPred$Clarity),
           interleave(DataTrainWithPred$Price,  0),#Set second arg 0 for points ony
           alpha = 0.4, col = "red")

# Draw the box
rgl.bbox(color = "grey50",          # grey60 surface and black text
         emission = "grey50",       # emission color is grey50
         xlen = 0, ylen = 0, zlen = 0)  # Don't add tick marks

# Set default color of future objects to black
rgl.material(color = "black")

# Add axes to specific sides. Possible values are "x--", "x-+", "x+-", and "x++".
axes3d(edges = c("x-", "y-", "z+"),
       ntick = 6,                       # Attempt 6 tick marks on each side
       cex = .75)                       # Smaller font



# Add axis labels. 'line' specifies how far to set the label from the axis.
mtext3d("Carat",       edge = "x--", line = 3)
mtext3d("Clarity", edge = "y--", line = 3)
mtext3d("      Price",  edge = "z+-", line = 3)



##  Make the plot using the data points. Plot is in separate window OUTSIDE RStudio ###
## Plot with Prediction surface
plot3d(DataTrainWithPred$Carat, DataTrainWithPred$Clarity, DataTrainWithPred$Price,
       xlab = "", ylab = "", zlab = "", axes = FALSE, #ommit this lines and axis are generated
       col="blue", type = "s", size = 0.5, lit = FALSE)

# Add line segments showing the error
segments3d(interleave(DataTrainWithPred$Carat,   DataTrainWithPred$Carat),
           interleave(DataTrainWithPred$Clarity, DataTrainWithPred$Clarity),
           interleave(DataTrainWithPred$Price,  DataTrainWithPred$.pred),#Set second arg 0 for points ony
           alpha = 0.4, col = "red")

# Add the mesh of predicted values

surface3d(mpgrid_list$Carat, mpgrid_list$Clarity, mpgrid_list$PredPrice,
         alpha = 0.4, front = "lines", back = "lines")

# Draw the box
rgl.bbox(color = "grey50",          # grey60 surface and black text
         emission = "grey50",       # emission color is grey50
         xlen = 0, ylen = 0, zlen = 0)  # Don't add tick marks

# Set default color of future objects to black
rgl.material(color = "black")

# Add axes to specific sides. Possible values are "x--", "x-+", "x+-", and "x++".
axes3d(edges = c("x-", "y-", "z+"),
       ntick = 6,                       # Attempt 6 tick marks on each side
       cex = .75)                       # Smaller font



# Add axis labels. 'line' specifies how far to set the label from the axis.
mtext3d("Carat",       edge = "x--", line = 3)
mtext3d("Clarity", edge = "y--", line = 3)
mtext3d("      Price",  edge = "z+-", line = 3)

