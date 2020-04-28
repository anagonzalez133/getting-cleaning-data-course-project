# Getting and cleaning data course project

## Introduction

This repository contains my work on Coursera's [course](https://www.coursera.org/learn/data-cleaning) final project assignment.
The instructions for the project are the following:

> The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project.
> You will be required to submit:
> 1. a tidy data set as described below
> 2. a link to a Github repository with your script for performing the analysis
> 3. a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md.
> 4. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

> One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

> http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

> Here are the data for the project:

> https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

> You should create one R script called run_analysis.R that does the following:
> * Merges the training and the test sets to create one data set.
> * Extracts only the measurements on the mean and standard deviation for each measurement.
> * Uses descriptive activity names to name the activities in the data set
> * Appropriately labels the data set with descriptive variable names.
> * From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Repository content

This github repository has the data and scripts separated in 3 folders:
* original-data: The original data set provided for the project, without any transformations, as is, including the information about the files provided originally. The publication from where this original dataset comes was: **_Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012_**
* code: The scripts used to clean the data
* final-data: The tidy data set which is the final objective of the project.

## Description of the original data

In the original-data folder we have a series of txt files containing different information. Here I'm going to describe the files needed for the project (there are other additional files that are not needed for this project).
* The file **features_info.txt** is not going to be used to get the tidy data set, but provides additional information about the notation used in the following file, so, as the instructions state that we only want the measurements in mean and standard deviation, from the description in this file we know that we will only want the features with the name containing:
  * **mean()**: Mean value
  * **std()**: Standard deviation
* The file **features.txt** contains information about the different measures (561) taken during different times for the different subjects performing different activities.
* The file **activity_labels.txt** describes the labels used to indicate the activity the subject was performing when the measures where taken.
* The data sets with information about the subjects, activities and measures are separated in two subfolders: train and test. These subfolders contain the same set of files but with measures for different subjects, and one of the aims of the project is to join this information in train and test.
  * The files **X_test/train.txt** contain the measures taken for different subjects and activities at different points of time. These files contain 561 measures for each row, the files have no headers informing of the measure, that information is provided in the **features.txt** file. The structure of these files is fixed length for each measure, as they are normalized, each measure takes 16 characters, with blank spaces filling when the maximum length is not reached.
  * The files **y_test/train.txt** contain the labels of the activity the subject was performing when the measures in the X_ file was taken, so the number of rows in this file is the same as in the X file in each subfolder. To have a description of the activity each label in this file represents you need the **activity_labels.txt** described above.
  * The files **subject_test/train.txt** contain the subjects for which the measures in the X_ file were taken, so the number of rows in this file is the same as in the X file in each subfolder. The subject is identified using integers from 1 to 30.
  
## Description of the steps performed by the code

1. Read the data of the different txt files.
2. Add to the main data in the **X_.txt** dataset two columns:
    * the first column with the subjects in the **subject_.txt** file
    * the second column with the activity labels in **y_.txt** file
3. Join the data of step 2 in the train and test subfolders to get one unique data set
4. Add a description of the columns using the content of the **features.txt** file (plus two additional column names, one for subjects and another for actitity labels)

With these steps we have achieved the first point of our project instructions, and the fourth point referring to descriptive variable names.

5. We extract the name of the columns with mean() and std() in their name to get the subset of measures we are interested in. With this we cover the second point in the project instructions.

6. Add the information of the file **activity_labels.txt** to translate the labels of activities to the description of activities, achieving the third point in the instructions.

7. For each Subject and Activity, we calculate the average of each of the measures of the data set in the previous point. The result set of this operation is written to a file in the **final-data** directory, the name of the file is tidy_data.table. With this we cover the last point in the project instructions.