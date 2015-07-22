## Coursera Course: Getting and Cleaning Data
## Course Project
## Author: Jigme Norbu.


setwd("C:/Users/Jigme505/Desktop/DATA SCIENCE COURSEs/3 - Getting and Cleaning Data/Course Project")

## Loading data
# Training
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Testing
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# reading in the tables for column names and activity labels
features <-read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")


## Concartinating (combining) the test and the training data set
x_full <- rbind(x_train,x_test)
y_full <- rbind(y_train, y_test)
subject_full <-rbind(subject_train, subject_test)
Subject <- as.factor(subject_full$V1) ## creating a factor variable for subjects 1:30



## changing the column names in x_full by matching it to the features list
names(x_full) <- paste(features$V2, 1:ncol(x_full))
  

## Notice that from the features.txt file, the variables with mean and std measurements 
## are located in a fixed column intervals and so the following code generates a vector 
## call "col_index" that contains the column numbers of the variables that we are interested in.

col_index <- vector()
for (i in seq(0,160,40)){
  for (j in 1:6){
    col_index<- c(col_index, i+j)
  }
}


for (i in seq(200,253,13)){
  for (j in 1:2){
    col_index<- c(col_index, i+j)
  }
}


for (i in seq(265,423,79)){
  for (j in 1:6){
    col_index<- c(col_index, i+j)
  }
}

for (i in seq(502,541,13)){
  for (j in 1:2){
    col_index<- c(col_index, i+j)
  }
}


x_full_subs <- x_full[,col_index]

## creating a new vector that assigns the activity label from activity_labels 
## to the activity index in y.

y_activity_labels <- vector()
for(i in y_full$V1){
  for (j in activity_labels$V1){
    if (i==j){ 
      y_activity_labels <- c(y_activity_labels, as.character(activity_labels$V2[j])) }
  }
}

## create a new data frame with both the index and activity labels in it.
y_full_new <- data.frame(y_full, y_activity_labels)

## rename the columns
names(y_full_new) <- paste(c("Activity_index", "Activity_labels"))
#names(subject_full) <- paste("Subject")

## Creating the Merged data frame.
merged_data <- data.frame(Subject, y_full_new, x_full_subs)

head(names(merged_data))



# Tidy new
tidy_data_ind <- aggregate(merged_data[,(3:69)], list(Subject=merged_data$Subject, 
                                                      Labels=merged_data$Activity_labels), 
                           mean)
tidy_data_ind <- tidy_data_ind[,-3]