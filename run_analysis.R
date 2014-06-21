#read in data
activity.labels <- read.table("UCI HAR Dataset\\activity_labels.txt",sep="",col.names=c("number","activity"))
features <- read.table("UCI HAR Dataset\\features.txt",sep="",col.names=c("number","feature"))

test.subjects <- read.table("UCI HAR Dataset\\test\\subject_test.txt",sep="",col.names="subjects")
X.test <- read.table("UCI HAR Dataset\\test\\X_test.txt",sep="",col.name=features[,2])

Y.test <- read.table("UCI HAR Dataset\\test\\y_test.txt",sep="",col.name="number")
# merge with activity label names
Y.test$activity <- activity.labels$activity[match(Y.test$number,activity.labels$number)]

train.subjects <- read.table("UCI HAR Dataset\\train\\subject_train.txt",sep="",col.names="subjects")
X.train <- read.table("UCI HAR Dataset\\train\\X_train.txt",sep="",col.name=features[,2])
Y.train <- read.table("UCI HAR Dataset\\train\\y_train.txt",sep="",col.name="number")
# merge with activity label names
Y.train$activity <- activity.labels$activity[match(Y.train$number,activity.labels$number)]

# combine data for one data set
test.data <- cbind(Y.test,X.test)
test.data <- cbind(test.subjects,test.data)

train.data <- cbind(Y.train,X.train)
train.data <- cbind(train.subjects,train.data)

all.data <- rbind(test.data,train.data)

# Extract only Mean and Std columns
## get column numbers of standard deviation and mean columns
ft.1 <- features[grep("std", features$feature), ]
ft.2 <- features[grep("mean()", features$feature,fixed=TRUE), ]
## combine and put in numerical order
std.mean.cols <- sort(c(ft.1$number,ft.2$number))
## add room for three beginning columns
std.mean.cols <- std.mean.cols + 3
std.mean.cols <- c(c(1,2,3),std.mean.cols)
## extract -- First tidy data set
mean.std.data <- all.data[,std.mean.cols]

# second tidy data set
avg.by.activity <- aggregate(all.data, by=list(all.data$subjects,all.data$activity), FUN=mean)
