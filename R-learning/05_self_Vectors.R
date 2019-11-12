library("sp")
library("sf")
library("rworldmap")
library("RColorBrewer")
library("classInt")
library("purrr")
library("tidyverse")
library("dplyr")
library("ggplot2")

# load the nc and meuse datasets
nc <- read_sf(system.file("shape/nc.shp", package = "sf"))
data(meuse)


st_crs(meuse)
plot(nc[3])
typeof(meuse)

meu_sf = st_as_sf(meuse, coords = c('x', 'y'))
plot(st_geometry(meu_sf))

meu_sf %>% 
    dplyr::filter(elev > 7 && copper > median(meu_sf$copper)) %>%
    