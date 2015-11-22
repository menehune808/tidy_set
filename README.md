###README
####Assumptions:
R installed and running on host computer.

"data.table" package installed.

Current directory hosts these files/folders:
- run_analysis.R  (R script)          
- README.md       (this file)
- CodeBook.md     (file will be updated with details about analysis)
- UCI HAR Dataset (If analysis had already run prior)

"run_analysis.R" can be run without prior downloading of the dataset. It will check if the UCI HAR Dataset 
exists, and if not, will download a copy of the dataset and unzip locally to the computer. The analysis will
only occur if two conditions of the data files are met:
  1. Existence of UHI HAR Dataset directory exists with all the datasets
  2. No UHI HAR Dataset exists, requiring downloading of zipped data.
The script will not process any pre-existing zipped files. If the requirement is to use a pre-existing zipped dataset,
then manual unzipping will need to be done for analysis to occur. 

To run the analysis, type:
 >source("./run_analysis.R")

Progress will be displayed in the console. Tidy set will be written to local directory when analysis 
is completed. CodeBook.md will be updated(if exists in current directory) with the name of zipped file (if download was required), birthdate
of data directory, output filename, and summary of resulting merged dataset.
