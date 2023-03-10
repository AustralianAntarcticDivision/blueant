#' Biological data sources
#'
#' Data sources providing selected Southern Ocean biological data sets. Please note that this is not intended to be a comprehensive collection of such data. Users are referred to the SCAR Standing Committee on Antarctic Data Management (\url{https://www.scar.org/data-products/scadm/}) and in particular the Antarctic Master Directory metadata catalogue (\url{http://gcmd.nasa.gov/portals/amd/}).
#'
#' \itemize{
#'   \item "Southern Ocean Continuous Plankton Recorder": zooplankton species, numbers and abundance data are recorded on a continuous basis while vessels are in transit
#'   \item "SEAPODYM Zooplankton & Micronekton weekly potential and biomass distribution": outputs of the SEAPODYM Low and Mid-Trophic Levels (LMTL) model, which simulates the spatial and temporal dynamics of six micronekton and one zooplankton functional groups between the sea surface and ~1000m depth
#'   \item "SCAR RAATD model outputs": Single-species habitat importance maps for 17 species of Antarctic and subantarctic seabirds, marine mammals, and penguins
#'   \item "SCAR RAATD data filtered": Tracking data from 17 species of Antarctic and subantarctic seabirds, marine mammals, and penguins. This data set is the 'filtered' version of the data files
#'   \item "SCAR RAATD data standardised": Tracking data from 17 species of Antarctic and subantarctic seabirds, marine mammals, and penguins. This data set is the 'standardized' version of the data files
#'   \item "Myctobase": A circumpolar database of Southern Ocean mesopelagic fish surveys, including occurrence and abundance information, as well as trait-based information of individuals including standard length, weight and life stage
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
#' @seealso \code{\link{sources_altimetry}}, \code{\link{sources_meteorological}}, \code{\link{sources_oceanographic}}, \code{\link{sources_reanalysis}}, \code{\link{sources_sdm}}, \code{\link{sources_seaice}}, \code{\link{sources_sst}}, \code{\link{sources_topography}}
#'
#' @return a tibble with columns as specified by \code{\link{bb_source}}
#'
#' @examples
#' ## our local directory to store the data
#' my_data_dir <- tempdir()
#' cf <- bb_config(my_data_dir)
#'
#' ## our data source to download
#' src <- sources("Myctobase")
#'
#' ## add to our config
#' cf <- bb_add(cf, src)
#'
#' ## and sync it
#' if (interactive()) {
#'   status <- bb_sync(cf)
#' }
#'
#' ## or equivalently
#' if (interactive()) {
#'   status <- bb_get(sources("Myctobase"), local_file_root = my_data_dir)
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
        doi <- get_aadc_doi("AADC-00099")
        out <- rbind(out,
                     bb_aadc_s3_source_gen(metadata_id = "AADC-00099",
                                           name = "Southern Ocean Continuous Plankton Recorder",
                                           id = "SO-CPR",
                                           description = "Continuous Plankton Recorder (CPR) surveys from the Southern Ocean. Zooplankton species, numbers and abundance data are recorded on a continuous basis while vessels are in transit",
                                           doi = doi,
                                           citation = tryCatch({
                                               if (is.null(doi)) stop("could not find DOI")
                                               paste0("Hosie, G. (1999, updated 2018) Southern Ocean Continuous Zooplankton Records Australian Antarctic Data Centre - doi:", doi)
                                           }, error = function(e) "See https://data.aad.gov.au/metadata/records/AADC-00099 for current citation"),
                                           collection_size = 0.1,
                                           data_group = "Biology"))
    }

    if (is.null(name) || any(name %in% tolower(c("SCAR RAATD model outputs", "SCAR_RAATD", "10.26179/5d64b361ca8ec")))) {
        out <- rbind(out,
                     bb_aadc_s3_source_gen(metadata_id = "SCAR_RAATD",
                                           name = "SCAR RAATD model outputs",
                                           doi = "10.26179/5d64b361ca8ec",
                                           description = "Single-species habitat importance maps for 17 species of Antarctic and subantarctic seabirds, marine mammals, and penguins. The data also include the integrated maps that incorporate all species (weighted by colony size, and unweighted)",
                                           citation = "Hindell MA, Reisinger RR, Ropert-Coudert Y, et al. (2020) Tracking of marine predators to protect Southern Ocean ecosystems. Nature. doi:10.1038/s41586-020-2126-y. Data from doi:10.26179/5d64b361ca8ec",
                                           collection_size = 0.3,
                                           data_group = "Biology"))
    }

    if (is.null(name) || any(name %in% tolower(c("SCAR RAATD data filtered", "SCAR_EGBAMM_RAATD_2018_Filtered", "10.4225/15/5afcadad6c130")))) {
        out <- rbind(out,
                     bb_aadc_s3_source_gen(metadata_id = "SCAR_EGBAMM_RAATD_2018_Filtered",
                                           name = "SCAR RAATD data filtered",
                                           doi = "10.4225/15/5afcadad6c130",
                                           description = "Tracking data from 17 species of Antarctic and subantarctic seabirds, marine mammals, and penguins. This data set is the 'filtered' version of the data files. These files contain position estimates that have been processed using a state-space model in order to estimate locations at regular time intervals. For technical details of the filtering process, consult the data paper. The filtering code can be found in the https://github.com/SCAR/RAATD repository.",
                                           citation = "Ropert-Coudert Y, Van de Putte AP, Reisinger RR, et al. (2020) The Retrospective Analysis of Antarctic Tracking Data Project. Nature Scientific Data. doi:10.1038/s41597-020-0406-x. Data from doi:10.4225/15/5afcadad6c130",
                                           collection_size = 1.2,
                                           data_group = "Biology"))
    }

    if (is.null(name) || any(name %in% tolower(c("SCAR RAATD data standardised", "SCAR_EGBAMM_RAATD_2018_Standardised", "10.4225/15/5afcb927e8162")))) {
        out <- rbind(out,
                     bb_aadc_s3_source_gen(metadata_id = "SCAR_EGBAMM_RAATD_2018_Standardised",
                                           name = "SCAR RAATD data standardised",
                                           doi = "10.4225/15/5afcb927e8162",
                                           description = "Tracking data from 17 species of Antarctic and subantarctic seabirds, marine mammals, and penguins. This data set is the 'standardized' version of the data files. These files contain position estimates as provided by the original data collectors (generally, raw Argos or GPS locations, or estimated GLS locations). Original data files have been converted to a common format and quality-checking applied, but have not been further filtered or interpolated.",
                                           citation = "Ropert-Coudert Y, Van de Putte AP, Reisinger RR, et al. (2020) The Retrospective Analysis of Antarctic Tracking Data Project. Nature Scientific Data. doi:10.1038/s41597-020-0406-x. Data from doi:10.4225/15/5afcb927e8162",
                                           collection_size = 0.3,
                                           data_group = "Biology"))
    }

    if (is.null(name) || any(name %in% tolower(c("Myctobase", "10.5281/zenodo.5590999")))) {
        ## that DOI is the master one, which will point to the latest version of the data set
        ## but we have to provide a record ID to the API. 6809070 is the latest version at the time of writing, but using `use_latest = TRUE` means that it will resolve to the latest version (with a different record ID) if there is a more recent one
        src <- bb_zenodo_source(6809070, use_latest = TRUE)
        src$data_group <- "Biology"
        out <- rbind(out, src)
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
