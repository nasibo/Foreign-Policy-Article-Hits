## run the  "freegeoip" function at bottom of code before starting. 

## libraries to load
library(rjson)
library(ggplot2)
library(rgdal)
library(mapproj)
library(ggmap)
library(dplyr)
library(tidyr)
library(maptools)
library(gpclib)
library(stringr)

## set to your working directory
setwd("/YOUR/WORKING/DIRECTORY")

## reading in the json file
json_file <- fromJSON(file = "websitehits.json")

## the json_file object is list, the for loop below puts it into a data frame
json_df <- NULL
for(i in 1:length(json_file)){
  line <- json_file[[i]]
  line <- as.data.frame(line)
  json_df <- rbind(json_df, line)
}

## each time a visitor goes to the site it shows up as a hit for each
## of the files, so we need to remove those duplicate hits. 
## To do this, only keep ULRs that equal /chinarealestate/
json_df <- filter(json_df, url == "/chinarealestate/")

## The agent column lists the type of device people are using to access the
## article, but to get at it we need to parse some text with the code below
type <- as.character(json_df$agent)

## get the first and second positions of the parenthesis 
pos1 <- as.data.frame(str_locate(type,"\\("))
pos2 <- as.data.frame(str_locate(type,"\\)"))
pos <- data.frame(start = pos1$start, end = pos2$end)
start <- pos$start + 1
end <- pos$end - 1

## get just the text between the parenthesis
type2 <- substr(type,start,end)

## then the first word
first_word <- as.data.frame(str_locate(type2," "))
first_word_start <- first_word$start - 1
device <- substr(type2,1,first_word_start)
device <- gsub(";","",device)

## change Linux to Android because in each case of Linux and Android 
## device comes after and that's what we're after
device <- replace(device, device == "Linux", "Android")

## attach device data to json_df
json_df$device <- device

## delete rows with "compatible", it also deletes NA rows, which is what 
## we want
json_df <- filter(json_df, device != "compatible")

locals <- NULL
for(i in 1:nrow(json_df)){
  data <- as.data.frame(json_df[i,])
  ip <- as.character(data$ip)
  local <- freegeoip(ip, format = "dataframe")
  local$device <- as.character(data$device)
  locals <- rbind(locals, local)
}

locals$longitude <- as.numeric(as.character(locals$longitude))
locals$latitude <- as.numeric(as.character(locals$latitude))

## The following command might need to be run to get the fortify()
## command below to run. It's fussy. 
gpclibPermit()

## load in the shapefile map data that should be in the same directory as
## this R code. Then turn that data into a dataframe with fortify()
map <- readOGR("ne_50m_admin_0_countries",layer="ne_50m_admin_0_countries")
map <- spTransform(map, CRS("+init=epsg:4326"))
map <- fortify(map, region = "admin")

## remove Antarctica and Greenland because they take up too much room on the map
map <- map[!map$id %in% c("Antarctica","Greenland"),]


device_map <- ggplot() + 
  geom_polygon(data = map, aes(long, lat, group = group)) + 
  coord_equal(xlim = c(-126, -66),ylim = c(50, 22)) + ## set on the US
  geom_point(data = locals, aes(x=longitude, y = latitude, color = device), 
    alpha = .5, size = 1) + 
  ggtitle("Website Visitor IP Locations and Devices") + 
  theme(plot.title = element_text(lineheight=.8),
    axis.ticks.y = element_blank(),
    axis.text.y = element_blank(),
    axis.title.y=element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.x = element_blank(),
    axis.title.x=element_blank())

print(device_map)
ggsave("US_device_map.png", device_map)

############################################################
## now lets put more IP address on a map
############################################################


## I was able to collect 1000 unique IP addresses from the awstats service 
## on Bluehost, where I host my website, and put them in a csv file
ip_data <- read.csv("IP.csv")

## the last row is not useful
ip_data <- head(ip_data, nrow(ip_data)-1)

ip_df <- NULL
for(i in 1:nrow(ip_data)){
  data <- as.data.frame(ip_data[i,])
  ip <- as.character(data$IP)
  hits <- data$Hits
  local <- freegeoip(ip, format = "dataframe")
  local$hits <- hits/4
  ip_df <- rbind(ip_df, local)
}

ip_df$longitude <- as.numeric(as.character(ip_df$longitude))
ip_df$latitude <- as.numeric(as.character(ip_df$latitude))

ip_world_map <- ggplot() + 
  geom_polygon(data = map, aes(long, lat, group = group)) + 
  coord_equal() +
  geom_point(data = ip_df, aes(x=longitude, y = latitude, size = hits), 
    color = "red", alpha = .15) + 
  scale_size(range = c(.1, 3)) + 
  ggtitle("Website Visitor IP Locations") +
  theme(plot.title = element_text(lineheight=.8),
    axis.ticks.y = element_blank(),
    axis.text.y = element_blank(),
    axis.title.y=element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.x = element_blank(),
    axis.title.x=element_blank())

print(ip_world_map)

ggsave("ip_world_map.png", ip_world_map)


## below is the code that is used to get the geographic data for each IP address
## this function was created by Andrew Ziem
## here: https://heuristically.wordpress.com/2013/05/20/geolocate-ip-addresses-in-r/

freegeoip <- function(ip, format = ifelse(length(ip)==1,'list','dataframe'))
{
  if (1 == length(ip))
  {
    # a single IP address
    require(rjson)
    url <- paste(c("http://freegeoip.net/json/", ip), collapse='')
    ret <- fromJSON(readLines(url, warn=FALSE))
    if (format == 'dataframe')
      ret <- data.frame(t(unlist(ret)))
    return(ret)
  } else {
    ret <- data.frame()
    for (i in 1:length(ip))
    {
      r <- freegeoip(ip[i], format="dataframe")
      ret <- rbind(ret, r)
    }
    return(ret)
  }
}
