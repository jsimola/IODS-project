# Jaana Simola
# 04.12.2018
# Data wrangling - 6th week

rm(list=ls())
setwd("~/Documents/GitHub/IODS-project/data") 

# Access the packages dplyr and tidyr
library(dplyr)
library(tidyr)

# Load datasets
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header = TRUE, sep = " ")
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = "\t")

# Check variable names
names(BPRS)
names(RATS)

# View the data structures
str(BPRS) # 40 obs. 11 vars.
str(RATS) # 16 obs. 13 vars.

head(BPRS)
head(RATS)

# Summaries of the variables
summary(BPRS)
summary(RATS)

# Convert categorical variables as factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# Convert datasets to long form
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
RATSL <- RATS %>% gather(key = times, value = rats, - ID, -Group)

# Add a week variable to BPRS and a Time variable to RATS
# Extract the week and Time numbers and convert to integer
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))
RATSL <- RATSL %>% mutate(Time = as.integer(substr(times,3,4)))

str(BPRSL) # 360 obs. 5 variables
# The number of variables in the BPRS wide form is 11 and it contains 9 variables for the measurements by weeks. 
# For the long form, one variable 'week' is created and it has values between 0 and 8. 
# Variable bprs contains the values of the measurements done on each week.
# 40 individuals multiplied by 9 weeks of measurements => 360 obs.


str(RATSL) # 176 obs. 5 variables
# The wide form of RATS contains variables 11 variables WD1..64. 
# In the long form, variable Time is created and it has (11) values: 1, 8, 15, .. 64. 
# 11 individuals multiplied by 16 measurement times => 176 obs in the long form


# Let's look at the first and the last 6 rows of the long data sets
head(BPRSL)
head(RATSL)
tail(BPRSL)
tail(RATSL)

# Save the datasets in the long form for the Analysis exercises
write.csv(BPRSL, file="BPRSL.csv", row.names = FALSE) 
write.csv(RATSL, file="RATSL.csv", row.names = FALSE)

# Test that everything works
#BPRSL <- read.csv(file="BPRSL.csv")
#RATSL <- read.csv(file="RATSL.csv")