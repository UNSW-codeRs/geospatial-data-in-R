# install packages if needed:
# install.packages(c("sf","mapview","leafpop"),dependencies = TRUE)
# For leaflet try to install the current github version with devtools
# devtools::install_github("rstudio/leaflet")

require(sf)
require(mapview)
require(leaflet)
require(leafpop)
require(dplyr)
require(ggplot2)
require(RColorBrewer)

##########
## Tutorial 1
######

# Create our first object:

my_geom <- st_point(c(23.978333, 38.118056))
my_crs <- st_crs("+proj=latlong +datum=WGS84")
data <- data.frame(name=c('Marathon'),
                   famous_for=c('Battle of Marathon'),
                   url=c('https://en.wikipedia.org/wiki/Battle_of_Marathon'),
                   year=c(-490))

hellas1 <- st_sf(data,
                 crs=my_crs,
                 geometry=st_sfc(my_geom))


## Exercise 1:
#my_data <- ____(name='This is Sparta!')
#my_crs <- ____("EPSG:4326")
#my_geom <- ____(c(22.431028, 37.075074))
#sparta <- st_sf(my_data,
#               crs=my_crs,
#              geometry=____)

#print(sparta)

## Solution:
my_data <- data.frame(name='This is Sparta!')
my_crs <- st_crs("EPSG:4326")
my_geom <- st_point(c(22.431028, 37.075074))
sparta <- st_sf(my_data,
                crs=my_crs,
                geometry=st_sfc(my_geom))


## Another object with two features:

pt2 <- st_point(c( 23.2, 39.05))
pt3 <- st_point(c(20.716667, 38.366667))

data <- data.frame(name=c('Arthemision','Ithaca'),
                   famous_for=c('Battle of Arthemision', "Homer's Odyssey"),
                   url=c('https://en.wikipedia.org/wiki/Battle_of_Artemisium', 'https://en.wikipedia.org/wiki/Ithaca'),
                   year=c(-480,-800))

hellas2 <- st_sf(data,
                 crs=my_crs,
                 geometry=st_sfc(pt2,pt3))


## combine objects with same columns:

not_sparta <- rbind(hellas1, hellas2)
not_sparta

## This will not work
##with_sparta <- rbind(hellas1, sparta)
##with_sparta

# but you can make it work if you add the missing variables:
sparta$famous_for <- NA
sparta$url <- NA
sparta$year <- NA
# try again:
with_sparta <- rbind(hellas1, sparta)
with_sparta

## Check methods for sf class
class(hellas1)
methods(class = "sf")

## Calculate distance between points:
st_distance(not_sparta) # internal distance
st_distance(sparta,not_sparta) # distance between points in each object
st_distance(not_sparta,sparta) # same as above

## Find nearest feature:
not_sparta[st_nearest_feature(sparta,not_sparta),]

## Visualisation with mapview:
# use mapviewOptions(fgb=FALSE) # if points/features not showing

mapview(not_sparta, col.regions = "blanchedalmond")

## show two layers in mapview:
sparta.popup='https://64.media.tumblr.com/c963fce8a6e638323f5e60df33c127f3/tumblr_mq3bykOEmD1s9xi1so1_500.gif'

mapview(not_sparta, col.regions = "blanchedalmond") +
  mapview(sparta, popup = popupImage(img=sparta.popup, src ="remote"))


##########
## Tutorial 2
######

UBT <- st_sf(data.frame(full_name='Universität Bayreuth',
                        url='https://uni-bayreuth.de/'),
             crs=st_crs("EPSG:4326"),
             geometry=st_sfc(
               st_point(c(11.585833, 49.928889))))

## breweries points dataset
breweries
## in case of 'old-style' warning run:
## st_crs(breweries) <- "EPSG:4326"

## separate data / geometry
breweries %>% st_drop_geometry()
breweries %>% st_geometry()

## histogram of variable:
breweries %>% pull(number.of.types) %>% hist(main="Nr. of types of beers")

## plot variable:
breweries %>% select(number.of.types) %>% plot(pch=19)


## find nearest breweries with more than X types (here X=9)
selected_breweries <- breweries %>% filter(number.of.types>9)
qry <- st_nearest_feature(UBT,selected_breweries)
selected_breweries %>% slice(qry)
st_distance(UBT,selected_breweries %>% slice(qry))

## franconia polygon dataset
franconia
## in case of 'old-style' warning run:
## st_crs(franconia) <- "EPSG:4326"

## plot geometry
franconia %>% st_geometry() %>% plot

## plot all variables 
franconia %>% plot

## plot one variable
franconia %>% select(district) %>% plot

## dissolve polygons by one variable:
franconia %>% group_by(district) %>% summarise(new_geom=st_union(geometry)) %>% plot

## spatial query
st_intersection(UBT,franconia)

## ggplot multiple layers:
ggplot() +
  geom_sf(data = franconia, aes(fill=district)) +
  geom_sf(data = breweries, col="darkgreen") +
  geom_sf(data = UBT, cex=2, col="brown") +
  scale_fill_brewer(palette = "Greys")

## ggplot with size/colors per variable
ggplot() +
  geom_sf(data = franconia, aes(fill=district)) +
  geom_sf(data = breweries, aes(size=number.of.types, colour=founded)) +
  geom_sf(data = UBT, cex=2, col="brown") +
  scale_fill_brewer(palette = "Greys") +
  scale_colour_gradientn(colours = brewer.pal(5,"Oranges"))

## trails multiline dataset
trails
## in case of 'old-style' warning run:
## st_crs(trails) <- "EPSG:32632"


## length of trails
trails %>% st_length() %>% hist(main="Length of trails")

## longest trail:
trails %>% mutate(length=st_length(geometry)) -> trails
trails %>% slice(which.max(length))

## filter by length (need to use threshold declared with units::set_units())
trails %>% mutate(length=st_length(geometry)) %>% filter(length>set_units(3000,'m'),length<set_units(3400,'m')) -> short_trails

trails %>% mutate(length=st_length(geometry)) %>% filter(length>set_units(40000,'m')) -> long_trails

## map in plane geographic projection
ggplot() +
  geom_sf(data = franconia, aes(fill=district)) +
  geom_sf(data = UBT, cex=2, col="yellow") +
  geom_sf(data = long_trails, col="whitesmoke")

## map in UTM projection: 3 options:

## projected map, option 1:
## project on the fly (projection taken from first element, suboptimal solution)
ggplot() +
  geom_sf(data=long_trails, col="whitesmoke") +
  geom_sf(data = franconia , aes(fill=district)) +
  geom_sf(data=UBT , cex=2, col="yellow")

## projected map, option 2 :
## use coord_sf to project on the fly
ggplot() +
  geom_sf(data = franconia, aes(fill=district)) +
  geom_sf(data = UBT, cex=2, col="yellow") +
  geom_sf(data = long_trails, col="whitesmoke") +
  coord_sf(crs=st_crs(long_trails))

## projected map, option 3:
## project spatial data first:
(UBT_utm = UBT %>% st_transform(st_crs(trails)))
franconia_utm = franconia %>% st_transform(st_crs(trails))
## then plot projected data
ggplot() +
  geom_sf(data = franconia_utm, aes(fill=district)) +
  geom_sf(data = UBT_utm, cex=2, col="yellow") +
  geom_sf(data =long_trails, col="whitesmoke")
