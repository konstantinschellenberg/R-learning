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

## stars_proxy vignette

install.packages("starsdata", repos = "http://pebesma.staff.ifgi.de", type = "source") 

# read_stars uses RasterIO, using the GDAL interface -> very handy
# yet, writting into memory. -> Time $ RAM consuming
library(stars)

tif = system.file("tif/L7_ETMs.tif", package = "stars")

star2 = read_stars(tif)

plot(star2)

gdal_query = list(nXOff = 6, nYOff = 6, nXSize = 100, nYSize = 100, 
                  bands = c(1, 3, 4))

plot(read_stars(tif, RasterIO = gdal_query))

gdal_query = list(nXOff = 6, nYOff = 6, nXSize = 100, nYSize = 100, 
                  nBufXSize = 20, nBufYSize = 20,
                  bands = c(1, 3, 4))

plot(read_stars(tif, RasterIO = gdal_query))

gdal_query = list(nXOff = 6, nYOff = 6, nXSize = 3, nYSize = 3,
                  nBufXSize = 200, nBufYSize = 200, bands = 1, 
                  resample = "cubic")

plot(read_stars(tif, RasterIO = gdal_query))

