library(dplyr) 
library(plyr)

## Set Working Direcotry setwd()
setwd("~/DataScience/data/final")

## Read in data sets 
testdata <- read.table("X_test.txt")
traindata <- read.table("X_train.txt")
features <- read.table("features.txt")
activitytrain <- read.table("y_train.txt")
activitytest <- read.table("y_test.txt")
subjecttest <- read.table("subject_test.txt")
subjecttrain <- read.table("subject_train.txt")
activitylabels <- read.table("activity_labels.txt")
   
# Provide descriptive column names for each data set
colnames(testdata) <- features[,2] # <- names from features.txt applied to column names
colnames(traindata) <- features[,2] # <- names from features.txt applied to column names
colnames(activitytest) <- "activityID"
colnames(activitytrain) <- "activityID"
colnames(subjecttest) <- "subject"
colnames(subjecttrain) <- "subject"
colnames(activitylabels) <- c('activityID','activityDesc')

# Join activity data sets with activity labels to get appropriate descriptions into final data set
activitytest <- inner_join(activitytest, activitylabels, by = "activityID")
activitytrain <- inner_join(activitytrain, activitylabels, by = "activityID")

# Append data sets for subject and activity to main data sets
testdata2 <- cbind(subjecttest, activitytest, testdata)
traindata2 <- cbind(subjecttrain, activitytrain, traindata)

# Bind test and training data sets into a final tidy data set
alldata <- rbind(testdata2, traindata2)

# Selecting only needed columns for subject, activity, mean and standard deviation. Removing all others.
# Using grepl to get TRUE for all columns I want to keep.
getfinalcolumns <- (grepl("activity..",colnames(alldata)) | grepl("subject",colnames(alldata)) 
                    | grepl("-mean..",colnames(alldata)) & !grepl("-meanFreq..",colnames(alldata)) & !grepl("mean..-[X-Z]",colnames(alldata))
                    | grepl("-std..",colnames(alldata)) & !grepl("-stdFreq..",colnames(alldata)) & !grepl("std..-[X-Z]",colnames(alldata)))

# Get just the columns I need for final data set
alldata = alldata[getfinalcolumns==TRUE]

# Apply friendly column names for feature columns
colnames(alldata) = gsub("\\()","",colnames(alldata))
colnames(alldata) = gsub("^t","Time",colnames(alldata))
colnames(alldata) = gsub("^f","Freq",colnames(alldata))
colnames(alldata) = gsub("[Mm]ag","Magnitude",colnames(alldata))
colnames(alldata) = gsub("Acc","Accel",colnames(alldata))
colnames(alldata) = gsub("BodyBody","Body",colnames(alldata))

# Extract a data subset that is an average by subject and activity using ddply from plyr package
alldata_summary <- ddply(alldata, .(subject, activityID, activityDesc), function(m)colMeans(m[, 4:21]))

# Write final tidy data set to a file
write.table(alldata_summary, "tidy_data.txt", row.names=FALSE,sep='\t')