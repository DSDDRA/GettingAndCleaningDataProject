Code Book: A list of variable and transforms used in Week 4 project

Variables:

       fileURL: Location of the project files to download for this effort.
       featureNames: table from UCI HAR Dataset/features.txt
       activityNames: table from UCI HAR Dataset/activity_labels.txt
       subjectTest: table from UCI HAR Dataset/test/subject_test.txt
       featureTest: table from UCI HAR Dataset/test/X_test.txt
       activityTestSet: table from UCI HAR Dataset/test/y_test.txt
       subjectTrain: table from UCI HAR Dataset/train/subject_train.txt
       featureTrain: table from UCI HAR Dataset/train/X_train.txt
       activityTrainSet: table from UCI HAR Dataset/train/y_train.txt
       subjectAll: combined tables (subjectTest,subjectTrain)
       activitySetAll: combined tables (activityTestSet,activityTrainSet)
       featureAll: combined tables (featureTest,featureTrain)
       joinedData: joined tables(subjectAll,activitySetAll,featureAll)
       meanStdColumns: Measurements on the mean and standard deviation for each measurement - including column 1 (subject) and col 2 (activity)
       meanStdDataSubSet:Subset of the data with only the columns activity,subject,std and mean
       dt.tidyData: table with merged activity names for clear tidy data
       aver.tidyData:From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
       
Transforms and Work to clean up code:  See comments in run_analysis.R, where each tracform and step is commented and explained.  For sake of keeping a tidy project, that is not repeated here.


