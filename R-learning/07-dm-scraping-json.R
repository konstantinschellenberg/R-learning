# Filename: dm_scraping.R (2017-11-13)
#
# Author(s): Jannes Muenchow, Patrick Schratz
#
# CONTENTS-------------------------------------------------
#
# 1 SCRAPE DM LOCATIONS---------------------------------------------------------

# 1.1 have a look at the page to scrape -----------------------------------------

browseURL("https://www.dm.de/filialfinder-c468710.html?q_storefinder=")
# again uses google maps and the output of google maps is used to define a
# bounding box which is used in the following GET-query

# typing 90403, Nuremberg, Germany into the query window gives you following
# GET command (can be found using the network developers mode in your
# browser)
# this is basically a bbox we can construct ourselves using the google map
# API

# 1.2 construct a URL and build a bounding box around your centroid -------------

# here, I use the centroid of a Jena PC but you have to find the centroid
# programmatically, of course
coords = data.frame(X = 11.59398, Y = 50.94939)

url = paste0(
  "https://www.dm.de/cms/restws/stores/find?requestingCountry=DE&", 
  "countryCodes=DE%2CAT%2CBA%2CBG%2CSK%2CRS%2CHR%2CCZ%2CRO%2CSI%", 
  "2CHU%2CMK&mandantId=100", 
  "&bounds=", coords$Y - 0.5, 
  "%2C", coords$X - 0.5,
  "%7C", coords$Y + 0.5, 
  "%2C", coords$X + 0.5, 
  "&before=false&after=false&morningHour=9&eveningHour=18&_", 
  "=1479236790492") 

# 1.3 download the GET response (which is a JSON file)---------------------------

browseURL(url)
# PLEASE RUN THE FOLLOWING COMMAND ONLY ONCE, we don't want to be blocked by the
# API due to an excessive amount of GET queries!
out = jsonlite::fromJSON(url)
# hence, save your output
saveRDS(out, "homework/01-stores/data/dm_json.rds")
# to read in the output, use
out = readRDS("homework/01-stores/data/dm_json.rds")

# 1.4 extract the information from the json-file you need -----------------------

out$address
