

rm(list = ls())
getwd()
setwd("C:/Users/hp/Documents/R 2019/data_science_specialization/Cleaning data/Projeto Cleaning Data/UCI HAR Dataset")

library(plyr)
library(dplyr)
library(data.table)

#1. Get and merge the data


#Read the activity and feature labels

activity_labels <- read.table('./activity/activity_labels.txt',col.names = c("code", "Activity"))


features <- read.table('./feature/features.txt', col.names = c("n","functions"))
              

View(features)
View(activity_labels)

#Read the Train files

subjectTrain = read.table('./train/subject_train.txt',col.names = "subject")

xTrain = read.table('./train/x_train.txt', col.names = features$functions)
yTrain = read.table('./train/y_train.txt', col.names = "code")


#Read the Test files
subjectTest = read.table('./test/subject_test.txt',col.names = "subject")

xTest = read.table('./test/x_test.txt',  col.names = features$functions)
yTest = read.table('./test/y_test.txt', col.names = "code")

str(subjectTest)
str(subjectTrain)

#Organizing and combining raw data sets into single one.

xDataSet <- rbind(xTrain, xTest)
yDataSet <- rbind(yTrain, yTest)
subject <- rbind(subjectTrain,subjectTest)

singleDataSet <- cbind(subject, xDataSet, yDataSet)


View(singleDataSet)



# 2. Extract only the measurements on the mean and standard deviation for each measurement.

#xData subset based on the logical vector to keep only desired columns, i.e. mean() and std().

subjectDataSet_mean_std <- singleDataSet %>% select(subject, code, contains("mean"), contains("std"))
View(subjectDataSet_mean_std)

#3. Use descriptive activity names to name the activities in the data set.
subjectDataSet_mean_std$code <- activity_labels[subjectDataSet_mean_std$code, 2]

#4. Appropriately label the data set with descriptive activity names.
names(subjectDataSet_mean_std )[2] = "activity"
names(subjectDataSet_mean_std) <- gsub('Acc',"Acceleration",names(subjectDataSet_mean_std))
names(subjectDataSet_mean_std) <- gsub('GyroJerk',"AngularAcceleration",names(subjectDataSet_mean_std))
names(subjectDataSet_mean_std) <- gsub('Gyro',"AngularSpeed",names(subjectDataSet_mean_std))
names(subjectDataSet_mean_std) <- gsub('Mag',"Magnitude",names(subjectDataSet_mean_std))
names(subjectDataSet_mean_std) <- gsub('^t',"TimeDomain.",names(subjectDataSet_mean_std))
names(subjectDataSet_mean_std) <- gsub('^f',"FrequencyDomain.",names(subjectDataSet_mean_std))
names(subjectDataSet_mean_std) <- gsub('\\.mean',".Mean",names(subjectDataSet_mean_std))
names(subjectDataSet_mean_std) <- gsub('\\.std',".StandardDeviation",names(subjectDataSet_mean_std))
names(subjectDataSet_mean_std) <- gsub('Freq\\.',"Frequency.",names(subjectDataSet_mean_std ))
names(subjectDataSet_mean_std) <- gsub('Freq$',"Frequency",names(subjectDataSet_mean_std))

names(subjectDataSet_mean_std)

#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidydata<-aggregate(. ~subject + activity, subjectDataSet_mean_std, mean)
tidydata<-tidydata[order(Data2$subject,Data2$activity),]
write.table(tidydata, file = "tidydata.txt",row.name=FALSE)
View(tidydata)
