#' Select observations sites based on Adams' technique. To be described.
#' 
#' Given a set of potential locations, sites will be selected that maximize
#' the land use variabilty. The objective is to observe air pollution 
#' concentrations in as various land use conditions as possible. It is based
#' on maximizing the minimum distance between points. 
#'
#' @param locations Points layer
#' @param ID Unique ID field of the locations field
#' @param num_sites The number of sites that will be selected.
#' 
#' @export

site_selection <- function(locations, ID, num_sites){
  # Get teh land use fields
  
}
