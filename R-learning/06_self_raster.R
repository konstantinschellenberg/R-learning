# 404 raster Prozessierung

library("raster")

getData(DGM.0.tif)

extent(raster) = extent(ger)

hasValues(raster)

# create noisy values
values(raster) = runif(ncell(raster))

# darstellen
plot(raster)

# add another
plot(ger, add = True)

# gibt Werte aus
getValues(r, row = 10)[1:20]
Values(r)[1:20]

# auch mit simpler R-syntax
r[1:12]

# statistics
cellStats(r, max)

summary(r)

# load external data
filename = system.file("external/file/grid.grd", package = "raster")

r = raster(filename)

# Projektion festlegen
wgs = "project4string"
r_2 = projectRaster(r, crs = wgs)

par(mfrom) = c(2, 1)
plot(r, main = "epsg:28992", legend = FALSE)
plot(r_2, main = "WGS84", legend = FALSE)

# resampling
res(r)

agg = aggregate(r, fact = 10, fun = sum)
plot(agg)
plot(r, add = True, alpha = 0.35, legend =FALSE, col = gray(0.4))

# export raster

writeRaster(r,
            filename = "raster.tif"
            format = "GTiff", overwrite = TRUE)

head(writeFormats())

# raster algebra
# algebraic, logical etc.

r*2

# raster from points

data(meuse)

# build a SPDF
coordinates(meuse) = ~ x + y

# create an empty raster based on r
lead = raster(extent(r), res = 400, crs = Project4string(r))

# rasterise
lead = rasterize(x = meuse, y = lead, field = "lead", fun = mean)

# color palette gelb -> blau
plot(lead, palette = "viridis") # oder so ähnlich

compareRaster()
setValues()
cellFromXY()
focal()
contour(), hillshade()
extract() # informationen herausziehen
intersect()
trim()
mosaic(), merge()
