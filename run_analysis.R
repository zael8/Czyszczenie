library(plyr)
library(dplyr)

#Merges the training and the test sets to create one data set
x_test<-read.table("UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("UCI HAR Dataset/test/Y_test.txt")
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")


x_train<-read.table("UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("UCI HAR Dataset/train/Y_train.txt")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")

x_all<-rbind(x_train, x_test)
y_all<-rbind(y_train, y_test)
subject_all<-rbind(subject_train, subject_test)

f<-read.table("UCI HAR Dataset/features.txt")
name<-as.character(f$V2)
name2<-c("subject", "y", name)

data_all<-cbind(subject_all, y_all, x_all)
names(data_all)<-name2

#Extracts only the measurements on the mean and standard deviation for each measurement. 
a<-filter(f, grepl('mean()|std()', V2))   #selecting values containing mean or std
b<-filter(a, !grepl("Freq",V2))			  # omitting values containing Freq
name3<-as.character(b$V2)
name4<-c("subject", "y", name3)
data1<-data_all[,name4]

#Uses descriptive activity names to name the activities in the data set
activity_name<-read.table("UCI HAR Dataset/activity_labels.txt")

data2<-merge(data1, activity_name,  by.x="y", by.y="V1", all=TRUE)
data2$y<-NULL

names(data2)[names(data2) == 'V2'] <- 'activity'
data3<-data2[,c(ncol(data2),1:(ncol(data2)-1))]
#Appropriately labels the data set with descriptive variable names. 

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
final<- ddply(data3, .(subject, activity), function(x) colMeans(x[, 3:68]))

write.table(final, "tidy_dataset.txt", row.name=FALSE )


 
