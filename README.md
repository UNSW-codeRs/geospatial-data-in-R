# geospatial-data-in-R

[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

José R. Ferrer-Paris (@jrfep) for [UNSW codeRs](https://github.com/UNSW-codeRs).

This repository contains code and data used (and re-used) for presentations about geospatial data in R. 

## Abstract

Spatial data is essential for understanding many phenomena in natural and social sciences, and maps are used in a variety of fields to visualise data and results in an appealing and interpretive way. I have been dealing with spatial data with (and without) R for nearly 20 years, using a variety of packages and approaches that have evolved over time, regularly finding challenges and new solutions. In this workshop I will show examples of how to work with geospatial data in R, including some basic geospatial analysis, and how current integration of R with external libraries like leaflet make interactive mapping easieR (and niceR!) than ever.


## Bio

José Rafael Ferrer-Paris (a.k.a. JR) is currently Research Fellow at the Centre for Ecosystem Science at UNSW and the UNSW Data Science Hub, and a member of the International Union for the Conservation of Nature (IUCN) Thematic Group on Red List of Ecosystems. JR has studied and worked in Venezuela, Germany and South Africa with biodiversity data, spatial and temporal ecological data and geographical information systems. He is currently working with Prof. David Keith on global risk assessment of ecosystems and with Prof. Richard Kingsford on tracking ecosystem change to inform ecosystem conservation and management. He has been using R since version 1.0.0, and also likes working with other command, scripting and programming languages like PHP, Bash, Python, JS, Java or Perl and all kinds of databases (SQL, XML, Graphs, etc).

## Content of this repo

### Presentations

The introduction to the workshop is available in the folder [intro-presentation/](intro-presentation/)

### Tutorials

For the Workshop I set up the tutorials using the package `learnr`. You can run these in your local machine from the workshop folder, but you need to handle all the right version of the packages.

The online versions of these tutorial are available through alternative shinyapp accounts in the following addresses:

- Tutorial 1: Create a spatial object [option 1](https://ecosphere.shinyapps.io/tutorial-1-create-spatial-object/) [option 2]( https://yessl3-unswcoders.shinyapps.io/tutorial-1-create-spatial-object/)
- Tutorial 2: Points, Lines and Polygons [option 1](https://yessl3-unswcoders.shinyapps.io/tutorial-2-points-lines-polygons/) [option 2]( https://ecosphere.shinyapps.io/tutorial-2-points-lines-polygons/)
- Tutorial 2: Thematic maps 
- Tutorial 4: In preparation 


### Going back in time

I have done some minor and major changes to this workshop material through time, and you probably want to work on the latest version. But here is a brief account of previous version, if you want to explore them.

This repository was first created for a presentation in [ResBaz Sydney 2021](https://resbaz.github.io/resbaz2021/sydney/program/#session-325) in November 2021.

If you want to visit the old code, you are welcome to do so by navigating the git commit history in GitHub, back to [November 28, 2021](https://github.com/UNSW-codeRs/geospatial-data-in-R/tree/332afeb63f669d9bccdcde133f6ceb2480c3e0be). There you will find the presentation in folder [presentation/intro/](presentation/intro/) and examples written as plain R scripts in folder [presentation/examples/](presentation/examples/)

Content was updated for the [UNSW CodeRs Workshop](https://unsw-coders.netlify.app/workshops/) in March 2022, and marked with a GitHub release on the [April 2022](https://github.com/UNSW-codeRs/geospatial-data-in-R/releases/tag/v1.0).

I updated the presentation in [presentation/intro/](presentation/intro/).

I created some tutorials:
- Create a spatial object with `sf` and display with `mapview` [workshop/tutorial-1/](workshop/tutorial-1/)
- Spatial objects and functions in `sf` package and plots with `ggplot2` in [workshop/tutorial-2/](workshop/tutorial-2/)

I also added a script with code from the tutorials in [examples/Tutorials-script.R](examples/Tutorials-script.R)

We shared the [recording for this workshop](https://bit.ly/37gE3t1) through the UNSW codeRs website. 

