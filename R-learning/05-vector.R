# Slides with excercises: lessons/03_vector/03_vector.Rmd
# Last updated: Oct 2019

# TO DO: introduce spatial vector operations in R

# Author(s): Jannes Muenchow & Patrick Schratz

#**********************************************************
# CONTENTS-------------------------------------------------
#**********************************************************

# 1. EXERCISE 1
# 2. EXERCISE 2
# 3. EXERCISE 3

# ATTACH PACKAGES AND DATA----------------------------------------------------

# attach packages
library("sp")
library("sf")
library("rworldmap")
library("RColorBrewer")
library("classInt")
library("purrr")

# load the nc and meuse datasets
nc <- read_sf(system.file("shape/nc.shp", package = "sf"))
data(meuse)
class(meuse)
View(meuse)
meuse
# 1 EXERCISE 1 -----------------------------------------------------------------

# 1.1  Load the "North Carolina" dataset into R, find out about its ------------
# coordinates reference system, and plot only the `BIR79`-column.

# coordinate reference system
st_crs(nc)
# plotting only the first column
plot(nc[, "BIR79"])

# 1.2 Convert it into a spatial object with the help of the x- and y-column ----

# convert meuse into a SpatialPointsDataFrame
meu_sp <- meuse
coordinates(meu_sp) <- c("x", "y")
# the same as
# coordinates(meu_sp) =~ x + y


# 1.3  Convert the object with `st_as_sf()` into an object of class `sf` -------

meu_sf <- st_as_sf(meu_sp)
# or doing it directly
st_as_sf(meuse, coords = c("x", "y"))

# (optional) set crs (helps for plotting)
st_crs(meu_sf) <- 28992

# 1.4 Compute some `summary` statistics for *heavy metal* concentrations--------

# heavy metals
vars <- c("cadmium", "copper", "lead", "zinc")
# compute summary statistics
summary(meuse[, vars])

# 1.5 How many points are at elevations higher than 7 and have a copper --------

med <- median(meu_sf$copper)
dplyr::filter(meu_sf, elev > 7 & copper > med)

# select the points which are at a elevation higher than 7 and whose copper
# content is greater than the median copper content
med <- median(meu_sf$copper)
subset <- meu_sf[meu_sf$copper > med & meu_sf$elev > 7, ]

plot(meu_sf[, "copper"], col = "black")
plot(st_geometry(meu_sf))
plot(st_geometry(subset), pch = 16, col = "red", add = TRUE)

# the sp-way:
# my_subset = meu_sp[meu_sp@data$copper > med & meu_sp@data$elev > 7, ]
# plot(meu_sp)
# points(my_subset, pch = 16, col = "red")

#**********************************************************
# 2 EXERCISE 2--------------------------------------------
#**********************************************************

library("sp")
library("dplyr")
library("classInt")
library("RColorBrewer")
library("purrr")
library("sf")
library("ggplot2")

# 2.1 Calculate the median of all numerical columns using `map()`.--------------

options(digits = 2, scipen = 4)
data(meuse)
# find out which columns are numeric
ind <- map_lgl(meuse, is.numeric)
# median of all numeric columns
map_dbl(meuse[, ind], median)

# 2.2 Use `dplyr::mutate()` to calculate the rowsums of all heavy metals. ------

# convert meuse to a SPDF
# add a column with the sum of all heavy metals
meuse %<>%
  dplyr::rowwise() %>%
  dplyr::mutate(heavy = sum(cadmium, copper, lead, zinc))

# the same using base R
# meuse[, "heavy"] = apply(meuse[, c("cadmium", "copper", "lead", "zinc")], 1,
# sum)

# 2.3 Plot the newly created column `heavy` ------------------------------------

meuse_sf <- st_as_sf(meuse, coords = c("x", "y"))
# plot heavy
q_5 <- classInt::classIntervals(meuse_sf$heavy, n = 5, style = "fisher")
pal <- brewer.pal(5, "Reds")
my_cols <- findColours(q_5, pal)
plot(meuse_sf[, "heavy"], col = my_cols, pch = 16)
legend("topleft",
  fill = attr(my_cols, "palette"),
  legend = names(attr(my_cols, "table")), bty = "n"
)

# or:
# 1. create a new categorical variable based on the breaks
meuse$cat <- cut(q_5$var, q_5$brks, include.lowest = TRUE)
# 2. plot the categorical variable
plot(meuse[, "cat"], pal = pal, pch = 19)

# 2.4 Convert `data(meuse.riv)` into SpatialPolygons ---------------------------

# load meuse.riv
data(meuse.riv)
class(meuse.riv) # matrix
# convert to SpatialPolygons
riv <- meuse.riv %>%
  list() %>%
  st_polygon() %>%
  st_sfc()

# 2.5  Draw a box around the plot and label the x- and y-axis. -----------------

# create a clipping box
bb <- st_bbox(meuse_sf) + c(-250, -250, 250, 250)
pmat <- matrix(c(bb[c(1, 2, 3, 2, 3, 4, 1, 4, 1, 2)]), ncol = 2, byrow = TRUE)
box <- st_polygon(list(pmat))
# or shortcut version (https://github.com/r-spatial/sf/issues/572)
box <- st_as_sfc(bb)
class(box)
# 2.6 Add the `meuse` river to your plot, and color it in an appropriate way ---

plot(st_intersection(riv, box), col = "lightblue")
plot(meuse_sf, col = "black", bg = my_cols, pch = 16, add = TRUE)
legend("topleft",
  fill = attr(my_cols, "palette"),
  legend = names(attr(my_cols, "table")), bty = "n"
)
axis(1)
axis(2)
box()

# ggplot2
ggplot() +
  geom_sf(data = meuse_sf, aes(col = heavy)) +
  geom_sf(data = st_sf(geometry = riv), fill = "grey", color = "black") +
  scale_color_viridis_c(option = "B")

#**********************************************************
# 3 EXERCISE 3--------------------------------------------
#**********************************************************

# 3.1 plot heavy metals in a multi-panel plot ----------------------------------
plot(meuse[, c("zinc", "cadmium", "copper", "lead")])

# 3.2  only select the `meuse` points falling into a rectangle -----------------
# spatial meuse subset
poly <- data.frame(
  x = rep(c(179000, 180000), each = 2),
  y = c(331000, 331500)
)
# order the points in clockwise direction, last point must be the first point
poly <- as.matrix(poly[c(2, 1, 3, 4, 2), ])
poly <- list(poly) %>%
  st_polygon() %>%
  st_sfc()

# or doing it like this
c(st_point(c(179000, 331000)), st_point(c(180000, 331500))) %>%
  st_bbox() %>%
  st_as_sfc()

st_crs(poly) <- st_crs(meuse_sf)
# meuse = st_as_sf(meuse, coords = c("x", "y"))

plot(st_geometry(meuse_sf))
plot(poly, add = TRUE, border = "blue")
# spatial overlay (spatial subset)
sub <- meuse_sf[poly, ]

plot(st_geometry(meuse_sf))
plot(poly, add = TRUE)
plot(sub, add = TRUE, col = "red")

# 3.3 Load the "countriesLow" dataset (`library("rworldmap")` ------------------

library("rworldmap")
data(countriesLow)
d <- countriesLow
class(d)
# convert into sf
d <- st_as_sf(d)

# 3.4 Save the Germany polygon in its own object (spatial query) ---------------

d[d$NAME == "Germany", ] # does not work due to NAs
d[d$NAME %in% "Germany", ]
ger <- d[d$NAME %in% "Germany", ]


# 3.5 Find the neighbors of the Germany polygon --------------------------------

int <- st_geometry(d[ger, ])

# 3.6 Plot Germany's neighbors and add Germany in another color. ---------------

plot(int,
  col = "lightblue", xlim = c(-5, 25),
  ylim = c(40, 60)
)
plot(st_geometry(ger), add = TRUE, col = "red")

