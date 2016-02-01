# Getting and Cleaning Data Course Project
by Vasanth Kumararajan (https://github.com/skvasant/getting-and-cleaning-data-course-project)


Purpose
-------

The purpose of this project is to demonstrate ability to collect, work with, and clean a data set.


Goal
----

The goal is to prepare tidy data that can be used for later analysis.

1) a tidy data set as described below,
2) a link to a Github repository with script for performing the analysis, and
3) a code book that describes the variables, the data, and any transformations or work that was performed to clean up the data called CodeBook.md. Also include a README.md in the repo with the scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example [this article](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/). Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


Steps to reproduce this project
-------------------------------

1. Open the R script `run_analysis.R` using a text editor.
2. Assign `dirName` your preferred working directory/folder (i.e., the folder where the data source zip file will be downloaded, extracted, worked with and tidy data set file will be created).
3. Save the R script `run_analysis.R` in the current working directory of the R process.
4. Run the R script `run_analysis.R`.

Reference
---------
* Codebook file `codebook.md` (Markdown)

Output produced
----------------
* Tidy data set file `human-activity-recognition-using-smartphones.txt` (space-delimited text)
