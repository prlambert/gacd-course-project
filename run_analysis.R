## run_analysis.R  - Course Project for Getting and Cleaning Data
## 
## From the Assignment:  "You should create one R script called run_analysis.R that does the following

## "Merges the training and the test sets to create one data set."
train_data <- read.table("data/train/X_train.txt")
test_data <- read.table("data/test/X_test.txt")
raw_data <- rbind(train_data, test_data)

## "Extracts only the measurements on the mean and standard deviation for each measurement."
features <- read.table("data/features.txt", col.names=c("index", "feature"), 
                       colClasses=c("integer", "character"))
idxs <- grep("(mean\\()|(std\\()", features$feature)
data <- raw_data[,idxs]

## "Appropriately labels the data set with descriptive variable names."
variable_names <- grep("(mean\\()|(std\\()", features$feature, value=TRUE)
names(data) <- variable_names

## "Uses descriptive activity names to name the activities in the data set"
# Note: here I read in all activiity indicators for each reading, and then
# replace their activity id with their corresponding label indicator 
# (e.g. "1" becomes "WALKING" and so forth)
train_activities <- read.table("data/train/y_train.txt")
test_activities <- read.table("data/test/y_test.txt")
all_activites <- rbind(train_activities, test_activities)
names(all_activites) <- c("activites")

activity_labels <- read.table("data/activity_labels.txt", col.names=c("index", "label"))
activity <- sapply(all_activites$activites, function(x) activity_labels[[x,2]])
activity_data <- cbind(activity, data) # activity_data is now the labeled master data table

# "From the data set in step 4, creates a second, independent tidy data set with 
#  the average of each variable for each activity and each subject."

# First, we add a subject id column to activity_data, creating the final master data table
train_subjects <- read.table("data/train/subject_train.txt", col.names=c("subject_id"))
test_subjects <- read.table("data/test/subject_test.txt", col.names=c("subject_id"))
subjects <- rbind(train_subjects, test_subjects)
all_data <- cbind(subjects, activity_data)

# Create a two dimensional list, to split the data by subject id and activity. 
# The first dimension is the activity level factor, the second dimension
# is the subject id. As such, there are 180 data frames (6 levels * 30 subjects) 
# held in the list. 
grouped_dfs <- by(all_data, all_data$activity, 
                    function(activity_df) by(activity_df, activity_df$subject, 
                        function(activity_subject_df) activity_subject_df))

# Now construct the tidied data frame, and compute the averages for all measures 
# for each of the 180 subject/activity combinations 
tidied <- data.frame(matrix(nrow=6*30, ncol=ncol(all_data)))
names(tidied) <- names(all_data)

row_index <- 1
for (activity_group in grouped_dfs) {
    for (df in activity_group) {
        tidied[[row_index,1]] <- df[[1,1]] # set subject id
        tidied[[row_index,2]] <- as.character(df[[1,2]]) # set activity label
        tidied[row_index,seq(from=3, to=ncol(tidied))] <- sapply(df[,seq(from=3, to=ncol(df))], mean) # compute averages 
        row_index <- row_index + 1
    }
}

# Finally, write the tidied data to a txt file
write.table(tidied, "tidied_data.txt", row.name=FALSE)

