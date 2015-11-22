# tidy_set

##Getting and Cleaning Data Course Project


###README
####Assumptions:
R installed and running on host computer
"data.table" package installed
Current directory hosts these files/folders:
run_analysis.R
UCI HAR Dataset (If analysis had already been prior)

"run_analysis.R" can be run without prior downloading of the dataset. It will check if the UCI HAR Dataset 
exists, and if not, will download a copy of the dataset and unzip locally to the computer. 

To run the analysis, type:
 >source("./run_analysis.R")

Progress will be displayed in the console. Tidy set will be written to local directory when analysis 
is completed.
