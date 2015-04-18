## Getting and Cleaning Data. COURSE PROJECT

## Downloading files and reading data

x_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
y_train <- read.table('./UCI HAR Dataset/train/y_train.txt', 
                      col.names=c("activityNum"))
subject_train <- read.table('./UCI HAR Dataset/train/subject_train.txt',
                            col.names=c("subjectId"))


x_test <- read.table('./UCI HAR Dataset/test/X_test.txt')
y_test <- read.table('./UCI HAR Dataset/test/y_test.txt', 
                     col.names=c("activityNum"))
subject_test <- read.table('./UCI HAR Dataset/test/subject_test.txt', 
                           col.names=c("subjectId"))

features <-read.table('./UCI HAR Dataset/features.txt', stringsAsFactors=FALSE)
featureNames <- features$V2
rm(features)


## STEP 1
## Merge the training and test data sets to create one data set.
dataset <- rbind(x_train, x_test)
colnames(dataset) <- featureNames
rm(list=c("x_train", "x_test"))


## STEP 2
## Extract only mean and standard deviation values for each measurement
std_mean <- featureNames[grepl("mean\\()|std\\()", featureNames)]
subdata <- dataset[, std_mean]
rm(list=c("std_mean","featureNames"))


## Descriptive activity names to name the activities in the data set

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                             col.names=c("activityNum", "activity"), 
                             stringsAsFactors=FALSE)

## STEP 3
## Use descriptive activity names
activityData <- merge(rbind(y_train, y_test), activity_labels, by="activityNum", 
                      sort=FALSE)[["activity"]]
activity <- sub("_", " ", tolower(activityData))
subdata <- cbind(activity, subdata)
rm(list=c("y_train", "y_test", "activity", "activityData", "activity_labels"))

# Add subject ids
subjectId <- rbind(subject_train, subject_test)
subdata <- cbind(subjectId, subdata)
rm(list=c("subject_train", "subject_test","subjectId"))


## STEP 4
## Appropriately labels the data set with descriptive variable names

names(subdata) = gsub("-", "_", names(subdata))
names(subdata) = gsub("mean\\(\\)", "Mean", names(subdata))
names(subdata) = gsub("std\\()", "StandardDev", names(subdata))

library(dplyr)
subdata <- rename(subdata, 
       fBodyAccJerkMag_Mean = fBodyBodyAccJerkMag_Mean,
       fBodyGyroJerkMag_Mean = fBodyBodyGyroJerkMag_Mean,
       fBodyGyroMag_Mean = fBodyBodyGyroMag_Mean,
       fBodyGyroMag_StandardDev = fBodyBodyGyroMag_StandardDev,
       fBodyAccJerkMag_StandardDev = fBodyBodyAccJerkMag_StandardDev,
       fBodyGyroJerkMag_StandardDev = fBodyBodyGyroJerkMag_StandardDev
)


## STEP 4
## From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject

library(reshape2)
subdata2 <- melt(subdata, id.vars = c("subjectId", "activity"))
grouped <- group_by(subdata2, subjectId, activity, variable)
df <- summarise(grouped, mean=mean(value))
rm(list=c("subdata2", "grouped"))

write.table(df, "step5.txt", row.names=FALSE, col.names=TRUE)

rm(list=ls())