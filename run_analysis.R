require(dplyr)

feat <- read.table('features.txt', header = F)
colnames(feat) <- c('id', 'name')
feat <- feat[grepl('mean\\(\\)', feat$name) | grepl('std', feat$name), ]
feat$tidyName <- tolower(gsub('\\(\\)', '', gsub('-', '', feat[,2])))

act <- read.table('activity_labels.txt')
colnames(act) <- c('actID', 'activity')

test <- read.table('./test/X_test.txt', header = F)[,feat[,1]]
test_subj <- read.table('./test/subject_test.txt')
test_act <- read.table('./test/y_test.txt')

test <- cbind(test_subj, test_act, test)

train <- read.table('./train/X_train.txt', header = F)[,feat[,1]]
train_subj <- read.table('./train/subject_train.txt')
train_act <- read.table('./train/y_train.txt')

train <- cbind(train_subj, train_act, train)

data <- rbind(test, train)
colnames(data) <- c('subject', 'actID', feat[,3])

data <- merge(data, act, by.x = 'actID', by.y = 'actID', sort = F)
data <- data[, c(2, 69, 3:68)]

tidy_data <- group_by(data, subject, activity) %>% summarise_each(funs(mean))


write.table(data, 'data.csv', row.name=FALSE)
write.table(tidy_data, 'tidy_data.csv', row.name=FALSE)
