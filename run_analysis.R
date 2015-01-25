#
#   script run_analysis.R
#   Wolf Metzner, 01/25/2015
#
#   setwd( 'D:/iMedici/Library/2014-12 Coursera, Big Data Signature Track/2015-01 Getting and Cleaning Data/Project')
#

nJob <- -1 # used for development of this script to control execution of individual steps

# handy function to display message with time stamp
tmessage <- function( cMsg) 
    message( paste( strsplit( as.character( Sys.time()), ' ')[[1]][2], ' ', cMsg))

#   Step 0. Download the Dataset
#   ----------------------------
if( nJob == -1 | nJob == 0) {
    tmessage( 'Step 0: Downloading data set ...')
    download.file( 
        'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', 
        destfile='getdata-projectfiles-UCI HAR Dataset.zip', 
        method='internal', 
        mode='wb')
    tmessage( 'Step 0: Unzipping data set ...')
    unzip( 'getdata-projectfiles-UCI HAR Dataset.zip')
    tmessage( 'Step 0: complete')
    }

#   Step 1. Merge the training and the test sets to create one data set
#   -------------------------------------------------------------------
#
# Final structure:
# col1: data set name, i.e. "test" or "train"
# col2: subject_id from .../subject_test.txt (.../subject_train.txt)
# col3: activity code from .../y_test.txt, replace with text label from .../activity_labels.txt

if( nJob == -1 | nJob == 1) {
    tmessage( 'Step 1: Prepare common variables ...')

# read activities both for test and train
    vActivities <- readLines( 'UCI HAR Dataset/activity_labels.txt')

# read features and convert to plain text labels
    vFeatures <- readLines( 'UCI HAR Dataset/features.txt')
    vCols <- vFeatures[ regexpr( '-mean()', vFeatures) > 0 | regexpr( '-std()', vFeatures) > 0]
    vCols <- sapply( vCols, function( cCol) { strsplit( cCol, ' ')[[1]][2]})

# create vector to control the columns to be loaded; +16=include, -16=drop columns
    vWidths <- 
        sapply( vFeatures, 
                function( cCol) 
                { if( regexpr( '-mean()', cCol) > 0 | regexpr( '-std()', cCol) > 0) 16 else -16})

# read test activities and replace with their descriptive names
    tmessage( 'Step 1: Read test activities ...')
    vActTest <- readLines( 'UCI HAR Dataset/test/y_test.txt')
    vActTest <- sapply( vActTest, function( cCode) vActivities[ as.integer( cCode)])

# create data frame with the first three columns
    tmessage( 'Step 1: Read test data ...')
    dfTest <- cbind( 'test', readLines( 'UCI HAR Dataset/test/subject_test.txt'), vActTest)

# read test data and append to dfTest data frame
    dfTest <- cbind( dfTest, 
            read.fwf( 
                'UCI HAR Dataset/test/X_test.txt', 
                vWidths, sep='', col.names=vCols))
    colnames( dfTest) <- c( 'Data-Set', 'Subject-ID', 'Activity', vCols)
    rownames( dfTest) <- NULL

# create train data frame and append to test data frame, copied code from above
    tmessage( 'Step 1: Read train activities ...')
    vActTrain <- readLines( 'UCI HAR Dataset/train/y_train.txt')
    vActTrain <- sapply( vActTrain, function( cCode) vActivities[ as.integer( cCode)])
    tmessage( 'Step 1: Read train data ...')
    dfTrain <- cbind( 'train', readLines( 'UCI HAR Dataset/train/subject_train.txt'), vActTrain)
    dfTrain <- cbind( dfTrain, 
             read.fwf( 
                 'UCI HAR Dataset/train/X_train.txt', 
                 vWidths, sep='', col.names=vCols))
    colnames( dfTrain) <- c( 'Data-Set', 'Subject-ID', 'Activity', vCols)
    rownames( dfTrain) <- NULL

# create combined data set
    tmessage( 'Step 1: Create combined data set ...')
    dfData <- rbind( dfTest, dfTrain)
    rownames( dfData) <- NULL
    colnames( dfData) <- c( 'Data-Set', 'Subject-ID', 'Activity', vCols)
    tmessage( 'Step 1: Completed')
    }

#   Step 4: Appropriately label the data set with descriptive variable names
#   ------------------------------------------------------------------------
if( nJob == -1 | nJob == 4) {
    tmessage( 'Step 4: Label the data set ...')

# set rownames to NULL
    rownames( dfData) <- NULL

# set colnames to the activity names, however remove parens and minus
    vCols <- sapply( vCols, function( cCol) gsub( '-', '_', gsub( '\\(\\)', '', cCol)))
    colnames( dfData) <- c( 'Data_Set', 'Subject_ID', 'Activity', vCols)

    tmessage( 'Step 4: Completed')
    }

#   Step 5: Prepare second data set with the average of each variable for each activity and each subject
#   ---------------------------------------------------------------------------------------------------
if( nJob == -1 | nJob == 5) {
    tmessage( 'Step 5: Installing dplyr library ...')
    install.packages("dplyr")
    library( plyr)
    tmessage( 'Step 5: Prepare second data set ...')
    dfData1 <- data.frame( lapply( dfData, as.character), stringsAsFactors=FALSE)
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyAcc_mean_X=mean( as.numeric( tBodyAcc_mean_X)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyAcc_mean_Y=mean( as.numeric( tBodyAcc_mean_Y)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyAcc_mean_Z=mean( as.numeric( tBodyAcc_mean_Z)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyAcc_std_X=mean( as.numeric( tBodyAcc_std_X)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyAcc_std_Y=mean( as.numeric( tBodyAcc_std_Y)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyAcc_std_Z=mean( as.numeric( tBodyAcc_std_Z)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tGravityAcc_mean_X=mean( as.numeric( tGravityAcc_mean_X)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tGravityAcc_mean_Y=mean( as.numeric( tGravityAcc_mean_Y)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tGravityAcc_mean_Z=mean( as.numeric( tGravityAcc_mean_Z)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tGravityAcc_std_X=mean( as.numeric( tGravityAcc_std_X)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tGravityAcc_std_Y=mean( as.numeric( tGravityAcc_std_Y)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tGravityAcc_std_Z=mean( as.numeric( tGravityAcc_std_Z)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyAccJerk_mean_X=mean( as.numeric( tBodyAccJerk_mean_X)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyAccJerk_mean_Y=mean( as.numeric( tBodyAccJerk_mean_Y)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyAccJerk_mean_Z=mean( as.numeric( tBodyAccJerk_mean_Z)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyAccJerk_std_X=mean( as.numeric( tBodyAccJerk_std_X)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyAccJerk_std_Y=mean( as.numeric( tBodyAccJerk_std_Y)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyAccJerk_std_Z=mean( as.numeric( tBodyAccJerk_std_Z)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyGyro_mean_X=mean( as.numeric( tBodyGyro_mean_X)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyGyro_mean_Y=mean( as.numeric( tBodyGyro_mean_Y)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyGyro_mean_Z=mean( as.numeric( tBodyGyro_mean_Z)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyGyro_std_X=mean( as.numeric( tBodyGyro_std_X)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyGyro_std_Y=mean( as.numeric( tBodyGyro_std_Y)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyGyro_std_Z=mean( as.numeric( tBodyGyro_std_Z)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyGyroJerk_mean_X=mean( as.numeric( tBodyGyroJerk_mean_X)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyGyroJerk_mean_Y=mean( as.numeric( tBodyGyroJerk_mean_Y)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyGyroJerk_mean_Z=mean( as.numeric( tBodyGyroJerk_mean_Z)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyGyroJerk_std_X=mean( as.numeric( tBodyGyroJerk_std_X)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyGyroJerk_std_Y=mean( as.numeric( tBodyGyroJerk_std_Y)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyGyroJerk_std_Z=mean( as.numeric( tBodyGyroJerk_std_Y)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyAccMag_mean=mean( as.numeric( tBodyAccMag_mean)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyAccMag_std=mean( as.numeric( tBodyAccMag_std)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tGravityAccMag_mean=mean( as.numeric( tGravityAccMag_mean)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tGravityAccMag_std=mean( as.numeric( tGravityAccMag_std)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyAccJerkMag_mean=mean( as.numeric( tBodyAccJerkMag_mean)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyAccJerkMag_std=mean( as.numeric( tBodyAccJerkMag_std)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyGyroMag_mean=mean( as.numeric( tBodyGyroMag_mean)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyGyroMag_std=mean( as.numeric( tBodyGyroMag_std)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyGyroJerkMag_mean=mean( as.numeric( tBodyGyroJerkMag_mean)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, tBodyGyroJerkMag_std=mean( as.numeric( tBodyGyroJerkMag_std)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAcc_mean_X=mean( as.numeric( fBodyAcc_mean_X)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAcc_mean_Y=mean( as.numeric( fBodyAcc_mean_Y)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAcc_mean_Z=mean( as.numeric( fBodyAcc_mean_Z)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAcc_std_X=mean( as.numeric( fBodyAcc_std_X)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAcc_std_Y=mean( as.numeric( fBodyAcc_std_Y)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAcc_std_Z=mean( as.numeric( fBodyAcc_std_Z)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAcc_meanFreq_X=mean( as.numeric( fBodyAcc_meanFreq_X)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAcc_meanFreq_Y=mean( as.numeric( fBodyAcc_meanFreq_Y)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAcc_meanFreq_Z=mean( as.numeric( fBodyAcc_meanFreq_Z)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAccJerk_mean_X=mean( as.numeric( fBodyAccJerk_mean_X)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAccJerk_mean_Y=mean( as.numeric( fBodyAccJerk_mean_Y)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAccJerk_mean_Z=mean( as.numeric( fBodyAccJerk_mean_Z)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAccJerk_std_X=mean( as.numeric( fBodyAccJerk_std_X)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAccJerk_std_Y=mean( as.numeric( fBodyAccJerk_std_Y)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAccJerk_std_Z=mean( as.numeric( fBodyAccJerk_std_Z)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAccJerk_meanFreq_X=mean( as.numeric( fBodyAccJerk_meanFreq_X)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAccJerk_meanFreq_Y=mean( as.numeric( fBodyAccJerk_meanFreq_Y)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAccJerk_meanFreq_Z=mean( as.numeric( fBodyAccJerk_meanFreq_Z)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyGyro_mean_X=mean( as.numeric( fBodyGyro_mean_X)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyGyro_mean_Y=mean( as.numeric( fBodyGyro_mean_Y)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyGyro_mean_Z=mean( as.numeric( fBodyGyro_mean_Z)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyGyro_std_X=mean( as.numeric( fBodyGyro_std_X)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyGyro_std_Y=mean( as.numeric( fBodyGyro_std_Y)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyGyro_std_Z=mean( as.numeric( fBodyGyro_std_Z)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyGyro_meanFreq_X=mean( as.numeric( fBodyGyro_meanFreq_X)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyGyro_meanFreq_Y=mean( as.numeric( fBodyGyro_meanFreq_Y)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyGyro_meanFreq_Z=mean( as.numeric( fBodyGyro_meanFreq_Z)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAccMag_mean=mean( as.numeric( fBodyAccMag_mean)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAccMag_std=mean( as.numeric( fBodyAccMag_std)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyAccMag_meanFreq=mean( as.numeric( fBodyAccMag_meanFreq)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyBodyAccJerkMag_mean=mean( as.numeric( fBodyBodyAccJerkMag_mean)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyBodyAccJerkMag_std=mean( as.numeric( fBodyBodyAccJerkMag_std)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyBodyAccJerkMag_meanFreq=mean( as.numeric( fBodyBodyAccJerkMag_meanFreq)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyBodyGyroMag_mean=mean( as.numeric( fBodyBodyGyroMag_mean)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyBodyGyroMag_std=mean( as.numeric( fBodyBodyGyroMag_std)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyBodyGyroMag_meanFreq=mean( as.numeric( fBodyBodyGyroMag_meanFreq)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyBodyGyroJerkMag_mean=mean( as.numeric( fBodyBodyGyroJerkMag_mean)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyBodyGyroJerkMag_std=mean( as.numeric( fBodyBodyGyroJerkMag_std)))
    dfData1 <- ddply( dfData1, c( 'Subject_ID', 'Activity'), transform, fBodyBodyGyroJerkMag_meanFreq=mean( as.numeric( fBodyBodyGyroJerkMag_meanFreq)))

# remove duplicate rows
    dfData1 <- unique( dfData1)

# drop first column, i.e. row source
    dfData1 <- dfData1[, 2:82]
    tmessage( 'Step 5: Completed')
    }

#   Step 6: Create local data files for the detail and aggregated data sets
#   -----------------------------------------------------------------------

if( nJob == -1 | nJob == 6) {
    tmessage( 'Step 6: Create local data files for the detail and aggregated data sets ...')
    write.table( dfData1, file='dfData1.txt', append=FALSE, row.names=FALSE)
    }
