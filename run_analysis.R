x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./UCI HAR Dataset/features.txt")

activity_label = read.table("./UCI HAR Dataset/activity_labels.txt")

colnames(x_train) <- features[, 2]
colnames(y_train) <- "activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activity_label) <- c('activityId','activityType')

merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
complete_data <- rbind(merge_train, merge_test)

mean_std <- (grepl( "activityId" , colnames(complete_data)) |
             grepl( "subjectId" , colnames(complete_data)) |
             grepl( "mean.." , colnames(complete_data)) |
             grepl( "std.." , colnames(complete_data)))

datams <- complete_data[, mean_std == TRUE]

datams_wactnam <- merge(datams, activity_label, by = "activityId", all.x = TRUE)

tidy_data <- aggregate(. ~ subjectId + activityId, datams_wactnam, mean)
tidy_dataset <- tidy_data[order(tidy_data$subjectId, tidy_data$activityId), ]

write.table(tidy_dataset, "tidydataset.txt", row.names = FALSE)