# run_analysis.R
# Practical portion of week 4 of "Getting and Cleaning DataR script called 
# run_analysis.R that does the following:
#
#  1.Merges the training and the test sets [1] to create one data set.
#  2.Extracts only the measurements on the mean and standard deviation 
#    for each measurement.
#  3.Uses descriptive activity names to name the activities in the data set
#  4.Appropriately labels the data set with descriptive variable names.
#  5.From the data set in step 4, creates a second, independent tidy data 
#    set with the average of each variable for each activity and each subject.
#
# The data is from accelerometers from the Samsung Galaxy S smartphone. 
# A full description is available at the site where the data was obtained:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# The data for the project:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# Reference
# [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes
# -Ortiz. Human Activity Recognition on Smartphones using a Multiclass 
# Hardware-Friendly Support Vector Machine. International Workshop of Ambient 
# Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012.
# load packages
library('dplyr')
#
# Soup to Nuts exercise ... create directory and download data....
# create data directory
       if(!file.exists('./data')) dir.create('./data')
#
       if(!file.exists('./data/getdata_Fprojectfiles_FUCI HAR Dataset.zip')) {
              fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
              download.file(fileURL, destfile = './data/getdata_Fprojectfiles_FUCI HAR Dataset.zip')
              }
# unzip data
       if(!file.exists('./data/UCI HAR Dataset')) {
              unzip('./data/getdata_Fprojectfiles_FUCI HAR Dataset.zip', exdir = './data')
              }
# Part 1: create one data set
# Read in feature names and label columns
       featureNames <- read.table("./data/UCI HAR Dataset/features.txt")
       names(featureNames) <- c("featureCode","featureName")
# Read in activity names  and label columns   
       activityNames <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
       names(activityNames) <- c("activityCode","activityName")
       
# Read in test data
       subjectTest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
       featureTest <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
       activityTestSet <- read.table("./data/UCI HAR Dataset/test/y_test.txt")

# Read in training data
       subjectTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
       featureTrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
       activityTrainSet <- read.table("./data/UCI HAR Dataset/train/y_train.txt")

# First combining by rows using rbind
       subjectAll <- rbind(subjectTest,subjectTrain)
       activitySetAll <- rbind(activityTestSet,activityTrainSet)
       featureAll <- rbind(featureTest,featureTrain)
#
# Label columns for subjectAll and activitySeteAll acccordingly
       colnames(subjectAll) <- "Subject"
       colnames(activitySetAll) <- "activityCode"
# Label featureAll columns by applying transposed (t) column of data from featureNames      
       colnames(featureAll) <- t(featureNames[2])
# Join data tables together with column bind (cbind)
       joinedData<- cbind(subjectAll,activitySetAll,featureAll)
#-------------------------------------------------------------------------------------------       
# Part 2.Extract only the measurements on the mean and standard deviation 
#        for each measurement - including column 1 (subject) and col 2 (activity).
       meanStdColumns <- grep("subject|activity|*mean*|*std*", colnames(joinedData),ignore.case =TRUE)
#
# Subset the data by creating table with only the columns activity,subject,std and mean
       meanStdDataSubSet <- joinedData[,meanStdColumns]     
#     
#-------------------------------------------------------------------------------------------       
# Part 3. Uses descriptive activity names to name the activities in the data set
# Use the merge function to match and add the activity names with the activity codes
     
       dt.tidyData <- merge(activityNames,meanStdDataSubSet)
# Make data tidy by removing ActivityCode column
       dt.tidyData$activityCode <- NULL
#
#-------------------------------------------------------------------------------------------       
# 4.Appropriately labels the data set with descriptive variable names. In tidy data this means
#    remove abreviations
#    Details for the abreviations were derived from the features_info.txt file.

#
       names(dt.tidyData) <- gsub("activityName", "ActivityName", names(dt.tidyData))
       names(dt.tidyData) <- gsub("^t", "Time", names(dt.tidyData))
       names(dt.tidyData) <- gsub("Acc", "Accelerometer", names(dt.tidyData))
       names(dt.tidyData) <- gsub("-mean", "Mean", names(dt.tidyData))
       names(dt.tidyData) <- gsub("-std", "StandardDeviation", names(dt.tidyData))
       names(dt.tidyData) <- gsub("Gyro", "Gyroscope", names(dt.tidyData))
       names(dt.tidyData) <- gsub("BodyBody", "Body", names(dt.tidyData))
       names(dt.tidyData) <- gsub("gravity", "Gravity", names(dt.tidyData))
       names(dt.tidyData) <- gsub("tBody", "TimeBody", names(dt.tidyData))
       names(dt.tidyData) <- gsub("fBody", "FrequencyBody", names(dt.tidyData))
       names(dt.tidyData) <- gsub("Mag","Magnitude", names(dt.tidyData))
       names(dt.tidyData) <- gsub("angle","Angle", names(dt.tidyData))
#     
#------------------------------------------------------------------------------------------- 
# 5.From the data set in step 4, creates a second, independent tidy data 
#    set with the average of each variable for each activity and each subject.   
#     
#
       aver.tidyData <- dt.tidyData %>% group_by(Subject,ActivityName) %>% summarize_all(funs(mean))
#     
# Save tidy data sets into .csv files for testing
       write.csv(dt.tidyData, file = 'tidyData.csv', row.names = FALSE)
       write.csv(aver.tidyData, file = 'tidyDataMeans.csv', row.names = FALSE)
# Save tidy data sets into .csv files for submission to Coursera       
       write.table(dt.tidyData, file = 'tidyData.txt', row.names = FALSE)
       write.table(aver.tidyData, file = 'tidyDataMeans.txt', row.names = FALSE)
# Test data set : Read back in and view....
       dt.test<-read.csv('tidyDataMeans.csv')     