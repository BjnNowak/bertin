#' Make point valued maps from sf polygon object
#'
#' Convert sf polygon object to sf points object
#'
#' @param polygon a sf polygon object
#' @param n number of points per side
#' @param square boolean: if TRUE, the points are placed following a square shape (otherwise following a hexagonal shape)
#
#' @return a sf point object
#' @import tidyverse
#' @import sf
#' @export
make_points<-function(
    polygon, # sf polygon object to be transformed as point object
    n, # number of points per side of the sf object
    square # if TRUE, points are placed as square (points as hexagons if FALSE)
){

  # Create an hexagonal grid
  grd_simple<-st_make_grid(
    polygon,
    n=n, # Number of shape per side
    square = square
  )%>%
    # Convert grid to sf object
    st_sf()%>%
    # Add "id" column
    #mutate(id=row_number())%>%
    # Use worldwide projected crs to compute centroids
    st_transform(4087)%>%
    st_centroid()%>%
    # Back to polygon centroids
    st_transform(st_crs(polygon))

  # Intersect grid with polygons
  grd<-grd_simple%>%
    st_intersection(polygon)

  return(grd)

}
