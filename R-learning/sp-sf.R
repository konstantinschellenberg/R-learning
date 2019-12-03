# read in some data

library("sf") # neues Paket
library("sp") # altes Paket, auswählen mit @, S4-Programmierung
library("dplyr")

class(object) # gibt aus, aus welchem Paket die Klasse kommt

nc = read_sf(system.file("shape/nc.shp", package = "sf"))
data(meuse)

meuse_sp = meuse
meuse_sf = meuse

class(nc)
typeof(nc)

plot(nc[, "BIR79"])
st_crs(nc)


## meuse heavy metal river analysis

st_crs(meuse_sp) # existiert noch nicht
?st_as_sf # Help

coordinates(meuse_sp) = c("x", "y")

# so schicker!!! Direkt in sf-Objekt

proj_meuse_sf = st_as_sf(meuse_sf, coords = c("x", "y"), crs = 28992, agr = "constant")
class(proj_meuse_sf)
st_crs(proj_meuse_sf)
plot(proj_meuse_sf)

summary(proj_meuse_sf)

# compute summary

summary(proj_meuse_sf)

# elevation hiiger than 7

med = median(proj_meuse_sf$copper)
dplyr::filter
