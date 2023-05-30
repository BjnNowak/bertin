#' Make point valued maps from terra raster object
#'
#' Convert terra raster object to sf points object
#'
#' @param rst a terra raster object to be transformed as sf point object
#' @param n number of points per side
#
#' @return a sf point object
#' @import tidyverse
#' @import sf
#' @import terra
#' @export
make_points_rst<-function(
    rst, # terra raster object to be transformed as sf point object
    n # number of points per side of the sf object
){

  if(n>nrow(rst)){
    k=1
  } else {
    k=nrow(rst)/n
  }

  rst_agg<-aggregate(
    rst,
    fact=k,
    fun="mean"
  )

  vec_agg<-as.points(x=rst_agg, na.rm=TRUE, na.all=FALSE)%>%
    st_as_sf()

  return(vec_agg)

}
