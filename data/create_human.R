# Jaana Simola
# 25.11.2018
# Data wrangling - 3rd week
# Link to the metadata (http://hdr.undp.org/en/content/human-development-index-hdi)

# Load datasets
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Explore the datasets: see the structure and dimensions of the data. 
str(hd)
str(gii)

# Create summaries of the variables. 
summary(hd)
summary(gii)

# Rename the variables with (shorter) descriptive names
colnames(hd)[3] <- "HDI"    # Human Development Index
colnames(hd)[4] <- "Life.expectancy"
colnames(hd)[5] <- "edu.expectancy"
colnames(hd)[6] <- "edu.inYears"
colnames(hd)[7] <- "GNI"    # Gross National Income
colnames(hd)[8] <- "GNI_minus_HDI"

colnames(gii)[3] <- "GII" # Gender Inequality Index
colnames(gii)[4] <- "MMR" # Maternal Mortality Ratio
colnames(gii)[5] <- "ABR" # Adolescent Birth Rate
colnames(gii)[6] <- "F.inParl" # Share of seats in parliament held by women
colnames(gii)[7] <- "edu2F" # Percentage of women (> 25 yrs old) with secondary education
colnames(gii)[8] <- "edu2M"  # Percentage of men (> 25 yrs old) with secondary education
colnames(gii)[9] <- "workF" # Percentage of women (> 15 yrs old) participating in labour 
colnames(gii)[10] <- "workM" # Percentage of men (> 15 yrs old) participating in labour 



# create two new variables to gii. 
gii <- mutate(gii, eduRatio = edu2F / edu2M) # the ratio of Female and Male populations with secondary education 
gii <- mutate(gii, workRatio = workF / workM) # the ratio of labour force participation of females and males 

# access the dplyr library
library(dplyr)


#Join together the two datasets using the variable Country as the identifier. 
human <- inner_join(gii, hd, by = "Country") # 195 observations and 19 variables. 

# Call the new joined data "human" and save it in your data folder.
write.csv(human, file="human.csv", row.names = FALSE) # write data to file