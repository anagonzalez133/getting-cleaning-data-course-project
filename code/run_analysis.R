# The object of this script is read the files needed from the directory
# ../original-data/ and create a tidy data set with:
# 1 - Train and test data in the original folder joined
# 2 - Extract only the measures referent to mean and standard deviation
# 3 - Use the descriptive activity names instead of the activity labels
# 4 - Use appropiate variable names for the diferent measures
# 5 - Create a tidy data set containing the average for each subject and activity
#     of the measures extracted. The tidy data set will be written to the
#     subdirectory ../final-data/

# Load the libraries we will need to run the script
library(data.table)
library(dplyr)

# To be able to navigate through the directories in our project, we set the working
# directory to the path of this script
try(setwd(dirname(rstudioapi::getActiveDocumentContext()$path)))
# print(getwd())

# We read all the files we will need from the original-data folder and store them in data sets
# The X_.txt files store the information in fixed length fields of 16 characters (561 measurements),
# the rest of the files can be read with a simple read.table
df_X_train <- read.fwf("../original-data/train/X_train.txt", header = FALSE, widths = rep(16, 561))
df_X_test <- read.fwf("../original-data/test/X_test.txt", header = FALSE, widths = rep(16, 561))
df_features <- read.table("../original-data/features.txt", header = FALSE)
df_activity_train <- read.table("../original-data/train/y_train.txt", header = FALSE)
df_activity_test <- read.table("../original-data/test/y_test.txt", header = FALSE)
df_subject_train <- read.table("../original-data/train/subject_train.txt", header = FALSE)
df_subject_test <- read.table("../original-data/test/subject_test.txt", header = FALSE)
dt_activity_labels <- data.table(read.table("../original-data/activity_labels.txt", header = FALSE))
colnames(dt_activity_labels) <- c("Activity.Label", "Activity")

# We create one train data frame adding to the X_train file two columns at the beginning, one with the subject
# and another with the label of the activity the subject was performing when the measures in the X file where
# taken. Repeat the same to create one test data frame.
df_train <- cbind(df_subject_train, df_activity_train, df_X_train)
df_test <- cbind(df_subject_test, df_activity_test, df_X_test)

# Now we create one big data frame with all the original data merging the information of
# the train a test data sets
df_merged_data <- rbind(df_train, df_test)

# Rename the columns of this data frame to know the measure each column contains.
# The measures where in the features.txt file, this file contains two columns,
# one with the column position in the X_.txt files and another with the measure name.
# Because we have added two inicial columns with the subject and activity, we add
# those column names manually:
colnames(df_merged_data) <- c("Subject", "Activity.Label", as.vector(t(df_features[, 2])))

# Search for measures containing the pattern mean() or std(). Cannot use grep("mean()")
# directly because it returns also the measures meanFreq(), or something like "MyMeanButItsOther()-X",
# to exact match the parenthesis we need to encase them in [], so our pattern is
# "mean[()]|std[()]"
# We are also interested in keeping the columns Subjet and Activity.Label in our subset of data,
# so we are going to build a vector with the names of the columns we need in the subset
vc_subset_namecol <- c("Subject", "Activity.Label", grep("mean[()]|std[()]", df_features[, 2], value = TRUE))

df_merged_subset <- df_merged_data[, vc_subset_namecol]

# Now we are going to add a column with the activities equivalent to the activity labels.
# We are going to use the data.table library to make a merge between our subset and the
# content of the activity_labels.txt. So we convert the data frame to a data table and then
# do the merge specifying the keys.
dt_merged_subset <- data.table(df_merged_subset)
dt_merged_data_activity <- merge(dt_activity_labels, dt_merged_subset, by.x = "Activity.Label", by.y = "Activity.Label")

# Now we calculate the average for each of the columns, grouping by Subject and Activity.
# For this we are going to use the functions group_by and summarise_all from the dplyr package,
# but to avoid to also calculate the average of the activity labels, we pass all the data set but the
# first column, with the activity labels
dt_tidy_data <- group_by(dt_merged_data_activity[, -1], Subject, Activity) %>% summarise_all(list(avg = mean))

# Create the tidy data file in each own directory
if (!dir.exists("../final-data")) {dir.create("../final-data")}
write.table(dt_tidy_data, file = "../final-data/tidy_data.table")





# The name of the columns where the mean function has been applied is the same as in the original data, with the sufix _avg

# write.table(df_merged_subset, file = "../df_merged_subset.table")

# df_merged_subset <- read.table(file = "../df_merged_subset.table")

# v_test <- df_features[c(265, 266, 294),]

# v_test <- rbind(c(1, "fprufreqmean"), c(2,"fprumeansometextfreq"), c(265, "tBodyGyroJerkMag-arCoeff()4"), c(266, "fBodyAcc-mean()-X"), c(294, "fBodyAcc-meanFreq()-X"))

# grep("mean[^Freq]", v_test[, 2], value = TRUE)
# grep("mean[\(\)]", v_test[, 2], value = TRUE)
# grep("mean[()]", v_test[, 2], value = TRUE)


# head(df_merged_data[, c("Subject", "Activity.Label")])

# library(data.table)