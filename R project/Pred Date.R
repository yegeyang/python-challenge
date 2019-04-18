#train data
Date_data <- read.csv("Date.csv", header = TRUE)
str(Date_data)

Date_data$Idea.Submission.Date  <- as.numeric(Date_data$Idea.Submission.Date)
Date_data$Idea.Implementation.Start.Date <- as.numeric(Date_data$Idea.Implementation.Start.Date)
Date_data$Expected.HC.Benefits.... <- as.numeric(Date_data$Expected.HC.Benefits....)

str(Date_data)

library(randomForest)
library(rpart)
library(rpart.plot)
library(lattice)
library(ggplot2)
library(caret)
library(foreach)
library(iterators)
library(snow)
library(doSNOW)
library(e1071)
library(party)

set.seed(1234)
1233*0.7
train <- sample(1:1233, 863, replace = FALSE)
traindata <- Date_data[train,]
testdata <- Date_data[-train,]

#create model
fit <- cforest(Completed~Metro.City.Description + Cluster.Recommendation  + Tech.Solution.Analyzed + Capability.Impacted + Expected.HC.Benefits.FTE., data = traindata, controls = cforest_unbiased(ntree = 1000, mtry = 2))
fit

cforestStats(fit)
rev(sort(varImp(fit)))

pred <- predict(fit, newdata = testdata, type = "response")
pred
cor(pred, testdata$Completed)^2
testdata$pred <- pred
