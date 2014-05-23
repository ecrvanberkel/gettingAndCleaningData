## read labels and feature names
activityLabels = read.table("activity_labels.txt")
features = read.table("features.txt")
featureNames = features[,2]
names(activityLabels) = c("acitivityNumber","Activity")

## read and prepare testdata
# Load test data
message("reading test data")
testmeasurements = read.table("./test/X_test.txt")
testactivities = read.table("./test/y_test.txt")
testsubject = read.table("./test/subject_test.txt")

# rewrite testactivities to activity name instead of number
for (i in 1:length(activityLabels[,2])) {
      testactivities[testactivities==i] = as.character(activityLabels[i,2])
}

# combine test data with the activity and provide names to the columns
testdata = cbind(testsubject, testactivities, testmeasurements)
names(testdata) = c("Subject","Activity", as.character(featureNames))

# subset the mean and standard deviations for the measurements
meancols = grepl("mean", names(testdata)) # grepl checks wheter the first string argument
stdcols = grepl("std", names(testdata)) # is part of a string in the second argument
subsetcols = meancols | stdcols
subsetcols[1:2] = TRUE # ensure that the Activity and Subject stay in the data set
testdata = testdata[,subsetcols] # only use relevant columns from now on     

## read and prepare traindata
# Load train data
message("reading train data")
trainmeasurements = read.table("./train/X_train.txt")
trainactivities = read.table("./train/y_train.txt")
trainsubject = read.table("./train/subject_train.txt")

# rewrite trainactivities to activity name instead of number
for (i in 1:length(activityLabels[,2])) {
      trainactivities[trainactivities==i] = as.character(activityLabels[i,2])
}

# combine train data with the activity and provide names to the columns
traindata = cbind(trainsubject, trainactivities, trainmeasurements)
names(traindata) = c("Subject","Activity", as.character(featureNames))

# subset the mean and standard deviations for the measurements
meancols = grepl("mean", names(traindata)) # grepl checks wheter the first string argument
stdcols = grepl("std", names(traindata)) # is part of a string in the second argument
subsetcols = meancols | stdcols
subsetcols[1:2] = TRUE # ensure that the Activity and Subject stay in the data set
traindata = traindata[,subsetcols] # only use relevant columns from now on     

message("finished reading and preparing data")

## merging datasets into one dataset
## An extra column is added in order to keep track of whether the data 
## corresponds to training or testdata an extra 
columnnr = length(testdata[1,]) + 1
testdata[,columnnr] = 'test'
traindata[,columnnr] = 'train'
alldata = rbind(testdata,traindata) # placing all measurements in one dataset 
rm(testdata,traindata,activityLabels,features) # only leaves the one dataset of interest
names(alldata)[colnames(alldata) == names(alldata[length(alldata)])] = "test/train" # give a name to the last column


## Create an independent tidy data set with the average of each variable for each activity and each subject. 
# Find the appropriate factors and corresponding levels
factorSubject = factor(alldata$Subject)
factorActivity= factor(alldata$Activity)
factorUse = interaction(factorSubject,  factorActivity, drop = TRUE)
factorLevels = levels(factorUse)

# create the first column of the new data set
tidyData = tapply(alldata[,3], factorUse , mean)

# now define each column of the data set and place it next to the previous one
for (i in 4:(length(alldata[2,])-1) ) {
      nextVar = tapply(alldata[,i], factorUse , mean)
      tidyData = cbind(tidyData,nextVar)
}

# give the appropriate column names to the matrix
namesOfVariables = names(alldata)
useVariables = namesOfVariables[4:length(namesOfVariables)-1]
colnames(tidyData) = useVariables

# write the data set to a file
write.table(tidyData, "finalDatafile.txt", sep = "\t")
