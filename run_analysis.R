library(dplyr)
library(reshape2)

readDataSet <- function(setPath, labelPath, subjectPath) {
    testSet <- read.table(setPath)
    testLabels <- read.table(labelPath)
    testSubjects <- read.table(subjectPath)
    cbind(testSubjects, testLabels, testSet)
}

# Read test set
completeTestSet <- readDataSet(setPath = './data/test/X_test.txt',
                               labelPath = './data/test/y_test.txt',
                               subjectPath = './data/test/subject_test.txt')

# Read training set
completeTrainSet <- readDataSet(setPath = './data/train/X_train.txt', 
                               labelPath = './data/train/y_train.txt',
                               subjectPath = './data/train/subject_train.txt')

# 1. Combine test and training sets
completeSet <- rbind(completeTestSet, completeTrainSet)

# 4. Add descriptive variable names
features <- read.table('./data/features.txt')
featureLabels <- features$V2
colNames <- make.names(c("subject", "label", as.vector(featureLabels)), unique = TRUE)
colnames(completeSet) <- colNames

# 2. Use only mean and standard deviation
data <- select(completeSet, matches("subject|label|mean|std", ignore.case = TRUE))

# 3. Replace label with describe activity label name
activityLabels <- read.table("./data/activity_labels.txt")
data <- mutate(data, label = activityLabels$V2[label])

# 5. Reshape data
idColumns <- names(data)[1:2]
measureColumns <- names(data)[-(1:2)]
meltedData <- melt(data, id=idColumns, measure.vars = measureColumns)
averageData <- dcast(meltedData, subject + label ~ variable, mean)

# Write to a file
write.table(averageData, "averages_by_subject_and_activity.txt", row.names = FALSE)