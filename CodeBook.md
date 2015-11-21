CODEBOOK

This document describes the variables, data, and transformations perfromed to clean up the data.

DATA SOURCE

original source:https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Website:http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

DATA

The dataset includes the following files:

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

TRANSFORMATION

1.Merges the training and the test sets to create one data set.
2.Extracts only the measurements on the mean and standard deviation for each measurement. 
3.Uses descriptive activity names to name the activities in the data set
4.Appropriately labels the data set with descriptive variable names. 
5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

IMPLEMENTATION:

A timestamp is captured for when the script is run. 
tstamp = Sys.time()
This will indicate when the dataset was last downloaded and when it was last ran.

The script checks to see if the dataset already exists, and if not, it will download and timstamp the 
data for future reference. The script will unzip the data locally in the current working
directory and will set the working directory as the newly unzipped directory.

if (!file.exists("UCI HAR Dataset")) {
  # download the data
  fileUrl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  destfile = paste("./UCI_HAR_DATA-", format(tstamp,"%Y%m%d_%H%M%S"), ".zip",sep="")
  download.file(fileUrl, destfile=destfile,method="curl")
  unzip(destfile)
  # record timestamp
  #write("",file=paste("./UCI HAR Dataset/downloaded_",format(tstamp,"%Y%m%d_%H%M%S"),sep=""))
} # end if()

#write("",file=paste("last_run_",format(tstamp,"%Y%m%d_%H%M%S"),sep=""))

setwd("./UCI HAR Dataset/")

Individual datasets of interest are brought into objects for manipulation and
aggregation later.

x.test          <- read.table("./test/X_test.txt")
x.train         <- read.table("./train/X_train.txt")
y.train         <- read.table("./train/y_train.txt")
y.test          <- read.table("./test/y_test.txt")
activity.labels <- read.table("./activity_labels.txt",stringsAsFactors = FALSE)
data.labels     <- read.table("./features.txt", stringsAsFactors = FALSE)
test.subject    <- read.table("./test/subject_test.txt")
train.subject   <- read.table("./train/subject_train.txt")


In accordance to identification of column data, mesaurement data is fused with 
label data. This will also support column filtering later in the process. Labeling 
the data prior to fusing will ensure that all data attributes will be maintained
even through process.

colnames(x.test) <- data.labels[,2]
colnames(x.train)<- data.labels[,2]
colnames(test.subject) <- c("Subject")
colnames(train.subject) <- c("Subject")

For a couple of datasets, explicit declaration of column labels is required from the
lack of labeling due to data transformation.

y.train <- data.frame(activity.labels[y.train[,1],2])
y.test  <- data.frame(activity.labels[y.test[,1],2])
colnames(y.train)<- c("Activity")
colnames(y.test) <- c("Activity")

Data is then filtered and fused based off the requirements provided. Proper order of processing
is required to ensure that data attributes are maintained. Though the labeling was accomplished
in an earlier step, proper grouping of datasets is followed to ensure data identification compliance.
  
x.test  <- x.test[grep("std|mean",data.labels[,2],ignore.case=TRUE)]
x.train <- x.train[grep("std|mean",data.labels[,2],ignore.case=TRUE)]
x.test  <- cbind(x.test,y.test,test.subject)
x.train <- cbind(x.train, y.train,train.subject)
x.merge <- merge( x.test, x.train,all=TRUE)
xmerge_table<-data.table(x.merge)
results<-xmerge_table[,lapply(.SD,mean),by=c("Subject","Activity"), .SDcols=1:(length(names(x.merge))-2)]
results<-results[order(Subject,Activity),]

When processing is complete, wrorking directory is moved one level up and data is written to a file the nomenclature,
descriptive name + hyphen + timestamp + file type.

setwd("../")

write.table(results,file=paste("tidy_set_result-",format(tstamp,"%Y%m%d_%H%M%S"),".txt",sep=""),row.name=FALSE)




