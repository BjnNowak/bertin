% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_points.R
\name{make_points}
\alias{make_points}
\title{Make point valued maps from sf polygon object}
\usage{
make_points(polygon, n, square)
}
\arguments{
\item{polygon}{a sf polygon object}

\item{n}{number of points per side}

\item{square}{boolean: if TRUE, the points are placed following a square shape (otherwise following a hexagonal shape)}
}
\value{
a sf point object
}
\description{
Convert sf polygon object to sf points object
}
