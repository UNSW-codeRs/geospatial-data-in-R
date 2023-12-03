require(dplyr)

# Create and project data with `sp`
require(sp)
data_ll <- read.csv("presentation/data/JBM-points.csv")
coordinates(data_ll) <- c("Longitude","Latitude")
proj4string(data_ll) <- "+proj=longlat +datum=WGS84"
data_utm <- spTransform(data_ll, CRS("+proj=utm +zone=19n +datum=WGS84"))

# Read and project data with `rgdal`
require(rgdal)
boundary_ll <- readOGR("presentation/data/JBM.gpkg",verbose = F)
boundary_utm <- spTransform(boundary_ll, CRS("+proj=utm +zone=19n +datum=WGS84"))

# Read data with `raster`
require(raster)
ik <- raster("presentation/data/kriging-example.tif")

## Plot all this together
require(RColorBrewer)
plot(ik,col=brewer.pal(9,'BuGn'))
plot(boundary_utm,add=T)
points(data_utm,cex=data_utm@data$Tree.cover)

# Visualise with leaflet
# **Leaflet** is an open-source JavaScript library for interactive maps. It is a very popular solution for adding spatial data to mobile apps and webpages. 
# https://leafletjs.com/ 
  
require(leaflet)

leaflet() %>%
  addTiles() %>%
  addRasterImage(ik,colors='BuGn',opacity=0.75) %>%
  addCircles(data=data_ll,radius=~Tree.cover,label=~Tree.cover)


# Create and project data with `sf`

require(sf)
UBT <- st_sf(text='Universität Bayreuth',
             url='https://uni-bayreuth.de/',
             crs=st_crs("+proj=latlong +datum=WGS84"),
             geometry=st_sfc(st_point(c(11.585833, 49.928889)) ))

UBT %>% st_transform(st_crs("+proj=robin"))


## Visualise data with mapview
require(mapview)
require(leafpop)

img <- "https://www.study-in-bavaria.de/fileadmin/_processed_/csm_Campus-Luftbild_1_qf_03_8a455a1f25.jpg"

mapview(list(franconia, breweries,trails),
        zcol = list("district", "founded",NULL),
        legend = list(TRUE, FALSE,FALSE)) +
  mapview(UBT, popup = popupImage(img, src = "remote")
  )


## Quick overview of `rgee` functions:

library(rgee)
ee_Initialize()
srtm <- ee$Image("USGS/SRTMGL1_003")
viz <- list(
  max = 4000,
  min = 0,
  palette = c("#000000","#5AAD5A","#A9AD84","#FFFFFF")
)
Map$addLayer(
  eeObject = srtm,
  visParams =  viz,
  name = 'SRTM'
)

mft1.2 <- ee$Image("users/jrferrerparis/IUCN-GET/L3_WM_nwt/MFT1_2")

viz <- list(
  max = 2,
  min = 1,
  palette = c("red","yellow")
)
Map$setCenter(140, -20.5, 7)
Map$addLegend(viz)

Map$addLayer(
  eeObject = mft1.2,
  visParams =  viz,
  name = 'MFT1.2 Intertidal forests and shrublands'
)


require(cptcity)
library(mapedit) # (OPTIONAL) Interactive editing of vector data
library(raster)  # Manipulate raster data
library(scales)  # Scale functions for visualization
library(cptcity)  # cptcity color gradients!
library(tmap)    # Thematic Map Visualization <3

dataset <- ee$ImageCollection("MODIS/006/MOD11A1")$
  filter(ee$Filter$date('2020-01-01', '2020-01-31'))$
  mean()

landSurfaceTemperature <- dataset$
  select("LST_Day_1km")$
  multiply(0.02)$
  subtract(273.15)

landSurfaceTemperatureVis <- list(
  min = -50, 
  max = 50,
  palette = cpt("grass_bcyr")
)
Map$addLayer(
  eeObject = landSurfaceTemperature,
  visParams = landSurfaceTemperatureVis,
  name = 'Land Surface Temperature'
)
geometry <- ee$Geometry$Rectangle(
  coords = c(-180,-90,180,90),
  ##coords = c(-90,-180,90,180),
  proj = "EPSG:4326",
  geodesic = FALSE
)

## transform the map calculated with GEE into a raster object and display it in R

world_temp <- ee_as_thumbnail(
  image = landSurfaceTemperature,  # Image to export
  region = geometry, # Region of interest
  dimensions = 1024, # output dimension
  raster = TRUE, # If FALSE returns a stars object. FALSE by default
  vizparams = landSurfaceTemperatureVis[-3] # Delete the palette element
)

min_lst <- landSurfaceTemperatureVis$min
max_lst <- landSurfaceTemperatureVis$max
world_temp[] <- scales::rescale(
  getValues(world_temp), c(min_lst, max_lst)
)

plot(world_temp)

## now create a thematic map with this layer

require(sf)
crs(world_temp) <- "EPSG:4326"
eck4proj <- "+proj=eck4 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"

data("World") # Load world vector (available after load tmap)
World %>% st_transform(eck4proj) -> w4e

world_temp_robin <- projectRaster(
  from = world_temp,
  crs = crs(w4e)
) %>% mask(w4e)

plot(world_temp_robin)

tm_shape(shp = world_temp_robin) +
  tm_raster(
    title = "LST (°C)",
    palette = cpt("grass_bcyr", n = 100),
    stretch.palette = FALSE,
    style = "cont"
  ) +
  tm_shape(shp = World) + 
  tm_borders(col = "black", lwd = 0.7) +
  tm_graticules(alpha=0.8, lwd = 0.5, labels.size = 0.5) +
  tm_layout() +
  tmap_style(style = "natural") +
  tm_layout(
    scale = .8,
    bg.color = "aliceblue",
    frame = FALSE,
    frame.lwd = NA,
    panel.label.bg.color = NA,
    attr.outside = TRUE,
    main.title.size = 0.8,
    main.title = "Global monthly mean LST from MODIS: January 2020",
    main.title.fontface = 2,
    main.title.position = 0.1,
    legend.title.size = 1,
    legend.title.fontface = 2,
    legend.text.size = 0.7,
    legend.frame = FALSE,
    legend.outside = TRUE,
    legend.position = c(0.10, 0.38),
    legend.bg.color = "white",
    legend.bg.alpha = 0
  ) +
  tm_credits(
    text = "Source: MOD11A1 - Terra Land Surface Temperature and Emissivity Daily Global 1km",
    size = 0.8,
    position = c(0.1,0)
  ) -> lst_tmap

lst_tmap
tmap_save(lst_tmap, "lst_tmap.png", width = 1865, height = 1165)

