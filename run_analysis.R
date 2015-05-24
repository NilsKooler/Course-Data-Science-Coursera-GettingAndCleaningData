# This program has been run and tested with R studio and windows 7
# Please make sure everything is in the right working directory. 
# It is assumed that the data file is downloaded and unzipped in the working directory

# The requirements for this run_analysis.R file can be found here:
# See https://class.coursera.org/getdata-014/human_grading/view/courses/973501/assessments/3/submissions
# The 5 following requirements are mentioned. These requirements are implemented in the script underneet. 
# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Requirement 1
X_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", header = FALSE)
X_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
X <- rbind(X_train, X_test)
Y <- rbind(y_train, y_test)
S <- rbind(subject_train, subject_test)

#Requirement 2
features <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")
names(features) <- c('feat_id', 'feat_name')
index_features <- grep("-mean\\(\\)|-std\\(\\)", features$feat_name) 
X <- X[, index_features] 
names(X) <- gsub("\\(|\\)", "", (features[index_features, 2]))
  
#Requirement 3 and 4
activities <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
names(activities) <- c('act_id', 'act_name')
Y[, 1] = activities[Y[, 1], 2]
names(Y) <- "Activity"
names(S) <- "Subject"
tidyDataSet <- cbind(S, Y, X)
View(tidyDataSet)

# Requirement 5
tDs <- tidyDataSet[, 3:dim(tidyDataSet)[2]] 
tidyDataSetAVG <- aggregate(tDs,list(tidyDataSet$Subject, tidyDataSet$Activity), mean)
names(tidyDataSetAVG)[1] <- "Subject"
names(tidyDataSetAVG)[2] <- "Activity"
View(tidyDataSetAVG)

# Create Data text file as result which needs to be uploaded for the first question in the assignment  
dataFile <- "./tidy-data-AVG.txt"  
write.table(tidyDataSetAVG, dataFile, row.name=FALSE)

#Create a codebook which is also requested in the assignment
#This code provide a codebook or datadictionary like the one in Quiz 1
##install.packages("memisc")
library(memisc)
DS <- data.set(tidyDataSetAVG)
codeBook <- codebook(DS)

fileConn <- file("Codebook.txt","w")
writeLines("                    Data Dictionary Tidy Data AVG", fileConn)
writeLines(" ", fileConn)
writeLines(" ", fileConn)
close(fileConn)
print(codeBook)

#Manually copy print output codeBook to de Codebook.txt. This wil be automated later ;)


