# Jaana Simola
# 25.11.2018
# Data wrangling - 3rd week
# Link to the metadata (http://hdr.undp.org/en/content/human-development-index-hdi)

rm(list = ls())
setwd("~/Documents/GitHub/IODS-project/data") 
library(dplyr) # access the dplyr library
library(stringr)

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
colnames(hd) <- c("HDI.Rank", "Country", "HDI", "life.expectancy", "edu.expectancy", "edu.inYears", "GNI", "GNI-HDI")
colnames(gii) <- c("GII.Rank", "Country", "GII", "MMR", "ABR", "F.inParl", "edu2F", "edu2M", "workF", "workM")
#colnames(hd)[3] <- "HDI"    # alternative way of changing the column names

# create two new variables to gii. 
gii <- mutate(gii, eduRatio = edu2F / edu2M) # the ratio of Female and Male populations with secondary education 
gii <- mutate(gii, workRatio = workF / workM) # the ratio of labour force participation of females and males 

#Join together the two datasets using the variable Country as the identifier. 
human <- inner_join(hd, gii, by = "Country") # 195 observations and 19 variables. 

# Call the new joined data "human" and save it in your data folder.
write.csv(human, file="human.csv", row.names = FALSE) # write data to file

# ------------------------------------------------


str(human) # the 'human' data includes 195 observations and 19 variables that combine health and education indicators from most countries in the world

# Description of 'human' dataset variables. 
# "HDI.Rank" = Country rank in Human Development Index
# "Coutry"
# "HDI" = Human Development Index
# "life.expectancy" = Life expectancy at birth
# "edu.expectancy" = Expected years of schooling
# "edu.inYears" = Mean years of schooling
# "GNI" = Gross national income (GNI) per capita
# "GNI-HDI" = Gross national income (GNI) per capita - Human Development Index
# "GII.Rank" = Country rank in Gender Inequality Index
# "GII" = Gender Inequality Index
# "MMR" = Maternal mortality ratio
# "ABR" = Adolescent birth rate
# "F.inParl" = Percetange of female representatives in parliament 
# "edu2F" = Population of women with at least some secondary education
# "edu2M" = Population of men with at least some secondary education
# "workF" = Population of women participating in labor
# "workM" = Population of men participating in labor
# "eduRatio" = The ratio of Female / Male populations with secondary education (edu2F / edu2M)
# "workRatio" = The ratio of Female / Male participation in labour force (work2F / work2M)  


# transform the Gross National Income (GNI) variable to numeric
human$GNI <- str_replace(human$GNI, ",", "")
human$GNI <- as.numeric(human$GNI)

# keep only these columns
keep <- c("Country", "eduRatio", "workRatio", "edu.expectancy", "life.expectancy", "GNI", "MMR", "ABR", "F.inParl")
human <- dplyr::select(human, one_of(keep))

# remove rows with missing values 
complete.cases(human)
data.frame(human[-1], comp = complete.cases(human))
human <- filter(human, complete.cases(human))

# remove regions that comprise the last 7 rows
tail(human, n=10L)
last <- nrow(human) - 7
human_ <- human[1:last, ]


rownames(human_) <- human_$Country # add countries as rownames
human_ <- dplyr::select(human_, -Country) # remove the Country variable
dim(human_) # 155 observations and 8 variables

write.csv(human_, file="human.csv", row.names = TRUE) # write data to file
# test <- read.csv(file="human.csv")
