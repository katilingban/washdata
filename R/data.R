################################################################################
#
#' Urban Water and Sanitation Survey Dataset
#'
#' See the README at
#' \href{https://github.com/katilingban/washdata#readme}{GitHub}
#'
#' @docType data
#' @name washdata
#' @keywords internal
#'
#
"_PACKAGE"

################################################################################
#
#' Population Data for Dhaka, Bangladesh
#'
#' Grid-based population of Dhaka, Bangladesh
#'
#' @format A data frame with four variables:
#' \describe{
#' \item{\code{psu}}{primary sampling unit (PSU) ID}
#' \item{\code{zone}}{survey enumeration area}
#' \item{\code{type}}{slum (1) or non-slum (2)}
#' \item{\code{pop}}{population}
#' }
#'
#' @examples
#' popBGD
#
"popBGD"

################################################################################
#
#' WASH Survey Raw Data for Dhaka, Bangladesh
#'
#' WASH survey raw data collected by WSUP in Dhaka, Bangladesh
#'
#' @format A data frame with 217 variables and 1282 entries:
#' \describe{
#' \item{\code{country}}{Country}
#' \item{\code{ccode}}{Country Code}
#' \item{\code{zone}}{Enumeration Area}
#' \item{\code{type}}{Sampling Point Type}
#' \item{\code{quadrat}}{Quadrat Number}
#' \item{\code{hhid}}{Household ID}
#' \item{\code{uniqueID}}{Unique ID}
#' \item{\code{month}}{Month of Survey}
#' \item{\code{year}}{Year of Survey}
#' \item{\code{deployment}}{Deployment}
#' \item{\code{enumerator}}{Enumerator}
#' \item{\code{status}}{Status}
#' \item{\code{responseCode}}{Response Code}
#' \item{\code{draftDate}}{Drafted On}
#' \item{\code{submissionDate}}{Submitted On}
#' \item{\code{ipAddress}}{IP Address}
#' \item{\code{surveyType}}{Survey type}
#' \item{\code{psu}}{primary sampling unit (PSU) ID}
#' \item{\code{psuTime}}{PSU ID  Time Answered}
#' \item{\code{latitude}}{PSU ID  Location Answered   latitude}
#' \item{\code{longitude}}{PSU ID  Location Answered   longitude}
#' \item{\code{accuracy}}{PSU ID  Location Answered   accuracy}
#' \item{\code{altitude}}{PSU ID  Location Answered   altitude}
#' \item{\code{area1}}{Thana}
#' \item{\code{area1Other}}{Thana  Other  please specify     specify}
#' \item{\code{area1Time}}{Thana  Time Answered}
#' \item{\code{area2}}{Ward}
#' \item{\code{slum}}{Slum}
#' \item{\code{gender}}{Respondent gender}
#' \item{\code{landOwnStatus}}{What is the respondent land ownership status}
#' \item{\code{nWomen}}{Number of adult women  aged 16 to  60}
#' \item{\code{nMen}}{Number of adult men  aged 16 to  60}
#' \item{\code{nOldWomen}}{Number of older women  aged _60}
#' \item{\code{nOldMen}}{Number of older men  aged _60}
#' \item{\code{nGirls}}{Number of girls  aged 4 15}
#' \item{\code{nBoys}}{Number of boys  aged 4 15}
#' \item{\code{nInfants}}{Number of infants  _3}
#' \item{\code{nMobility}}{How many people with reduced mobility are there in this household}
#' \item{\code{water1}}{Main source of drinking water}
#' \item{\code{water2}}{Main source of drinking water  Other  please specify     specify}
#' \item{\code{water3}}{Is the service provision formal or informal}
#' \item{\code{water4}}{Is the service provision formal or informal   Don t Know}
#' \item{\code{water5}}{Is main source of drinking water a WSUP supported facility}
#' \item{\code{water6}}{Is main source of drinking water a WSUP supported facility   Don t Know}
#' \item{\code{water7}}{Typical number of hours per day that water is available}
#' \item{\code{water8}}{Typical number of hours per day that water is available  Don t Know}
#' \item{\code{water9}}{Typical days per week that water is available}
#' \item{\code{water10}}{Typical days per week that water is available  Don t Know}
#' \item{\code{water11}}{Is water typically available and sufficient throughout the whole year}
#' \item{\code{water12}}{Is water typically available and sufficient throughout the whole year   Comments}
#' \item{\code{water13}}{Is water typically available and sufficient throughout the whole year   Don t Know}
#' \item{\code{water14}}{How long does it take to go there  get water  and come back}
#' \item{\code{water15}}{How long does it take to go there  get water  and come back   Don t Know}
#' \item{\code{water16}}{Are you satisfied that the distance between your main water source and your home is acceptable}
#' \item{\code{water17}}{Are you satisfied that the distance between your main water source and your home is acceptable   Don t Know}
#' \item{\code{water18}}{Do you consider that the queuing time at your main water source is acceptable}
#' \item{\code{water19}}{Do you consider that the queuing time at your main water source is acceptable   Not Applicable}
#' \item{\code{water20}}{Do you consider that the queuing time at your main water source is acceptable   Don t Know}
#' \item{\code{water21}}{Which household member s  usually collect the water}
#' \item{\code{water22}}{Which household member s  usually collect the water   Other  please specify     specify}
#' \item{\code{water23}}{Typical amount of water used by your household  per person per day}
#' \item{\code{water24}}{Typical amount of water used by your household  per person per day   Don t Know}
#' \item{\code{water25}}{Do you consider the amount of water supplied from your primary water source to be sufficient to meet your household_s requirements each day}
#' \item{\code{water26}}{Do you consider the amount of water supplied from your primary water source to be sufficient to meet your household_s requirements each day   Don t Know}
#' \item{\code{water27}}{Do you also use water from other water sources}
#' \item{\code{water28}}{Do you also use water from other water sources   Don t Know}
#' \item{\code{water29}}{Which is your usual secondary water source}
#' \item{\code{water30}}{Which is your usual secondary water source   Other  please specify     specify}
#' \item{\code{water31}}{Which is your usual secondary water source   Don t Know}
#' \item{\code{water32}}{Typical amount of money spent on water per week  magnitude}
#' \item{\code{water33}}{Typical amount of money spent on water per week  units}
#' \item{\code{water34}}{Typical amount of money spent on water per week  Don t Know}
#' \item{\code{water35}}{Are you satisfied with the price of your main water source}
#' \item{\code{water36}}{Are you satisfied with the price of your main water source   Don t Know}
#' \item{\code{water37}}{Would you be willing to invest in improving your drinking water source}
#' \item{\code{water38}}{Would you be willing to invest in improving your drinking water source   Comments}
#' \item{\code{water39}}{Would you be willing to invest in improving your drinking water source   Don t Know}
#' \item{\code{water40}}{Are you satisfied with the quality of your main water source}
#' \item{\code{water41}}{Are you satisfied with the quality of your main water source   Don t Know}
#' \item{\code{water42}}{What would increase your satisfaction}
#' \item{\code{water43}}{What would increase your satisfaction   Other improvement  please specify     specify}
#' \item{\code{water44}}{What would increase your satisfaction   Don t Know}
#' \item{\code{water45}}{Are you satisfied with the water pressure of your main water source}
#' \item{\code{water46}}{Are you satisfied with the water pressure of your main water source   Don t Know}
#' \item{\code{water47}}{Who do you talk to if there is a problem with the water supply}
#' \item{\code{water48}}{Who do you talk to if there is a problem with the water supply    Other  please specify     specify}
#' \item{\code{water49}}{Who do you talk to if there is a problem with the water supply    Not Applicable}
#' \item{\code{water50}}{Who do you talk to if there is a problem with the water supply    Don t Know}
#' \item{\code{water51}}{Previous source of drinking water}
#' \item{\code{water52}}{Previous source of drinking water  Other  please specify     specify}
#' \item{\code{water53}}{Previous source of drinking water  Don t Know}
#' \item{\code{water54}}{Typical amount of money spent per week on the previous water source  magnitude}
#' \item{\code{water55}}{Typical amount of money spent per week on the previous water source  units}
#' \item{\code{water56}}{Typical amount of money spent per week on the previous water source  Don t Know}
#' \item{\code{water57}}{Why do you use the WSUP supported facility instead of the facility you used before}
#' \item{\code{water58}}{Why do you use the WSUP supported facility instead of the facility you used before   Other  please specify     specify}
#' \item{\code{water59}}{Why do you use the WSUP supported facility instead of the facility you used before   Don t Know}
#' \item{\code{san1}}{Usage arrangement for household_s sanitation facility}
#' \item{\code{san2}}{Usage arrangement for household_s sanitation facility  Other  please specify     specify}
#' \item{\code{san3}}{Usage arrangement for household_s sanitation facility  Don t Know}
#' \item{\code{san4}}{How many people share use of the communal   shared toilet}
#' \item{\code{san5}}{How many people share use of the communal   shared toilet   Don t Know}
#' \item{\code{san6}}{What kind of toilet facility do members in your household usually use}
#' \item{\code{san7}}{What kind of toilet facility do members in your household usually use   Other  please specify     specify}
#' \item{\code{san8}}{What kind of toilet facility do members in your household usually use   Don t Know}
#' \item{\code{san9}}{Where does your toilet flush to}
#' \item{\code{san10}}{Where does your toilet flush to   Other  please specify     specify}
#' \item{\code{san11}}{Where does your toilet flush to   Don t Know}
#' \item{\code{san12}}{Is main sanitation  facility a WSUP supported facility}
#' \item{\code{san13}}{Is main sanitation  facility a WSUP supported facility   Not Applicable}
#' \item{\code{san14}}{Is main sanitation  facility a WSUP supported facility   Don t Know}
#' \item{\code{san15}}{Is water available at the sanitation facility}
#' \item{\code{san16}}{Is water available at the sanitation facility   Don t Know}
#' \item{\code{san17}}{Are you satisfied with the status of the hand washing facilities at the sanitation facility}
#' \item{\code{san18}}{Are you satisfied with the status of the hand washing facilities at the sanitation facility   Don t Know}
#' \item{\code{san19}}{What would increase your satisfaction  1}
#' \item{\code{san20}}{What would increase your satisfaction   Other  please specify     specify}
#' \item{\code{san21}}{What would increase your satisfaction   Don t Know  1}
#' \item{\code{san22}}{Is there an electric light in the sanitation facility}
#' \item{\code{san23}}{Is there an electric light in the sanitation facility   Don t Know}
#' \item{\code{san24}}{Does the sanitation facility have a lockable door}
#' \item{\code{san25}}{Does the sanitation facility have a lockable door   Don t Know}
#' \item{\code{san26}}{Does the sanitation facility have a container for menstrual hygiene management}
#' \item{\code{san27}}{Does the sanitation facility have a container for menstrual hygiene management   Don t Know}
#' \item{\code{san28}}{The last time your youngest child passed stools  what was done to dispose of the stools}
#' \item{\code{san29}}{The last time your youngest child passed stools  what was done to dispose of the stools   Not Applicable}
#' \item{\code{san30}}{The last time your youngest child passed stools  what was done to dispose of the stools   Don t Know}
#' \item{\code{san31}}{How long does it take to go there  queue for the toilet  if applicable  and come back}
#' \item{\code{san32}}{How long does it take to go there  queue for the toilet  if applicable  and come back   Don t Know}
#' \item{\code{san33}}{Typical amount of money spent on the main sanitation facility per week  magnitude}
#' \item{\code{san34}}{Typical amount of money spent on the main sanitation facility per week  units}
#' \item{\code{san35}}{Typical amount of money spent on the main sanitation facility per week  Don t Know}
#' \item{\code{san36}}{Are you satisfied with the price of the sanitation facility}
#' \item{\code{san37}}{Are you satisfied with the price of the sanitation facility   Don t Know}
#' \item{\code{san38}}{Did you make an initial investment in the sanitation facility}
#' \item{\code{san39}}{Did you make an initial investment in the sanitation facility    Don t Know}
#' \item{\code{san40}}{How much was the initial investment   magnitude}
#' \item{\code{san41}}{How much was the initial investment   units}
#' \item{\code{san42}}{How much was the initial investment   Don t Know}
#' \item{\code{san43}}{Would you be willing to invest in improved sanitation facilities}
#' \item{\code{san44}}{Would you be willing to invest in improved sanitation facilities   Comments}
#' \item{\code{san45}}{Would you be willing to invest in improved sanitation facilities   Don t Know}
#' \item{\code{san46}}{Are you satisfied with the cleanliness of the sanitation facilities}
#' \item{\code{san47}}{Are you satisfied with the cleanliness of the sanitation facilities   Don t Know}
#' \item{\code{san48}}{What would increase your level of satisfaction}
#' \item{\code{san49}}{What would increase your level of satisfaction   Other  please specify     specify}
#' \item{\code{san50}}{What would increase your level of satisfaction   Don t Know}
#' \item{\code{san51}}{Is everyone in the household able to get to the sanitation facility and use it}
#' \item{\code{san52}}{Is everyone in the household able to get to the sanitation facility and use it   Don t Know}
#' \item{\code{san53}}{Who is not using them}
#' \item{\code{san54}}{Who is not using them   Other  please specify     specify}
#' \item{\code{san55}}{Who is not using them   Don t Know}
#' \item{\code{san56}}{Why not}
#' \item{\code{san57}}{Why not   Other  please specify     specify}
#' \item{\code{san58}}{Why not   Don t Know}
#' \item{\code{san59}}{Do all household members usually use the available sanitation facilities}
#' \item{\code{san60}}{Do all household members usually use the available sanitation facilities   Don t Know}
#' \item{\code{san61}}{Who is not using them  1}
#' \item{\code{san62}}{Who is not using them   Other  please specify     specify 1}
#' \item{\code{san63}}{Who is not using them   Don t Know  1}
#' \item{\code{san64}}{Why are they not using the facilities}
#' \item{\code{san65}}{Why are they not using the facilities   Don t Know}
#' \item{\code{san66}}{Who do you talk to if there is a problem with the sanitation facility}
#' \item{\code{san67}}{Who do you talk to if there is a problem with the sanitation facility   Other  please specify     specify}
#' \item{\code{san68}}{Who do you talk to if there is a problem with the sanitation facility   Not Applicable}
#' \item{\code{san69}}{Who do you talk to if there is a problem with the sanitation facility   Don t Know}
#' \item{\code{san70}}{Do the women and girls in your household feel safe using the sanitation facilities during the day and night}
#' \item{\code{san71}}{Do the women and girls in your household feel safe using the sanitation facilities during the day and night  Don t Know}
#' \item{\code{san72}}{Why not  1}
#' \item{\code{san73}}{Why not   Don t Know  1}
#' \item{\code{san74}}{Do the women and girls in the household feel comfortable using the sanitation facilities during menstruation}
#' \item{\code{san75}}{Do the women and girls in the household feel comfortable using the sanitation facilities during menstruation   Not Applicable}
#' \item{\code{san76}}{Why not  2}
#' \item{\code{san77}}{Why not   Other  please specify     specify 1}
#' \item{\code{san78}}{Why not   Don t Know  2}
#' \item{\code{san79}}{What materials are used by the women girls of your house during their menstruation cycle}
#' \item{\code{san80}}{What materials are used by the women girls of your house during their menstruation cycle   Other  please specify     specify}
#' \item{\code{san81}}{How is the cloth washed}
#' \item{\code{san82}}{How is the cloth washed   Other  please specify     specify}
#' \item{\code{san83}}{Where do you dispose of the used napkin pad}
#' \item{\code{san84}}{Where do you dispose of the used napkin pad   Other  please specify     specify}
#' \item{\code{san85}}{When should you wash your hands}
#' \item{\code{san86}}{When should you wash your hands   Other  please specify     specify}
#' \item{\code{san87}}{When should you wash your hands   Don t Know}
#' \item{\code{san88}}{Can you show me where you wash your hands}
#' \item{\code{san89}}{Can you show me where you wash your hands   Not Applicable}
#' \item{\code{wash60}}{Can you show me where you store your drinking water}
#' \item{\code{wash61}}{Can you show me where you store your drinking water   Not Applicable}
#' \item{\code{wash62}}{Can you show me where you store your drinking water   Don t Know}
#' \item{\code{san90}}{How often do you empty your pit septic tank}
#' \item{\code{san91}}{How often do you empty your pit septic tank   Other  please specify     specify}
#' \item{\code{san92}}{How often do you empty your pit septic tank   Not Applicable}
#' \item{\code{san93}}{How often do you empty your pit septic tank   Don t Know}
#' \item{\code{san94}}{How much does it cost to empty   magnitude}
#' \item{\code{san95}}{How much does it cost to empty   units}
#' \item{\code{san96}}{How much does it cost to empty   Not Applicable}
#' \item{\code{san97}}{How much does it cost to empty   Don t Know}
#' \item{\code{san98}}{Who empties the pit}
#' \item{\code{san99}}{Who empties the pit   Other  please specify     specify}
#' \item{\code{san100}}{Who empties the pit   Not Applicable}
#' \item{\code{san101}}{Who empties the pit   Don t Know}
#' \item{\code{san102}}{Who pays for the pit to be emptied}
#' \item{\code{san103}}{Who pays for the pit to be emptied   Other  please specify     specify}
#' \item{\code{san104}}{Who pays for the pit to be emptied   Not Applicable}
#' \item{\code{san105}}{Who pays for the pit to be emptied   Don t Know}
#' \item{\code{san106}}{Are you satisfied with the pit emptying service}
#' \item{\code{ppi1}}{How many   household members are 12 years old or younger}
#' \item{\code{ppi2}}{Do all   household members ages 6 to 12 currently attend a school educational   institution}
#' \item{\code{ppi3}}{X   In the   past year  did any household member ever do work for which he she was paid on   a daily basis}
#' \item{\code{ppi4}}{How many   rooms does your household occupy  excluding rooms used for business}
#' \item{\code{ppi5}}{What is the main construction material of the walls of the main room}
#' \item{\code{ppi6}}{Does the household own any televisions}
#' \item{\code{ppi7}}{How many fans does the household own}
#' \item{\code{ppi8}}{How many mobile phones does the household own}
#' \item{\code{ppi9}}{Does the household own any bicycles  motorcycle scooters  or motor cars etc}
#' \item{\code{ppi10}}{Does the household own  or rent sharecrop mortgage in or out  51 or more decimals of cultivable agricultural land  excluding uncultivable land and dwelling house homestead land}
#' \item{\code{ppi11}}{Does the household own  or rent sharecrop mortgage in or out  51 or more decimals of cultivable agricultural land  excluding uncultivable land and dwelling house homestead land    Time Answered}
#' }
#'
#' @examples
#' surveyDataBGD
#'
#
"surveyDataBGD"

################################################################################
#
#' WASH Survey Indicators Data for Dhaka, Bangladesh
#'
#' WASH survey indicators data calculated from survey raw data
#'
#' @format A data frame with 162 variables and 1282 entries
#'
#' @examples
#' indicatorsDataBGD
#'
#
"indicatorsDataBGD"

################################################################################
#
#' PPI Look-up Table for Bangladesh
#'
#' PPI look-up table for Bangladesh to calculate PPI score
#'
#' @format A data frame with 10 variables and 101 entries
#'
#' @examples
#' ppiMatrixBGD
#'
"ppiMatrixBGD"

