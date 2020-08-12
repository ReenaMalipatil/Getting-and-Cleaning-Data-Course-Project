# Getting-and-Cleaning-Data-Course-Project

This is the course project for the Getting and Cleaning Data Coursera course. The R script, 'Run_analysis.R', does the following:

1) Download the dataset if it does not already exist in the working directory
2) Load the activity and feature info
3) Loads both the training and test datasets, keeping only those columns which reflect a mean or standard deviation
4) Loads the activity and subject data for each dataset, and merges those columns with the dataset
5) Merges the two datasets, converts the activity and subject columns into factors
6) Creates a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair.
7) The final file is 'TidyData.txt'
