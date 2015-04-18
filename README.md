# GettingCleaningDataProject

This file describes how run_analysis.R script works.

•	First, download and unzip the data from
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip-

•	Make sure the run_analysis.R script is in the current working directory.

•	Second, use source("run_analysis.R") command in RStudio. 

•	Third, you will find the output file step5.txt is generated in the current working directory that contains the data frame resulting after the five steps.

•	Finally, use data <- read.table("step5.txt",  header=TRUE) command in RStudio to read the file. 
