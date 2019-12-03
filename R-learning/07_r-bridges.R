# install packages from remote

remotes::install_github("r-spatial/RQGIS3")

library("RQGIS3")

rgrass7::initGRASS(gisBase = "/usr/lib/grass76", override = T)
