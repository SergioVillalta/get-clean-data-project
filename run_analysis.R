library(dplyr)
##  This function will read the data from the folders
##      UCI HAR Dataset: read data for activities and features
##      UCI HAR Dataset\train: read information from text files x_train, y_train, subject_train
##      UCI HAR Dataset\test: read information from text files x_train, y_train, subject_train
##  Parameters:
##      path: directory where the Folder structure for this assignments is located
run_analysis <- function(path = "UCI HAR Dataset", writeFile = TRUE){
    
    if(is.null(path) || path == ""){
        message("Directory not valid.")
        stop()
    }
    ## 1. READING THE DATA
    message("1. READING THE DATA...")
    ## Reading features information
    message("Loading features.txt file...")
    features <- read.table(paste(path, "\\features.txt",sep=""))
    message("Loading activity_labels.txt file...")
    activities <- read.table(paste(path, "\\activity_labels.txt",sep=""))
    ## Reading train information
    message("Loading x_train.txt file...")
    trainX <- read.table(paste(path, "\\train\\x_train.txt",sep=""))
    message("Loading y_train.txt file...")
    trainY <- read.table(paste(path, "\\train\\y_train.txt" , sep = ""))
    message("Loading subject_train.txt file...")
    trainSubject <- read.table(paste(path, "\\train\\subject_train.txt", sep = ""))
    
    ## Reading test information
    message("Loading x_test.txt file...")
    testX <- read.table(paste(path, "\\test\\x_test.txt", sep = ""))
    message("Loading y_test.txt file...")
    testY <- read.table(paste(path, "\\test\\y_test.txt", sep = ""))
    message("Loading subject_test.txt file...")
    testSubject <- read.table(paste(path, "\\test\\subject_test.txt", sep = ""))
    message("Loading data successful...")
    
    ## 2. TRANSFORMING THE DATA
    message("2. TRANSFORMING THE DATA...")
    trainY <- merge(trainY,activities,by.x = "V1", by.y = "V1", all = FALSE)
    testY <- merge(testY,activities,by.x = "V1", by.y = "V1", all = FALSE)
    
    colnames(trainY) <- c("ActivityId", "Activity")
    colnames(testY) <- c("ActivityId", "Activity")
    
    colnames(trainSubject) <- c("SubjectId")
    colnames(testSubject) <- c("SubjectId")
    
    ## Adding Observation Id to train data set
    message("Adding Observation ID to Train and Test data sets")
    XObsId <- seq(from = 1, to = length(trainX[,1]))
    trainX <- cbind(ObsId = XObsId,trainX)
    YObsId <- seq(from = 1, to = length(trainY[,1]))
    trainY <- cbind(ObsId = YObsId,trainY)
    SubjectObsId <- seq(from = 1, to = length(trainSubject[,1]))
    trainSubject <- cbind(ObsId = SubjectObsId,trainSubject)
    
    ## Adding Observation Id to test data set
    
    XObsId <- seq(from = 1, to = length(testX[,1]))
    testX <- cbind(ObsId = XObsId,testX)
    YObsId <- seq(from = 1, to = length(testY[,1]))
    testY <- cbind(ObsId = YObsId,testY)
    SubjectObsId <- seq(from = 1, to = length(testSubject[,1]))
    testSubject <- cbind(ObsId = SubjectObsId,testSubject)
    
    ## 3. MERGING THE DATA
    message("3. MERGING THE DATA...")
    trainData <- merge(trainX,trainY,by.x = "ObsId", by.y = "ObsId", all = FALSE)
    trainData <- merge(trainData, trainSubject,by.x = "ObsId", by.y = "ObsId", all = FALSE )
    
    message("Merging test data sets")
    testData <- merge(trainX,trainY,by.x = "ObsId", by.y = "ObsId", all = FALSE)
    testData <- merge(testData,testSubject,by.x = "ObsId", by.y = "ObsId", all = FALSE)
    
    
    ## 4. UNITING THE DATA
    message("4. UNITING THE DATA...")
    message("Adding Observation Type Column")
    trainData <- cbind(ObsType = "Train", trainData)
    testData <- cbind(ObsType = "Test", testData)
    analysisDataSet <- rbind(trainData,testData)
    analysisDataSet <- select(analysisDataSet, ObsType, ObsId, SubjectId, ActivityId, Activity, 3:563)
    
    ## renaming columns for X train and test
    message("Renaming columns to feature")
    feat <- as.character(features$V2)
    cols <- c("ObsType","ObsId","SubjectId","ActivityId","Activity")
    cols <- make.names(c(cols,feat),unique = TRUE)
    colnames(analysisDataSet) <- cols  
    if(writeFile==TRUE){
        message("Writing to output file resultAnalysis.txt")
        write.table(analysisDataSet, file = "resultAnalysis.txt")
    }
    
    ## 5. SUMMARIZING THE DATA
    message("5. SUMMARIZING THE DATA...")
    gbds <- select(analysisDataSet,-(ObsId))
    gbds <- group_by(gbds, ObsType, SubjectId, ActivityId, Activity)
    resultSummary <- summarise_each(gbds, funs(mean))
    if(writeFile==TRUE){
        message("Writing to output file resultSummary.txt")
        write.table(resultSummary, file = "resultSummary.txt")
    }
    print(cols)
    resultSummary
    # View(analysisDataSet)
}
