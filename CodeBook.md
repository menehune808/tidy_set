##CODEBOOK

This document describes the variables, data, and transformations perfromed to clean up the data.

###DATA SOURCE

original source:[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

Website:[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

###DATA

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

*- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

####Notes: 
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

###OUTPUT REQUIREMENTS

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

###IMPLEMENTATION:

A timestamp is captured as an attribute for this analysis. 
```
  tstamp = Sys.time()
```
This will indicate when the dataset was last downloaded and also for when it was last analyzed.

The script checks to see if the dataset already exists, and if not, it will download and timstamp the 
data for future reference. The script will unzip the data locally in the current working
directory and will set the working directory as the newly unzipped directory.
```
  if (!file.exists("UCI HAR Dataset")) 
  {
    fileUrl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    destfile = paste("./UCI_HAR_DATA-", format(tstamp,"%Y%m%d_%H%M%S"), ".zip",sep="")
    download.file(fileUrl, destfile=destfile,method="curl")
    unzip(destfile)
  } 
  destfile = paste("./UCI_HAR_DATA-", format(tstamp,"%Y%m%d_%H%M%S"), ".zip",sep="")
  write("",file=paste("last_run_",format(tstamp,"%Y%m%d_%H%M%S"),sep=""))
  setwd("./UCI HAR Dataset/")
```
Individual datasets of interest are brought in as objects for manipulation and
aggregation later.
```
  x.test          <- read.table("./test/X_test.txt")
  x.train         <- read.table("./train/X_train.txt")
  y.train         <- read.table("./train/y_train.txt")
  y.test          <- read.table("./test/y_test.txt")
  activity.labels <- read.table("./activity_labels.txt",stringsAsFactors = FALSE)
  data.labels     <- read.table("./features.txt", stringsAsFactors = FALSE)
  test.subject    <- read.table("./test/subject_test.txt")
  train.subject   <- read.table("./train/subject_train.txt")
```

To provide sufficient identificatin of column data, mesaurement data is fused with 
labeling data. Column identification also benefits in decreasing ambiguity in 
the process of column filtering that occurs later in the process. Labeling the data 
prior to fusing will help to ensure that all data attributes will be paired with their 
respective datasets through the processes.
```
  colnames(x.test) <- data.labels[,2]
  colnames(x.train)<- data.labels[,2]
  colnames(test.subject) <- c("Subject")
  colnames(train.subject) <- c("Subject")
```
For a couple of datasets, explicit declaration of column labels is required from the
transformation process they undergo.
```
  y.train <- data.frame(activity.labels[y.train[,1],2])
  y.test  <- data.frame(activity.labels[y.test[,1],2])
  colnames(y.train)<- c("Activity")
  colnames(y.test) <- c("Activity")
```
The data is then filtered and fused based off the requirements provided. Proper procedure of processing
is required to ensure that data attributes are maintained. Though the labeling was accomplished
in an earlier step, datasets are explicitly grouped to ensure data identification integrity.
```  
  x.test  <- x.test[grep("std|mean",data.labels[,2],ignore.case=TRUE)]
  x.train <- x.train[grep("std|mean",data.labels[,2],ignore.case=TRUE)]
  x.test  <- cbind(x.test,y.test,test.subject)
  x.train <- cbind(x.train, y.train,train.subject)
  x.merge <- merge( x.test, x.train,all=TRUE)
  xmerge_table<-data.table(x.merge)
  results<-xmerge_table[,lapply(.SD,mean),by=c("Subject","Activity"), .SDcols=1:(length(names(x.merge))-2)]
  results<-results[order(Subject,Activity),]
```
When processing is complete, wrorking directory is moved one level up and data is written to a file the nomenclature,
descriptive name + hyphen + timestamp + file type.
```
  setwd("../")

  write.table(results,file=paste("tidy_set_result-",format(tstamp,"%Y%m%d_%H%M%S"),".txt",sep=""),row.name=FALSE)
```

###ANALYSIS HISTORY
---------------------------------------------------------

zip file:./UCI_HAR_DATA-20151122_010736.zip
UCI HAR Dataset:  :  Birth: 2015-11-22 01:08:04.255626500 -1000
result: tidy_set_result-20151122_010736.txt
summary of merged:
Min.   :-1.0000  
1st Qu.: 0.2626  
Median : 0.2772  
Mean   : 0.2743  
3rd Qu.: 0.2884  
Max.   : 1.0000  
Min.   :-1.00000  
1st Qu.:-0.02490  
Median :-0.01716  
Mean   :-0.01774  
3rd Qu.:-0.01062  
Max.   : 1.00000  
Min.   :-1.00000  
1st Qu.:-0.12102  
Median :-0.10860  
Mean   :-0.10892  
3rd Qu.:-0.09759  
Max.   : 1.00000  
Min.   :-1.0000  
1st Qu.:-0.9924  
Median :-0.9430  
Mean   :-0.6078  
3rd Qu.:-0.2503  
Max.   : 1.0000  
Min.   :-1.00000  
1st Qu.:-0.97699  
Median :-0.83503  
Mean   :-0.51019  
3rd Qu.:-0.05734  
Max.   : 1.00000  
Min.   :-1.0000  
1st Qu.:-0.9791  
Median :-0.8508  
Mean   :-0.6131  
3rd Qu.:-0.2787  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.: 0.8117  
Median : 0.9218  
Mean   : 0.6692  
3rd Qu.: 0.9547  
Max.   : 1.0000  
Min.   :-1.000000  
1st Qu.:-0.242943  
Median :-0.143551  
Mean   : 0.004039  
3rd Qu.: 0.118905  
Max.   : 1.000000  
Min.   :-1.00000  
1st Qu.:-0.11671  
Median : 0.03680  
Mean   : 0.09215  
3rd Qu.: 0.21621  
Max.   : 1.00000  
Min.   :-1.0000  
1st Qu.:-0.9949  
Median :-0.9819  
Mean   :-0.9652  
3rd Qu.:-0.9615  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9913  
Median :-0.9759  
Mean   :-0.9544  
3rd Qu.:-0.9464  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9866  
Median :-0.9665  
Mean   :-0.9389  
3rd Qu.:-0.9296  
Max.   : 1.0000  
Min.   :-1.00000  
1st Qu.: 0.06298  
Median : 0.07597  
Mean   : 0.07894  
3rd Qu.: 0.09131  
Max.   : 1.00000  
Min.   :-1.000000  
1st Qu.:-0.018555  
Median : 0.010753  
Mean   : 0.007948  
3rd Qu.: 0.033538  
Max.   : 1.000000  
Min.   :-1.000000  
1st Qu.:-0.031552  
Median :-0.001159  
Mean   :-0.004675  
3rd Qu.: 0.024578  
Max.   : 1.000000  
Min.   :-1.0000  
1st Qu.:-0.9913  
Median :-0.9513  
Mean   :-0.6398  
3rd Qu.:-0.2912  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9850  
Median :-0.9250  
Mean   :-0.6080  
3rd Qu.:-0.2218  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9892  
Median :-0.9543  
Mean   :-0.7628  
3rd Qu.:-0.5485  
Max.   : 1.0000  
Min.   :-1.00000  
1st Qu.:-0.04579  
Median :-0.02776  
Mean   :-0.03098  
3rd Qu.:-0.01058  
Max.   : 1.00000  
Min.   :-1.00000  
1st Qu.:-0.10399  
Median :-0.07477  
Mean   :-0.07472  
3rd Qu.:-0.05110  
Max.   : 1.00000  
Min.   :-1.00000  
1st Qu.: 0.06485  
Median : 0.08626  
Mean   : 0.08836  
3rd Qu.: 0.11044  
Max.   : 1.00000  
Min.   :-1.0000  
1st Qu.:-0.9872  
Median :-0.9016  
Mean   :-0.7212  
3rd Qu.:-0.4822  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9819  
Median :-0.9106  
Mean   :-0.6827  
3rd Qu.:-0.4461  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9850  
Median :-0.8819  
Mean   :-0.6537  
3rd Qu.:-0.3379  
Max.   : 1.0000  
Min.   :-1.00000  
1st Qu.:-0.11723  
Median :-0.09824  
Mean   :-0.09671  
3rd Qu.:-0.07930  
Max.   : 1.00000  
Min.   :-1.00000  
1st Qu.:-0.05868  
Median :-0.04056  
Mean   :-0.04232  
3rd Qu.:-0.02521  
Max.   : 1.00000  
Min.   :-1.00000  
1st Qu.:-0.07936  
Median :-0.05455  
Mean   :-0.05483  
3rd Qu.:-0.03168  
Max.   : 1.00000  
Min.   :-1.0000  
1st Qu.:-0.9907  
Median :-0.9348  
Mean   :-0.7313  
3rd Qu.:-0.4865  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9922  
Median :-0.9548  
Mean   :-0.7861  
3rd Qu.:-0.6268  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9926  
Median :-0.9503  
Mean   :-0.7399  
3rd Qu.:-0.5097  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9819  
Median :-0.8746  
Mean   :-0.5482  
3rd Qu.:-0.1201  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9822  
Median :-0.8437  
Mean   :-0.5912  
3rd Qu.:-0.2423  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9819  
Median :-0.8746  
Mean   :-0.5482  
3rd Qu.:-0.1201  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9822  
Median :-0.8437  
Mean   :-0.5912  
3rd Qu.:-0.2423  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9896  
Median :-0.9481  
Mean   :-0.6494  
3rd Qu.:-0.2956  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9907  
Median :-0.9288  
Mean   :-0.6278  
3rd Qu.:-0.2733  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9781  
Median :-0.8223  
Mean   :-0.6052  
3rd Qu.:-0.2454  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9775  
Median :-0.8259  
Mean   :-0.6625  
3rd Qu.:-0.3940  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9923  
Median :-0.9559  
Mean   :-0.7621  
3rd Qu.:-0.5499  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9922  
Median :-0.9403  
Mean   :-0.7780  
3rd Qu.:-0.6093  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9913  
Median :-0.9456  
Mean   :-0.6228  
3rd Qu.:-0.2646  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9792  
Median :-0.8643  
Mean   :-0.5375  
3rd Qu.:-0.1032  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9832  
Median :-0.8954  
Mean   :-0.6650  
3rd Qu.:-0.3662  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9929  
Median :-0.9416  
Mean   :-0.6034  
3rd Qu.:-0.2493  
Max.   : 1.0000  
Min.   :-1.00000  
1st Qu.:-0.97689  
Median :-0.83261  
Mean   :-0.52842  
3rd Qu.:-0.09216  
Max.   : 1.00000  
Min.   :-1.0000  
1st Qu.:-0.9780  
Median :-0.8398  
Mean   :-0.6179  
3rd Qu.:-0.3023  
Max.   : 1.0000  
Min.   :-1.00000  
1st Qu.:-0.41878  
Median :-0.23825  
Mean   :-0.22147  
3rd Qu.:-0.02043  
Max.   : 1.00000  
Min.   :-1.000000  
1st Qu.:-0.144772  
Median : 0.004666  
Mean   : 0.015401  
3rd Qu.: 0.176603  
Max.   : 1.000000  
Min.   :-1.00000  
1st Qu.:-0.13845  
Median : 0.06084  
Mean   : 0.04731  
3rd Qu.: 0.24922  
Max.   : 1.00000  
Min.   :-1.0000  
1st Qu.:-0.9912  
Median :-0.9516  
Mean   :-0.6567  
3rd Qu.:-0.3270  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9848  
Median :-0.9257  
Mean   :-0.6290  
3rd Qu.:-0.2638  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9873  
Median :-0.9475  
Mean   :-0.7436  
3rd Qu.:-0.5133  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9920  
Median :-0.9562  
Mean   :-0.6550  
3rd Qu.:-0.3203  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9865  
Median :-0.9280  
Mean   :-0.6122  
3rd Qu.:-0.2361  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9895  
Median :-0.9590  
Mean   :-0.7809  
3rd Qu.:-0.5903  
Max.   : 1.0000  
Min.   :-1.00000  
1st Qu.:-0.29770  
Median :-0.04544  
Mean   :-0.04771  
3rd Qu.: 0.20447  
Max.   : 1.00000  
Min.   :-1.000000  
1st Qu.:-0.427951  
Median :-0.236530  
Mean   :-0.213393  
3rd Qu.: 0.008651  
Max.   : 1.000000  
Min.   :-1.00000  
1st Qu.:-0.33139  
Median :-0.10246  
Mean   :-0.12383  
3rd Qu.: 0.09124  
Max.   : 1.00000  
Min.   :-1.0000  
1st Qu.:-0.9853  
Median :-0.8917  
Mean   :-0.6721  
3rd Qu.:-0.3837  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9847  
Median :-0.9197  
Mean   :-0.7062  
3rd Qu.:-0.4735  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9851  
Median :-0.8877  
Mean   :-0.6442  
3rd Qu.:-0.3225  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9881  
Median :-0.9053  
Mean   :-0.7386  
3rd Qu.:-0.5225  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9808  
Median :-0.9061  
Mean   :-0.6742  
3rd Qu.:-0.4385  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9862  
Median :-0.8915  
Mean   :-0.6904  
3rd Qu.:-0.4168  
Max.   : 1.0000  
Min.   :-1.00000  
1st Qu.:-0.27189  
Median :-0.09868  
Mean   :-0.10104  
3rd Qu.: 0.06810  
Max.   : 1.00000  
Min.   :-1.00000  
1st Qu.:-0.36257  
Median :-0.17298  
Mean   :-0.17428  
3rd Qu.: 0.01366  
Max.   : 1.00000  
Min.   :-1.00000  
1st Qu.:-0.23240  
Median :-0.05369  
Mean   :-0.05139  
3rd Qu.: 0.12251  
Max.   : 1.00000  
Min.   :-1.0000  
1st Qu.:-0.9847  
Median :-0.8755  
Mean   :-0.5860  
3rd Qu.:-0.2173  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9829  
Median :-0.8547  
Mean   :-0.6595  
3rd Qu.:-0.3823  
Max.   : 1.0000  
Min.   :-1.00000  
1st Qu.:-0.09663  
Median : 0.07026  
Mean   : 0.07688  
3rd Qu.: 0.24495  
Max.   : 1.00000  
Min.   :-1.0000  
1st Qu.:-0.9898  
Median :-0.9290  
Mean   :-0.6208  
3rd Qu.:-0.2600  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9907  
Median :-0.9255  
Mean   :-0.6401  
3rd Qu.:-0.3082  
Max.   : 1.0000  
Min.   :-1.000000  
1st Qu.:-0.002959  
Median : 0.164180  
Mean   : 0.173220  
3rd Qu.: 0.357307  
Max.   : 1.000000  
Min.   :-1.0000  
1st Qu.:-0.9825  
Median :-0.8756  
Mean   :-0.6974  
3rd Qu.:-0.4514  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9781  
Median :-0.8275  
Mean   :-0.7000  
3rd Qu.:-0.4713  
Max.   : 1.0000  
Min.   :-1.00000  
1st Qu.:-0.23436  
Median :-0.05210  
Mean   :-0.04156  
3rd Qu.: 0.15158  
Max.   : 1.00000  
Min.   :-1.0000  
1st Qu.:-0.9921  
Median :-0.9453  
Mean   :-0.7798  
3rd Qu.:-0.6122  
Max.   : 1.0000  
Min.   :-1.0000  
1st Qu.:-0.9926  
Median :-0.9382  
Mean   :-0.7922  
3rd Qu.:-0.6437  
Max.   : 1.0000  
Min.   :-1.00000  
1st Qu.:-0.01948  
Median : 0.13625  
Mean   : 0.12671  
3rd Qu.: 0.28896  
Max.   : 1.00000  
Min.   :-1.000000  
1st Qu.:-0.124694  
Median : 0.008146  
Mean   : 0.007705  
3rd Qu.: 0.149005  
Max.   : 1.000000  
Min.   :-1.000000  
1st Qu.:-0.287031  
Median : 0.007668  
Mean   : 0.002648  
3rd Qu.: 0.291490  
Max.   : 1.000000  
Min.   :-1.00000  
1st Qu.:-0.49311  
Median : 0.01719  
Mean   : 0.01768  
3rd Qu.: 0.53614  
Max.   : 1.00000  
Min.   :-1.000000  
1st Qu.:-0.389041  
Median :-0.007186  
Mean   :-0.009219  
3rd Qu.: 0.365996  
Max.   : 1.000000  
Min.   :-1.0000  
1st Qu.:-0.8173  
Median :-0.7156  
Mean   :-0.4965  
3rd Qu.:-0.5215  
Max.   : 1.0000  
Min.   :-1.000000  
1st Qu.: 0.002151  
Median : 0.182029  
Mean   : 0.063255  
3rd Qu.: 0.250790  
Max.   : 1.000000  
Min.   :-1.000000  
1st Qu.:-0.131880  
Median :-0.003882  
Mean   :-0.054284  
3rd Qu.: 0.102970  
Max.   : 1.000000  
LAYING            :1944  
SITTING           :1777  
STANDING          :1906  
WALKING           :1722  
WALKING_DOWNSTAIRS:1406  
WALKING_UPSTAIRS  :1544  
Min.   : 1.00  
1st Qu.: 9.00  
Median :17.00  
Mean   :16.15  
3rd Qu.:24.00  
Max.   :30.00  
-------------------------------
