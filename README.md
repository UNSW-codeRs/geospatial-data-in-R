# geospatial-data-in-R

What's so special about spatial? Exploring maps with R

A "spatial analysis" can be as simple as asking the value of a variable at a set of location or as complex as fitting spatially explicit models with autocorrelated covariates.

Can we do this in R...?
Yes of course




https://r-spatial.org/r/2018/10/25/ggplot2-sf.html

```{r}
library(rnaturalearth)
library(rnaturalearthdata)
library(sf)
```

Use of sf:
https://www.computerworld.com/article/3175623/mapping-in-r-just-got-a-whole-lot-easier.html

rgooglemaps googleVis RWorldMap

https://pakillo.github.io/R-GIS-tutorial/


https://csiss.org/aboutus/presentations/files/goodchild_qmss_oct02.pdf
What to do with spatial data:
- query and reasoning
- measurement
- transformation (buffers, vector to raster, aggregation, etc)
- spatial context (fragmentation, etc)
- descriptive summary
- optimization
- hypothesis testing



Where?: display location of points, polygons, visualise raster

What? Query attributes, values

Distance and measurements

Context: moving windowns, fragmentation

Fill gaps: interpolation

Model projection:

Geospatial analysis (geostatistics, point patterns)
