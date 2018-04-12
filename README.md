# README

### Assignment:

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
1. Extracts only the measurements on the mean and standard deviation for each measurement.
1. Uses descriptive activity names to name the activities in the data set
1. Appropriately labels the data set with descriptive variable names.
1. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Raw data set

The raw data set can be downloaded at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Because it is over 250 MegaBytes big when extracted I did not include it in this repository. The [run_analysis.R](run_analysis.R) script needs this data extracted in a `data` folder in the working directory.

### Tidy data set

See [averages_by_subject_and_activity.txt](averages_by_subject_and_activity.txt)

It can be loaded back into R via

```R
data <- read.table("averages_by_subject_and_activity.txt", header = TRUE)
```

This data set includes averages of each variable for each activity and each subject.

### Code Book

See [CodeBook.md](CodeBook.md)

### Recipe

Running [run_analysis.R](run_analysis.R) will create the tidy data set from the raw data set.
For this to work the [raw data set](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
needs to be extracted into a `data` folder in the working directory.

Reading data sets:

#### 1. Merges the training and the test sets to create one data set.

First of all `X_*.txt`, `y_*.txt`and `subject_*.txt` files are read for both the test and training set. 
The measurements (`X_*.txt`) are combined with label and subject information with the cbind function. This will allow us to
identify which measurements belongs to which subject and activity.

Then `rbind` is used to combine both data sets into one, resulting in a complete data set assigned to `completeSet`

#### 4. Appropriately labels the data set with descriptive variable names.

In order to `Extracts only the measurements on the mean and standard deviation` for task 2 I thought it would be easier to set
the column names now. So at this point I decided to do task 4 right away.
The features are read from `./data/features.txt`. Because we 
added subject and label information in step 1 we also need to add them to our column names. 
The [make.names](https://stat.ethz.ch/R-manual/R-devel/library/base/html/make.names.html) function is used to ensure that
our column names are syntactically valid for R. This removes the parantheses and dashes in the column names.
Now we set the colNames for our completeSet, thereby fullfilling task 4.

#### 2. Extracts only the measurements on the mean and standard deviation for each measurement.

For this task the `select` function of the `dplyr` package is used with a regular expression to only select certain measurements.
In order to not lose subject/label information these two fields are also included in the regular expression.

The task is a little bit vague at this point. For me it was unclear if mean and standard deviation only mean features
that exactly match mean() and std() or if things like mean frequencies (e.g. `fBodyAcc-meanFreq()-X`) should also be included.
I opted for causion and included everything that has mean or std in its name. It is easy to remove these columns in a future
tidying up step if they are not needed, but re-adding them would be way more complicated.

#### 3. Uses descriptive activity names to name the activities in the data set
The activity labels are read from `data/activity_labels.txt`. The `mutate` of the `dplyr` package is used to overwrite the
old label with new descriptive names like `WALKING`

#### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
The `melt` function of the `reshape2` package is used to create a narrow data set, which includes one measurement per row.
The `dcast` function of the `reshape2` package is then used to calculate the mean for combinations of activities and subjects.

This is then written to a [averages_by_subject_and_activity.txt](averages_by_subject_and_activity.txt)] in the current 
working directory. I didn't use the data directory here to have a better seperation between raw and tidy data.


