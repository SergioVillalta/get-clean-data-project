# GETTING AND CLEANING DATA PROJECT
## TIDY DATA PROCESSS
## run_analysis.R
### Description
The following is the detail of how the script run_analysis.R works to process the data from the UCI HAR Dataset folder and return a file with summary data.

### Usage
run_analysis(path, writeFile = TRUE)
### Arguments
* **path**: location where the UCI HAR Dataset is located. Do not include the last \\ on the path.
* **writeFile**: indicates if the program should generate the output .txt files (resultAnalysis.txt and resultSummary.txt)
### Details
The run_analysis.R can be breakdown in the following parts:
1. [Reading the Data]
Part of the process where the data is read from the .txt files in the UCI HAR Dataset folder provided.

2. [Transforming the Data]
Part of the process where observations, activities and subjects are transformed into data frames that can be associated for each type of observation.

3. [Merging the Data]
Part of the process where the data is merged to create one data frame for the TRAIN data and one for the TEST data.

4. [Uniting the Data]
Part of the process where the TRAIN and TEST data are united into one single data frame.

5. [Summarizing the Data]
Part of the process where the summary of the data is created.

#### Reading the Data
In this part of the process the data is gathered from each file using the function *read.table()*. There is one data frame for:
* Features
* Activities
* Train observations
* Train subjects
* Train activities
* Test observations
* Test subjects
* Test activities
#### Transforming the Data
In this part of the process the data frames are manipulated in order to allowed joins between them. The Activities are joined in a single data frame including the its own description.

The main step is to add an Observation Identifier to each data of the following data frames:
* Train observations
* Train subjects
* Train activities
* Test observations
* Test subjects
* Test activities

The identifier is created with the *seq()* function from 1 to the number of rows in each data frame and it is named *ObsId*. With this new identifier the Training and Test data frames will be able to be joined in one single data frame.

#### Merging the Data
In this part of the process the join between each set of data frames corresponding to Training and Test is performed. This is achieved using the *merge()* function with the Observation Identifier added in the [Transforming the Data] section.

For example:

    trainData <- merge(trainX,trainY,by.x = "ObsId", by.y = "ObsId", all = FALSE)

Where *trainX* holds the values of the observations and *trainY* the values of the activities for the Training type.
#### Uniting the Data
In this part of the process the data of the Training and the Test types of observation are united with the help of the *rbind()* function.

Prior to the use of the *rbind()* a Observation Type column is added to each of the two data frames. The name of the column is *ObsType*. The data frame for Training observation will hold the value "Train" and the Test observation will hold the value "Test".

It is worth noting that it was necessary to use the function *make.names()* in order to create unique names for the columns of each variable, as some of them repeated. For example: fBodyAcc-bandsEnergy()-1,8 existed 3 times in the features list in the position 303, 317 and 331.

#### Summarizing the Data
In this part of the process creates a second, independent tidy data set with the average of each variable for each activity and each subject. To achieve this the functions *group_by()* and *summarize_each()* are used. It is worth noting that the Observation Identifer column must be removed to perform this calculation, as this unique value will not allow to group by the columns required.

Here is also performed the writing to the .txt output files, if the *writeFile* argument is TRUE:
* **resultAnalysis.txt**: holds the data frame with the entire information prior to the create the summary. 
* **resultSummary.txt**: holds the summarized data frame.
### Notes
* This scripts depends on the *dplyr* library.
* Compatible only with Windows OS.

[//]: #
   [Reading the Data]: README.md#reading-the-data
   [Transforming the Data]: README.md#transforming-the-data
   [Merging the Data]: README.md#merging-the-data
   [Uniting the Data]: README.md#uniting-the-data
   [Summarizing the Data]: README.md#Summarizing-the-data