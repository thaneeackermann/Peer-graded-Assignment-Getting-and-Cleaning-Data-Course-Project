# Installing and loading the required packages
install.packages("dplyr")
library(dplyr)

# Download the data set
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "Dataset.zip", mode = "wb")

# Unzip the data
dataset <- unzip("Dataset.zip")

# Read in and assign all the different data frames
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)

y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)

y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

# Merge the training and the test sets to create one data set
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
data_merged <- cbind(subject, y, x)

# Extract only the measurements on the mean and standard deviation for each measurement.
tidy_data <- data_merged %>% select(subject, code, contains("mean"), contains("std"))

# Use descriptive activity names to name the activities in the data set.
tidy_data$code <- activities[tidy_data$code, 2]

# Label the data set with the appropriate variable names
names(tidy_data)[2] = "activity"
names(tidy_data) <- gsub("^t", "Time", names(tidy_data))
names(tidy_data) <- gsub("^f", "Frequency", names(tidy_data))
names(tidy_data) <- gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data) <- gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data) <- gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data) <- gsub(".freq()", "Frequency", names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub(".meaFrequency", "MeanFrequency", names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub(".mean()", "Mean", names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub(".std()", "StandardDeviation", names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data) <- gsub("angle", "Angle", names(tidy_data))
names(tidy_data) <- gsub("gravity", "Gravity", names(tidy_data))
names(tidy_data) <- gsub("tBody", "TimeBody", names(tidy_data))
names(tidy_data) <- gsub(".tBody", "TimeBody", names(tidy_data))

# Create a second, independent tidy data set with the average of each variable for each activity and each subject.
final_data <- tidy_data %>% group_by(subject, activity) %>% summarise_all(list(mean))

# Output to file "final_data.txt"
write.table(final_data, "final_data.txt", row.names = FALSE)



