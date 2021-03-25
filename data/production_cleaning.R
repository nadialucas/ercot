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
library(raster)
library(sf)
library(sp)
library(rgdal)
rm(list = ls())
# set directory
ddir <- "/Users/nadialucas/Documents/ercot"
setwd(ddir)

datadir <- "/Users/nadialucas/Dropbox/research/ercot"

prodtable <- read.csv(paste(datadir, "/raw_data/Production\ Table.CSV", sep = ""))
county_names = unique(prodtable$County.Parish)

# match each county to corresponding load zone
# read in tiffs
#lz_raster <- raster(paste(datadir, "/raw_data/maps/Load-Zone-Map_2020_full.tiff", sep = ""))
#lz_raster <- setMinMax(lz_raster)
#crs(lz_raster) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 

prodtable <- prodtable %>% rename(county = County.Parish) %>%
  mutate(lz = "")
#template

# first get at the border counties
prodtable <- prodtable %>% mutate(lz = ifelse(county == "TRAVIS (TX)", "AEN", lz)) %>%
  mutate(lz = ifelse(county == "BEXAR (TX)", "H", lz)) %>%
  mutate(lz = ifelse(county == "CHAMBERS (TX)", "H", lz)) %>%
  mutate(lz = ifelse(county == "HARRIS (TX)", "H", lz)) %>%
  mutate(lz = ifelse(county == "MONTGOMERY (TX)", "H", lz)) %>%
  mutate(lz = ifelse(county == "GALVESTON-LB (TX)", "H", lz)) %>%
  mutate(lz = ifelse(county == "GALVESTON-SB (TX)", "H", lz)) %>%
  mutate(lz = ifelse(county == "GALVESTON (TX)", "H", lz)) %>%
  mutate(lz = ifelse(county == "FORT BEND (TX)", "H", lz)) %>%
  mutate(lz = ifelse(county == "MATAGORDA (TX)", "H", lz)) %>%
  mutate(lz = ifelse(county == "WHARTON (TX)" , "S", lz)) %>%
  mutate(lz = ifelse(county == "COLORADO (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "AUSTIN (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "WASHINGTON (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "GRIMES (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "BRAZOS (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "BRAZOS-SB (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "BRAZOS-LB (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "BURLESON (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "BRAZORIA (TX)"  , "H", lz)) %>%
  mutate(lz = ifelse(county == "MILAM (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "ROBERTSON (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "FALLS (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "MCLENNAN (TX)" , "N", lz)) %>%
  mutate(lz = ifelse(county == "BOSQUE (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "CORYELL (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "HAMILTON (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "WILLIAMSON (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "MILLS (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "LAMPASAS (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "BROWN (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "COMANCHE (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "ERATH (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "EASTLAND (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "STEPHENS (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "YOUNG (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "ARCHER (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "CLAY (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "MONTAGUE (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "WISE (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "JACK (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "MCCULLOCH (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "MENARD (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "KIMBLE (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "EDWARDS (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "VAL VERDE (TX)", "W", lz))

# now time for the 
prodtable <- prodtable %>% mutate(lz = ifelse(county == "PECOS (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "REEVES (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "LOVING (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "CULBERSON (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "JEFF DAVIS (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "PRESIDIO (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "TERRELL (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "CROCKETT (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "WARD (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "WINKLER (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "ECTOR (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "CRANE (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "ANDREWS (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "MIDLAND (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "UPTON (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "REAGAN (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "GLASSCOCK (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "GAINES (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "YOAKUM (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "TERRY (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "COCHRAN (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "LYNN (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "GARZA (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "BORDEN (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "DAWSON (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "HOCKLEY (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "LUBBOCK (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "LAMB (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "HALE (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "FLOYD (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "MOTLEY (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "COTTLE (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "CROSBY (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "DICKENS (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "KENT (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "STONEWALL (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "SCURRY (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "MARTIN (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "HOWARD (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "MITCHELL (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "NOLAN (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "TAYLOR (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "STERLING (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "IRION (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "TOM GREEN (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "COKE (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "SCHLEICHER (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "SUTTON (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "CONCHO (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "RUNNELS (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "COLEMAN (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "CALLAHAN (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "SHACKELFORD (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "DALLAM (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "SHERMAN (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "HANSFORD (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "OCHILTREE (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "LIPSCOMB (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "HARTLEY (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "MOORE (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "HUTCHINSON (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "ROBERTS (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "HEMPHILL (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "OLDHAM (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "POTTER (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "CARSON (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "GRAY (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "WHEELER (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "DONLEY (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "COLLINGSWORTH (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "BRISCOE (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "CHILDRESS (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "HARDEMAN (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "FOARD (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "KING (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "KNOX (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "HASKELL (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "FISHER (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "JONES (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "THROCKMORTON (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "BAYLOR (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "WILBARGER (TX)", "W", lz)) %>%
  mutate(lz = ifelse(county == "WICHITA (TX)", "W", lz))

# now North area
prodtable <- prodtable %>% 
  mutate(lz = ifelse(county == "COOKE (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "GRAYSON (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "FANNIN (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "RED RIVER (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "DENTON (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "PALO PINTO (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "PARKER (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "TARRANT (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "DALLAS (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "HUNT (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "HOPKINS (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "WOOD (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "FRANKLIN (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "TITUS (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "CAMP (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "BOWIE (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "MORRIS (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "MARION (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "HARRISON (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "PANOLA (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "GREGG (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "UPSHUR (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "RUSK (TX)" , "N", lz)) %>%
  mutate(lz = ifelse(county == "SHELBY (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "SABINE (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "SAN AUGUSTINE (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "NEWTON (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "JASPER (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "TYLER (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "POLK (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "HARDIN (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "ORANGE (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "JEFFERSON (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "SAN JACINTO (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "LIBERTY (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "WALKER (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "ANGELINA (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "NACOGDOCHES (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "SMITH (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "CHEROKEE (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "HOUSTON (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "ANDERSON (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "MADISON (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "LEON (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "FREESTONE (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "HENDERSON (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "VAN ZANDT (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "KAUFMAN (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "ELLIS (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "NAVARRO (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "LIMESTONE (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "JOHNSON (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "HOOD (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "HILL (TX)", "N", lz))

# time to code the south
prodtable <- prodtable %>%
  mutate(lz = ifelse(county == "CAMERON (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "WILLACY (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "HIDALGO (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "KENEDY (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "STARR (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "JIM HOGG (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "BROOKS (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "KLEBERG (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "JIM WELLS (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "NUECES (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "DUVAL (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "WEBB (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "LA SALLE (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "ZAPATA (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "SAN PATRICIO (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "REFUGIO (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "ARANSAS (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "BEE (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "GOLIAD (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "MCMULLEN (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "LIVE OAK (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "DIMMIT (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "ZAVALA (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "FRIO (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "KARNES (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "ATASCOSA (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "WILSON (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "DEWITT (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "GONZALES (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "GUADALUPE (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "CALDWELL (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "BASTROP (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "FAYETTE (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "JACKSON (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "VICTORIA (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "CALHOUN (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "KERR (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "UVALDE (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "REAL (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "BANDERA (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "MEDINA (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "HUDSPETH (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "LAVACA (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "MAVERICK (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "CASS (TX)", "NA", lz)) %>%
  mutate(lz = ifelse(county == "LEE (TX)", "S", lz)) %>%
  mutate(lz = ifelse(county == "WALLER (TX)", "H", lz)) %>%
  mutate(lz = ifelse(county == "SOMERVELL (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "MATGRDA IS-LB (TX)", "H", lz)) %>%
  mutate(lz = ifelse(county == "MATGRDA IS-SB (TX)", "H", lz)) %>%
  mutate(lz = ifelse(county == "RAINS (TX)", "N", lz)) %>%
  mutate(lz = ifelse(county == "TRINITY (TX)", "NA", lz)) 

write.csv(prodtable, paste(datadir, "/intermediate_data/prod_data_cleaned.csv", sep=""))
  
  
    



