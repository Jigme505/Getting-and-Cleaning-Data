---
output: pdf_document
---
# Coursera Course: Getting and Cleaning Data
## Course Project

#### Author: Jigme Norbu.

The purpose of this project is to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used analysis. 


### Loading Data

```r
## reading train data set
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

## reading test data set
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

## reading in the tables for column names and activity labels
features <-read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
```

### Merging the training and testing data sets
Since the training and testing data set together makes up the complete data set, we can just use the rbind() function to do the job.


```r
## Concartinating (combining) the test and the training data set

x_full <- rbind(x_train,x_test)
y_full <- rbind(y_train, y_test)
subject_full <-rbind(subject_train, subject_test)
Subject <- as.factor(subject_full$V1) ## creating a factor variable for subjects 1:30
```


### Renaming the Columns (Variables)
I can just use the data file "features" which has all the names of the variables in the "x_full" data in the accending order. I use the names()function which gives a vector of all the column names in "x_full" data and replaced it with the names from the features$V2 column. 

```r
## changing the column names in x_full by matching it to the features list
names(x_full) <- paste(features$V2, 1:ncol(x_full))

head(names(x_full), n = 10)
```

```
##  [1] "tBodyAcc-mean()-X 1" "tBodyAcc-mean()-Y 2" "tBodyAcc-mean()-Z 3"
##  [4] "tBodyAcc-std()-X 4"  "tBodyAcc-std()-Y 5"  "tBodyAcc-std()-Z 6" 
##  [7] "tBodyAcc-mad()-X 7"  "tBodyAcc-mad()-Y 8"  "tBodyAcc-mad()-Z 9" 
## [10] "tBodyAcc-max()-X 10"
```

### Subsetting by variables of interest
Since we want to keep only the mean and the std for each measurement I use the following subsetting method. 

* Notice that from the "features" data, the variables with mean and std measurements have patterns in their interval. So I noted the gap between the mean and the std of each measurment and then created a new numeric vector using the for loop that gives us the column number for each variable of interest.


```r
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

## subsetting
x_full_subs <- x_full[,col_index]
```

### Using descriptive activity names to name the activities in the data set

The following code creates a vector that corresponds to the activity index in the "y_full" data set and assigns the descriptive activity names (Labels) according to the index.


```r
## creating a new vector that assigns the activity label from activity_labels 
## to the activity index in y.

y_activity_labels <- vector()
for(i in y_full$V1){
     for (j in activity_labels$V1){
               if (i==j){ 
                    y_activity_labels <- c(y_activity_labels,
                                           as.character(activity_labels$V2[j]))
                    }
     }
}
```

### Replacing the Column names for the y_full data frame
Here I create a new data frame with both the index and activity labels in it. Then I rename the columns like before. 

```r
y_full_new <- data.frame(y_full, y_activity_labels)

## rename the columns
names(y_full_new) <- paste(c("Activity_index", "Activity_labels"))
#names(subject_full) <- paste("Subject")
```

## Creating the Merged data frame

Here I merge the data sets by using the data.frame() function.

```r
merged_data <- data.frame(Subject, y_full_new, x_full_subs)
```


### Independent tidy data set
From the data set "merged_data" we can then create an independent tidy data set using the function "aggregate()" which shows the average of each variable for each activity and each subject.


```r
#
tidy_data_ind <- aggregate(merged_data[,(3:69)], list(Subject=merged_data$Subject, 
                                          Labels=merged_data$Activity_labels), 
               mean)
tidy_data_ind <- tidy_data_ind[,-3]

write.table(tidy_data_ind, file="Tidy_data_set.txt", row.names = F)
```
