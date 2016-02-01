#install.packages("data.table")
library("data.table")

#install.packages("reshape2")
library("reshape2")

#Working folder
dirName <- "skvasant"

#Create working folder if it does not exist
if (!file.exists(dirName)) {
  dir.create(dirName)
}

#Set zip file absolute path
zipAbsolutePath <- file.path(dirName, "UCI HAR Dataset.zip")

##Get the data
print("Get the data")

#Download the source zip file
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = zipAbsolutePath)
###
#trying URL 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
#Content type 'application/zip' length 62556944 bytes (59.7 MB)
#downloaded 59.7 MB
###

#Unzip the downloaded file
unzip(zipfile = zipAbsolutePath,overwrite = TRUE,exdir = dirName)

#Set extracted files path
exDirName <- file.path(dirName, "UCI HAR Dataset")
list.files(exDirName, recursive = TRUE)
###
# [1] "activity_labels.txt"                          "features.txt"                                
# [3] "features_info.txt"                            "README.txt"                                  
# [5] "test/Inertial Signals/body_acc_x_test.txt"    "test/Inertial Signals/body_acc_y_test.txt"   
# [7] "test/Inertial Signals/body_acc_z_test.txt"    "test/Inertial Signals/body_gyro_x_test.txt"  
# [9] "test/Inertial Signals/body_gyro_y_test.txt"   "test/Inertial Signals/body_gyro_z_test.txt"  
#[11] "test/Inertial Signals/total_acc_x_test.txt"   "test/Inertial Signals/total_acc_y_test.txt"  
#[13] "test/Inertial Signals/total_acc_z_test.txt"   "test/subject_test.txt"                       
#[15] "test/X_test.txt"                              "test/y_test.txt"                             
#[17] "train/Inertial Signals/body_acc_x_train.txt"  "train/Inertial Signals/body_acc_y_train.txt" 
#[19] "train/Inertial Signals/body_acc_z_train.txt"  "train/Inertial Signals/body_gyro_x_train.txt"
#[21] "train/Inertial Signals/body_gyro_y_train.txt" "train/Inertial Signals/body_gyro_z_train.txt"
#[23] "train/Inertial Signals/total_acc_x_train.txt" "train/Inertial Signals/total_acc_y_train.txt"
#[25] "train/Inertial Signals/total_acc_z_train.txt" "train/subject_train.txt"                     
#[27] "train/X_train.txt"                            "train/y_train.txt"
###

##Read the files
print("Read the files")

#Read the subject files
dtSubjectTrain <- fread(file.path(exDirName, "train", "subject_train.txt"))
dtSubjectTest <- fread(file.path(exDirName, "test", "subject_test.txt"))

#Read the activity files
dtActivityTrain <- fread(file.path(exDirName, "train", "Y_train.txt"))
dtActivityTest <- fread(file.path(exDirName, "test", "Y_test.txt"))

#Method to convert file to data table
fileToDataTable <- function(file) {
    dataFile <- read.table(file)
    dataTable <- data.table(dataFile)
}

#Read the data files
dtTrain <- fileToDataTable(file.path(exDirName, "train", "X_train.txt"))
dtTest <- fileToDataTable(file.path(exDirName, "test", "X_test.txt"))

##Merge the training and the test sets
print("Merge the training and the test sets")

#Concatenate the data tables
dtSubject <- rbind(dtSubjectTrain, dtSubjectTest)
setnames(dtSubject, "V1", "subject")
dtActivity <- rbind(dtActivityTrain, dtActivityTest)
setnames(dtActivity, "V1", "activityNum")
dt <- rbind(dtTrain, dtTest)

#Merge columns
dtSubject <- cbind(dtSubject, dtActivity)
dt <- cbind(dtSubject, dt)

#Set key
setkey(dt, subject, activityNum)

##Extract only the mean and standard deviation
print("Extract only the mean and standard deviation")

#Read the 'features.txt' file. This tells which variables in 'dt' are measurements for the mean and standard deviation.
dtFeatures <- fread(file.path(exDirName, "features.txt"))
setnames(dtFeatures, names(dtFeatures), c("featureNum", "featureName"))

#Subset only measurements for the mean and standard deviation
dtFeatures <- dtFeatures[grepl("mean\\(\\)|std\\(\\)", featureName)]

#Convert the column numbers to a vector of variable names matching columns in 'dt'
dtFeatures$featureCode <- dtFeatures[, paste0("V", featureNum)]
head(dtFeatures)
###
#   featureNum       featureName featureCode
#1:          1 tBodyAcc-mean()-X          V1
#2:          2 tBodyAcc-mean()-Y          V2
#3:          3 tBodyAcc-mean()-Z          V3
#4:          4  tBodyAcc-std()-X          V4
#5:          5  tBodyAcc-std()-Y          V5
#6:          6  tBodyAcc-std()-Z          V6
###
dtFeatures$featureCode
###
# [1] "V1"   "V2"   "V3"   "V4"   "V5"   "V6"   "V41"  "V42"  "V43"  "V44"  "V45"  "V46"  "V81"  "V82" 
#[15] "V83"  "V84"  "V85"  "V86"  "V121" "V122" "V123" "V124" "V125" "V126" "V161" "V162" "V163" "V164"
#[29] "V165" "V166" "V201" "V202" "V214" "V215" "V227" "V228" "V240" "V241" "V253" "V254" "V266" "V267"
#[43] "V268" "V269" "V270" "V271" "V345" "V346" "V347" "V348" "V349" "V350" "V424" "V425" "V426" "V427"
#[57] "V428" "V429" "V503" "V504" "V516" "V517" "V529" "V530" "V542" "V543"
###

#Subset these variables using variable names
select <- c(key(dt), dtFeatures$featureCode)
dt <- dt[, select, with = FALSE]

##Use descriptive activity names
print("Use descriptive activity names")

#Read 'activity_labels.txt' file. This will be used to add descriptive names to the activities
dtActivityNames <- fread(file.path(exDirName, "activity_labels.txt"))
setnames(dtActivityNames, names(dtActivityNames), c("activityNum", "activityName"))

##Label with descriptive activity names
print("Label with descriptive activity names")

#Merge activity labels
dt <- merge(dt, dtActivityNames, by = "activityNum", all.x = TRUE)

#Add 'activityName' as a key
setkey(dt, subject, activityNum, activityName)

#Melt the data table to reshape it from a short and wide format to a tall and narrow format
dt <- data.table(melt(dt, key(dt), variable.name = "featureCode"))

#Merge activity name
dt <- merge(dt, dtFeatures[, list(featureNum, featureCode, featureName)], by = "featureCode", all.x = TRUE)

#Create a new variable, 'activity' that is equivalent to 'activityName' as a factor class.
dt$activity <- factor(dt$activityName)

#Create a new variable, 'feature' that is equivalent to 'featureName' as a factor class.
dt$feature <- factor(dt$featureName)

#Seperate features from 'featureName' using the helper function 'grepthis'
grepthis <- function(regex) {
    grepl(regex, dt$feature)
}

#Features with 2 categories
n <- 2
y <- matrix(seq(1, n), nrow = n)
x <- matrix(c(grepthis("^t"), grepthis("^f")), ncol = nrow(y))
dt$featDomain <- factor(x %*% y, labels = c("Time", "Freq"))
x <- matrix(c(grepthis("Acc"), grepthis("Gyro")), ncol = nrow(y))
dt$featInstrument <- factor(x %*% y, labels = c("Accelerometer", "Gyroscope"))
x <- matrix(c(grepthis("BodyAcc"), grepthis("GravityAcc")), ncol = nrow(y))
dt$featAcceleration <- factor(x %*% y, labels = c(NA, "Body", "Gravity"))
x <- matrix(c(grepthis("mean()"), grepthis("std()")), ncol = nrow(y))
dt$featVariable <- factor(x %*% y, labels = c("Mean", "SD"))

#Features with 1 category
dt$featJerk <- factor(grepthis("Jerk"), labels = c(NA, "Jerk"))
dt$featMagnitude <- factor(grepthis("Mag"), labels = c(NA, "Magnitude"))

#Features with 3 categories
n <- 3
y <- matrix(seq(1, n), nrow = n)
x <- matrix(c(grepthis("-X"), grepthis("-Y"), grepthis("-Z")), ncol = nrow(y))
dt$featAxis <- factor(x %*% y, labels = c(NA, "X", "Y", "Z"))

#Check to make sure all possible combinations of 'feature' are accounted for by all possible combinations of the factor class variables.
r1 <- nrow(dt[, .N, by = c("feature")])
r2 <- nrow(dt[, .N, by = c("featDomain", "featAcceleration", "featInstrument", "featJerk", "featMagnitude", "featVariable", "featAxis")])
r1 == r2
###
#[1] TRUE
###

##Create a tidy data set
print("Create a tidy data set")

setkey(dt, subject, activity, featDomain, featAcceleration, featInstrument, featJerk, featMagnitude, featVariable, featAxis)
dtTidy <- dt[, list(count = .N, average = mean(value)), by = key(dt)]

##Save to file
print("Save to file")

tidyFile <- file.path(dirName, "human-activity-recognition-using-smartphones.txt")
write.table(dtTidy, tidyFile, row.names=FALSE)
