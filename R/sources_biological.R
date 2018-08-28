#' Biological data sources
#'
#' Data sources providing selected Southern Ocean biological data sets. Please note that this is not intended to be a comprehensive collection of such data. Users are referred to the SCAR Standing Committee on Antarctic Data Management (\url{https://www.scar.org/data-products/scadm/}) and in particular the Antarctic Master Directory metadata catalogue (\url{http://gcmd.nasa.gov/portals/amd/}).
#'
#' \itemize{
#'   \item "Southern Ocean Continuous Plankton Recorder": zooplankton species, numbers and abundance data are recorded on a continuous basis while vessels are in transit
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
#' @seealso \code{\link{sources_altimetry}}, \code{\link{sources_meteorological}}, \code{\link{sources_oceanographic}}, \code{\link{sources_reanalysis}}, \code{\link{sources_seaice}}, \code{\link{sources_sst}}, \code{\link{sources_topography}}
#'
#' @return a tibble with columns as specified by \code{\link{bb_source}}
#'
#' @examples
#' ## our local directory to store the data
#' my_data_dir <- tempdir()
#' cf <- bb_config(my_data_dir)
#'
#' ## our data source to download
#' src <- sources_biological("Southern Ocean Continuous Plankton Recorder")
#' ## or, equivalently just
#' src <- sources("Southern Ocean Continuous Plankton Recorder")
#'
#' ## add to our config
#' cf <- bb_add(cf, src)
#'
#' ## sync it
#' \dontrun{
#' bb_sync(cf)
#' }
#'
#' @export
sources_biological <- function(name, formats, time_resolutions, ...) {
    if (!missing(name) && !is.null(name)) {
        assert_that(is.character(name))
        name <- tolower(name)
    } else {
        name <- NULL
    }
    out <- tibble()

    if (is.null(name) || any(name %in% tolower(c("Southern Ocean Continuous Plankton Recorder","SO-CPR")))) {
        out <- rbind(out,
                     bb_source(
                         name = "Southern Ocean Continuous Plankton Recorder",
                         id = "SO-CPR",
                         description = "Continuous Plankton Recorder (CPR) surveys from the Southern Ocean. Zooplankton species, numbers and abundance data are recorded on a continuous basis while vessels are in transit",
                         doc_url = "https://data.aad.gov.au/metadata/records/AADC-00099",
                         citation = tryCatch({
                             doi <- get_aadc_doi("https://data.aad.gov.au/metadata/records/AADC-00099")
                             if (is.null(doi)) stop("could not find DOI")
                             paste0("Hosie, G. (1999, updated 2018) Southern Ocean Continuous Zooplankton Records Australian Antarctic Data Centre - doi:", doi)
                         }, error = function(e) "See https://data.aad.gov.au/metadata/records/AADC-00099 for current citation"),
                         license = "CC-BY",
                         source_url = "https://data.aad.gov.au/eds/4672/download",
                         method = list("bb_handler_rget", force_local_filename = "download.zip", no_check_certificate = TRUE),
                         comment = "server certificate is valid but not recognized as such by some systems (e.g. Ubuntu)",
                         postprocess = list("bb_unzip"),
                         collection_size = 0.1,
                         data_group = "Biology"))
    }

    out
}

