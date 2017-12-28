################################################################################
#
# Load libraries
#
################################################################################
#
# Load stringr - library for character manipulation/handling
#
library(stringr)


################################################################################
#
# Read raw survey data
#
################################################################################
#
# Create surveyDataX object containing survey data
#
surveyDataX <- read.csv(file = "data-raw/surveyDataBGD.csv", header = TRUE)


################################################################################
#
# Rename survey data variable names
#
################################################################################
#
# Get variable names of survey data
#
varNames <- names(surveyDataX)
#
# Split words in the variable names to allow for word manipulation
#
temp <- str_split(string = varNames, pattern = "[.]")
#
# Create storage object for variable name vector
#
varNames <- NULL
#
# Cycle through the split up list of words of the variable names
#
for(i in 1:length(temp)) {
  #
  # Create appropriate variable names based on split up words
  #
  varNames <- c(varNames, paste(temp[[i]], sep = " ", collapse = " "))
}
#
# Create variable code list vector matching variable names
#
# CAUTION: This script is hardcoded to create a variable list based on the
#          existing questionnaire. Any changes in the questionnaire sequence
#          (i.e., addition or deletion of questions) will break the
#          software
#
varList <- c("deployment", "enumerator", "status", "responseCode",
             "draftDate", "submissionDate", "ipAddress", "surveyType",
             "psu", "psuTime", "latitude", "longitude", "accuracy",
             "altitude", "area1", "area1Other", "area1Time", "area2",
             "slum", "houseIdentifiers", "gender", "landOwnStatus",
             "nWomen", "nMen", "nOldWomen", "nOldMen", "nGirls",
             "nBoys", "nInfants", "nMobility",
             paste("water", 1:59, sep = ""),
             paste("san", 1:89, sep = ""),
             "wash60", "wash61", "wash62",
             paste("san", 90:106, sep = ""),
             paste("ppi", 1:11, sep = ""))
#
# Rename surveyDataX data.frame using the variable code list created
#
names(surveyDataX) <- varList
#
# Remove household identifiers
#
surveyDataX <- subset(surveyDataX, select = -houseIdentifiers)

################################################################################
#
# Create sampling unit identifiers (i.e, country, zone, type, quadrat)
#
################################################################################
#
# Create country vector
#
country <- rep("Bangladesh", nrow(surveyDataX))
#
# Create country code vector
#
ccode <- rep("BGD", nrow(surveyDataX))
#
# Extract survey area from psu data
#
zone <- trunc(surveyDataX$psu / 1000)
#
# Extract survey area type from psu data
#
type <- trunc((surveyDataX$psu - signif(surveyDataX$psu, digits = 1)) / 100)
#
# extract quadrat number/sampling point id from psu data
#
quadrat <- as.numeric(sprintf("%02d", surveyDataX$psu %% 100))
#
# Add survey month
#
month <- as.numeric(str_split(string = surveyDataX$submissionDate,
                              pattern = "/",
                              simplify = TRUE)[ , 2])
#
# Convert numeric month to month name
#
month <- ifelse(month == 1, "Jan",
           ifelse(month == 2, "Feb",
             ifelse(month == 3, "Mar",
               ifelse(month == 4, "Apr",
                 ifelse(month == 5, "May",
                   ifelse(month == 6, "Jun",
                     ifelse(month == 7, "Jul",
                       ifelse(month == 8, "Aug",
                         ifelse(month == 9, "Sep",
                           ifelse(month == 10, "Oct",
                             ifelse(month == 11, "Nov", "Dec")))))))))))

#
# Add survey year
#
year <- as.numeric(str_split(string = surveyDataX$submissionDate,
                             pattern = "/",
                             simplify = TRUE)[ , 3])


################################################################################
#
# Lines 132, 133, 134 below are specific to the first Dhaka, Bangladesh survey
# and were used to re-assign sampling points to more appropriate survey areas
# based on GPS location.
#
################################################################################
#
# Run next lines only if survey was done on the 3rd month of 2017 in Dhaka
#
if(unique(country) == "Bangladesh" &
   unique(year) == 2017 &
   unique(month) == "Mar") {
  #
  # Re-code zones for PSUs based on actual location after survey
  #
  zone[surveyDataX$psu == 3101] <- 1
  zone[surveyDataX$psu == 9215] <- 8
  zone[surveyDataX$psu %in% c(8110, 8111, 8114, 8115)] <- 9
}


################################################################################
#
# Add household ID
#
################################################################################
#
# Create hhid container vector
#
hhid <- vector(mode = "numeric", length = nrow(surveyDataX))
#
# Cylce through each unique psu ids
#
for(i in unique(surveyDataX$psu)) {
  #
  # Assign household ids
  #
  hhid[surveyDataX$psu == i] <- 1:2
}
#
# Create unique IDs by adding psuid and hhid
#
uniqueID <- (surveyDataX$psu * 100) + hhid
#
# Create admin data.frame for sampling point identifiers
#
admin <- data.frame(country, ccode, zone, type, quadrat, hhid, uniqueID, month, year)
#
# Add unique ID to administrative data
#
surveyDataX <- data.frame(admin, surveyDataX)
#
# Save ammended survey data as workingSurveyData.csv
#
write.csv(x = surveyDataX,
          file = paste("data-raw/workingSurveyData", unique(ccode), ".csv", sep = ""),
          row.names = FALSE)
#
# Rename surveyDataX object
#
surveyDataBGD <- surveyDataX
#
# Save ammended survey data as .rda format
#
devtools::use_data(surveyDataBGD, overwrite = TRUE)


################################################################################
#
# Create codebook for survey data variables
#
################################################################################
#
# Expand variable code list and variable names list
#
varList  <- c("country", "countryCode", "zone", "type", "quadrat", "hhid",
              "uniqueID", "month", "year", varList)
varNames <- c("Country", "Country Code", "Enumeration Area", "Sampling Point Type",
              "Quadrat Number", "Household ID", "Unique ID", "Month of Survey",
              "Year of Survey", varNames)
#
# Concatenate variable code list and variable names list vectors
#
codeBook <- data.frame(varList, varNames)
#
# Save codebook in CSV format
#
write.csv(x = codeBook,
          file = paste("data-raw/codeBook", unique(ccode), ".csv", sep = ""),
          row.names = FALSE)
#
# Clean-up
#
rm(varList, varNames, codeBook, temp, hhid, uniqueID,
   admin, zone, type, quadrat, i)

