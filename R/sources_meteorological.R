#' Meteorological data sources
#'
#' Data sources providing meteorological data.
#'
#' \itemize{
#'   \item "Antarctic Mesoscale Prediction System grib files": The Antarctic Mesoscale Prediction System - AMPS - is an experimental, real-time numerical weather prediction capability that provides support for the United States Antarctic Program, Antarctic science, and international Antarctic efforts
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
#' @seealso \code{\link{sources_altimetry}}, \code{\link{sources_biological}}, \code{\link{sources_ocean_colour}}, \code{\link{sources_oceanographic}}, \code{\link{sources_reanalysis}}, \code{\link{sources_sdm}}, \code{\link{sources_seaice}}, \code{\link{sources_sst}}, \code{\link{sources_topography}}
#'
#' @return a tibble with columns as specified by \code{\link{bb_source}}
#'
#' @examples
#' \dontrun{
#' ## define a configuration and add the AMPS data to it
#' cf <- bb_config("/my/file/root") %>%
#'   bb_add(sources_meteorological("Antarctic Mesoscale Prediction System grib files"))
#' }
#' @export
sources_meteorological <- function(name,formats,time_resolutions, ...) {
    if (!missing(name) && !is.null(name)) {
        assert_that(is.character(name))
        name <- tolower(name)
    } else {
        name <- NULL
    }
    out <- tibble()
    if (is.null(name) || any(name %in% tolower(c("Antarctic Mesoscale Prediction System grib files","AMPS_grib")))) {
        out <- rbind(out,
                     bb_source(name = "Antarctic Mesoscale Prediction System grib files",
                               id = "AMPS_grib",
                               description = "The Antarctic Mesoscale Prediction System - AMPS - is an experimental, real-time numerical weather prediction capability that provides support for the United States Antarctic Program, Antarctic science, and international Antarctic efforts.",
                               doc_url = "http://www2.mmm.ucar.edu/rt/amps/",
                               citation = "See http://www2.mmm.ucar.edu/rt/amps/",
                               license = "Please cite",
                               comment = "d1,d2 files for hours 000-027 only. Note that this web site provides only the last few days of files.",
                               source_url = "http://www2.mmm.ucar.edu/rt/amps/wrf_grib/",
                               method = list("bb_handler_amps"),
                               collection_size = NA, ## depends on how long the sync has been running, since only the last few days worth are exposed at any one time
                               data_group = "Meteorological"))
    }
    out
}
