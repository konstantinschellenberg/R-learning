library(terra)
library(raster)
library(stars)
library(tidyverse)
library(RColorBrewer)


# Raster -----------------------------------------------------------------------

ras = raster("data/2015-08-23_NDVI.tif")

pal = brewer.pal(6, "RdYlGn")

plot(ras, col = pal,
     maxpixels = 10000)

plot(ras, col = pal,
     ext = c(630000, 660000, 5690000, 5710000))


# Terra ------------------------------------------------------------------------



# Stars ------------------------------------------------------------------------

star2 = read_stars(proxy = T, "D:/Geodaten/#Jupiter/GEO402/01_data/s1_data/S1_A_D_VH_free_state_study_area_geo402")
star2

star = read_stars("data/S2A_20161004.tif", proxy = TRUE)
dim(star)

star %>%
    slice(index = 1, along = "band") %>%
    plot()

methods(class = "stars")
methods(class = "stars_proxy")

system.time(plot(star))







