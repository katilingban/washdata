################################################################################
#
# Load libraries
#
################################################################################
#
# Load stringr - library for character manipulation/handling
#
library(stringr)
#
# Load geospatial packages
#
library(rgeos)
library(rgdal)
library(raster)


################################################################################
#
# Read processed data
#
################################################################################
#
# Read workingSurveyDataBGD.csv
#
surveyData <- read.csv(file = paste("data-raw/workingSurveyData", unique(ccode), ".csv", sep = ""),
                       header = TRUE,
                       sep = ",",
                       stringsAsFactors = FALSE)


################################################################################
#
# Admin data
#
################################################################################
#
# Extract identifier data
#
adminDF <- surveyData[ , c("country", "ccode", "uniqueID", "psu",
                           "zone", "type", "quadrat", "hhid", "month", "year",
                           "longitude", "latitude")]


################################################################################
#
# Demographics data
#
################################################################################
#
# Extract demographic data
#
demoDF <- surveyData[ , c("uniqueID", "gender", "landOwnStatus",
                          "nWomen", "nMen", "nOldWomen", "nOldMen",
                          "nGirls", "nBoys", "nInfants", "nMobility")]
#
# Count total number of household members
#
nMembers <- surveyData$nWomen + surveyData$nMen +
  surveyData$nOldMen + surveyData$nOldWomen +
  surveyData$nGirls + surveyData$nBoys +
  surveyData$nInfants
#
# Create demographic data.frame
#
demoDF <- data.frame(demoDF, nMembers)
#
# Clean-up
#
rm(nMembers)


################################################################################
#
# Progress out of Poverty Index (PPI) - Bangladesh
#
################################################################################
#
# Check if country is Bangladesh
#
if(unique(surveyData$country) == "Bangladesh") {
  #
  # ppi1: Number of household members 12-years old or younger
  #
  ppi1 <- ifelse(surveyData$ppi1 == "None", 32,
                 ifelse(surveyData$ppi1 == "One", 16,
                        ifelse(surveyData$ppi1 == "Two", 10, 0)))
  #
  # ppi2: Do household members 6-12 years old attend school?
  #
  ppi2 <- ifelse(surveyData$ppi2 == "Yes", 6, 0)
  #
  # ppi3: In past year, any household member do paid work?
  #
  ppi3 <- ifelse(surveyData$ppi3 == "No", 8, 0)
  #
  # ppi4: Number of rooms used by household
  #
  ppi4 <- ifelse(surveyData$ppi4 == "Three or more", 5,
                 ifelse(surveyData$ppi4 == "Two", 3, 0))
  #
  # ppi5: Main construction material of the walls of the main room
  #
  ppi5 <- ifelse(surveyData$ppi5 == "Brick/cement", 9,
                 ifelse(surveyData$ppi5 == "Mud brick, or C.I. sheet/wood", 2, 0))
  #
  # ppi6: Does the household own television?
  #
  ppi6 <- ifelse(surveyData$ppi6 == "Yes", 7, 0)
  #
  # ppi7: Number of fans the household owns
  #
  ppi7 <- ifelse(surveyData$ppi7 == "Two or more", 7,
                 ifelse(surveyData$ppi7 == "One", 4, 0))
  #
  # ppi8: Number of mobile phones the household owns
  #
  ppi8 <- ifelse(surveyData$ppi8 == "Two or more", 15,
                 ifelse(surveyData$ppi8 == "One", 8, 0))
  #
  # ppi9: Does household own bicycles, motorcycles/scooters, cars?
  #
  ppi9 <- ifelse(surveyData$ppi9 == "Yes", 4, 0)
  #
  # ppi10: Does the household own/rent/sharecrop/mortgage in or out 51 or more
  #        decimals of cultivable agricultural land
  #
  ppi10 <- ifelse(surveyData$ppi10 == "Yes", 7, 0)
  #
  # ppi: total score
  #
  ppi <- ppi1 + ppi2 + ppi3 + ppi4 + ppi5 + ppi6 + ppi7 + ppi8 + ppi9 + ppi10
  #
  # Probability of being below poverty line: load lookup table
  #
  #ppiMatrix <- read.csv(file = "data/ppiTableBGD.csv", header = TRUE, sep = ",")
  #
  # Create empty vector container for poverty probabilities
  #
  pPoverty <- NULL
  #
  # Cycle through each row of data
  #
  for(i in 1:nrow(surveyData)) {
    #
    # Populate poverty probabilities vector
    #
    pPoverty <- data.frame(rbind(pPoverty, ppiMatrixBGD[ppiMatrixBGD["score"] == ppi[i], 2:10]))
  }
}


################################################################################
#                                                                              #
# Group population by wealth quintiles                                         #
#                                                                              #
################################################################################
#
# Find the quintile cutoffs for PPI
#
qCutOff <- quantile(ppi, probs = c(0.2, 0.4, 0.6, 0.8, 1))
#
# Classify households by wealth quintile
#
pQuintile <- ifelse(ppi <= qCutOff[1], 1,
               ifelse(ppi > qCutOff[1] & ppi <= qCutOff[2], 2,
                 ifelse(ppi > qCutOff[2] & ppi <= qCutOff[3], 3,
                   ifelse(ppi > qCutOff[3] & ppi <= qCutOff[4], 4, 5))))
#
# Concatenate PPI indicators into single data.frame
#
povertyDF <- data.frame("uniqueID" = surveyData[ , "uniqueID"],
                        ppi, pQuintile, pPoverty)


################################################################################
#
# Calculate indicators: Water
#
################################################################################
#
# waterSource: source of drinking water
#
waterSource <- ifelse(surveyData$water1 == "Other (please specify)",
                      surveyData$water2,
                      surveyData$water1)
waterSource <- ifelse(waterSource == "Deep tube well ",
                      "Deep tube well",
                      waterSource)
waterSource <- ifelse(waterSource == "Shallow tubwell",
                      "Shallow tube well",
                      waterSource)
#
# water1: improved source of drinking water
#
water1 <- ifelse(waterSource %in% c("Bottled water",
                                    "Deep tube well",
                                    "Piped water into dwelling",
                                    "Piped water to yard/plot",
                                    "Public tap/standpipe/kiosk",
                                    "Water lifted by motor",
                                    "Cart with small tank/drum or tanker-truck",
                                    "Rainwater collection"), 1, 0)
#
# water2: formal/informal source of drinking water for Pareto chart
#
water2 <- ifelse(surveyData$water3 == "", "Don't know", surveyData$water3)
#
# water2a: formal/informal source of drinking water for estimation
#
water2a <- ifelse(surveyData$water3 == "", NA,
             ifelse(surveyData$water3 == "Formal", 1, 0))
#
# water3: source of water a WSUP-supported facility
#
water3 <- ifelse(surveyData$water5 == "", "Don't know", surveyData$water5)
#
# water3a: source of water a WSUP-supported facility estimation
#
water3a <- ifelse(surveyData$water5 == "", NA,
             ifelse(surveyData$water5 == "Yes", 1, 0))
#
# water4: mean number of hours per day water is available
#
water4 <- surveyData$water7
#
# water4a: water available at least 12 hours (half a day)
#
water4a <- ifelse(surveyData$water7 >= 12, 1, 0)
#
# water4b: water available for full day
#
water4b <- ifelse(is.na(surveyData$water7), 0,
             ifelse(surveyData$water7 == 24, 1, 0))
#
# water5: mean number of days per week water available
#
water5 <- ifelse(surveyData$water9 == "", NA,
            ifelse(surveyData$water9 == "7 day per week", 7,
              ifelse(surveyData$water9 == "6 day per week", 6,
                ifelse(surveyData$water9 == "5 day per week", 5,
                  ifelse(surveyData$water9 == "4 day per week", 4,
                    ifelse(surveyData$water9 == "3 day per week", 3,
                      ifelse(surveyData$water9 == "2 day per week", 2,
                        ifelse(surveyData$water9 == "1 day per week", 1, 0))))))))
#
# water5a: water available more than 3 days a week
#
water5a <- ifelse(water5 > 3, 1, 0)
#
# water5b: water available the whole week
#
water5b <- ifelse(is.na(water5), 0,
             ifelse(water5 == 7, 1, 0))
#
# water6: water available for the whole year
#
water6 <- ifelse(surveyData$water11 == "", "Don't know",
            ifelse(surveyData$water11 == "Yes", "Yes", "No"))
#
# water6a: water available for the whole year (estimation)
#
water6a <- ifelse(surveyData$water11 == "", 0,
             ifelse(surveyData$water11 == "Yes", 1, 0))
#
# water7: mean number of minutes to collect water
#
water7 <- ifelse(is.na(surveyData$water14), 0, surveyData$water14)
#
# water7a: distance to water source is within 30 minutes or less
#
water7a <- ifelse(water7 <= 30, 1, 0)
#
# water7b: satisfied with distance between home and water source
#
water7b <- ifelse(surveyData$water16 == "", 1,
             ifelse(surveyData$water16 == "Yes", 1, 0))
#
# water7c: satisfied with distance between home and water source (estimate)
#
water7c <- ifelse(water7b == 2, NA, water7b)
#
# water8: satisfied with queuing time
#
water8 <- vector(mode = "numeric", length = nrow(surveyData))
water8[surveyData$water18 == "No"] <- 0
water8[surveyData$water18 == "Yes"] <- 1
water8[surveyData$water18 == "" & surveyData$water19 == TRUE] <- 2
water8[surveyData$water18 == "" & surveyData$water20 == TRUE] <- 3
water8[is.na(surveyData$water18) &
       is.na(surveyData$water19) &
       is.na(surveyData$water20)] <- 4
#
# water8a: satisfied with queuing time
#
water8a <- ifelse(water8 %in% 2:4, NA, water8)

################################################################################
#
# water9: person who usually collects water
#
################################################################################
#
# waterCollect: person who usually collects water
#
waterCollect <- ifelse(surveyData$water21 == "Other (please specify)",
                       surveyData$water22,
                       surveyData$water21)
waterCollect <- ifelse(waterCollect == "",
                       NA,
                       waterCollect)
waterCollect <- ifelse(waterCollect == "Source inside house",
                       NA,
                       waterCollect)
waterCollect <- str_split(string = waterCollect, pattern = ", ", simplify = TRUE)
#
# Create temporary container for vector outputs
#
temp <- NULL
#
# Cycle through columns of waterCollect
#
for(i in 1:ncol(waterCollect)) {
  #
  # Concatenate waterCollect columns into a single vector
  #
  temp <- c(temp, waterCollect[ , i])
}
#
# Re-assign NA value to "" answers
#
temp <- ifelse(temp == "", NA, temp)
#
# Get responses
#
tempNames <- names(table(temp))
#
# Create empty vector container
#
water9 <- NULL
#
# Cycle through responses
#
for(i in 1:length(tempNames)) {
  #
  # Create empty vector with length of surveyData
  #
  assign(paste("water9", letters[i], sep = ""),
         vector(mode = "numeric", length = nrow(surveyData)))
  #
  # Cycle through data columns in waterCollect
  #
  for(j in 1:ncol(waterCollect)) {
    #
    # Assign values
    #
    x <- ifelse(waterCollect[ , j] == tempNames[i], i, 0)
    #
    # Concatenate responses
    #
    assign(paste("water9", letters[i], sep = ""),
           get(paste("water9", letters[i], sep = "")) + x)
  }
  #
  # Rename responses to character strings
  #
  assign(paste("water9", letters[i], sep = ""),
         ifelse(get(paste("water9", letters[i], sep = "")) == i, tempNames[i], NA))
  #
  #
  #
  water9 <- data.frame(cbind(water9,
                             get(paste("water9", letters[i], sep = ""))))
}
#
# Rename the data.frame
#
names(water9) <- paste("water9", letters[1:length(tempNames)], sep = "")
#
# Clean-up
#
rm(waterCollect, i, j, x, temp, tempNames)
rm(list = names(water9))


################################################################################
#
# water10: amount of water used by household per day
#
################################################################################
#
# water10: amount of water (litres) used by household per day
#
water10 <- ifelse(surveyData$water23 == "", "Don't know", surveyData$water23)
#
# water10a: amount of water sufficient
#
water10a <- ifelse(surveyData$water25 == "", "Don't know", surveyData$water25)
#
# water10b: amount of water sufficient (estimate)
#
water10b <- ifelse(water10a == "Don't know", NA,
              ifelse(water10a == "Yes", 1, 0))


################################################################################
#
# water11: water from other sources
#
################################################################################
#
# Re-code "Don't know"
#
water11 <- ifelse(surveyData$water27 == "", "Don't know", surveyData$water27)
#
# Re-code NAs
#
water11a <- ifelse(water11 == "Don't know", NA,
              ifelse(water11 == "Yes", 1, 0))
#
# Re-code factors
#
water11b <- ifelse(surveyData$water29 == "", NA,
              ifelse(surveyData$water29 == "Other (please specify)",
                     surveyData$water30,
                     surveyData$water29))
#
# Re-code
#
water11b <- ifelse(water11b == "", NA, water11b)
water11b[water11b == "Mosque"] <- "Mosque, school, etc."
water11b[water11b %in% c("Neighbour's house",
                         "Pump point of water")] <- "Other's water point"
water11b[water11b == "Deep tube well"] <- "Tube well"
water11b[water11b == "Cann't arranged"] <- "Can't arrange"
#
# Re-code
#
water11c <- ifelse(water11b %in% c("Bottled water",
                                   "Piped water into dwelling",
                                   "Piped water to yard/plot",
                                   "Protected well or spring in yard",
                                   "Public tap/standpipe/kiosk",
                                   "Tube well",
                                   "Water lifted by motor"), 1,
              ifelse(is.na(water11b), 0, 0))
#
# Re-code
#
water11d <- ifelse(water1 == 1 & water7a == 1 &
                   water4b == 1 & water5b == 1 & water6a == 1, 1,
              ifelse(water1 == 1 & water7a == 1 &
                     ((water4b == 0 | water5b == 0 | water6a == 0) &
                     water11c == 1), 1, 0))


################################################################################
#
# water12: spend on water
#
################################################################################
#
# mean spend on water
#
water12 <- ifelse(surveyData$water32 == "", NA, surveyData$water32)
#
# satisfied with price of water
#
water12a <- ifelse(surveyData$water35 == "", "Don't know", surveyData$water35)
#
# satisfied with price of water - estimate
#
water12b <- ifelse(water12a == "Don't know", NA,
              ifelse(water12a == "Yes", 1, 0))


################################################################################
#
# water13: investment in improving water source
#
################################################################################
#
# Recode
#
water13 <- ifelse(surveyData$water37 == "", "Don't know", surveyData$water37)
#
# Recode
#
water13a <- ifelse(water13 == "Don't know", NA,
              ifelse(water13 == "Yes", 1, 0))


################################################################################
#
# water14: water quality
#
################################################################################
#
# Recode
#
water14 <- ifelse(surveyData$water40 == "", "Don't know", surveyData$water40)
#
# Recode
#
water14a <- ifelse(water14 == "Don't know", NA,
              ifelse(water14 == "Yes", 1, 0))


################################################################################
#
# water15: water quality improvement
#
################################################################################
#
# waterImprovement: water quality improvement
#
waterImprovement <- ifelse(surveyData$water42 == "Other improvement (please specify)",
                           surveyData$water43,
                           surveyData$water42)
waterImprovement <- ifelse(waterImprovement == "",
                           "Don't know/no answer/not applicable",
                           waterImprovement)
waterImprovement <- str_split(string = waterImprovement, pattern = ", ", simplify = TRUE)
#
# Create temporary container for vector outputs
#
temp <- NULL
#
# Cycle through columns of waterImprovement
#
for(i in 1:ncol(waterImprovement)) {
  waterImprovement[ , i] <- ifelse(waterImprovement[ , i] == "Other improvement (please specify)",
                                   surveyData$water43,
                                   waterImprovement[ , i])
}
#
# Cycle through columns of waterImprovement
#
for(i in 1:ncol(waterImprovement)) {
  #
  # Concatenate waterImprovement columns into a single vector
  #
  temp <- c(temp, waterImprovement[ , i])
}
#
# Re-assign NA value to "" answers
#
temp <- ifelse(temp == "", NA, temp)
#
# Get responses
#
tempNames <- names(table(temp))
#
# Create vector accumulator
#
water15 <- NULL
#
# Cycle through responses
#
for(i in 1:length(tempNames)) {
  #
  # Create empty vector with length of surveyData
  #
  assign(paste("water15", letters[i], sep = ""),
         vector(mode = "numeric", length = nrow(surveyData)))
  #
  # Cycle through data columns in waterCollect
  #
  for(j in 1:ncol(waterImprovement)) {
    #
    # Assign values
    #
    x <- ifelse(waterImprovement[ , j] == tempNames[i], i, 0)
    #
    # Concatenate responses
    #
    assign(paste("water15", letters[i], sep = ""),
           get(paste("water15", letters[i], sep = "")) + x)
  }
  #
  # Rename responses to character strings
  #
  assign(paste("water15", letters[i], sep = ""),
         ifelse(get(paste("water15", letters[i], sep = "")) == i, tempNames[i], NA))
  #
  # Create water quality data.frame
  #
  water15 <- data.frame(cbind(water15, get(paste("water15", letters[i], sep = ""))))
}
#
# Rename the data.frame
#
names(water15) <- paste("water15", letters[1:length(tempNames)], sep = "")
#
# Clean-up
#
rm(waterImprovement, i, j, x, temp, tempNames)
rm(list = names(water15))


################################################################################
#
# water16: water pressure
#
################################################################################
#
# Re-code
#
water16 <- ifelse(surveyData$water45 == "", "Don't know", surveyData$water45)
#
# Re-code
#
water16a <- ifelse(water16 == "Don't know", NA,
              ifelse(water16 == "Yes", 1, 0))


################################################################################
#
# water17: support provider
#
################################################################################
#
# Re-code
#
water17 <- ifelse(surveyData$water47 == "", "Don't know/not applicable",
             ifelse(surveyData$water47 == "Other (please specify)",
                    surveyData$water48,
                    surveyData$water47))
#
# Re-code
#
water17 <- ifelse(water17 == "", "Don't know/not applicable", water17)
#
# Re-code: these lines of code [473-495] are Dhaka, Bangladesh 2017 specific.
#
water17 <- ifelse(water17 == "Landlord/House owner ", "Landlord/House owner",
             ifelse(water17 == "Caretaker ", "Caretaker",
               ifelse(water17 %in% c("Gaurd", "Gaurd "), "Guard",
                 ifelse(water17 %in% c("No complain arise",
                                       "No complain  arise",
                                       "Till lemdon't face any problem"),
                                       "No complaints",
                   ifelse(water17 == "Water office ", "Water office",
                     ifelse(water17 == "Do no't cpmlain", "Do not complain",
                       ifelse(water17 == "Parlament Member (MP)", "Parliament Member (MP)",
                         ifelse(water17 == "Relavent office", "Relevant office",
                           ifelse(water17 == "Messengaer ", "Messenger",
                             ifelse(water17 == "Local Gverenment Engineering office", "Local Government Engineering office", water17))))))))))
#
# Re-code: these lines of code [499-506] are Dhaka, Bangladesh 2017 specific
#
water17 <- ifelse(water17 %in% c("Facility operator",
                                 "Local Government Engineering office",
                                 "Power and Water Development office",
                                 "Relevant office",
                                 "Water office",
                                 "Water supplier",
                                 "Water utility",
                                 "Women Affair Directory"), 1, 0)


################################################################################
#
# water18: water storage
#
################################################################################
#
# waterStorage
#
waterStorage <- ifelse(surveyData$wash60 == "",
                       "Don't know/not applicable",
                       surveyData$wash60)
waterStorage <- str_split(string = waterStorage, pattern = ", ", simplify = TRUE)
#
# water18a: Clean container (with lid)
#
water18a <- vector(mode = "numeric", length = nrow(surveyData))
water18a[waterStorage[,1] == "Clean container (with lid)" |
         waterStorage[,2] == "Clean container (with lid)" |
         waterStorage[,3] == "Clean container (with lid)"] <- 1
#
# water18b: Clean container (without lid)
#
water18b <- vector(mode = "numeric", length = nrow(surveyData))
water18b[waterStorage[,1] == "Clean container (without lid)" |
         waterStorage[,2] == "Clean container (without lid)" |
         waterStorage[,3] == "Clean container (without lid)"] <- 2
#
# water18c: Dirty container
#
water18c <- vector(mode = "numeric", length = nrow(surveyData))
water18c[waterStorage[,1] == "Dirty container" |
         waterStorage[,2] == "Dirty container" |
         waterStorage[,3] == "Dirty container"] <- 3
#
# water18d: Don't know/not applicable
#
water18d <- vector(mode = "numeric", length = nrow(surveyData))
water18d[waterStorage[,1] == "Don't know/not applicable" |
         waterStorage[,2] == "Don't know/not applicable" |
         waterStorage[,3] == "Don't know/not applicable"] <- 4
#
# water18
#
water18 <- ifelse(water18d == 4, NA,
             ifelse(water18a == 1 & water18b != 2 & water18c != 3, 1, 0))


################################################################################
#
# waterQuality: this indicator was not collected in survey. For future
#               surveys, if water quality tests are performed, this indicator
#               will be calculated based on that data.
#
################################################################################
#
# Check whether waterQualityDF has been loaded
#
if(exists("waterQualityDF"))
{
  #
  # Add logic here to process water quality data with waterQuality variable as
  # the result to be used for calculating indicators
  #
} else
  #
  # Assign NULL value to waterQuality variable if waterQualityDF is not available
  #
  waterQuality <- NULL


################################################################################
#
# JMP indicators for drinking water - post-2015
#
################################################################################
#
# Surface water: river, dam, lake, pond, stream, canal or irrigation channel
#
jmpWater1 <- ifelse(waterSource == "Surface water", 1, 0)
#
# Unimproved: unprotected dug wells, unprotected springs
#
jmpWater2 <- vector(mode = "numeric", length = nrow(surveyData))
jmpWater2[water1 != 1 & waterSource != "Surface water"] <- 1
#
# Limited: Improved but more than 30 minutes collection time
#
jmpWater3 <- vector(mode = "numeric", length = nrow(surveyData))
jmpWater3[water1 == 1 & water7a == 0] <- 1
#
# Determine if water quality data is available
#
if(is.null(waterQuality)) {
  #
  # At least basic: improved and no more than 30 minutes collection time
  #
  jmpWater4 <- vector(mode = "numeric", length = nrow(surveyData))
  jmpWater4[water1 == 1 & water7a == 1] <- 1
  #
  # no safely managed: create jmpWater5 empty vector
  #
  jmpWater5 <- vector(mode = "numeric", length = nrow(surveyData))
  jmpWater5[jmpWater5 == 0] <- NA
} else {
  #
  # Basic: Improved and no more than 30 minutes collection time
  #
  jmpWater4 <- vector(mode = "numeric", length = nrow(surveyData))
  #
  #
  #
  jmpWater4[water1 == 1 &
            !waterSource %in% c("Piped water into dwelling",
                                "Piped water to yard/plot",
                                "Protected dug well or spring in yard") &
            water7a == 1] <- 1
  #
  #
  #
  jmpWater4[water1 == 1 &
            waterSource %in% c("Piped water into dwelling",
                               "Piped water to yard/plot",
                               "Protected dug well or spring in yard") &
            (water4a == 0 | water5b == 0 | water6a == 0) &
            water7a == 1] <- 1
  #
  # Self-managed: improved and no more than 30 minutes collection time and available
  #               when needed and free from priority contamination
  #
  jmpWater5 <- vector(mode = "numeric", length = nrow(surveyData))
  #
  #
  #
  jmpWater5[water1 == 1 &
            waterSource %in% c("Piped water into dwelling",
                               "Piped water to yard/plot",
                               "Protected dug well or spring in yard") &
            water4a == 1 &
            water5b == 1 &
            water6a == 1 &
            waterQuality == 1] <- 1
}


################################################################################
#
# accessWater: Access to sufficient and sustained drinking water
#
################################################################################
#
# Re-code
#
accessWater <- ifelse(water10 %in% c("61-100 litres per day",
                                     "101-150 litres per day",
                                     "150-200 litres per day",
                                     "201-300 literes per day",
                                     ">301 litres per day") &
                      water4b == 1 & water5b == 1 & water6a == 1, 1, 0)

################################################################################
#
# Create waterDF
#
################################################################################
#
# Concatenate water indicators
#
waterDF <- data.frame("uniqueID" = surveyData[ , "uniqueID"],
                      waterSource, water1, water2, water2a, water3, water3a,
                      water4, water4a, water4b, water5, water5a, water5b,
                      water6, water6a, water7, water7a, water7b, water7c, water8, water8a,
                      water9, water10, water10a, water10b,
                      water11, water11a, water11b, water11c, water11d,
                      water12, water12a, water12b,
                      water13, water13a,
                      water14, water14a,
                      water16, water16a,
                      water17, water18,
                      jmpWater1, jmpWater2, jmpWater3, jmpWater4, jmpWater5,
                      accessWater)
#
# Clean-up
#
rm(waterSource, water1, water2, water2a, water3, water3a, water4, water4a, water4b,
   water5, water5a, water5b, water6, water6a, water7, water7a, water7b, water7c,
   water8, water8a, water9,
   water10, water10a, water10b, water11, water11a, water11b, water11c, water11d,
   water12, water12a, water12b, water13, water13a, water14, water14a,
   water16, water16a, water17, water18,
   jmpWater1, jmpWater2, jmpWater3, jmpWater4, jmpWater5, accessWater,
   waterQuality)


################################################################################
#
# Sanitation indicators
#
################################################################################

################################################################################
#
# san1: shared sanitation facility - user arrangements
#
################################################################################
#
# Re-code
#
san1 <- ifelse(surveyData$san1 == "", "Don't know",
          ifelse(surveyData$san1 == "Other (please specify)",
                 surveyData$san2,
                 surveyData$san1))
#
# Clean-up
#
san1 <- ifelse(san1 == "Communal / shared toilet ", "Communal / shared toilet", san1)
#
# san1a: is toilet facility shared with other households
#
san1a <- ifelse(san1 == "Household toilet", 0, 1)


################################################################################
#
# san2: Number of people who share toilet facilities
#
################################################################################
#
# san2: Mean number of people who share toilet facilities
#
san2 <- ifelse(is.na(surveyData$san4), 0, surveyData$san4)
#
# san2a: shared toilet facility
#
san2a <- ifelse(san2 == 0, 0, 1)


################################################################################
#
# san3: type of facility
#
################################################################################
#
# san3: type  of facility
#
san3 <- ifelse(surveyData$san6 == "Other (please specify)",
               surveyData$san7,
               surveyData$san6)
#
# clean-up
#
san3 <- ifelse(san3 %in% c("Drain", "Drain connected with waterbody",
                           "Drain with water body (Jhill)", "Open drain"), "Drain",
          ifelse(san3 %in% c("In water body (Jhill)", "Water body (Lake)", "Lake", "Pond",
                             "No facilities or bush or field"), "No facilities or bush or field or lake or pond",
            ifelse(san3 %in% c("Ditch with ring", "Ring and slub",
                               "Slub and in the bottom drain"), "Ring and slab without pit latrine", san3)))


################################################################################
#
# san4: where effluent flushes to
#
################################################################################
#
# san4: where effluent flushes to
#
san4 <- ifelse(surveyData$san9 == "", "Don't know",
          ifelse(surveyData$san9 == "Other (please specify)",
                 surveyData$san10,
                 surveyData$san9))
#
# clean-up
#
san4 <- ifelse(san4 %in% c("Open drain",
                           "Adjacent to pond",
                           "Ditch",
                           "Ditch ",
                           "pond",
                           "River",
                           "Water body (Cannel)"), "Open drain/ditch/water body",
          ifelse(san4 == "Tanki", "Septic tank", san4))


################################################################################
#
# san5: WSUP-supported facility
#
################################################################################
#
# san5: WSUP-supported facility
#
san5 <- ifelse(surveyData$san12 == "" & surveyData$san13 == "TRUE", "Not applicable",
          ifelse(surveyData$san12 == "" & surveyData$san14 == "TRUE", "Don't know", surveyData$san12))
#
# re-code
#
san5 <- ifelse(san5 == "Yes", 1,
          ifelse(san5 == "No", 0, NA))


################################################################################
#
# san6: water in facility
#
#################################################################################
#
# san6: water in facility (Yes / No)
#
san6 <- ifelse(surveyData$san15 == "Yes", 1, 0)


################################################################################
#
# san7: satisfied with handwashing facility
#
################################################################################
#
# san7: satisfied with handwashing facility
#
san7 <- ifelse(surveyData$san17 == "Yes", 1, 0)


################################################################################
#
# san8: what would increase your satisfaction
#
################################################################################
#
# Re-code
#
sanSatisfaction <- ifelse(surveyData$san19 == "Other (please specify)",
                          surveyData$san20,
                          surveyData$san19)
sanSatisfaction <- ifelse(sanSatisfaction == "",
                          NA,
                          sanSatisfaction)
sanSatisfaction <- str_split(string = sanSatisfaction, pattern = ", ", simplify = TRUE)
#
# Cycle through columns of sanSatisfaction
#
for(i in 1:ncol(sanSatisfaction)) {
  sanSatisfaction[ , i] <- ifelse(sanSatisfaction[ , i] == "Other (please specify)",
                                  surveyData$san20,
                                  sanSatisfaction[ , i])
  sanSatisfaction[ , i] <- ifelse(sanSatisfaction[ , i] == "",
                                  NA,
                                  sanSatisfaction[ , i])
}
#
# Create temporary container for vector outputs
#
temp <- NULL
#
# Cycle through columns of sanSatisfaction
#
for(i in 1:ncol(sanSatisfaction)) {
  #
  # Concatenate sanSatisfaction columns into a single vector
  #
  temp <- c(temp, sanSatisfaction[ , i])
}
#
# Re-assign NA value to "" answers
#
temp <- ifelse(temp == "", NA, temp)
#
# Get responses
#
tempNames <- names(table(temp))
#
# Vector accumulator
#
san8 <- NULL
#
# Cycle through responses
#
for(i in 1:length(tempNames)) {
  #
  # Create empty vector with length of surveyData
  #
  assign(paste("san8", letters[i], sep = ""),
         vector(mode = "numeric", length = nrow(surveyData)))
  #
  # Cycle through data columns in waterCollect
  #
  for(j in 1:ncol(sanSatisfaction)) {
    #
    # Assign values
    #
    x <- ifelse(sanSatisfaction[ , j] == tempNames[i], i, 0)
    #
    # Concatenate responses
    #
    assign(paste("san8", letters[i], sep = ""),
           get(paste("san8", letters[i], sep = "")) + x)
  }
  #
  # Rename responses to character strings
  #
  assign(paste("san8", letters[i], sep = ""),
         ifelse(get(paste("san8", letters[i], sep = "")) == i, tempNames[i], NA))
  #
  # Concatenate into data.frame
  #
  san8 <- data.frame(cbind(san8, get(paste("san8", letters[i], sep = ""))))
}
#
# Rename the data.frame
#
names(san8) <- paste("san8", letters[1:length(tempNames)], sep = "")
#
# Clean-up
#
rm(sanSatisfaction, i, j, temp, tempNames, x)
rm(list = names(san8))


################################################################################
#
# san9: lights in toilet facility
#
################################################################################
#
# san9: lights in toilet facility
#
san9 <- ifelse(surveyData$san22 == "Yes", 1, 0)


################################################################################
#
# san10: toilet facility with lockable door
#
################################################################################
#
# san10: lockable door
#
san10 <- ifelse(surveyData$san24 == "Yes", 1, 0)


################################################################################
#
# san11: container for menstrual hygiene management
#
################################################################################
#
# san11: container for menstrual hygiene management
#
san11 <- ifelse(surveyData$san26 == "Yes", 1, 0)


################################################################################
#
# san12: Sanitary disposal of child's faeces
#
################################################################################
#
# san12: sanitary disposal of child's faeces
#
san12 <- ifelse(surveyData$san28 %in% c("Child used toilet/latrine",
                                        "Put/rinsed into the toilet"), 1, 0)


################################################################################
#
# san13: Waiting time to use the toilet
#
################################################################################
#
# san13: Waiting time to use the toilet
#
san13 <- ifelse(is.na(surveyData$san31), 0, surveyData$san31)
#
# san13a: adequate physical access to sanitation facility
#
san13a <- ifelse(san13 < 30, 1, 0)

################################################################################
#
# san14: spend on sanitation facility
#
################################################################################
#
# san14: spend on sanitation facility
#
san14 <- ifelse(is.na(surveyData$san33), 0, surveyData$san33)


################################################################################
#
# san15: satisfied with spend
#
################################################################################
#
# san15: satisfied with spend
#
san15 <- ifelse(surveyData$san36 == "", NA,
           ifelse(surveyData$san36 == "Yes", 1, 0))


################################################################################
#
# san16: initial investment in toilet facility
#
################################################################################
#
# san16: initial investment in toilet facility
#
san16 <- ifelse(surveyData$san38 == "Yes", 1, 0)


################################################################################
#
# san17: amount of investment
#
################################################################################
#
# san17: amount of investment
#
san17 <- ifelse(is.na(surveyData$san40), 0, surveyData$san40)


################################################################################
#
# san18: willingness to invest
#
################################################################################
#
# san18: willingness to invest
#
san18 <- ifelse(surveyData$san43 == "Yes", 1, 0)


################################################################################
#
# san19: satisfied with cleanliness
#
################################################################################
#
# san19: satisfied with cleanliness
#
san19 <- ifelse(surveyData$san46 == "Yes", 1,
           ifelse(surveyData$san46 == "No", 0, NA))


################################################################################
#
# san20: increase satisfaction
#
################################################################################
#
# Re-code
#
cleanSatisfaction <- ifelse(surveyData$san48 == "Other (please specify)",
                            surveyData$san49,
                            surveyData$san48)
cleanSatisfaction <- ifelse(cleanSatisfaction == "",
                            NA,
                            cleanSatisfaction)
cleanSatisfaction <- str_split(string = cleanSatisfaction, pattern = ", ", simplify = TRUE)
#
# Create temporary container for vector outputs
#
temp <- NULL
#
# Cycle through columns of cleanSatisfaction
#
for(i in 1:ncol(cleanSatisfaction)) {
  #
  # Re-code
  #
  cleanSatisfaction[ , i] <- ifelse(cleanSatisfaction[ , i] == "Other (please specify)",
                                    surveyData$san20, cleanSatisfaction[ , i])
  cleanSatisfaction[ , i] <- ifelse(cleanSatisfaction[ , i] == "",
                                    NA, cleanSatisfaction[ , i])
}
#
# Create temporary container for vector outputs
#
temp <- NULL
#
# Cycle through columns of cleanSatisfaction
#
for(i in 1:ncol(cleanSatisfaction)) {
  #
  # Concatenate cleanSatisfaction columns into a single vector
  #
  temp <- c(temp, cleanSatisfaction[ , i])
}
#
# Re-assign NA value to "" answers
#
temp <- ifelse(temp == "", NA, temp)
#
# Get responses
#
tempNames <- names(table(temp))
#
# Empty container
#
san20 <- NULL
#
# Cycle through responses
#
for(i in 1:length(tempNames)) {
  #
  # Create empty vector with length of surveyData
  #
  assign(paste("san20", letters[i], sep = ""),
         vector(mode = "numeric", length = nrow(surveyData)))
  #
  # Cycle through data columns in cleanSatisfaction
  #
  for(j in 1:ncol(cleanSatisfaction)) {
    #
    # Assign values
    #
    x <- ifelse(cleanSatisfaction[ , j] == tempNames[i], i, 0)
    #
    # Concatenate responses
    #
    assign(paste("san20", letters[i], sep = ""),
           get(paste("san20", letters[i], sep = "")) + x)
  }
  #
  # Rename responses to character strings
  #
  assign(paste("san20", letters[i], sep = ""),
         ifelse(get(paste("san20", letters[i], sep = "")) == i, tempNames[i], NA))
  #
  # Concatenate into data.frame
  #
  san20 <- data.frame(cbind(san20, get(paste("san20", letters[i], sep = ""))))
}
#
# Rename the data.frame
#
names(san20) <- paste("san20", letters[1:length(tempNames)], sep = "")
#
# Clean-up
#
rm(cleanSatisfaction, i, j, x, temp, tempNames)
rm(list = names(san20))


################################################################################
#
# san21: Everyone in household able to get to sanitation facility?
#
################################################################################
#
# san21: everyone in household able to get to sanitation facility
#
san21 <- ifelse(surveyData$san51 == "Yes", 1, 0)


################################################################################
#
# san22: who is not using the sanitation facility?
#
################################################################################
#
# Re-code
#
sanitationUse <- ifelse(surveyData$san53 == "", NA,
                   ifelse(surveyData$san53 == "Other (please specify)", surveyData$san54, surveyData$san53))
sanitationUse <- str_split(string = sanitationUse, pattern = ", ", simplify = TRUE)
#
# Create temporary container for vector outputs
#
temp <- NULL
#
# Cycle through columns of sanitationUse
#
for(i in 1:ncol(sanitationUse)) {
  sanitationUse[ , i] <- ifelse(sanitationUse[ , i] == "Other (please specify)",
                                surveyData$san20, sanitationUse[ , i])
  sanitationUse[ , i] <- ifelse(sanitationUse[ , i] == "",
                                NA, sanitationUse[ , i])
}
#
# Create temporary container for vector outputs
#
temp <- NULL
#
# Cycle through columns of sanitationUse
#
for(i in 1:ncol(sanitationUse)) {
  #
  # Concatenate sanitationUse columns into a single vector
  #
  temp <- c(temp, sanitationUse[ , i])
}
#
# Re-assign NA value to "" answers
#
temp <- ifelse(temp == "", NA, temp)
#
# Get responses
#
tempNames <- names(table(temp))
#
# Vector accumulator
#
san22 <- NULL
#
# Cycle through responses
#
for(i in 1:length(tempNames)) {
  #
  # Create empty vector with length of surveyData
  #
  assign(paste("san22", letters[i], sep = ""),
         vector(mode = "numeric", length = nrow(surveyData)))
  #
  # Cycle through data columns in waterCollect
  #
  for(j in 1:ncol(sanitationUse)) {
    #
    # Assign values
    #
    x <- ifelse(sanitationUse[ , j] == tempNames[i], i, 0)
    #
    # Concatenate responses
    #
    assign(paste("san22", letters[i], sep = ""),
           get(paste("san22", letters[i], sep = "")) + x)
  }
  #
  # Rename responses to character strings
  #
  assign(paste("san22", letters[i], sep = ""),
         ifelse(get(paste("san22", letters[i], sep = "")) == i, tempNames[i], NA))
  #
  # Concatenate into data.frame
  #
  san22 <- data.frame(cbind(san22, get(paste("san22", letters[i], sep = ""))))
}
#
# Rename the data.frame
#
names(san22) <- paste("san22", letters[1:length(tempNames)], sep = "")
#
# Clean-up
#
rm(sanitationUse, i, j, x, temp, tempNames)
rm(list = names(san22))


################################################################################
#
# san23: do all household members usually use the available sanitation facilities
#
################################################################################
#
# Re-code
#
san23 <- ifelse(surveyData$san59 == "", "Don't know", surveyData$san59)
san23 <- ifelse(san23 == "Yes", 1,
           ifelse(san23 == "No", 0, NA))


################################################################################
#
# san24: who is not using sanitation facilities
#
################################################################################
#
# Re-code
#
sanitationUsage <- ifelse(surveyData$san61 == "", NA,
                     ifelse(surveyData$san61 == "Other (please specify)", surveyData$san62, surveyData$san61))
sanitationUsage <- str_split(string = sanitationUsage, pattern = ", ", simplify = TRUE)
#
# Create temporary container for vector outputs
#
temp <- NULL
#
# Cycle through columns of sanitationUsage
#
for(i in 1:ncol(sanitationUsage)) {
  #
  # Assign values
  #
  sanitationUsage[ , i] <- ifelse(sanitationUsage[ , i] == "Other (please specify)",
                                  surveyData$san62,
                                  sanitationUsage[ , i])
  sanitationUsage[ , i] <- ifelse(sanitationUsage[ , i] == "",
                                  NA,
                                  sanitationUsage[ , i])
}
#
# Create temporary container for vector outputs
#
temp <- NULL
#
# Cycle through columns of sanitationUsage
#
for(i in 1:ncol(sanitationUsage)) {
  #
  # Concatenate sanitationUsage columns into a single vector
  #
  temp <- c(temp, sanitationUsage[ , i])
}
#
# Re-assign NA value to "" answers
#
temp <- ifelse(temp == "", NA, temp)
#
# Get responses
#
tempNames <- names(table(temp))
#
# Vector accumulator
#
san24 <- NULL
#
# Cycle through responses
#
for(i in 1:length(tempNames)) {
  #
  # Create empty vector with length of surveyData
  #
  assign(paste("san24", letters[i], sep = ""),
         vector(mode = "numeric", length = nrow(surveyData)))
  #
  # Cycle through data columns in waterCollect
  #
  for(j in 1:ncol(sanitationUsage)) {
    #
    # Assign values
    #
    x <- ifelse(sanitationUsage[ , j] == tempNames[i], i, 0)
    #
    # Concatenate responses
    #
    assign(paste("san24", letters[i], sep = ""),
           get(paste("san24", letters[i], sep = "")) + x)
  }
  #
  # Rename responses to character strings
  #
  assign(paste("san24", letters[i], sep = ""),
         ifelse(get(paste("san24", letters[i], sep = "")) == i, tempNames[i], NA))
  #
  # Concatenate data.frame
  #
  san24 <- data.frame(cbind(san24, get(paste("san24", letters[i], sep = ""))))
}
#
# Rename the data.frame
#
names(san24) <- paste("san24", letters[1:length(tempNames)], sep = "")
#
# Clean-up
#
rm(sanitationUsage, i, j, x, temp, tempNames)
rm(list = names(san24))


################################################################################
#
# san25: problem with sanitation facility
#
################################################################################
#
# san25:
#
san25 <- ifelse(surveyData$san66 == "", "Don't know",
                ifelse(surveyData$san66 == "Other (please specify)",
                       surveyData$san67,
                       surveyData$san66))
san25 <- ifelse(san25 == "", "Don't know", san25)
#
# Clean-up
#
san25 <- ifelse(san25 %in% c("Call sweeper by own intiative ",
                             "Do work by calling sweeper"), "Call sweeper by own intiative",
           ifelse(san25 == "Manager ", "Manager",
             ifelse(san25 == "Quarter inside university, so the relevant person of university", "Responsible university staff", san25)))
#
# Re-code: formal service maintainer
#
san25 <- ifelse(san25 %in% c("Facility operator",
                             "Quarter inside university, so the relevent person of university",
                             "Water and Sanitation Authority  (WASHA)"), 1, 0)


################################################################################
#
# san31: when should you wash hands?
#
################################################################################
#
# washEvents
#
washEvents <- ifelse(surveyData$san85 == "", "Don't know",
                ifelse(surveyData$san85 == "Other (please specify)", surveyData$san86, surveyData$san85))
washEvents <- str_split(string = washEvents, pattern = ", ", simplify = TRUE)
#
# Create temporary container for vector outputs
#
temp <- NULL
#
# Cycle through columns of washEvents
#
for(i in 1:ncol(washEvents)) {
  #
  # Assign values
  #
  washEvents[ , i] <- ifelse(washEvents[ , i] == "Other (please specify)",
                             surveyData$san86,
                             washEvents[ , i])
}
#
# Create temporary container for vector outputs
#
temp <- NULL
#
# Cycle through columns of washEvents
#
for(i in 1:ncol(washEvents)) {
  #
  # Concatenate washEvents columns into a single vector
  #
  temp <- c(temp, washEvents[ , i])
}
#
# Re-assign NA value to "" answers
#
temp <- ifelse(temp == "", NA, temp)
#
# Get responses
#
tempNames <- names(table(temp))
#
# Vector accumulator
#
san31 <- NULL
#
# Cycle through responses
#
for(i in 1:length(tempNames)) {
  #
  # Create empty vector with length of surveyData
  #
  assign(paste("san31", letters[i], sep = ""),
         vector(mode = "numeric", length = nrow(surveyData)))
  #
  # Cycle through data columns in waterCollect
  #
  for(j in 1:ncol(washEvents)) {
    #
    # Assign values
    #
    x <- ifelse(washEvents[ , j] == tempNames[i], i, 0)
    #
    # Concatenate responses
    #
    assign(paste("san31", letters[i], sep = ""),
           get(paste("san31", letters[i], sep = "")) + x)
  }
  #
  # Rename responses to character strings
  #
  assign(paste("san31", letters[i], sep = ""),
         ifelse(get(paste("san31", letters[i], sep = "")) == i, tempNames[i], NA))
  #
  # Concatenate into data.frame
  #
  san31 <- data.frame(cbind(san31, get(paste("san31", letters[i], sep = ""))))
}
#
# Rename the data.frame
#
names(san31) <- paste("san31", letters[1:length(tempNames)], sep = "")
#
# Clean-up
#
rm(washEvents, i, j, x, temp, tempNames)
rm(list = names(san31))


################################################################################
#
# san32: households with handwashing facility with soap and water at sanitation facility
#
################################################################################
#
# Re-code
#
san32 <- ifelse(surveyData$san88 == "Handwashing station with clean water and soap available", 1, 0)


################################################################################
#
# san33: how often is septic tank emptied
#
################################################################################
#
# san33
#
san33 <- ifelse(surveyData$san90 == "Other (please specify)", surveyData$san91,
           ifelse(surveyData$san90 == "" & surveyData$san92 == TRUE, NA,
             ifelse(surveyData$san90 == "" & surveyData$san93 == TRUE, "Don't know", surveyData$san90)))
#
# clean-up
#
san33 <- ifelse(!san4 %in% c("Pit latrine", "Septic tank"), NA,
           ifelse(san33 %in% c("new house", "Did not empty till now"), "Don't know",
             ifelse(san33 %in% c("Stool go to pond", "Stool go to the cannal"), NA, san33)))


################################################################################
#
# san34: cost of empyting tank
#
################################################################################
#
# san34
#
san34 <- ifelse(surveyData$san94 == "", NA, surveyData$san94)


################################################################################
#
# san35: who empties pit
#
################################################################################
#
# san35
#
san35 <- ifelse(surveyData$san98 == "", "Don't know/not applicable",
           ifelse(surveyData$san98 == "Other (please specify)",
                  surveyData$san99,
                  surveyData$san98))
#
# Clean-up
#
san35a <- ifelse(san35 == "House owner ", "House owner",
            ifelse(san35 == "Sweeper ", "Sweeper",
              ifelse(san35 == "By own", "Family member or informal manual emptier", san35)))
#
# Re-code
#
san35 <- ifelse(san35a %in% c("Formal larger business",
                              "Formal small business using manual or automated tool",
                              "Water and Sanitation Authority  (WASHA)"), 1, 0)


################################################################################
#
# san36: who pays for pit to be emptied
#
################################################################################
#
# san36
#
san36 <- ifelse(surveyData$san102 == "", "Don't know/not applicable",
           ifelse(surveyData$san102 == "Other (please specify)",
                  surveyData$san103,
                  surveyData$san102))
#
# Clean-up
#
san36 <- ifelse(san36 == "Water and Sanitation Authority  (WASHA)", "Water and Sanitation Authority (WASHA)",
           ifelse(san36 == "City corporation ", "City corporation",
             ifelse(san36 == "Owner of house ", "Owner of house", san36)))


################################################################################
#
# Re-code san34 to take into account who pays for pit emptying
#
################################################################################
#
# Re-code
#
san34a <- ifelse(san36 != "My household", NA, san34)

################################################################################
#
# san37: satisfaction with pit emptying service
#
################################################################################
#
# san37
#
san37 <- ifelse(surveyData$san106 == "", NA,
           ifelse(surveyData$san106 == "Yes", 1, 0))


################################################################################
#
# san38: excreta disposal after emptying tank
#
################################################################################
#
# Check if excreta disposal after emtpying data avaiable
#
if(exists("excretaDisposalDF")) {
  #
  # Add re-code logic here using excreta disposal data to create
  # object called san38
  #
} else {
  san38 <- vector(mode = "numeric", length = nrow(surveyData))
  san38[san38 == 0] <- NA
}


################################################################################
#
# JMP Post-2015 sanitation indicators
#
################################################################################
#
# jmpSan1: open defecation
#
jmpSan1 <- ifelse(san3 == "No facilities or bush or field or lake or pond", 1, 0)


#
# jmpSan2: unimproved sanitation facilities
#
jmpSan2 <- ifelse(san3 %in% c("Hanging toilet/hanging latrine",
                              "Pit latrine without slab/open pit",
                              "Ring and slab without pit latrine",
                              "Drain"), 1, 0)

#
# jmpSan3: limited sanitation facility
#
jmpSan3 <- ifelse(san3 %in% c("Flush/pour flush",
                              "Pit latrine with slab or ventilated improved pit latrine (VIP)",
                              "Portable toilet with emptying service",
                              "Composting toilet") &
                    san4 %in% c("Piped sewer system", "Pit latrine", "Septic tank", "Don't know") &
                    san1a == 1, 1, 0)
#
# jmpSan4: at least basic
#
jmpSan4 <- ifelse(san3 %in% c("Flush/pour flush",
                              "Pit latrine with slab or ventilated improved pit latrine (VIP)",
                              "Portable toilet with emptying service",
                              "Composting toilet") &
                    san4 %in% c("Piped sewer system", "Pit latrine", "Septic tank", "Don't know") &
                    san1a == 0, 1, 0)
#
# jmpSan5: empty
#
jmpSan5 <- vector(mode = "numeric", length = nrow(surveyData))
jmpSan5[jmpSan5 == 0] <- NA
#
# Check if excretaDisposalDF is available
#
if(exists("excretaDisposalDF")) {
  #
  # jmpSan4: basic sanitation facility
  #
  jmpSan4 <- vector(mode = "numeric", length = nrow(surveyData))
  #
  # Basic sanitation services - pit latrine system
  #
  jmpSan4[san3 %in% c("Pit latrine with slab or ventilated improved pit latrine (VIP)",
                      "Composting toilet") &
          san4 != "Piped sewer system" &
          san1a == 0 &
          san33 != "Have never emptied it before" &
          !san38 %in% c("To a covered and sealed hole (buried)",
                        "Taken away through the sewer system to a treatment facility",
                        "Taken away by the service provider to a treatment facility")] <- 1
  #
  # Basic sanitation services - flush/pour flush/toilet system without piped water system
  #
  jmpSan4[san3 %in% c("Flush/pour flush",
                      "Portable toilet with emptying service") &
          san4 != "Piped sewer system" &
          san1a == 0 &
          !san38 %in% c("To a covered and sealed hole (buried)",
                        "Taken away through the sewer system to a treatment facility",
                        "Taken away by the service provider to a treatment facility")] <- 1
  #
  # jmpSan5: safely managed
  #
  jmpSan5 <- vector(mode = "numeric", length = nrow(surveyData))
  #
  #
  #
  jmpSan5[san3 %in% c("Flush/pour flush",
                      "Portable toilet with emptying service") &
          san4 == "Piped sewer system" &
          san1a == 0] <- 1
  #
  #
  #
  jmpSan5[san3 %in% c("Flush/pour flush",
                      "Portable toilet with emptying service") &
          san4 %in% c("Pit latrine",
                      "Septic tank",
                      "Don't know") &
          san1a == 0 &
          san38 %in% c("To a covered and sealed hole (buried)",
                       "Taken away through the sewer system to a treatment facility",
                       "Taken away by the service provider to a treatment facility")] <- 1
  #
  #
  #
  jmpSan5[san3 %in% c("Pit latrine with slab or ventilated improved pit latrine (VIP)",
                      "Composting toilet") &
          san4 != "Piped sewer system" &
          san1a == 0 &
          (san33 == "Have never emptied it before" |
           san38 %in% c("To a covered and sealed hole (buried)",
                        "Taken away through the sewer system to a treatment facility",
                        "Taken away by the service provider to a treatment facility"))] <- 1
}


################################################################################
#
# Adequate sanitaiton facility
#
################################################################################
#
# Re-code
#
adequateSan <- ifelse(san3 %in% c("Flush/pour flush",
                                  "Pit latrine with slab or ventilated improved pit latrine (VIP)") &
                      san4 != "Open drain / ditch / water body", 1, 0)

################################################################################
#
# Accessible sanitation facility
#
################################################################################
#
# Re-code
#
accessSan <- ifelse(san21 == 1 & san23 == 1, 1, 0)


################################################################################
#
# Acceptabl sanitation facility
#
################################################################################
#
# Re-code for proportion indicator
#
acceptSan <- ifelse(adequateSan == 1 & san6 == 1 & san9 == 1 & san10 == 1 &
                    san11 == 1, 1, 0)
#
# Re-code for mean indicator
#
acceptDF <- data.frame(adequateSan, san6, san9, san10, san11)
#
# Get acceptable sanitaiton score (0-5)
#
acceptScore <- rowSums(acceptDF, na.rm = TRUE)

################################################################################
#
# Create sanDF
#
################################################################################
#
# Concatenate sanitation indicators
#
sanDF <- data.frame("uniqueID" = surveyData[ , "uniqueID"],
                    san1, san1a, san2, san2a, san3, san4, san5, san6, san7, san8,
                    san9, san10, san11, san12, san13, san13a, san14, san15, san16,
                    san17, san18, san19, san20, san21, san22, san23, san24, san25,
                    san32, san33, san34, san34a, san35, san35a, san36, san37,
                    jmpSan1, jmpSan2, jmpSan3, jmpSan4, jmpSan5,
                    adequateSan, accessSan, acceptSan, acceptScore)
#
# Clean-up
#
rm(san1, san1a, san2, san2a, san3, san4, san5, san6, san7, san9, san10,
   san11, san12, san13, san13a, san14, san15, san16, san17, san18, san19, san21,
   san23, san25, san32, san33, san34, san34a, san35, san35a, san36, san37, san22,
   jmpSan1, jmpSan2, jmpSan3, jmpSan4, jmpSan5, adequateSan, accessSan, acceptSan,
   acceptDF, acceptScore, san20, san24)


################################################################################
#
# Handwashing indicators
#
################################################################################
#
# Check if handwashing facility at home data is available
#
if(exists("handwashingFacilityDF")) {
  #
  # jmpHand1
  #
  jmpHand1 <- ifelse(surveyData$san107 == "No handwashing station", 1, 0)
  #
  # jmpHand2
  #
  jmpHand2 <- ifelse(surveyData$san107 == "Handwashing station with water only", 1, 0)
  #
  # jmpHand3
  #
  jmpHand3 <- ifelse(surveyData$san107 == "Handwashing station with clean water and soap available", 1, 0)
} else {
  jmpHand1 <- vector(mode = "numeric", length = nrow(surveyData))
  jmpHand1[jmpHand1 == 0] <- NA
  jmpHand2 <- vector(mode = "numeric", length = nrow(surveyData))
  jmpHand2[jmpHand2 == 0] <- NA
  jmpHand3 <- vector(mode = "numeric", length = nrow(surveyData))
  jmpHand3[jmpHand3 == 0] <- NA
}


################################################################################
#
# Create handDF
#
################################################################################
#
# Concatenate handwashing indicators
#
handDF <- data.frame("uniqueID" = surveyData[ , "uniqueID"],
                     jmpHand1, jmpHand2, jmpHand3)
#
# Clean-up
#
rm(jmpHand1, jmpHand2, jmpHand3)


################################################################################
#
# Hygiene indicators
#
################################################################################

################################################################################
#
# san26: feel safe with sanitation facility
#
################################################################################
#
# Re-code
#
san26 <- ifelse(surveyData$san70 == "Yes", 1, 0)


################################################################################
#
# san27: feel safe using facility during menstruation
#
################################################################################
#
# Re-code
#
san27 <- ifelse(surveyData$san74 == "Yes", 1,
           ifelse(surveyData$san74 == "No", 0, NA))


################################################################################
#
# jmpWoman: girls and women comfortable with using facility
#
################################################################################
#
# Re-code
#
jmpWoman <- ifelse(san26 == 1 & san27 == 1, 1, 0)


################################################################################
#
# san28: material used for menstruation - clean menstrual management material
#
################################################################################
#
# Re-code
#
san28 <- ifelse(surveyData$san79 == "", "Don't know",
           ifelse(surveyData$san79 == "Other (please specify)", surveyData$san80, surveyData$san79))
#
# Re-code
#
san28 <- ifelse(san28 == "", "Don't know", san28)
#
# Clean-up - report as NA those who report not having a period/no need;
#            these lines of code [63-68] are Dhaka, Bangladesh specific
#
san28a <- ifelse(san28 %in% c("Cycle did not resume after birth",
                              "Menstrual cycle stopped",
                              "None aged of cycle",
                              "Pragnent",
                              "Ovary removed"), NA,
            ifelse(san28 == "Tissu paper", "Tissue paper", san28))
#
# Re-code
#
san28 <- ifelse(san28a == "Don't know", NA,
           ifelse(san28a %in% c("Cloth", "Napkin/pad"), 1, 0))

################################################################################
#
# san29: Appropriate menstrual cloth cleansing
#
################################################################################
#
# Re-code
#
san29 <- ifelse(surveyData$san81 == "", NA,
           ifelse(surveyData$san81 == "Other (please specify)", surveyData$san82, surveyData$san81))
#
# Re-code for estimation
#
san29 <- ifelse(san28a == "Napkin/pad", NA,
           ifelse(san28a == "Cloth" & san29 %in% c("Water and soap",
                                                   "Do not use again, disposed"), 1, 0))


################################################################################
#
# san30: Appropriate disposal of sanitary napkin
#
################################################################################
#
# Re-code
#
san30 <- ifelse(surveyData$san83 == "", NA,
           ifelse(surveyData$san83 == "Other (please specify)", surveyData$san84, surveyData$san83))
#
# Clean-up: these lines of code [109-114] is Dhaka, Bangladesh 2017 specific
#
san30 <- ifelse(san30 %in% c("Garbage  basket",
                             "Garbage basket in the sanitation facility",
                             "Garbage disposal",
                             "Under the soil by making ditch"), "Garbage disposal",
           ifelse(san30 == "Water body (Khal/Jhill)", "Water body (lake/river/pond)",
             ifelse(san30 %in% c("Menstrual cycle stopped", "Pragnent"), NA, san30)))
#
# Re-code for estimation
#
san30 <- ifelse(san28a == "Cloth", NA,
           ifelse(san28a == "Napkin/pad" & san30 == "Garbage disposal", 1, 0))


################################################################################
#
# jmpWomenHygiene: Good menstrual hygiene practice
#
################################################################################
#
# Re-code
#
jmpWomenHygiene <- ifelse(san29 == 1 | san30 == 1, 1, 0)


################################################################################
#
# Create hygieneDF
#
################################################################################
#
# Concatenate sanitation indicators
#
hygieneDF <- data.frame("uniqueID" = surveyData[ , "uniqueID"],
                        san26, san27, san28, san28a, san29, san30, jmpWoman, jmpWomenHygiene)
#
# Clean-up
#
rm(san26, san27, san28, san28a, san29, san30, jmpWoman, jmpWomenHygiene)


################################################################################
#
# Overall indicators
#
################################################################################
#
# overall1: not adequate water and not adequate sanitaiton services
#
overall1 <- ifelse(waterDF$accessWater == 0 & sanDF$adequateSan == 0, 1, 0)
#
# overall2: adequate water only
#
overall2 <- ifelse(waterDF$accessWater == 1 & sanDF$adequateSan == 0, 1, 0)
#
# overall3: adequate sanitation only
#
overall3 <- ifelse(waterDF$accessWater == 0 & sanDF$adequateSan == 1, 1, 0)
#
# overall4: adequate water and adequate sanitation services
#
overall4 <- ifelse(waterDF$accessWater == 1 & sanDF$adequateSan == 1, 1, 0)
#
# Overall spend
#
overallSpend <- rowSums(data.frame(waterDF$water12, sanDF$san14, sanDF$san34a), na.rm = TRUE)

################################################################################
#
# Create overallDF
#
################################################################################
#
# Concatenate overall indicators
#
overallDF <- data.frame("uniqueID" = surveyData[ , "uniqueID"],
                        overall1, overall2, overall3, overall4, overallSpend)
#
# Clean-up
#

rm(overall1, overall2, overall3, overall4)


################################################################################
#
# Create master data
#
################################################################################
#
# Merge all data.frames from current survey data
#
temp <- merge(adminDF, demoDF, by = "uniqueID")
temp <- merge(temp, povertyDF, by = "uniqueID")
temp <- merge(temp, waterDF, by = "uniqueID")
temp <- merge(temp, sanDF, by = "uniqueID")
temp <- merge(temp, handDF, by = "uniqueID")
temp <- merge(temp, hygieneDF, by = "uniqueID")
indicatorsDF <- merge(temp, overallDF, by = "uniqueID")


################################################################################
#
# Add identifier for city corporation - Bangladesh only
#
################################################################################

if(unique(country) == "Bangladesh") {
  #
  #
  #
  xx <- readOGR(dsn = "data-raw/dhakaCorporations",
                layer = "dhakaCorporations",
                verbose = FALSE)
  #
  #
  #
  long.lat.crs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
  #
  #
  #
  xx <- spTransform(x = xx, CRSobj = CRS(long.lat.crs))
  #
  #
  #
  yy <- SpatialPointsDataFrame(coords = indicatorsDF[ , c("longitude", "latitude")],
                               data = indicatorsDF,
                               proj4string = CRS(long.lat.crs))
  #
  #
  #
  north <- subset(xx, corprtn == "north")
  south <- subset(xx, corprtn == "south")
  #
  #
  #
  zz <- ifelse(indicatorsDF$psu %in% intersect(yy, north)@data$psu, "North City Corporation",
          ifelse(indicatorsDF$psu %in% intersect(yy, south)@data$psu, "South City Corporation", "Outside"))
  #
  #
  #
  indicatorsDF$corporation <- zz
  #
  #
  #
  rm(xx, yy, north, south, zz)
}

if(unique(country) != "Bangladesh") {
  #
  #
  #
  indicatorsDF$corporation <- NA
}

#
# Save indicators dataset
#
write.csv(x = indicatorsDF,
          file = paste("data-raw/indicatorsData",
                       unique(ccode), ".csv", sep = ""),
          row.names = FALSE)
#
#
#
indicatorsDataBGD <- indicatorsDF
#
#
#
devtools::use_data(indicatorsDataBGD, overwrite = TRUE)


################################################################################
#
# Merge all data.frames from all surveys
#
################################################################################
#
# Get range of survey years based on current year
#
#survey.date.range <- 2017:str_split(Sys.Date(), pattern = "-", simplify = TRUE)[ , 1]
#
# Get list of months
#
#survey.month.range <- substr(format(ISOdate(2004,1:12,1),"%B"), start = 1, stop = 3)
#
# Get list of countries
#
#survey.country.code <- c("BGD", "GHA", "KEN", "MDG", "MOZ", "ZMB")
#
#
#
#indicatorsDataAll <- NULL
#
#
#
#for(i in survey.country.code) {
  #
  #
  #
  #for(j in survey.month.range) {
    #
    #
    #
    #for(k in survey.date.range) {
      #
      #
      #
      #temp <- try(read.csv(file = paste("data/indicatorsData", i, j, k, ".csv", sep = ""),
      #                     header = TRUE, sep = ","),
      #            silent = TRUE)
      #
      #
      #
      #if(class(temp) == "try-error") { temp <- NULL }
      #
      #
      #
      #indicatorsDataAll <- data.frame(rbind(indicatorsDataAll, temp))
#    }
#  }
#}
#
# Save indicatorsAll dataset
#
#write.csv(x = indicatorsDataAll,
#          file = "data/indicatorsDataAll.csv",
#          row.names = FALSE)
#
# Clean-up
#
#rm(survey.date.range, survey.month.range, survey.country.code, temp)

