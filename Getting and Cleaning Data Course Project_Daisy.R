library(dplyr)

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activity <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("n", "activity"))
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "nb")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "nb")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

#1 Merges the training and the test sets to create one data set.
train<- cbind(subject_train,x_train,y_train)
test<-cbind(subject_test,y_test,x_test)
Mer_dt<-rbind(train,test)
#2 Extracts only the measurements on the mean and standard deviation for each measurement.
A <- Mer_dt %>% select(subject, nb, contains("mean"), contains("std"))

#3 Uses descriptive activity names to name the activities in the data set
A$nb <- activity[A$nb, 2]

#4 Appropriately labels the data set with descriptive variable names.
names(A)[2] = "activity"
names(A)<-gsub("^t", "time", names(A))
names(A)<-gsub("^f", "frequency", names(A))
names(A)<-gsub("Acc", "Accelerometer", names(A))
names(A)<-gsub("Gyro", "Gyroscope", names(A))
names(A)<-gsub("std()", "std", names(A))
names(A)<-gsub("mean()", "mean", names(A))
names(A)<-gsub("Acc", "Accelerometer", names(A))
names(A)<-gsub("Gyro", "Gyroscope", names(A))
names(A)<-gsub("Mag", "Magnitude", names(A))
names(A)<-gsub("BodyBody", "Body", names(A))


#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidydata <- A %>%
  group_by(subject, activity) %>%
  summarise_all(mean)

write.table(tidydata, "UCI HAR Dataset/tidydata.txt", row.name=FALSE)