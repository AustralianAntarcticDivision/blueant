#' Data sources intended for species distribution modelling and similar tasks
#'
#' Data sources providing environmental and similar gridded data, suitable for species distribution modelling, regionalisation analyses, and similar tasks.
#'
#' \itemize{
#'   \item "Southern Ocean marine environmental data": a collection of gridded marine environmental data layers suitable for use in Southern Ocean species distribution modelling. All environmental layers have been generated at a spatial resolution of 0.1 degrees, covering the Southern Ocean extent (80 degrees S - 45 degrees S, -180 - 180 degrees). The layers include information relating to bathymetry, sea ice, ocean currents, primary production, particulate organic carbon, and other oceanographic data. See the vignette for more information: \code{vignette("SO_SDM_data", package = "blueant")}
#' }
#'
#' The returned tibble contains more information about each source.
#'
#' @param name character vector: only return data sources with name or id matching these values
#' @param formats character: for some sources, the format can be specified. See the list of sources above for details
#' @param time_resolutions character: for some sources, the time resolution can be specified. See the list of sources above for details
#' @param ... : additional source-specific parameters. See the list of sources above for details
#'
#' @references See the \code{doc_url} and \code{citation} field in each row of the returned tibble for references associated with these particular data sources
#'
#' @seealso \code{\link{sources_altimetry}}, \code{\link{sources_biological}}, \code{\link{sources_meteorological}}, \code{\link{sources_ocean_colour}}, \code{\link{sources_oceanographic}}, \code{\link{sources_reanalysis}}, \code{\link{sources_seaice}}, \code{\link{sources_sst}}, \code{\link{sources_topography}}
#' @return a tibble with columns as specified by \code{\link{bb_source}}
#'
#' @examples
#' \dontrun{
#' ## define a configuration, storing data in a temporary directory
#' cf <- bb_config(local_file_root = tempdir())
#'
#' ## add the marine environmental data layers
#' cf <- cf %>% bb_add(sources_sdm("Southern Ocean marine environmental data"))
#'
#' ## sync it (get the data)
#' res <- bb_sync(cf, verbose = TRUE)
#'
#' ## see the vignette for more information on this data source:
#' vignette("SO_SDM_data", package = "blueant")
#' }
#' @export
sources_sdm <- function(name, formats, time_resolutions, ...) {
    if (!missing(name) && !is.null(name)) {
        assert_that(is.character(name))
        name <- tolower(name)
    } else {
        name <- NULL
    }
    if (!missing(time_resolutions) && !is.null(time_resolutions)) {
        assert_that(is.character(time_resolutions))
        time_resolutions <- tolower(time_resolutions)
    } else {
        time_resolutions <- NULL
    }
    out <- tibble()
    if (is.null(name) || any(name %in% tolower(c("Southern Ocean marine environmental data", "10.26179/5b8f30e30d4f3")))) {
        this <- bb_aadc_source(metadata_id = "environmental_layers", access_function = "raster::stack", data_group = "Modelling")
        this$name <- "Southern Ocean marine environmental data" ## backwards compat
        out <- rbind(out, this)
    }
    out
}
