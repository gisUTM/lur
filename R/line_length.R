#' Calculate line length by category within buffers of points
#'
#' For a set of points, buffer each point and calculate the total length of
#' surronding lines by type. Often used to calculate the length of road by type.
#'
#' @param points Spatial points object
#' @param IDs Unique ID field in points
#' @param buffer_size Radius used to buffer points.
#' @param lines Spatial lines object, which contains road classes
#' @param categories Road types in the spatial line object
#' @param shorten_names
#'
#' @details The length of road by type is a common variable in land use regression models.
#'
#'
#' @export
line_length <- function(points, IDs, buffer_size, lines, categories, 
                        shorten_names = TRUE){

  # Check all ID values are unique
  if(any(base::duplicated(points[,IDs])) == TRUE){
    stop("ID field not unique. Must be unique, or removed.")
  }

  if(sf::st_crs(points) != sf::st_crs(lines)){
    stop("The projections do not match")
  }

  # Buffer Points
  bufferPoints <- sf::st_buffer(points, dist = buffer_size)

  # Intersect buffered points and lines
  intersectionLinesPoints <- sf::st_intersection(bufferPoints, lines)

  # Calculate line length intersected lines
  intersectLineLength <- dplyr::mutate(intersectionLinesPoints, length = sf::st_length(intersectionLinesPoints))

  # Convert to a df
  sf::st_geometry(intersectLineLength) <- NULL

  # Group and sum up the lengths by ID and Category
  lengthGrouped <- dplyr::group_by_(intersectLineLength, IDs, categories)
  lengthGrouped <- dplyr::summarise(lengthGrouped, length = round(sum(length), 2))

  # Pivot table
  lengthSpread <- tidyr::spread_(lengthGrouped, categories, "length")

  # Set NA to Zero
  lengthSpread[is.na(lengthSpread)] <- 0
  
  # Update Column Names to Include Buffer Size
  if(shorten_names == TRUE){
    colnames(lengthSpread)[-1] <- paste(stringr::word(colnames(lengthSpread)[-1],1),
                                        buffer_size, sep = "_")
  }else{
    colnames(lengthSpread)[-1] <- paste(colnames(lengthSpread)[-1],buffer_size, 
                                        sep = "_")
  }
  

  # Drop Spatial Units
  calculatedValues <- dplyr::mutate_all(lengthSpread, dplyr::funs(units::drop_units))
  return(calculatedValues)
}
