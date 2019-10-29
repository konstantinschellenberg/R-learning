## Exercise II

library("sp")
library("dplyr")
library("classInt")
library("RColorBrewer")
library("purrr")
library("sf")
library("ggplot2")

# dp

data(meuse)
meu_sf = st_as_sf(meuse, coords = c("x", "y"), crs = 28992, agr = "constant")


ind <- map_lgl(meuse, is.numeric)

map_dbl(meuse[,ind], median)


# Versuch

metals = c("cadmium", "copper", "lead", "zinc")
metals
meu %>%
  mutate(sumVar = rowSums(metals))
  head
  
map(meu, sum)
 
# Lösung

meuse = meuse %>%
  dplyr::rowwise() %>%
  dplyr::mutate(heavy = sum(cadmium, copper, lead, zinc))

meuse ["heavy"]

