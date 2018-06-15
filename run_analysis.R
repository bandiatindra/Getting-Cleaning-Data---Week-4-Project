setwd("C:/Users/Atindra/Data_Science/Data Cleaning")
#************Data Loading & Preprocessing Starts************
library (dplyr)
library(plyr)

# Download Human Activity File if it has not been downloaded
if(!file.exists("human_activity.zip")) {download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "human_activity.zip")}

# Unzip the Human Activity File
if(!file.exists("UCI HAR Dataset")) {unzip("human_activity.zip")}

#************Reading Data Files************

# Read Training and Test Data
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

values_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
values_test <- read.table("./UCI HAR Dataset/test/X_test.txt")

activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
activity_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

# Read all the feature variables
features <- read.table("./UCI HAR Dataset/features.txt",as.is = TRUE)

#Read activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

#Consolidate test and training data
training_data <- cbind(subject_train,activity_train,values_train)
test_data <- cbind(subject_test,activity_test,values_test)

#1. Merge training and test sets to create one data set
human_activity <- rbind(training_data,test_data)

# 4. Appropriately label the data set with descriptive names
colnames(training_data) = c("subject", "activity", features[,2])
colnames(test_data) = c("subject", "activity", features[,2])   

#2. Extract only the measurements on mean and standard deviations for each measurement
human_activity <- human_activity[,grepl("subject|activity|mean|std",names(human_activity))]

#3. Use descriptive activity name to name the activities in the data set
human_activity$activity <- as.factor(human_activity$activity)
levels(human_activity$activity) <- activity_labels[,2]

#5. Create a second independent tiny data set with average of each variables for each activity and each subject
human_activity_mean <- human_activity %>% 
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

write.table(human_activity_mean, file="./UCI HAR Dataset/tidy_data.txt", row.names = FALSE)
