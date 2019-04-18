#load raw data

train <- read.csv("Train.csv", header =TRUE)
test <- read.csv("Test.csv", header = TRUE)

#create new field for test data
test.completed <- data.frame(Completed = rep("None", nrow(test)), test[,])

#combine data
data.combined <- rbind(train, test.completed)

str(data.combined)

data.combined$Completed <- as.factor(data.combined$Completed)

str(data.combined$Completed)

table(data.combined$Completed)

table(data.combined$Cluster.Recommendation)

train$Completed <- as.factor(train$Completed)

library(ggplot2)

#hypothesis - cluster higher, close quicker
ggplot(train, aes(x = Cluster.Recommendation, fill = factor(Completed))) + 
  geom_bar(width = 0.5) + 
  xlab("Level") + 
  ylab("Total value") + 
  labs(fill = "Completion")

ggplot(train, aes(x = Capability.Impacted, fill = factor(Completed))) + 
  geom_bar(width = 0.5) + 
  xlab("Capability") + 
  ylab("Total value") + 
  labs(fill = "Completion")

ggplot(train, aes(x = Curator, fill = factor(Completed))) + 
  geom_bar(width = 0.5) + 
  xlab("Curator") + 
  ylab("Total value") + 
  labs(fill = "Completion")

ggplot(train, aes(x = Total.Benefits, fill = factor(Completed))) + 
  geom_bar(width = 0.5) + 
  xlab("Benefits") + 
  ylab("Total value") + 
  labs(fill = "Completion")

ggplot(train, aes(x = FTE.Saving, fill = factor(Completed))) + 
  geom_bar(width = 0.5) + 
  xlab("FTE") + 
  ylab("Total value") + 
  labs(fill = "Completion")

ggplot(train, aes(x = Targeted.Primary.Biz.Outcome, fill = factor(Completed))) + 
  geom_bar(width = 0.5) + 
  xlab("Primary") + 
  ylab("Total value") + 
  labs(fill = "Completion")

table(data.combined$Completed[1:2515])

library(randomForest)

# first test
rf.train.1 <- data.combined[1:2515, c("Cluster.Recommendation", "Capability.Impacted")]
rf.label <- as.factor(train$Completed)

set.seed(1234)
rf.1 <- randomForest(x = rf.train.1, y = rf.label, importance = TRUE, ntree = 1000)
rf.1
varImpPlot(rf.1)

#second test
rf.train.2 <- data.combined[1:2515, c("Cluster.Recommendation", "Capability.Impacted","Curator")]
rf.label <- as.factor(train$Completed)

set.seed(1234)
rf.2 <- randomForest(x = rf.train.2, y = rf.label, importance = TRUE, ntree = 1000)
rf.2
varImpPlot(rf.2)

#
features <- c("Curator","AEE.Location", "Targeted.Primary.Biz.Outcome", "Capability.Impacted","FTE.Saving","Idea.Source","Country.Location.1","Decision","Idea.State","If.AUTOMATION..choose.type.of.Automation") 
rf.train.3 <- data.combined[1:2515, features]

set.seed(1234)
rf.3 <- randomForest(x = rf.train.3, y = rf.label, importance = TRUE, ntree = 1000)
rf.3
varImpPlot(rf.3)

test.result.df <- data.combined[2516:3071, features]
rf.preds <- predict(rf.3, test.result.df)
table(rf.preds)

submit.df <- data.frame(Idea.Request = rep(2516:3071), Completed = rf.preds)
write.csv(submit.df, file = "test_result.csv", row.names = FALSE)
write.csv(data.combined, file = "raw_data.csv", row.names = FALSE)

#Single decision tree
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

set.seed(2348)
cv.10.folds <- createMultiFolds(rf.label, k = 10, times = 10)

table(rf.label)

table(rf.label[cv.10.folds[[33]]])

ctrl.1 <- trainControl(method = "repeatedcv", number = 10, repeats = 10, index = cv.10.folds)

cl <- makeCluster(6, type = "SOCK")
registerDoSNOW(cl)

set.seed(34324)
rf.3.cv.1 <- train(x = rf.train.3, y = rf.label, method = "rf", tuneLength = 3, ntree = 1000, trControl = ctrl.1) 

stopCluster(cl)

rf.3.cv.1


#5-fold cv

set.seed(5983)
cv.5.folds <- createMultiFolds(rf.label, k = 5, times = 10)

ctrl.2 <- trainControl(method = "repeatedcv", number = 5, repeats = 10, index = cv.5.folds)

cl <- makeCluster(6, type = "SOCK")
registerDoSNOW(cl)

set.seed(89472)

rf.3.cv.2 <- train(x = rf.train.3, y = rf.label, method = "rf", tuneLength = 3, ntree = 1000, trControl = ctrl.2)

stopCluster(cl)

rf.3.cv.2

#3-folds
set.seed(37596)
cv.3.folds <- createMultiFolds(rf.label, k = 3, times = 10)

ctrl.3 <- trainControl(method = "repeatedcv", number = 3, repeats = 10, index = cv.3.folds)

cl <- makeCluster(6, type = "SOCK")
registerDoSNOW(cl)

set.seed(94622)

rf.3.cv.3 <- train(x = rf.train.3, y = rf.label, method = "rf", tuneLength = 3, ntree = 1000, trControl = ctrl.3)

stopCluster(cl)

rf.3.cv.3



#Single discision tree
rpart.cv <- function(seed, training, labels, ctrl) {
  cl <- makeCluster(6, type = "SOCK")
  registerDoSNOW(cl)
  
  set.seed(seed)
  
  rpart.cv <- train(x= training, y = labels, method = "rpart", tuneLength = 30, trControl = ctrl)
  
  stopCluster(cl)
  
  return(rpart.cv)
}

rpart.train.1 <- data.combined[1:2515, features]

rpart.1.cv.1 <- rpart.cv(94622, rpart.train.1, rf.label, ctrl.3)
rpart.1.cv.1

prp(rpart.1.cv.1$finalModel, type =0, extra = 1, under = TRUE)


rpart.1.preds <- predict(rpart.1.cv.1$finalModel, test.result.df, type ="class")

table(rpart.1.preds)

