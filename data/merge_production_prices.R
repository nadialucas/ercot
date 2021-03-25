# title:    ps3.R
# author:  nadia lucas
# updated:  march 2021

#================================================#
# set up
#================================================#

# packages
library(tidyverse)
library(tigris)
library(sf)
library(RColorBrewer)
library(ggmap)
library(ggthemes)
library(mapview)
library(webshot)
library(ggpubr)
library(Hmisc)
library(knitr)
rm(list = ls())
# set directory
ddir <- "/Users/nadialucas/Documents/ercot"
setwd(ddir)

datadir <- "/Users/nadialucas/Dropbox/research/ercot"

prodtable <- read.csv(paste(datadir, "/intermediate_data/prod_data_cleaned.csv", sep = "")) 

prodtable <- prodtable %>%
  mutate(last_prod = as.Date(Last.Prod.Date)) %>%
  mutate(first_prod = as.Date(First.Prod.Date)) %>%
  mutate(complete_date = as.Date(Completion.Date)) %>%
  mutate(prod_length = 1 + last_prod - first_prod) %>%
  mutate(prod_length_int = as.integer(prod_length)) %>%
  mutate(prod_daily = Cum.Oil/prod_length_int)

prodtable_slim <- prodtable %>%
  select(last_prod, first_prod, lz, prod_daily)


start <- as.Date("01-01-08",format="%d-%m-%y")
end   <- as.Date("31-12-14",format="%d-%m-%y")

theDate <- start

datevec <- c()
Wvec <- c()
Nvec <- c()
Hvec <- c()
Svec <- c()
AENvec <- c()
NAvec <- c()

while (theDate <= end)
{
  datevec <- append(datevec, theDate)
  prod_temp <- prodtable_slim %>% filter(last_prod >= theDate & first_prod <= theDate)
  hi <- prod_temp %>%
    filter(last_prod >= theDate & first_prod <= theDate) %>%
    group_by(lz) %>%
    summarise(production = sum(prod_daily, na.rm = TRUE))
  Wvec <- append(Wvec, sum((hi$lz == "W") * hi$production, na.rm = TRUE))
  Nvec <- append(Nvec, sum((hi$lz == "N") * hi$production, na.rm = TRUE))
  Hvec <- append(Hvec, sum((hi$lz == "H") * hi$production, na.rm = TRUE))
  Svec <- append(Svec, sum((hi$lz == "S") * hi$production, na.rm = TRUE))
  AENvec <- append(AENvec, sum((hi$lz == "AEN") * hi$production, na.rm = TRUE))
  NAvec <- append(NAvec, sum((hi$lz == "") * hi$production, na.rm = TRUE))
  
  theDate <- theDate + 1                    
}

df <- data.frame(date = datevec,
                 LZ_WEST = Wvec,
                 LZ_NORTH = Nvec,
                 LZ_HOUSTON = Hvec,
                 LZ_SOUTH = Svec,
                 LZ_AEN = AENvec)

df_long <- df %>% gather(Zone, production, -c(date))


write.csv(df_long, paste(datadir, "/intermediate_data/prod_by_lz.csv", sep=""))

# time to loop through the prices and merge that shit

price_data <- data.frame()
files <- list.files(path = paste(datadir, "/raw_data/ercot_lmps/", sep = ""), pattern = "*.csv")
for (file in files) {
  tempdf <- read.csv(paste(datadir, "/raw_data/ercot_lmps/", file, sep = ""))
  price_data <- rbind(price_data, tempdf)
}

price_data_cleaned <- price_data %>% 
  separate(Date, c("day_str", "time_str", "ampm"), " ") %>%
  separate(time_str, c("hr", "trash1", "trash2"), ":") %>%
  mutate(hr = as.integer(hr)) %>%
  mutate(hr = ifelse(ampm == "PM", hr+12, hr)) %>%
  mutate(hr = ifelse(hr == 24, 25, hr)) %>%
  mutate(hr = ifelse(hr == 12, 24, hr)) %>%
  mutate(hr = ifelse(hr == 25, 12, hr)) %>%
  select(-trash1, -trash2, -ampm) %>%
  mutate(date = as.Date(day_str, "%m/%d/%Y")) %>%
  select(-day_str)


final_df <- merge(price_data_cleaned, df_long, by= c("date", "Zone")) %>%
  mutate(production = production /1e6)
write.csv(final_df, paste(datadir, "/intermediate_data/prod_prices_lz_merged.csv", sep=""))


final_df2 <- final_df %>% mutate(monthyr = format(date, "%Y-%m")) %>%
  group_by(monthyr, hr, Zone) %>%
  summarise(production = sum(production), Price = mean(Price))



# regress now
model <- lm(Price ~ production + as.factor(hr) + as.factor(monthyr), data = final_df2)
summary(model)
