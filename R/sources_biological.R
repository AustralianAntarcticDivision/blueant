#' Biological data sources
#'
#' Data sources providing selected Southern Ocean biological data sets. Please note that this is not intended to be a comprehensive collection of such data. Users are referred to the SCAR Standing Committee on Antarctic Data Management (\url{https://www.scar.org/data-products/scadm/}) and in particular the Antarctic Master Directory metadata catalogue (\url{http://gcmd.nasa.gov/portals/amd/}).
#'
#' \itemize{
#'   \item "Southern Ocean Continuous Plankton Recorder": zooplankton species, numbers and abundance data are recorded on a continuous basis while vessels are in transit
#'   \item "SEAPODYM Zooplankton & Micronekton weekly potential and biomass distribution": outputs of the SEAPODYM Low and Mid-Trophic Levels (LMTL) model, which simulates the spatial and temporal dynamics of six micronekton and one zooplankton functional groups between the sea surface and ~1000m depth
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

    if (is.null(name) || any(name %in% tolower(c("SEAPODYM Zooplankton & Micronekton weekly potential and biomass distribution","SEAPODYM_ZM_weekly")))) {
        out <- rbind(out,
                     bb_source(
                         name = "SEAPODYM Zooplankton & Micronekton weekly potential and biomass distribution",
                         id = "SEAPODYM_ZM_weekly",
                         description = "The zooplankton & micronekton biomass distributions are outputs of the SEAPODYM Low and Mid-Trophic Levels (LMTL) model (Lehodey et al., 1998; 2010; 2015). SEAPODYM-LMTL model simulates the spatial and temporal dynamics of six micronekton and one zooplankton functional groups between the sea surface and ~1000m. The model is driven by ocean temperature, horizontal currents, primary production and euphotic depth. Primary production can be outputs from biogeochemical models or derived from ocean color satellite data using empirical optical models (e.g., Behrenfeld and Falkowski 1997).",
                         doc_url = "http://www.mesopp.eu/catalogue/seapodym-zooplankton-micronekton-weekly-potential-and-biomass-distribution-2016/#dataset",
                         citation = "Lehodey P, Conchon A, Senina I, Domokos R, Calmettes B, Jouanno J, Hernandez O, Kloser R (2015) Optimization of a micronekton model with acoustic data. ICES Journal of Marine Science, 72(5): 1399-1412",
                         license = "Please cite",
                         source_url = "http://www.mesopp.eu/data/catalogue/?wpsolr_fq%5B0%5D=model_str%3ASEAPODYM",
                         method = list("bb_handler_rget", level = 2, accept_follow = "potential-and-biomass-distribution", no_parent = FALSE),
                         postprocess = list("bb_unzip"),
                         authentication_note = "Requires registration, see http://www.mesopp.eu/data/registration/",
                         user = "",
                         password = "",
                         warn_empty_auth = FALSE,
                         ##collection_size = ,
                         data_group = "Biology"))
    }
    out
}
