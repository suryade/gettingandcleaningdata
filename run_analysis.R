## This section loads up all the packages that will be required for the run_analysis script
## to run properly.

require(data.table)
require(plyr)


## The merge_all_data function merges the train and the test data sets and returns one
## large super set so to speak. For convenience I am also labeling the columns and massaging
## the data to make it more presentable in this function as well. So this satisfies the
## requirements 1, 3 and 4 of the assignment.

## Prerequisite for the function is that it needs to be told where the location of the 
## files for the train and test data sets are located. So the user needs to specify
## a full directory path.

## Step 1 it reads the test data sets and fixes up the column names if needed
## and column binds them
## Step 2 it reads the train data set and fixes up the column names if needed
## and column binds them
## Step 3 it row binds the data sets together to create the final data set and that is
## then returned back by the function

mergeAllData <- function(directory) {
    
    ## Read subject test data
    subject_test <- fread(paste0(directory, "test/subject_test.txt"))
    
    ## Rename the column
    names(subject_test) <- c("subject")
    
    X_test <- fread(paste0(directory, "test/X_test.txt"))
    
    ## Read the file that contains the what will be used as the column names
    features <- fread(paste0(directory, "features.txt"))
    
    ## However that results in 2 columns in the features data frame and we need the
    ## second column which has the names we are interested in. So I will create a 
    ## vector from the features second column
    features_col_names <- features$V2
    
    ## Do the actual renaming of the columns of the X_test data frame now
    names(X_test) <- features_col_names
    
    Y_test <-fread(paste0(directory, "test/y_test.txt"))
    
    ## We need the descriptive activity names to be present in the final merged data set
    ## So here I am reading in the activity names first
    activity_names <- fread(paste0(directory, "activity_labels.txt"))
    
    ## Now I merge the activity_names with the Y_test because I want to match up
    ## the descriptive activity names with to the activites in the data set
    Y_test <- merge(Y_test, activity_names, by.x = 'V1', by.y = 'V1')
    
    ## Now I will have a 2 column data frame with the numeric code and the corresponding
    ## activity name but I will only want the activity name column for the final merge
    Y_test <- subset(Y_test, select = c(V2))
    
    ## Rename the column
    names(Y_test) <- c("activityName")
    
    ## Do the final column bind of all the data frames
    merged_test_data <- cbind(subject_test, X_test, Y_test)
    
    ## Now handle the train data sets
    
    ## Read the subject train data
    subject_train <- fread(paste0(directory,"train/subject_train.txt"))
    
    ## Rename the column
    names(subject_train) <- c("subject")
    
    X_train <- fread(paste0(directory,"train/X_train.txt"))
    
    ## Do the actual renaming of the columns of the X_test data frame now. Note I am
    ## reusing the previously created column names vector because the names have not
    ## changed.
    names(X_train) <- features_col_names
    
    Y_train <-fread(paste0(directory,"train/y_train.txt"))
    
    ## Merge the activity names reusing the already loaded activity_names data frame
    Y_train <- merge(Y_train, activity_names, by.x = 'V1', by.y = 'V1')
    
    ## Selecting the activity names
    Y_train <- subset(Y_train, select = c(V2))
    
    ## Rename the column
    names(Y_train) <- c("activityName")
    
    ## Do the column bind of all the cleaned up train data sets
    merged_train_data <- cbind(subject_train, X_train, Y_train)
    
    ## Do the final row bind of all the train and test data
    merged_all_data <- rbind(merged_test_data, merged_train_data)
    
    ## Let's clean up the column names a bit more for the merged data set
    colNames <- names(merged_all_data)
    
    for (i in 1:length(colNames))
    {
        colNames[i] = gsub("\\()","",colNames[i])
        colNames[i] = gsub("-std$","StndrddDev",colNames[i])
        colNames[i] = gsub("-mean","Mean",colNames[i])
        colNames[i] = gsub("^(t)","time",colNames[i])
        colNames[i] = gsub("^(f)","frequency",colNames[i])
        colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
        colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
        colNames[i] = gsub("[Gg]yro","Gyroscope",colNames[i])
        colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
        colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
        colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
        colNames[i] = gsub("GyroMag","GyroscopeMagnitude",colNames[i])
    }
    
    colnames(merged_all_data) = colNames
    
    return(merged_all_data)
}


## The following function extracts the mean and standard deviation values for the 
## activity measurements. This is basically meeting requirement 2 of the assignment.

## Prerequisite is that the function will need to be passed in the cleaned and merged 
## data frame from the mergeAllData function to work properly.

extractMeanStdData <- function(merged_data) {
    
    ## Step 1 is to figure out the column names that have the string 'Mean' in them
    col_names <- grep("mean", names(merged_data), ignore.case = TRUE, perl = TRUE, value = TRUE)
    
    ## Step 2 is to subset from the original merged data set the mean columns which we 
    ## previously figured out
    grep_mean_data <- subset(merged_data, select = col_names)
    
    ## Similarly perform same steps but for the standard deviation columns. The value
    ## we are searching for in the column names is "StndrddDev"
    col_names <- grep("StndrddDev", names(merged_data), ignore.case = TRUE, perl = TRUE, value = TRUE)
    
    ## Doing the subset for the std data
    grep_std_data <- subset(merged_data, select = col_names)
    
    ## Now we combine together the mean and the std data in to one data frame
    mean_std_data <- cbind(grep_mean_data, grep_std_data)
    
    ## Adding the activityName column as well so it's more readable
    mean_std_data <- cbind(merged_data$activityName, mean_std_data)
    
    ## cbind replaced the column name with V1 so massaging it to have the appropriate
    ## column name of 'activityName'
    colnames(mean_std_data)[1] <- "activityName"
    
    return(mean_std_data)
}


## The following function creates a second independent data set with the average for
## each variable for each avtivity for each subject. This meets requirement 5 of the
## course assignment.

## Prerequisite is that the function will need to be passed in the cleaned and merged 
## data frame from the mergeAllData function to work properly.

tidyDataFrame <- function(merged_data) {
    
    ## Compute the averages across the subject and activity name
    avg_df <- ddply(merged_data, .(subject, activityName), function(x) colMeans(x[, 1:562]))
    
    ## Write out the data to a file
    write.table(avg_df, file = "averages.txt", row.name = FALSE)
    
}