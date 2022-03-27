#Peer-graded Assignment: Getting and Cleaning Data Course Project
library(plyr)
library(dplyr)
library(readr)
library(data.table)

#download file
download.file("http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip", "zip_file")
unzip("zip_file")

#label train and test data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)

#merge tables
subject <- rbind(subject_train, subject_test)
y <- rbind(y_train, y_test)
x <- rbind(x_train, x_test)
colnames(subject) <- "subject"
colnames(y) <- "y"
colnames(x) <- "x"
all_data <- cbind(x , y, subject)

#mean and standard deviation measurements
cols_mean_std <- grep(".*Mean.*|.*Std.*", names(all_data), ignore.case=TRUE)
all_columns <- c(cols_mean_std, 562, 563)
dim(all_data)
mean_std_data <- all_data[cols_mean_std]
dim(mean_std_data)

#descriptive activity names
a_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)[,2]
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y <- rbind(y_test, y_train)
names(y) <- "activity"

activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
all_data$y[all_data$y==1] <- "Walking"
all_data$y[all_data$y==2] <- "Walking_Upstairs"
all_data$y[all_data$y==3] <- "Walking_Downstairs"
all_data$y[all_data$y==4] <- "Sitting"
all_data$y[all_data$y==5] <- "Standing"
all_data$y[all_data$y==6] <- "Laying"

#appropriately label dataset variables
names(mean_std_data) <- gsub("Acc", "Accelerometer", names(mean_std_data))
names(mean_std_data) <- gsub("Gyro", "Gyroscope", names(mean_std_data))
names(mean_std_data) <- gsub("BodyBody", "Body", names(mean_std_data))
names(mean_std_data) <- gsub("Mag", "Magnitude", names(mean_std_data))
names(mean_std_data) <- gsub("^t", "Time", names(mean_std_data))
names(mean_std_data) <- gsub("^f", "Frequency", names(mean_std_data))
names(mean_std_data) <- gsub("tBody", "TimeBody", names(mean_std_data))
names(mean_std_data) <- gsub("-mean()", "Mean", names(mean_std_data), ignore.case = TRUE)
names(mean_std_data) <- gsub("-std()", "STD", names(mean_std_data), ignore.case = TRUE)
names(mean_std_data) <- gsub("-freq()", "Frequency", names(mean_std_data), ignore.case = TRUE)
names(mean_std_data) <- gsub("angle", "Angle", names(mean_std_data))
names(mean_std_data) <- gsub("gravity", "Gravity", names(mean_std_data))

#tidy dataset
tidy_data<-aggregate(. ~subject + y, all_data, mean)
tidy_data<-tidy_data[order(tidy_data$x,tidy_data$y),]
write.table(tidy_data, file = "tidy_data.txt",row.name=FALSE)
