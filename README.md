#Readme for the Course Project of Getting and Cleaning Data

This repo contains a script, run_analysis.R, that takes the raw data given in the assigment and produces a tidied data table printed to a .txt file, "tidied_data.txt". 

## Overview
The raw data from this script is described in full at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

It includes many data points (features) from a smartphone's accelerometers conducted during an experiment with 30 human subjects and 6 different activities. 

This script restricts the feature vectors (measures) to those measuring mean and standard deviation. It then computes the mean (average) for each subject/activity combination across all of the subject's measurements for that given feature and activity. The result is a 180-row table (6 activities * 30 rows) with the average values for each mean & std measure. 

## Script Steps
The script proceeds in a number of main steps:

1. It reads in all raw measurement data from both the "train" and "test" directories, combining them into a single large data frame. 

2. Then we find the indexes of the measures concerning mean and standard deviation and subset the data frame to only include those. We also label the columns with the appropriate variable names.

3. It then adds an activity column, labeling the activity for each measure, using the readable names (e.g. "LAYING"), not the activity id numbers. 

4. We then do the same thing for subjects, adding a subject column to the data using the subject id numbers (we are not given names or any other way of identifying subjects). 

5. Now that the data is labelled and contains all measure, subjects, and activities, we divide the data into 180 separate data frames (one for each subject/activity pair).

6. Finally, we compute the mean (average) for all measures, reducing each of the 180 data frames into a single row of the final tidied data frame, which we write to the file "tidied_data.txt".


## Codebook 

See CodeBook.md for a description of the variables in the final tidied output, "tidied_data.txt". 

See features.txt and features_info.txt, which have been copied from the source (raw) data provided, for context on the type of measures. 

