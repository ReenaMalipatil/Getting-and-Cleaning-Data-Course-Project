


library(dplyr)

## READ IN ALL FILES

Inputfile <- "getdata_projectfiles_UCI HAR Dataset.zip"

if(!file.exists(Inputfile)){
  InputURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(InputURL,Inputfile,method = "curl")
  unzip(Inputfile)
}

list.files("./")
getwd()
setwd("./getdata_projectfiles_UCI HAR Dataset/")

## Read in all train and test datasets

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","features"))
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))


## Assign column names for test and train datasets

colnames(X_test) <- features$features
colnames(Y_test) <- "code"

colnames(X_train) <- features$features
colnames(Y_train) <- "code"


## 1) Merges the training and test datasets to create one dataset


X_data <- rbind(X_train,X_test)
Y_data <- rbind(Y_train,Y_test)
Subject_data <- rbind(subject_train,subject_test)

Final_data <- cbind(X_data, Y_data, Subject_data)
# Final_data <- cbind(Subject_data, Y_data, X_data)


View(Final_data)
names(Final_data)

## 2) Extract only the measurements on mean and standard deviation for each measurement

cnames <- colnames(Final_data)
match_string <- grepl("mean", cnames) | grepl("std", cnames)
Final_data_2 <- Final_data[,match_string==TRUE]

temp <- Final_data[,c("code", "subject")]
Final_data_3 <- cbind(Final_data_2,temp)



## 3) Uses descriptive activity names to name the activities in the data set
# Replace column code numbers with activity names

Final_data_3$code <- activity_labels[Final_data_3$code, 2]



## 4) Appropriately labels the data set with descriptive variable names
names(Final_data_3)

Final_data_3 <- Final_data_3 %>% rename("activity"="code")

colnames(Final_data_3) <- gsub("Acc", "Accelorometer", colnames(Final_data_3))
colnames(Final_data_3) <- gsub("Gyro", "Gyroscope", colnames(Final_data_3))
colnames(Final_data_3) <- gsub("Mag", "Magnitude", colnames(Final_data_3))
colnames(Final_data_3) <- gsub("mean()", "Mean", colnames(Final_data_3), ignore.case = TRUE)
colnames(Final_data_3) <- gsub("std()", "STD", colnames(Final_data_3), ignore.case = TRUE)
colnames(Final_data_3) <- gsub("freq()", "Frequency", colnames(Final_data_3), ignore.case = TRUE)
colnames(Final_data_3) <- gsub("^t", "Time", colnames(Final_data_3), ignore.case = TRUE)
colnames(Final_data_3) <- gsub("^f", "Frequency", colnames(Final_data_3), ignore.case = TRUE)


## 5) From the data set in step 4, creates a second, independent tidy data set with the average
## of each variable for each activity and each subject


Final_data_4 <- Final_data_3 %>%
    group_by(subject,activity) %>%
    summarise_all(mean)

View(Final_data_4)

## Create final dataset
write.table(Final_data_4,"TidyData.txt")

