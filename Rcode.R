
#----------------------NEW START--------------------------------
setwd("C:/Users/Vishal Lakha/OneDrive/TATA Steel internship Stuff/H Blast furnace data")
dat=read.csv("full data with na removed.csv")
str(dat)
#----------------scatterplot matrix ggally--------------
library(GGally)
ggpairs(dat, lower=list(continuous="smooth"),
        diag=list(continuous="bar"))

cr=cor(dat)

#-----------finding smoothing spline relationships---------

graphs<-apply(train.full,2,function(x=names(train.full)){
  ggplot(train.full,aes(x,HM.Si))+stat_smooth() 
})

for(i in 1:16){
  xlabname=names(train.full)[i]
  graphs[[i]]=graphs[[i]]+xlab(xlabname)+ggtitle(paste("HM Si vs ",xlabname,sep=""))
}

for(i in 1:16){
  
  xlabname=names(train.full)[i]
  mypath=file.path("C:","Users","Vishal Lakha","OneDrive","TATA Steel internship Stuff","H Blast furnace data","graph",paste("HM Si VS ",xlabname,".jpg",sep=""))
  ggsave(filename = mypath, plot = graphs[[i]])
}

#-------------eXtreme gradient Boosting-----------------
library(xgboost)
library(Metrics)


#------------tuning xgboost------------------------------
searchGridSubCol <- expand.grid(subsample = c(0.5, 0.75, 1), 
                                colsample_bytree = c(0.6, 0.8, 1))
ntrees <- 100

#Build a xgb.DMatrix object
DMMatrixTrain <- xgb.DMatrix(data = as.matrix(train.full[,-16]), label = train.full[,16])

rmseErrorsHyperparameters <- apply(searchGridSubCol, 1, function(parameterList){
  
  #Extract Parameters to test
  currentSubsampleRate <- parameterList[["subsample"]]
  currentColsampleRate <- parameterList[["colsample_bytree"]]
  
  xgboostModelCV <- xgb.cv(data =  DMMatrixTrain, nrounds = ntrees, nfold = 5, showsd = TRUE, 
                           metrics = "rmse", verbose = TRUE, "eval_metric" = "rmse",
                           "objective" = "reg:linear", "max.depth" = 15, "eta" = 2/ntrees,                               
                           "subsample" = currentSubsampleRate, "colsample_bytree" = currentColsampleRate)
  
  xvalidationScores <- as.data.frame(xgboostModelCV)
  #Save rmse of the last iteration
  rmse <- tail(xvalidationScores$test.rmse.mean, 1)
  
  return(c(rmse, currentSubsampleRate, currentColsampleRate))
  
})
# 
#         [,1]     [,2]     [,3]     [,4]     [,5]     [,6]     [,7]     [,8]     [,9]
# [1,] 0.124213 0.124166 0.126146 0.124306 0.126002 0.127174 0.125192 0.126817 0.131516
# [2,] 0.500000 0.750000 1.000000 0.500000 0.750000 1.000000 0.500000 0.750000 1.000000
# [3,] 0.600000 0.600000 0.600000 0.800000 0.800000 0.800000 1.000000 1.000000 1.000000
# 

#--------------applying model to train test data--------------------
xgb <- xgboost(data = as.matrix(train.full[1:300,-16]), 
               label = train.full[1:300,16],objective="reg:linear", nrounds = 100,eta=2/100,"subsample" = 0.75, "colsample_bytree" = 0.6)

y_pred <- predict(xgb, as.matrix(train.full[301:426,-16]))
mean(y_pred)
rmse(train.full[301:426,16],y_pred)
#---rmse is 0.12344
write.csv(y_pred,"predicted values for 70% train -test original data.csv")





#-----------------applying the model to changed data----------------------
xgb <- xgboost(data = as.matrix(train.full[,-16]), 
               label = train.full[,16],objective="reg:linear", nrounds = 100,eta=0.01,"subsample" = 0.5, "colsample_bytree" = 0.8,"max.depth"=60)

y_pred <- predict(xgb, as.matrix(test.full[,]))
mean(y_pred)
