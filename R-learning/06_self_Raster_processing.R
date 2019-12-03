# Workflow for aggregating POI from OSM in Dresden

library(curl)
library(raster)
library(sf)
library(here) # for easy relative paths
library(tibble)
library(dplyr)
library(ggplot)
library(tmap) # for osm view

# download shape file

# temp <- tempfile()
# download.file("https://www.geofabrik.de/data/shapefiles_dresden.zip", temp)

--------------------------------------------------------------------------------
here()

# makes the tibbles to be printed to the end
options(tibble.print_max = 100)

# load data into workspace
shape <- read_sf(here("/ignored/shapefiles_dresden/gis_osm_pois_07_1.shp"))
#st_crs(shape) = 32632

# convert projection
#st_transform(shape, crs = 32632)

# Koordinatensystem
st_crs(shape)

# create factor column, better to sort
shape$fclass = as.factor(shape$fclass)
shape[, "fclass"]

# get all classes
fclasses = shape %>%
    dplyr::count(shape$fclass)

# get restaurants and atms
rest_atm = shape %>% 
    dplyr::filter(shape$code == 2301 | shape$fclass == "atm")
    # dplyr::group_by(shape$code)
    # dplyr::count()

# display head of tibble
head(rest_atm)

# get count of restaurants and atms
dplyr::count(rest_atm, rest_atm$fclass)

plot(rest_atm["fclass"], axis = TRUE)
summary(rest_atm)

# dplyr sorting

show_nice_table = rest_atm %>% 
    group_by(fclass) %>% 
    summarise(count = n()) %>% 
    st_set_geometry(NULL) %>%       # geometrien entfernen 
    arrange(desc(count)) %>% 
    print(n = nrow(.))              # print things inside the pipe, not necessary

# crop extent
ex = c(13.7, 13.8, 51.05, 51.1)
poi2 = st_crop(rest_atm, ex)

# show restaurants and atm in central dresden
plot(poi2["fclass"], axis = TRUE, pch = 16)

cuts = c(0, 5, 10, 15, 20, 30, 50, 75, 100)

tmap_mode("view")

tm_basemap("OpenStreetMap")
# now show the raster on it über leaflet
