
# Jaana Simola
# 07.11.2018
# The first script

# 1. read data 
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)


# 2. explore the structure and dimensions of the data
str(lrn14) # The 60 columns are integers except the last column which represents gender as a factor
dim(lrn14) # The data has 183 rows and 60 columns


# 3. Create an analysis dataset with the variables gender, age, attitude, deep, stra, surf 
library(dplyr) # Access the dplyr library

# columns for the analysis dataset
cols <- c("gender", "Age", "Attitude","deep", "stra", "surf", "Points") 

# combine questions in the learning2014 data
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
stra_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
surf_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")

# select data and scale combination variables by taking the mean
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

strategic_columns <- select(lrn14, one_of(stra_questions))
lrn14$stra <- rowMeans(strategic_columns)

surface_columns <- select(lrn14, one_of(surf_questions))
lrn14$surf <- rowMeans(surface_columns)

# create the analysis dataset, learning2014
learning2014 <- select(lrn14, one_of(cols))

# exclude observations where the exam points variable is zero
learning2014 <- filter(learning2014, Points > 0)
str(learning2014) # study the dimensions of learning2014: 166 obs, 7 vars

# ret the working directory
setwd("~/Documents/GitHub/IODS-project")
getwd() 

# save the analysis dataset and read it 
write.csv(learning2014, file = "learning2014.csv", row.names = FALSE)
read.csv("learning2014.csv")