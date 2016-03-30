

library(caret)
library(plyr)
library(data.table)
library(e1071)
library(snowfall)


setwd("/Users/jolee/Desktop/santander")

train.df <- read.csv("train.csv")
test.df <- read.csv("test.csv")


head(train.df)



class(train.df$TARGET)

train.df$TARGET <- as.factor(train.df$TARGET)


fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number = 10,
  ## repeated ten times
  repeats = 10)
sfInit(parallel=TRUE, cpus=4)

#wishlist: this uses huge amount of serial time - consider selective export!
sfExportAll(except=NULL) # Export all objects to cluster


gbmFit1 <- train(TARGET ~ ., data = train.df,
                 method = "xgbTree",
                 trControl = fitControl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 verbose = FALSE)

sfStop()