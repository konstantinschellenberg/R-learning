library(terra)
library(raster)
library(stars)
library(tidyverse)
library(RColorBrewer)


# Raster -----------------------------------------------------------------------

ras = brick("data/2015-08-23_NDVI.tif")

pal = brewer.pal(6, "RdYlGn")

plot(ras, col = pal,
     maxpixels = 10000)

plot(ras, col = pal,
     ext = c(630000, 660000, 5690000, 5710000))


# Terra ------------------------------------------------------------------------



# Stars 1 read data and plot ---------------------------------------------------

star = read_stars("data/S2A_20160527.tif", proxy = TRUE)
dim(star)

star %>%
    slice(index = seq(1:4), along = "band") %>%   # slice from dplyr
    plot()

methods(class = "stars")



# install.packages("starsdata", repos = "http://pebesma.staff.ifgi.de", type = "source") 

# read_stars uses RasterIO, using the GDAL interface -> very handy
# yet, written into memory. -> Time & RAM consuming


# Stars 2 read with GDAL arguments ---------------------------------------------


tif2 = system.file("tif/L7_ETMs.tif", package = "stars")
star2 = read_stars(tif2)

plot(star2)

gdal_query = list(bands = c(1, 3, 4))

plot(read_stars(tif2, RasterIO = gdal_query))


gdal_query = list(nXOff = 6, nYOff = 6, nXSize = 100, nYSize = 100, 
                  nBufXSize = 100, nBufYSize = 100,
                  bands = c(1, 3, 4))

plot(read_stars(tif2, RasterIO = gdal_query))

gdal_query = list(nXOff = 6, nYOff = 6, nXSize = 20, nYSize = 20,
                  nBufXSize = 100, nBufYSize = 100, bands = c(1, 2, 4), 
                  resample = "cubic")

plot(read_stars(tif2, RasterIO = gdal_query))


# stars_proxy vignette ---------------------------------------------------------

granule = system.file("sentinel/S2A_MSIL1C_20180220T105051_N0206_R051_T32ULE_20180221T134037.zip", package = "starsdata")
s2 = paste0("SENTINEL2_L1C:/vsizip/", granule, "/S2A_MSIL1C_20180220T105051_N0206_R051_T32ULE_20180221T134037.SAFE/MTD_MSIL1C.xml:10m:EPSG_32632")

methods(class = "stars_proxy")

star3a = read_stars(s2, proxy = FALSE) %>% 
    slice(index = c(1,2), along = "band")

star3b = read_stars(s2, proxy = TRUE) %>% 
    slice(index = c(1,2), along = "band")

# system.time(plot(star3a)) # takes > 2 min.
system.time(plot(star3b)) # takes 0.51 sec.

# <https://r-spatial.github.io/stars/articles/stars2.html>

# bounding box -----------------------------------------------------------------

bb = st_bbox(c(xmin = 350000, ymin = 5890200, xmax = 370000, ymax = 5910000)) %>% 
    st_as_sfc()

st_crs(bb) = st_crs(star3b)

subset = star3b[bb]

class(subset) # still no data here!!
plot(subset) # plot reads the data, at resolution that is relevant

 # calculating on proxy --------------------------------------------------------

class(star)

star4 = star %>% 
    slice(index = c(4, 8), along = "band") %>% 
    .[read_sf("data/crop.shp")]

class(star4)

plot(star4)

# S2 10m: band 4: near infrared, band 1: red.
ndvi = function(x) (x[2] - x[1])/(x[2] + x[1])

star4.ndvi = st_apply(star4, c("x", "y"), ndvi)

system.time(plot(star4.ndvi)) # read - compute ndvi - plot

write_stars(star4.ndvi, dsn = "data/ndvi.tif") # read - compute ndvi - write to disk

star4.ndvi

# curviliear grids -------------------------------------------------------------

# composed to rectangular grid and matrix with lat/lon information

s5p = system.file("sentinel5p/S5P_NRTI_L2__NO2____20180717T120113_20180717T120613_03932_01_010002_20180717T125231.nc", package = "starsdata")

nit.c = read_stars(s5p, sub = "//PRODUCT/SUPPORT_DATA/DETAILED_RESULTS/nitrogendioxide_summed_total_column",
                   curvilinear = c("//PRODUCT/longitude", "//PRODUCT/latitude"), driver = NULL, proxy = T)

if (inherits(nit.c[[1]], "units")) {
    threshold = units::set_units(9e+36, mol/m^2)
} else {
    threshold = 9e+36
}
nit.c[[1]][nit.c[[1]] > threshold] = NA
st_crs(nit.c) = 4326

# inspect
nit.c

plot(nit.c, breaks = "equal", reset = FALSE, axes = TRUE, as_points = TRUE, 
     pch = 16,  logz = TRUE, key.length = 1)

# downsampling
nit.c_down = stars:::st_downsample(nit.c, 8)

plot(nit.c_down, breaks = "equal", reset = FALSE, axes = TRUE, as_points = FALSE, 
     border = NA, logz = TRUE, key.length = 1)

maps::map('world', add = TRUE, col = 'black', fill = F, lwd = 0.5)
