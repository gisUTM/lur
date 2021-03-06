% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/site_selection.R
\name{site_selection}
\alias{site_selection}
\title{Select observations sites based on Adams' technique. To be described.}
\usage{
site_selection(locations, ID, num_sites)
}
\arguments{
\item{locations}{Points layer}

\item{ID}{Unique ID field of the locations field}

\item{num_sites}{The number of sites that will be selected.}
}
\description{
Given a set of potential locations, sites will be selected that maximize
the land use variabilty. The objective is to observe air pollution 
concentrations in as various land use conditions as possible. It is based
on maximizing the minimum distance between points.
}
