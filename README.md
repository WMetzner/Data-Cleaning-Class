# Data-Cleaning-Class
Author:		Wolf Metzner
Class:		Getting and Cleaning Data
Date:		  01/25/2015
Submittal files for Data Cleaning Class at Coursera

This repository has the submittal files for the class project for the Data Cleaning Class:
1. Read.mk - yo are reading it
2. run_analysis.R - the script which pulls the data down and creates the requested output file
3. CodeBook.mk - description of the variables in the output data set

The purpose of this class is to demonstrate skills in obtaining and cleaning data.
The deliverables for this project are:
* the script run_analysis.R which performs all the functions necessary
* the  result of running the script, i.e. a tidy data set 
* this README.mk file, providing additional insights into the project
* the DataBook.mk, explaining the details of the resulting tidy data set.

The run_analysis.R script follows the steps of the class project:

Step 0. Download and Analyse the Dataset
----------------------------------------

According to the instructions, the data set was downloaded from:
    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
* Use the download.file function to retrieve the file; 
  since this is a binary zip archive, make sure to use method='internal' and mode='wb';
* Use the unzip command to retrieve the file structure from the zip archive and place it
  into the local working directory.

Important files for this project:
	UCI HAR Dataset/activity.txt				6 activity labels
	UCI HAR Dataset/features.txt				561 features, describing the columns in X_...txt files
	UCI HAR Dataset/test/X_test.txt             2947 observations, column headers in features.txt
	UCI HAR Dataset/test/Y_test.txt				2947 activity labels for the observations in X_test.txt
	UCI HAR Dataset/test/subject_test.txt		2947 ids for subjects being tested, range 2-24
	UCI HAR Dataset/train/X_train.txt			7352 observations, column headers in features.txt
	UCI HAR Dataset/train/Y_train.txt			7352 activity labels for observations
	UCI HAR Dataset/train/subject_train.txt		7352 ids for subjects being trained, range 1-30


Step 1. Merge the training and the test sets to create one data set
        Extract only the measurements on the mean and standard deviation for each measurement
		Uses descriptive activity names to name the activities in the data set
---------------------------------------------------------------------------------------------
Activity names:
	The six names are read from file [UCI HAR Dataset/activity.txt].
	I left the formatting untouched, i.e. the leading digit in the description to allow 
	consistent sorting later on. To just use the text label, use the strplit function.
Features:
	The test and train data sets share the same column labels.
	Thus the labels are read first from the file [UCI HAR Dataset/features.txt] and then converted
	into two vectors:
	* vCols is the list of features that are to be extracted, i.e. only columns whose names 
	  contain [-mean()], [-std()] and [???] are extracted.
	* vWidths is a vector of length 561, indicating the column widths to be read;
	  negative entries identify columns to be skipped.
The resulting data set has 10,299 observations and 82 variables. This is a tidy data set because:
* Each row represents an independent observation, a snapshot in time combining categorical data such as
  project section (test or train), subject id and activity description and measurement data originating
  from the cell phone.
* Each column refers to one and only one variable, mostly numeric measurements.
* The entire dataset contains 

Step 4. Appropriately label the data set with descriptive variable names
------------------------------------------------------------------------
We use descriptive labels for the first three variables.
The labels for the remaining 79 variables are taken from the file [UCI HAR Dataset/activity.txt]. 
To make these proper variable names, we remove the opening and closing parens and replace minus
with underscore; thus we can use the column names as variable names in the next step.
The resulting data set has 10,299 observations and the following variables:
	1.	Data-Set		source of the observation: "test" or "train"
	2.	Subject-ID		taken from the subject_test.txt resp. subject_train.txt file
	3.	Activity		the activity label taken from the Y_test.txt (Y_train.txt) file,
						replaced by the label text from the activity.txt file
	4..82.				variables taken from X_test.txt ( X_train.txt), only ...mean() and ... std()


Step 5: From the data set in step 4, create a second, independent tidy data set with the average of 
		each variable for each activity and each subject
----------------------------------------------------------------------------------------------------

First, the activity codes must be converted from factors into strings; this is for the ddply function ( see below) to work properly.
Then the ddply function is applied for each of the 79 measurements to replace the individual measurements with their averages, 
calculated over groups of SUBJECT_IDs and Activity codes.
The script employs 79 individual statements for this; I am sure there is a better solution, however, I did not find it.
At the end, the unique function is used to remove the duplicate rows from the data frame, leaving averages for 121 unique 
combinations of activity and subject.
Since the original data set was tidy, we find this data set also tidy.


Step 6: Create local data file for the aggregated data set
----------------------------------------------------------
The last data frame is exported as a txt file created with write.table() using row.name=FALSE.

Note: For some reason the script runs sometimes into a warning and stops executing. 
      Also, R keeps bombing out on me; sorry, not enought time to resolve all this.
      
