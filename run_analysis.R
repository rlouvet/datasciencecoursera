library(data.table)

# Reading features and activity names
features = read.table(".\\UCI HAR Dataset\\features.txt")
activities = read.table(".\\UCI HAR Dataset\\activity_labels.txt")
names(activities) = c("Id", "Activity")

# Preparing the list of data files to be read for each folder (training or test)
seq = list(c(".\\UCI HAR Dataset\\train",list.files(path = ".\\UCI HAR Dataset\\train", pattern = "*.txt")),
           c(".\\UCI HAR Dataset\\test",list.files(path = ".\\UCI HAR Dataset\\test", pattern = "*.txt")))


for (files_list in seq){ #looping first on training files then on test files
  object_names = gsub(".txt", "", files_list[2:length(files_list)]) # Creating a list of vector names based on file names
  inputfolder = files_list[1]
  for (i in 2:length(files_list)){ # looping on each file of the selected folder
    f1 <- read.table(paste(inputfolder, "\\",files_list[i], sep=""))
    assign(object_names[i-1], f1) # renaming with corresponding vector name
  }

}

remove("f1","files_list","object_names") # deleting temporary declaration

# Merging the training and the test sets to create one data set
total_subject = rbind(subject_train,subject_test)$V1
total_X = rbind(X_train,X_test)
colnames(total_X) = features$V2
total_Y = rbind(y_train,y_test)$V1

# Retrieving activity name string 
Y_activity = activities[match(total_Y,activities$Id),"Activity"]

name_match = grep("mean|std", features$V2, value = TRUE)

DT = data.table(X = total_X[,name_match],  Activity = Y_activity, Subject = total_subject)
#DT[]

