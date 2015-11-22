#
# Title:     run_analysis.R
#
# Author:    Gilbert Maerina
#
# Purpose:   Process data into structures for
#            processing
#
#
#The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 
#  1) a tidy data set as described below, 
#  2) a link to a Github repository with your script for performing the analysis, and 
#  3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
# 
#You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

#
#
#
# You should create one R script called run_analysis.R that does the following. 
#  >Merges the training and the test sets to create one data set.
#  >Extracts only the measurements on the mean and standard deviation for each measurement. 
#  >Uses descriptive activity names to name the activities in the data set
#  >Appropriately labels the data set with descriptive variable names. 
#  >From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#
#
library('data.table')


# timestamp of this processing
tstamp = Sys.time()

zip_file     <- "no file downloaded"
data_file    <- "UCI HAR Dataset: "
output_file  <- "< none created >"
summary_stmt <- "summary of merged:"
spacer_line  <- "-------------------------------"
merge_summary <- ""

if (!file.exists("UCI HAR Dataset")) {
  # download the data
  fileUrl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  destfile = paste("./UCI_HAR_DATA-", format(tstamp,"%Y%m%d_%H%M%S"), ".zip",sep="")
  download.file(fileUrl, destfile=destfile,method="curl")
  zip_file <- paste("zip file:",destfile,sep="")
  message("unzipping file ", destfile)
  unzip(destfile)
  
  
  # record timestamp
  write("",file=paste("./UCI HAR Dataset/downloaded_",format(tstamp,"%Y%m%d_%H%M%S"),sep=""))
} 

data_file <- paste(data_file, " : ", system("stat 'UCI HAR Dataset'", intern = TRUE)[8],sep="")


setwd("./UCI HAR Dataset/")

message("setting up temp datasets")
# setup data sets
x.test          <- read.table("./test/X_test.txt")
x.train         <- read.table("./train/X_train.txt")
y.train         <- read.table("./train/y_train.txt")
y.test          <- read.table("./test/y_test.txt")
activity.labels <- read.table("./activity_labels.txt",stringsAsFactors = FALSE)
data.labels     <- read.table("./features.txt", stringsAsFactors = FALSE)
test.subject    <- read.table("./test/subject_test.txt")
train.subject   <- read.table("./train/subject_train.txt")

message("setting up colnames")
# setup colnames
colnames(x.test) <- data.labels[,2]
colnames(x.train)<- data.labels[,2]
colnames(test.subject) <- c("Subject")
colnames(train.subject) <- c("Subject")

message("mapping descriptions")
# map descriptions
y.train <- data.frame(activity.labels[y.train[,1],2])
y.test  <- data.frame(activity.labels[y.test[,1],2])
colnames(y.train)<- c("Activity")
colnames(y.test) <- c("Activity")

message("merging datasets")
# merge datasets
x.test  <- x.test[grep("std|mean",data.labels[,2],ignore.case=TRUE)]
x.train <- x.train[grep("std|mean",data.labels[,2],ignore.case=TRUE)]
x.test  <- cbind(x.test,y.test,test.subject)
x.train <- cbind(x.train, y.train,train.subject)
x.merge <- merge( x.test, x.train,all=TRUE)


#for appending to codebook
merge_summary <- summary(x.merge)


xmerge_table<-data.table(x.merge)
results<-xmerge_table[,lapply(.SD,mean),by=c("Subject","Activity"), .SDcols=1:(length(names(x.merge))-2)]
results<-results[order(Subject,Activity),]

# move up one level
setwd("../")


message("writing tidy set:",paste("tidy_set_result-",format(tstamp,"%Y%m%d_%H%M%S"),".txt",sep=""))
# write results
write.table(results,file=paste("tidy_set_result-",format(tstamp,"%Y%m%d_%H%M%S"),".txt",sep=""),row.name=FALSE)
output_file <- paste("result: ","tidy_set_result-",format(tstamp,"%Y%m%d_%H%M%S"),".txt",sep="")

# announce completion
message("analysis done")



if(file.exists("./CodeBook.md"))
{
  message("updating CodeBook.md")
  write(c(zip_file,data_file,output_file,summary_stmt,merge_summary,spacer_line),file="CodeBook.md",append=TRUE)
}

# end run_analysis()

