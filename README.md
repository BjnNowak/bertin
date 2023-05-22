{bertin} package vignette
================

The main goal of this package is to easily transform choropleth maps
into valued points in the way of Jacques Bertin.

![](https://raw.githubusercontent.com/BjnNowak/Lessons/main/fig/R_2/bertin.png)

# 1. Package installation

The package may be downloaded from GitHub. It may also be downloaded
directly from R with the following command:

``` r
# Installation directly with R (to use only once):
# devtools::install_github("BjnNowak/bertin")

# Once installed, you may load it into your R session
library(bertin)

# Two other packages will be useful to process the data: {tidyverse} and {sf}
library(tidyverse)
library(sf)
```

# 2. First example

Several datasets are already included in the package and may be used
directly.

We will start with the population density of the French regions.

``` r
head(france_regions)
#> Simple feature collection with 6 features and 2 fields
#> Geometry type: GEOMETRY
#> Dimension:     XY
#> Bounding box:  xmin: -5.103601 ymin: 41.36705 xmax: 9.559721 ymax: 50.16073
#> Geodetic CRS:  WGS 84
#>                       nom   density                       geometry
#> 1    Auvergne-Rhône-Alpes 115.88188 POLYGON ((4.780213 46.17668...
#> 2 Bourgogne-Franche-Comté  58.15100 POLYGON ((3.629424 46.74946...
#> 3                Bretagne 125.20448 MULTIPOLYGON (((-3.659144 4...
#> 4     Centre-Val de Loire  65.21896 POLYGON ((2.874625 47.52042...
#> 5                   Corse  40.39509 POLYGON ((9.402268 41.8587,...
#> 6               Grand Est  96.65120 POLYGON ((4.233164 49.95775...
```

A choropleth map of the population density can be easily created from
this file:

``` r
ggplot(france_regions, aes(fill=density))+
  geom_sf()+
  coord_sf(crs='EPSG:2154') # CRS for France
```

![](README_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

With {bertin}, it only takes one function (**make_points()**) to convert
this choropleth map to a point valued map.

``` r
regions_valued <- make_points(
  polygon=france_regions, # Input file (sf object)
  n=45, # Number of points per side
  square=TRUE # Points shaped as squares (hexagons otherwise)
)

ggplot(regions_valued,aes(size=density))+
  # Keep French regions borders as background
  geom_sf(
    france_regions,
    mapping=aes(geometry=geometry),
    inherit.aes=FALSE
  )+
  geom_sf()+
  coord_sf(crs='EPSG:2154')+
  scale_size(range=c(1,3))
```

![](README_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

# 3. Second example

In the previous example, the high population density of the Paris region
overwhelms the differences between the other regions. In addition, the
spatial scale is coarser than that of the original map by Jacques
Bertin.

We will now try to reproduce this map with the departmental scale
dataset, also available in the package.

``` r
departments_valued<-make_points(
  polygon=france_departments,
  n=55,
  square=TRUE
  )%>%
  mutate(density_cl=case_when(
    density<40~40,
    density<80~80,
    density<120~120,
    density<160~160,
    TRUE~161
  ))

ggplot(departments_valued,aes(size=as.factor(density_cl)))+
  # French departments as background
  geom_sf(
    departments_valued,
    mapping=aes(geometry=geometry),
    fill="grey95",color="grey60",
    inherit.aes=FALSE
  )+
  geom_sf()+
  scale_size_manual(
    values=seq(0.5,3,0.5),
    labels=c("<40","<80","<120","<160","≥160"))+
  labs(size="Population density")+
  theme_void()
```

![](README_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

Besides these examples for France, the make_points() function can be
applied to any sf polygon object, with a valid crs.
