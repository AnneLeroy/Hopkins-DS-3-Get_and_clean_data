# Keep order of library for plyr and dplyr

library(plyr)
library(dplyr)

library(tidyr)



# 0. Read all tables

        # dir data = absolute path for data
        dirdata <- paste0(getwd(),"/UCI HAR Dataset/")


        # Get Feature File
        file <- paste0(dirdata, "features.txt")
        features <- read.table(file,header=FALSE)
        colnames(features) <- c("featcode","feature")       
 
        # Get activity label      
        file <- paste0(dirdata, "activity_labels.txt")
        activity <- read.table(file,header=FALSE)
        colnames(activity) <- c("activity_code","activity")    
  
        # Get Test Files
        file <- paste0(dirdata, "test/X_test.txt")
        Xtest <- read.table(file,header=FALSE)
        colnames(Xtest) <- features[,2]
        
        file <- paste0(dirdata,"test/y_test.txt")
        ytest <- read.table(file,header=FALSE)
        colnames(ytest) <- c("activity_code")
        
        file <-paste0(dirdata,"test/subject_test.txt")
        subjecttest <- read.table(file,header=FALSE)
        colnames(subjecttest) <- c("subject")
        

        
        # Get Train Files
        file <- paste0(dirdata, "train/X_train.txt")
        Xtrain <- read.table(file,header=FALSE)
        colnames(Xtrain) <- features[,2]
        
        file <- paste0(dirdata,"train/y_train.txt")
        ytrain <- read.table(file,header=FALSE)
        colnames(ytrain) <- c("activity_code")
        
        file <-paste0(dirdata,"train/subject_train.txt")
        subjecttrain <- read.table(file,header=FALSE)
        colnames(subjecttrain) <- c("subject")
    
                  
# 1. Merges the training and the test sets to create one data set.

        # Merge tests datasets
        
        train <- cbind(subjecttrain, ytrain, Xtrain)
        test <- cbind(subjecttest, ytest, Xtest)
 
        # # Add "test" or "train" info (for future split if necessary) 
        # # not necessary
        # 
        # train <- mutate(train, type="train")
        # test <- mutate(test, type="test")       

        
        # 1 file        
        full <- rbind(train, test)

        

        # Remove uncessary data from memory
        # rm(Xtest,Xtrain,ytest,ytrain,subjecttest,subjecttrain, train, test)

#-----------------------------------------------------------
        
# 2. Extracts only the measurements on the mean and standard deviation for each measurement
#     don't forget subject and activity_code     . 
        
        full <- full[,grepl("subject|activity_code|Mean|mean|Std|std", names(full))]


#-----------------------------------------------------------

# 3. Uses descriptive activity names to name the activities in the data set

        
        full <- join(full, activity, by="activity_code")
        
        
# 4. Appropriately labels the data set with descriptive variable names. 
        
#####   => this has been done in step 0
#####       colnames are "subject" "activity_code" and then each of the LABELS corresponding 
#####       to selected columns    
#####        
#####     done by instruction : colnames(Xtest) <- features[,2]  
        
  
# 5.     From the data set in step 4, creates a second, independent tidy data set 
#        with the average of each variable for each activity and each subject.   
        
        
        # aggregate by subject and activity code; take the mean
        
        newmeanfile <- aggregate (. ~subject + activity_code, full, mean)
        
        # write to a file
        
        write.table(newmeanfile, file = "tidy.txt",row.name=FALSE)

                

        