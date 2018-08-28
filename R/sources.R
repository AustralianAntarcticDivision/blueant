#' Bowerbird configurations for various Antarctic and Southern Ocean data sources
#'
#' The \code{sources} function is a convenience wrapper around the thematic functions: \code{sources_seaice}, \code{sources_altimetry}, etc.
#'
#' @param name character vector: only return data sources with name or id matching these values
#' @param formats character: for some sources, the format can be specified. See thematic source functions for details
#' @param time_resolutions character: for some sources, the time resolution can be specified. See thematic source functions for details
#' @param ... : other parameters passed to thematic source functions
#'
#' @references See \code{reference} and \code{citation} field in each row of the returned tibble
#'
#' @return tibble
#'
#' @seealso \code{\link{bb_config}}, \code{\link{sources_altimetry}}, \code{\link{sources_biological}}, \code{\link{sources_meteorological}}, \code{\link{sources_ocean_colour}}, \code{\link{sources_oceanographic}}, \code{\link{sources_reanalysis}}, \code{\link{sources_seaice}}, \code{\link{sources_sst}}, \code{\link{sources_topography}}
#'
#' @export
sources <- function(name, formats, time_resolutions, ...) {
    if (missing(name)) name <- NULL
    if (missing(formats)) formats <- NULL
    if (missing(time_resolutions)) time_resolutions <- NULL

    rbind(sources_seaice(name=name, formats=formats, time_resolutions=time_resolutions, ...),
          sources_topography(name=name, formats=formats, time_resolutions=time_resolutions, ...),
          sources_sst(name=name, formats=formats, time_resolutions=time_resolutions, ...),
          sources_altimetry(name=name, formats=formats, time_resolutions=time_resolutions, ...),
          sources_oceanographic(name=name, formats=formats, time_resolutions=time_resolutions, ...),
          sources_ocean_colour(name=name, formats=formats, time_resolutions=time_resolutions, ...),
          sources_meteorological(name=name, formats=formats, time_resolutions=time_resolutions, ...),
          sources_reanalysis(name=name, formats=formats, time_resolutions=time_resolutions, ...),
          sources_biological(name=name, formats=formats, time_resolutions=time_resolutions, ...)
          )
}
