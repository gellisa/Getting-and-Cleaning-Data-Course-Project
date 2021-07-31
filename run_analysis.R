library(plyr)


#download the dataset
if(!file.exists("./data")){dir.create("./data")}
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL,destfile="./data/Dataset.zip",method="curl")


#unzip the dataset
unzip(zipfile="./data/Dataset.zip",exdir="./data")


#get the list of the files
path <- file.path("./data" , "UCI HAR Dataset")
files <-list.files(path, recursive=TRUE)

###############################################
#read data

#read activity
ActivityTest<- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
ActivityTrain<- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)

#read subject
SubjectTrain<- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
SubjectTest<- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)

#read features
FeaturesTest<- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrain<- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)

##################################################
#merge training and test data

Activity<- rbind(ActivityTrain, ActivityTest)
Subject<- rbind(SubjectTrain, SubjectTest)
Features<- rbind(FeaturesTrain, FeaturesTest)

#set names to the variables
names(Subject)<-c("Subject")
names(Activity)<- c("Activity")
FeaturesNames <- read.table(file.path(path, "features.txt"),head=FALSE)
names(Features)<- FeaturesNames$V2

#merge cols
alldata<-cbind(Subject, Activity)
data <- cbind(Features, alldata)

activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)


#rename the labels
names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))

#creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data2<-aggregate(. ~subject + activity, data, mean)
data2<-data2[order(data2$subject,Data2$activity),]
write.table(data2, file = "tidydata.txt",row.name=FALSE)

library(knitr)
knit2html("codebook.Rmd")

