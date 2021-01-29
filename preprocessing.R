library(dplyr)


#read in data after setting working directory to file location
hotels <- read.csv('./hotel_bookings.csv')

#Checking for missing values
length(which(rowSums(is.na(hotels))>0)) #returns 4 rows
colnames(hotels)[colSums(is.na(hotels))>0] #returns children column


#### Cleaning ISO code issue before joining with ISO dataset
hotels <- hotels %>% mutate(country = replace(country,
                                              country == 'CN',
                                              'CHN'))

iso_codes <- read.csv('https://datahub.io/core/country-codes/r/country-codes.csv')
iso_codes <- iso_codes %>% select(country = ISO3166.1.Alpha.3,
                                  country_name = official_name_en,
                                  region = Region.Name)
hotels <- hotels %>% 
  left_join(iso_codes, by = 'country') %>% 
  rename(country_code = country)


########Cleaning missing/null values from ISO code join
hotels <- hotels %>% 
  mutate(country_name = replace(
    country_name, country_code == 'NULL','Unknown'),
    region = replace(region,country_code == 'NULL','Unknown'),
    
    country_name = replace(country_name, 
                           country_code == 'TMP','East Timor'),
    region = replace(region, country_code == 'TMP', 'Asia'),
    
    country_name = replace(country_name, 
                           country_code == 'TWN','Taiwan'),
    region = replace(region, country_code == 'TWN', 'Asia'),
    
    region = replace(region, country_code == 'ATA', 'Antarctica'))


#Remove extraneous columns from dataframe
hotels <- hotels %>% select(-arrival_date_week_number,
                            -meal,-distribution_channel,
                            -agent,-company,
                            -required_car_parking_spaces,
                            -total_of_special_requests)

#Calculate total nights for each stay
hotels <- hotels %>% 
  mutate(total_nights = stays_in_week_nights +
           stays_in_weekend_nights)

# Derive season based on which month the reservation is
hotels <- hotels %>% mutate(
  season = case_when(arrival_date_month %in% 
                       c('December','January','February') ~'Winter',
                     arrival_date_month %in% 
                       c('March','April','May')~'Spring',
                     arrival_date_month %in% 
                       c('June','July','August')~'Summer',
                     arrival_date_month %in% 
                       c('September','October','November')~'Fall'))


hotels <- hotels %>% mutate(stay_revenue = total_nights*adr)



#replacing unknown values of children number with 0

hotels$children[is.na(hotels$children)] <- 0

# Write cleaned data to new CSV file
write.csv(hotels, file = 'hotel_bookings_cleaned.csv',row.names = F)
