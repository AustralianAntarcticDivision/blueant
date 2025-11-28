#' Biological data sources
#'
#' Data sources providing selected Southern Ocean biological data sets. Please note that this is not intended to be a comprehensive collection of such data. Users are referred to the SCAR Standing Committee on Antarctic Data Management (<https://www.scar.org/data-products/scadm/>) and in particular the Antarctic Master Directory metadata catalogue (<http://gcmd.nasa.gov/portals/amd/>).
#'
#' * "Southern Ocean Continuous Plankton Recorder": zooplankton species, numbers and abundance data are recorded on a continuous basis while vessels are in transit
#' * "SEAPODYM Zooplankton & Micronekton weekly potential and biomass distribution": outputs of the SEAPODYM Low and Mid-Trophic Levels (LMTL) model, which simulates the spatial and temporal dynamics of six micronekton and one zooplankton functional groups between the sea surface and ~1000m depth
#' * "SCAR RAATD model outputs": Single-species habitat importance maps for 17 species of Antarctic and subantarctic seabirds, marine mammals, and penguins
#' * "SCAR RAATD data filtered": Tracking data from 17 species of Antarctic and subantarctic seabirds, marine mammals, and penguins. This data set is the 'filtered' version of the data files
#' * "SCAR RAATD data standardised": Tracking data from 17 species of Antarctic and subantarctic seabirds, marine mammals, and penguins. This data set is the 'standardized' version of the data files
#' * "Myctobase": A circumpolar database of Southern Ocean mesopelagic fish surveys, including occurrence and abundance information, as well as trait-based information of individuals including standard length, weight and life stage
#'
#' The returned tibble contains more information about each source.
#'
#' @param name character vector: only return data sources with name or id matching these values
#' @param formats character: for some sources, the format can be specified. See the list of sources above for details
#' @param time_resolutions character: for some sources, the time resolution can be specified. See the list of sources above for details
#' @param ... : additional source-specific parameters. See the list of sources above for details
#'
#' @references See the `doc_url` and `citation` field in each row of the returned tibble for references associated with these particular data sources
#'
#' @return a tibble with columns as specified by [bowerbird::bb_source()]
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

    if (is.null(name) || any(name %in% tolower(c("Southern Ocean Continuous Plankton Recorder", "SO-CPR")))) {
        this <- bb_aadc_source(metadata_id = "AADC-00099", eds_id = 6120, id_is_metadata_id = TRUE, data_group = "Biology")
        ## note: to update the eds_id when the dataset is updated, check https://data.aad.gov.au/eds/api/metadata/AADC-00099?format=json
        this$name <- "Southern Ocean Continuous Plankton Recorder" ## backwards compat
        out <- rbind(out, this)
    }

    if (is.null(name) || any(name %in% tolower(c("SCAR RAATD model outputs", "SCAR_RAATD", "10.26179/5d64b361ca8ec")))) {
        this <- bb_aadc_source(metadata_id = "SCAR_RAATD", data_group = "Biology")
        this$name <- "SCAR RAATD model outputs" ## backwards compat
        out <- rbind(out, this)
    }

    if (is.null(name) || any(name %in% tolower(c("SCAR RAATD data filtered", "SCAR_EGBAMM_RAATD_2018_Filtered", "10.4225/15/5afcadad6c130")))) {
        this <- bb_aadc_source(metadata_id = "SCAR_EGBAMM_RAATD_2018_Filtered", data_group = "Biology")
        this$name <- "SCAR RAATD data filtered" ## backwards compat
        out <- rbind(out, this)
    }

    if (is.null(name) || any(name %in% tolower(c("SCAR RAATD data standardised", "SCAR_EGBAMM_RAATD_2018_Standardised", "10.4225/15/5afcb927e8162")))) {
        this <- bb_aadc_source(metadata_id = "SCAR_EGBAMM_RAATD_2018_Standardised", data_group = "Biology")
        this$name <- "SCAR RAATD data standardised" ## backwards compat
        out <- rbind(out, this)
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
