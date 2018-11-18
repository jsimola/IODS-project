
# Jaana Simola
# 13.11.2018
# Data wrangling - 3rd week
# Data obtained from Student Performance Data Set (https://archive.ics.uci.edu/ml/machine-learning-databases/00320/)

# clear workspace first
rm(list = ls()) 
setwd("~/Documents/GitHub/IODS-project/data")

# Read both student-mat.csv and student-por.csv 
student_mat <- read.csv("~/Documents/GitHub/IODS-project/data/student-mat.csv", sep = ";", header = TRUE)
student_por <- read.csv("~/Documents/GitHub/IODS-project/data/student-por.csv", sep = ";", header = TRUE)

# Explore the structure and dimensions of the data
dim(student_mat) # 395 observations, 33 vars
dim(student_por) # 649 observations, 33 vars

# access the dplyr library
library(dplyr)

# Join the two data sets using the variables 
join_by = c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")  

# Keep only the students present in both data sets. 
mat_por <- inner_join(student_mat, student_por, by = join_by)

# Explore the structure and dimensions of the joined data
dim(mat_por) # 382 observations, 53 vars


str(mat_por) # 13 joined variables, 20 + 20 duplicated variables

# Combine the 'duplicated' answers in the joined data
# ----------------------------------------------------

# create a new data frame with only the joined columns
joined_data <- select(mat_por, one_of(join_by)) # 382 observations, 13 vars 

duplicated_columns <- colnames(student_mat)[!colnames(student_mat) %in% join_by] # 10 cols

for(column_name in duplicated_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(mat_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    joined_data[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    joined_data[column_name] <- first_column
  }
}

str(joined_data)
dim(joined_data) # 382 x 33

# Take the average of weekday and weekend alcohol consumption to create a new column 'alc_use' to the joined data.
joined_data$alc_use <- (joined_data$Dalc + joined_data$Walc) / 2

 # Use 'alc_use' to create a new logical column 'high_use' 
joined_data <- mutate(joined_data, high_use = alc_use > 2)  

glimpse(joined_data)  # 382 observations of 35 variable

write.csv(joined_data, file="alc.csv", row.names = FALSE) # write joined data to file
