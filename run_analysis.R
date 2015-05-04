# This script creates two tidy data sets from the HCI HAR dataset:
# 1. with only the mean and standard deviation from set tables
# 2. with with the average of each variable for each activity and each
#   subject

# Read in the relevant files, create headings and merge
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")
features <- read.table("features.txt")
features <- features$V2
names(X_train) <- features
names(y_train) <- "activity"
names(subject_train) <- "subject"
train <- cbind(subject_train, y_train, X_train)
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")
test <- cbind(subject_test, y_test, X_test)
names(test) <- names(train)
data <- rbind(train, test)

# Extract mean and standard deviation measurements
mean <- grep("mean", names(data))
std <- grep("std", names(data))
subset <- data[ , c(1:2, std, mean)]

# Make activity labels descriptive
al <- read.table("activity_labels.txt")
al$V2 <- sub("_", "", al$V2)
subset <- merge(al, subset, by.x="V1", by.y="activity", all=T)
subset <- merge(al, subset, by.x="V1", by.y="activity", all=T)
subset <- subset[, -1]
names(subset)[1] <- "activity"
subset <- subset[c(2,1,3:81)]

# Label columns with descriptive variable names 
names(subset) <- tolower(names(subset))
names(subset) <- gsub("\\-", "",names(subset)) 
names(subset) <- sub("\\()", "", names(subset))
names(subset) <- sub("bodybody", "body", names(subset))
names(subset) <- sub("^f", "frequency", names(subset))
names(subset) <- sub("^t", "time", names(subset))
names(subset) <- sub("acc", "acceleration", names(subset))
names(subset) <- sub("gyro", "angularvelocity", names(subset))
names(subset) <- sub("mag", "magnitude", names(subset))
names(subset) <- sub("std", "standarddeviation", names(subset))

# Create second data set
library(dplyr)
tidy <- tbl_df(subset)
tidy <- group_by(tidy, subject, activity)
tidymean <- summarise_each(tidy, funs(mean))
