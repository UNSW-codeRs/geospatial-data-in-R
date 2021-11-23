# geospatial-data-in-R

[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

José R. Ferrer-Paris (@jrfep) for UNSW codeRs.

## Abstract

Spatial data is essential for understanding many phenomena in natural and social sciences, and maps are used in a variety of fields to visualise data and results in an appealing and interpretive way. I have been dealing with spatial data with (and without) R for nearly 20 years, using a variety of packages and approaches that have evolved over time, regularly finding challenges and new solutions. In this presentation I will try to summarise my long personal journey with spatial data analysis and visualisation while I demostrate how current integration of R with external libraries like leaflet or plotly make interactive mapping easier (and nicer!) than ever.


## Bio

José Rafael Ferrer-Paris (a.k.a. JR) is currently Research Fellow at the Centre for Ecosystem Science at UNSW and the UNSW Data Science Hub, and a member of the International Union for the Conservation of Nature (IUCN) Thematic Group on Red List of Ecosystems. JR has studied and worked in Venezuela, Germany and South Africa with biodiversity data, spatial and temporal ecological data and geographical information systems. He is currently working with Prof. David Keith on global risk assessment of ecosystems. He has been using R since version 1.0.0, and also likes working with other command, scripting and programming languages like PHP, Bash, Python, JS, Java or Perl and all kinds of databases (SQL, XML, Graphs, etc).



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
