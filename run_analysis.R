#Import the training and test files 
file1 <- read.table('~/UCI HAR Dataset/train/Y_train.txt')
 file2 <- read.table('~/UCI HAR Dataset/test/Y_test.txt')
file3 <- read.table('~/UCI HAR Dataset/train/X_train.txt')
file4 <- read.table('~/UCI HAR Dataset/test/X_test.txt')
subjects_train <- read.table('~/UCI HAR Dataset/train/subject_train.txt')
subjects_test <- read.table('~/UCI HAR Dataset/test/subject_test.txt')
features <- read.table('~/UCI HAR Dataset/features.txt')
#add the names of the columns from the features files
names(file3) <- features$V2
names(file4) <- features$V2
#add the activity and subject id columns
file3 <- cbind(file1, subjects_train, file3)
file4 <- cbind(file2,subjects_test, file4)
#combine the train and test files
file5 <-rbind(file3,file4)
#Add column names for the activities and subject id 
names(file5)[1:2] <- c('Activities', 'Subject')
#Convert the activity codes into their descriptions

activity_names <- read.table('~/UCI HAR Dataset/activity_labels.txt')
file5$Activities <- activity_names[file5$Activities,2]

#Take only the standard deviation and mean columns
file6 <- file5[ ,c(1, 2, grep('std()', names(file5)),grep('mean()', names(file5)))]
#use data.table to get the average of each column 
library(data.table)
file7 <- data.table(file6)
results <- file7[, lapply(.SD, mean), by = .(Activities, Subject) ]
#write table  
write.table(results, file='results.txt',row.name=FALSE)
