#' Calculate polygon area by category within buffers of points
#'
#' For a set of points, buffer each point and calculate the amount of area by land use category
#'
#' @param points Spatial points object
#' @param IDs Unique ID field in points
#' @param buffer_size Radius used to buffer points.
#' @param polygons Spatial polygons object, which contains land use classes
#' @param categories Land use classes in the spatial polygon object
#' @param standardize Row Standardize area calculations to proportions instead of area
#' @param shorten_names
#'
#' @export
poly_area <- function(points, IDs, buffer_size, polygons, categories,
                      standardize = FALSE, shorten_names = TRUE){

  # Check all ID values are unique
  if(any(base::duplicated(points[,IDs])) == TRUE){
    stop("ID field not unique. Must be unique, or removed.")
  }

  if(sf::st_crs(points) != sf::st_crs(polygons)){
    stop("The projections do not match")
  }

    # Check for ring self-intersection in polygons
  # if(FALSE %in% sf::st_is_valid(polygons) ){
  #   stop("Ring Self-Intersection")
  # }

  # Buffer Points
  bufferPoints <- sf::st_buffer(points, dist = buffer_size)

  # Intersect buffered points and land use
  intersectionPolysPoints <- sf::st_intersection(bufferPoints, polygons)

  # Calcualte area of each intersected polygon
  intersectPolyArea <- dplyr::mutate(intersectionPolysPoints, area = sf::st_area(intersectionPolysPoints))

  # Convert to a df
  sf::st_geometry(intersectPolyArea) <- NULL

  # Group and sum up the areas by ID and Category
  areaGrouped <- dplyr::group_by_(intersectPolyArea, IDs, categories)
  areaGrouped <- dplyr::summarise(areaGrouped, area = round(sum(area), 2))

  # Pivot table
  areaSpread <- tidyr::spread_(areaGrouped, categories, "area")

  # Set NA to Zero
  areaSpread[is.na(areaSpread)] <- 0

  # Update Column Names to Include Buffer Size
  if(shorten_names == TRUE){
    colnames(areaSpread)[-1] <- paste(stringr::word(colnames(areaSpread)[-1],1),
                                        buffer_size, sep = "_")
  }else{
    colnames(areaSpread)[-1] <- paste(colnames(areaSpread)[-1],buffer_size, 
                                        sep = "_")
  }

  # Row Standardize value to 0 - 1, only useful for polygons
  if(standardize == TRUE){
    row_sum <- apply(areaSpread[2:ncol(areaSpread)], MARGIN = 1, FUN = sum)
    areaSpread[2:ncol(areaSpread)] <- areaSpread[2:ncol(areaSpread)] / row_sum
  }

  # Drop Spatial Units
  calculatedValues <- dplyr::mutate_all(areaSpread, dplyr::funs(units::drop_units))
  return(calculatedValues)



}
