#! R --vanilla

###
# I put this code in a gist: https://gist.github.com/jrfep/615d627db68cee263171e35154dc51e4
##

library(rvest)
library(dplyr)
require(stringr)
require(magrittr)
here::i_am("inc/plot-all-packages-in.R")

# Step 1: get the current or active versions of the packages

## Check if output file exists:
arch <- here::here("Rdata", "R-package-list-current.rds")
if (file.exists(arch)) {
  current_pkgs <- readRDS(file=arch)
} else {
  urldir <- "https://cran.rstudio.com/src/contrib/"
  # urldir <- "https://cran.curtin.edu.au/src/contrib/" # Mirrors appear to have a different listing structure :(
  # Read html file as a text file from url, then filter lines with compressed files (assumed to be packages)
  flat_html <- readLines(urldir)
  tar_list <- flat_html %>% grep("tar.gz",.,value=T) %>% gsub("> 2",">  2",.) ## fix one very long package name...
  ## get package name and version from file name
  raw_list <- tar_list %>% str_trim %>% str_split("[:blank:]{2,}",simplify=T)
  raw_names <- unname(sapply(raw_list[,1],function(x) html_text(read_html(x)))) %>%
    gsub(".tar.gz","",.) %>% str_trim %>% str_split("_",simplify=T)
  # put everything together in a tibble and save to RDS
  current_pkgs <-  tibble(name=raw_names[,1],version=raw_names[,2],last_modified=as.POSIXct(raw_list[,2]))
  saveRDS(file=arch,current_pkgs)
}

# Step 2: get the archive versions of the packages

## Check if output file exists, if not, initiate a tibble to store the data

arch <- here::here("Rdata", "R-package-list-archive.rds")
if (file.exists(arch)) {
  archive_pkgs <- readRDS(file=arch)
} else {
  archive_pkgs <- tibble()
}

# We will need to get into each folder (packages) to download the list of compressed files (versions)
urldir <- "https://cran.rstudio.com/src/contrib/Archive"
pkg_dirs <- read_html(urldir) %>% html_nodes("a") %>% html_text()
pkg_dirs <- grep("/$",pkg_dirs,value=T)

# In case of resuming from an interrupted/incomplete loop, we can skip packages already in the tibble:
 pkg_dirs <- pkg_dirs[!gsub("/$","",pkg_dirs) %in% archive_pkgs$name]

for (j in sample(pkg_dirs)) { # sample, because everybody needs some randomness in their lives ...
  raw_list <- try(readLines(sprintf("%s/%s",urldir,j)))
  if (any(class(raw_list) %in% "try-error")) { ## skip in case of error downloading the list
    cat(sprintf("error with directory %s...\n",j))
  } else {
    # do the same as above, but for each directory
    raw_list %<>%
      grep("tar.gz",.,value=T) %>%
      gsub("> ([0-9])",">  \\1",.) %>% str_trim %>% str_split("[:blank:]{2,}",simplify=T)
    raw_names <- unname(sapply(raw_list[,1],function(x) html_text(read_html(x)))) %>%
      gsub(".tar.gz","",.) %>% str_trim %>% str_split("_",simplify=T)
    archive_pkgs %<>% bind_rows(tibble(name=raw_names[,1],version=raw_names[,2],last_modified=as.POSIXct(raw_list[,2])))
  }
}

saveRDS(file=arch,archive_pkgs)


# Step 3: read files and make the plot
library(ggplot2)
require(RColorBrewer)

if (!exists("archive_pkgs"))
  archive_pkgs <- readRDS(file='R-package-list-archive.rds')
if (!exists("current_pkgs"))
  current_pkgs <- readRDS(file='R-package-list-current.rds')

# combine tibbles, group and summarise to get information on each package:
pkg_history <- archive_pkgs %>% bind_rows(current_pkgs) %>% group_by(name) %>% summarise(n_versions=n_distinct(version),first=min(last_modified),last=max(last_modified)) %>% arrange(first) %>% mutate(index=vctrs::vec_group_id(first))

# Select colors for the plot
clrs <- brewer.pal(6,"Paired")

# assemble plot elements
ggplot(pkg_history, aes(as.Date(first), index)) +
  geom_line(size = 2,col=clrs[1]) +
  scale_x_date(date_breaks = '5 year', date_labels = '%Y') +
  scale_y_continuous(breaks = seq(0, 20000, 1500)) + # or: # scale_y_continuous(trans='log10') +
  xlab('') + ylab('') + theme_bw() +
  theme(plot.title = element_text(colour = clrs[2]), plot.subtitle = element_text(colour = clrs[6])) +
  labs(title='Cummulative number of R packages published on CRAN') -> our_plot

# Optional: highlight some packages, for example spatial packages
selected_packages <- pkg_history %>% filter(name %in% c("sf","raster","sp",'rgee') | grepl("GRASS|grass|gdal|spatial|spat|geo|maps|leaflet|mapbox|plotly|proj4",name))
selection <- c('sgeostat','GRASS','geoR','spatstat','rgdal','sp','rgee', 'raster','sf','leaflet','mapboxapi','plotly')
selected_packages %>% filter(name %in% selection) -> highlighted_packages

our_plot +
  labs(subtitle=sprintf("ca. %s (geo)spatial packages!",nrow(selected_packages))) +
  geom_rug(data=selected_packages,aes(as.Date(first)),color=clrs[5],sides="b") +
  geom_text(data=highlighted_packages,
            aes(x=as.Date(first),
                y=index+if_else(index<1500,500,0),
                label=name, angle=if_else(index<1500,45,0)),
            color=clrs[6])

# Finally, save the last plot here:
ggsave(here::here("images", "number-of-submitted-packages-to-CRAN.png"),width=6,height=5)
