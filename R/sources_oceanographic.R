#' Oceanographic data sources
#'
#' Data sources providing oceanographic data.
#'
#' \itemize{
#'   \item "CSIRO Atlas of Regional Seas 2009": CARS is a digital climatology, or atlas of seasonal ocean water properties
#'   \item "World Ocean Atlas 2009": World Ocean Atlas 2009 is included here for convenience but has been superseded by the World Ocean Atlas 2013 V2
#'   \item "World Ocean Atlas 2013 V2": World Ocean Atlas 2013 version 2 (WOA13 V2) is a set of objectively analyzed (1 degree grid) climatological fields of in situ temperature, salinity, dissolved oxygen, Apparent Oxygen Utilization (AOU), percent oxygen saturation, phosphate, silicate, and nitrate at standard depth levels for annual, seasonal, and monthly compositing periods for the World Ocean. It also includes associated statistical fields of observed oceanographic profile data interpolated to standard depth levels on 5 degree, 1 degree, and 0.25 degree grids
#'   \item "Argo ocean basin data (USGODAE)": Argo float data from the Global Data Access Centre in Monterey, USA (US Global Ocean Data Assimilation Experiment). These are multi-profile netcdf files divided by ocean basin. Accepts \code{region} parameter values of "pacific" (default), "atlantic", and/or "indian". Also accepts \code{years} parameter: an optional vector of years to download data for
#'   \item "Argo profile data": Argo profile data, by default from the Global Data Access Centre in Monterey, USA (US Global Ocean Data Assimilation Experiment). The DAC can be changed by specifying a \code{dac_url} parameter (see example below). Also see \code{\link{bb_handler_argo}} for a description of the other parameters that this source accepts.
#'   \item "Effects of Sound on the Marine Environment": ESME uses publically available environmental data sources that provide detailed information about the ocean: (1) Bottom Sediment Type (BST) v 2.0, (2) Digital Bathymetry Database (DBDB) v 5.4, (3) Generalized Digital Environment Model (GDEM) v 3.0, (4) Surface Marine Gridded Climatology (SMGC) v 2.0"
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
#' @seealso \code{\link{sources_altimetry}}, \code{\link{sources_biological}}, \code{\link{sources_meteorological}}, \code{\link{sources_ocean_colour}}, \code{\link{sources_reanalysis}}, \code{\link{sources_sdm}}, \code{\link{sources_seaice}}, \code{\link{sources_sst}}, \code{\link{sources_topography}}
#'
#' @return a tibble with columns as specified by \code{\link{bb_source}}
#'
#' @examples
#' \dontrun{
#' ## define a configuration and add the Atlas of Regional Seas data to it
#' cf <- bb_config("/my/file/root")
#' src <- sources_oceanographic("CSIRO Atlas of Regional Seas 2009")
#' cf <- bb_add(cf,src)
#'
#' ## Argo data, Pacific ocean basin only, all years
#' src <- sources_oceanographic("Argo ocean basin data (USGODAE)", region="pacific")
#'
#' ## Argo data, Pacific ocean basin for 2018 only
#' src <- sources_oceanographic("Argo ocean basin data (USGODAE)",
#'   region="pacific", years=2018)
#'
#' ## Argo data, all ocean basins and for 2017 and 2018 only
#' src <- sources_oceanographic("Argo ocean basin data (USGODAE)",
#'   region=c("pacific", "indian", "atlantic"), years=c(2017, 2018))
#'
#' ## Argo merge profile data, from the French GDAC (ftp://ftp.ifremer.fr/ifremer/argo/)
#' ## Only download profiles from institutions "CS" or "IN", south of 30S,
#' ##  with parameter "NITRATE" or "CHLA"
#' src <- sources_oceanographic("Argo profile data", profile_type = "merge",
#'                              dac_url = "ftp://ftp.ifremer.fr/ifremer/argo/",
#'                              institutions = c("CS", "IN"),
#'                              latitude_filter = function(z) z < -30,
#'                              parameters = c("CHLA", "NITRATE"))
#' }

#' @export
sources_oceanographic <- function(name,formats,time_resolutions, ...) {
    if (!missing(name) && !is.null(name)) {
        assert_that(is.character(name))
        name <- tolower(name)
    } else {
        name <- NULL
    }
    dots <- list(...)

    out <- tibble()

    if (is.null(name) || any(name %in% tolower(c("CSIRO Atlas of Regional Seas 2009", "cars2009")))) {
        out <- rbind(out,
                     bb_source(
                         name = "CSIRO Atlas of Regional Seas 2009",
                         id = "cars2009",
                         description = "CARS is a digital climatology, or atlas of seasonal ocean water properties.",
                         doc_url = "http://www.marine.csiro.au/~dunn/cars2009/",
                         citation = "Ridgway K.R., J.R. Dunn, and J.L. Wilkin, Ocean interpolation by four-dimensional least squares - Application to the waters around Australia, J. Atmos. Ocean. Tech., Vol 19, No 9, 1357-1375, 2002",
                         source_url = "http://www.marine.csiro.au/atlas/",
                         license = "Please cite",
                         ##method=list("bb_handler_wget",accept_regex=".*2009.*.nc.gz",robots_off=TRUE),
                         method = list("bb_handler_rget", level = 1),
                         postprocess = list("bb_gunzip"),
                         collection_size = 2.8,
                         data_group = "Oceanographic"))
    }

    if (is.null(name) || any(name %in% tolower(c("World Ocean Atlas 2009", "WOA09")))) {
        out <- rbind(out,
                     bb_source(
                         name = "World Ocean Atlas 2009",
                         id = "WOA09",
                         description = "World Ocean Atlas 2009 (WOA09) is a set of objectively analyzed (1 degree grid) climatological fields of in situ temperature, salinity, dissolved oxygen, Apparent Oxygen Utilization (AOU), percent oxygen saturation, phosphate, silicate, and nitrate at standard depth levels for annual, seasonal, and monthly compositing periods for the World Ocean. It also includes associated statistical fields of observed oceanographic profile data interpolated to standard depth levels on both 1 degree and 5 degree grids",
                         doc_url = "http://www.nodc.noaa.gov/OC5/WOA09/pr_woa09.html",
                         citation = "Citation for WOA09 Temperature: Locarnini, R. A., A. V. Mishonov, J. I. Antonov, T. P. Boyer, and H. E. Garcia, 2010. World Ocean Atlas 2009, Volume 1: Temperature. S. Levitus, Ed. NOAA Atlas NESDIS 68, U.S. Government Printing Office, Washington, D.C., 184 pp.\nCitation for WOA09 Salinity: Antonov, J. I., D. Seidov, T. P. Boyer, R. A. Locarnini, A. V. Mishonov, and H. E. Garcia, 2010. World Ocean Atlas 2009, Volume 2: Salinity. S. Levitus, Ed. NOAA Atlas NESDIS 69, U.S. Government Printing Office, Washington, D.C., 184 pp.\nCitation for WOA09 Oxygen: Garcia, H. E., R. A. Locarnini, T. P. Boyer, and J. I. Antonov, 2010. World Ocean Atlas 2009, Volume 3: Dissolved Oxygen, Apparent Oxygen Utilization, and Oxygen Saturation. S. Levitus, Ed. NOAA Atlas NESDIS 70, U.S. Government Printing Office, Washington, D.C., 344 pp.\nCitation for WOA09 Nutrients: Garcia, H. E., R. A. Locarnini, T. P. Boyer, and J. I. Antonov, 2010. World Ocean Atlas 2009, Volume 4: Nutrients (phosphate, nitrate, silicate). S. Levitus, Ed. NOAA Atlas NESDIS 71, U.S. Government Printing Office, Washington, D.C., 398 pp.",
                         license = "Please cite",
                         source_url = "https://data.nodc.noaa.gov/woa/WOA09/NetCDFdata/",
                         ##method=list("bb_handler_wget",robots_off=TRUE,reject="index.html*"), ## --recursive --no-parent
                         method = list("bb_handler_rget", level = 1),
                         postprocess = NULL,
                         collection_size = 6.0,
                         data_group = "Oceanographic"))
    }

    if (is.null(name) || any(name %in% tolower(c("World Ocean Atlas 2013 V2", "WOA13V2")))) {
        out <- rbind(out,
                     bb_source(
                         name = "World Ocean Atlas 2013 V2",
                         id = "WOA13V2",
                         description = "World Ocean Atlas 2013 version 2 (WOA13 V2) is a set of objectively analyzed (1 degree grid) climatological fields of in situ temperature, salinity, dissolved oxygen, Apparent Oxygen Utilization (AOU), percent oxygen saturation, phosphate, silicate, and nitrate at standard depth levels for annual, seasonal, and monthly compositing periods for the World Ocean. It also includes associated statistical fields of observed oceanographic profile data interpolated to standard depth levels on 5 degree, 1 degree, and 0.25 degree grids",
                         doc_url = "https://www.nodc.noaa.gov/OC5/woa13/",
                         citation = "Citation for WOA13 Temperature:\nLocarnini, R. A., A. V. Mishonov, J. I. Antonov, T. P. Boyer, H. E. Garcia, O. K. Baranova, M. M. Zweng, C. R. Paver, J. R. Reagan, D. R. Johnson, M. Hamilton, and D. Seidov, 2013. World Ocean Atlas 2013, Volume 1: Temperature. S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 73, 40 pp.\nCitation for WOA13 Salinity:\nZweng, M.M, J.R. Reagan, J.I. Antonov, R.A. Locarnini, A.V. Mishonov, T.P. Boyer, H.E. Garcia, O.K. Baranova, D.R. Johnson, D.Seidov, M.M. Biddle, 2013. World Ocean Atlas 2013, Volume 2: Salinity. S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 74, 39 pp.\nCitation for WOA13 Oxygen:\nGarcia, H. E., R. A. Locarnini, T. P. Boyer, J. I. Antonov, O.K. Baranova, M.M. Zweng, J.R. Reagan, D.R. Johnson, 2014. World Ocean Atlas 2013, Volume 3: Dissolved Oxygen, Apparent Oxygen Utilization, and Oxygen Saturation. S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 75, 27 pp.\nCitation for WOA13 Nutrients:\nGarcia, H. E., R. A. Locarnini, T. P. Boyer, J. I. Antonov, O.K. Baranova, M.M. Zweng, J.R. Reagan, D.R. Johnson, 2014. World Ocean Atlas 2013, Volume 4: Dissolved Inorganic Nutrients (phosphate, nitrate, silicate). S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 76, 25 pp.",
                         license = "Please cite",
                         source_url = "https://data.nodc.noaa.gov/woa/WOA13/DATAv2/",
                         ##method = list("bb_handler_wget",level=5,robots_off=TRUE,reject="index.html*",reject_regex="/(ascii|csv|shape|5564|6574|7584|8594|95A4|A5B2)/"),
                         method = list("bb_handler_rget", level = 6, reject_follow = "/(ascii|csv|shape|5564|6574|7584|8594|95A4|A5B2)/"),
                         comment = "Only the long-term (not per-decade) netcdf files are retrieved here: adjust the method reject_download parameter if you want ascii, csv, or shapefiles, or per-decade files.",
                         postprocess = NULL,
                         collection_size = 57,
                         data_group = "Oceanographic"))
    }


    if (is.null(name) || any(name %in% tolower(c("Argo ocean basin data (USGODAE)", "10.17882/42182")))) {
        if ("region" %in% names(dots)) {
            region <- tolower(dots[["region"]])
            if (!all(region %in% c("pacific", "atlantic", "indian")))
                stop("the region parameter should be one or more of \"pacific\", \"atlantic\", or \"indian\"")
        } else {
            region <- "pacific" ## default
        }
        if ("years" %in% names(dots)) {
            years <- dots[["years"]]
            assert_that(is.numeric(years) || is.character(years))
        } else {
            years <- ""
        }
        ## all source_url combinations of region and years
        temp <- paste0(apply(expand.grid(paste0("http://www.usgodae.org/ftp/outgoing/argo/geo/", region, "_ocean"), years), 1, paste0, collapse = "/"), "/")
        temp <- sub("/+$", "/", temp) ## remove any double trailing slashes
        out <- rbind(out,
                     bb_source(
                         name = "Argo ocean basin data (USGODAE)",
                         id = "10.17882/42182",
                         description = "Argo float data from the Global Data Access Centre in Monterey, USA (US Global Ocean Data Assimilation Experiment). These are multi-profile netcdf files divided by ocean basin.",
                         doc_url = "http://www.argodatamgt.org/Documentation",
                         citation = "To properly acknowledge Argo data usage, please use the following sentence: \"These data were collected and made freely available by the International Argo Program and the national programs that contribute to it (http://www.argo.ucsd.edu, http://argo.jcommops.org). The Argo Program is part of the Global Ocean Observing System. http://doi.org/10.17882/42182\"",
                         license = "Please cite",
                         source_url = temp,
                         ##method = list("bb_handler_wget", level=3, robots_off=TRUE),
                         method = list("bb_handler_rget", level = 3, accept_follow = "[[:digit:]]+/$"),
                         comment = "Only the 2018 data is so far included here",
                         postprocess = NULL,
                         collection_size = NA, ## unknown yet
                         data_group = "Oceanographic"))
    }

    ## general Argo profile source, that accepts dac_url parameter but defaults to the USGODAE DAC
    if (is.null(name) || any(name %in% tolower(c("Argo profile data", "10.17882/42182 profile")))) {
        if ("profile_type" %in% names(dots)) {
            profile_type <- dots[["profile_type"]]
        } else {
            profile_type <- "merge"
        }
        if ("dac_url" %in% names(dots)) {
            dac_url <- dots[["dac_url"]]
        } else {
            dac_url <- "https://www.usgodae.org/ftp/outgoing/argo/"
            ## can also use this, but is slower: dac_url = "ftp://ftp.ifremer.fr/ifremer/argo/",
        }
        if ("institutions" %in% names(dots)) {
            institutions <- dots[["institutions"]]
        } else {
            institutions <- NULL
        }
        if ("parameters" %in% names(dots)) {
            parameters <- dots[["parameters"]]
        } else {
            parameters <- NULL
        }
        if ("latitude_filter" %in% names(dots)) {
            latitude_filter <- dots[["latitude_filter"]]
        } else {
            latitude_filter <- function(z) rep(TRUE, length(z))
        }
        if ("longitude_filter" %in% names(dots)) {
            longitude_filter <- dots[["longitude_filter"]]
        } else {
            longitude_filter <- function(z) rep(TRUE, length(z))
        }
        out <- rbind(out,
                     bb_source(
                         name = "Argo profile data",
                         id = "10.17882/42182 profile",
                         description = paste0("Argo profile data from ", dac_url, "."),
                         doc_url = "http://www.argodatamgt.org/Documentation",
                         citation = "To properly acknowledge Argo data usage, please use the following sentence: \"These data were collected and made freely available by the International Argo Program and the national programs that contribute to it (http://www.argo.ucsd.edu, http://argo.jcommops.org). The Argo Program is part of the Global Ocean Observing System. http://doi.org/10.17882/42182\"",
                         license = "Please cite",
                         source_url = dac_url,
                         method = list("bb_handler_argo", profile_type = profile_type, institutions = institutions, parameters = parameters, latitude_filter = latitude_filter, longitude_filter = longitude_filter),
                         postprocess = NULL,
                         collection_size = NA, ## unknown yet
                         data_group = "Oceanographic"))
    }

    ## for backwards-compatibility, a source with "USGODAE" in the name, that does not accept a dac_url parameter
    if (is.null(name) || any(name %in% tolower(c("Argo profile data (USGODAE)")))) {
        if ("profile_type" %in% names(dots)) {
            profile_type <- dots[["profile_type"]]
        } else {
            profile_type <- "merge"
        }
        if ("institutions" %in% names(dots)) {
            institutions <- dots[["institutions"]]
        } else {
            institutions <- NULL
        }
        if ("parameters" %in% names(dots)) {
            parameters <- dots[["parameters"]]
        } else {
            parameters <- NULL
        }
        if ("latitude_filter" %in% names(dots)) {
            latitude_filter <- dots[["latitude_filter"]]
        } else {
            latitude_filter <- function(z) rep(TRUE, length(z))
        }
        if ("longitude_filter" %in% names(dots)) {
            longitude_filter <- dots[["longitude_filter"]]
        } else {
            longitude_filter <- function(z) rep(TRUE, length(z))
        }
        out <- rbind(out,
                     bb_source(
                         name = "Argo profile data (USGODAE)",
                         id = "10.17882/42182 profile",
                         description = "Argo profile data from the Global Data Access Centre in Monterey, USA (US Global Ocean Data Assimilation Experiment).",
                         doc_url = "http://www.argodatamgt.org/Documentation",
                         citation = "To properly acknowledge Argo data usage, please use the following sentence: \"These data were collected and made freely available by the International Argo Program and the national programs that contribute to it (http://www.argo.ucsd.edu, http://argo.jcommops.org). The Argo Program is part of the Global Ocean Observing System. http://doi.org/10.17882/42182\"",
                         license = "Please cite",
                         source_url = "https://www.usgodae.org/ftp/outgoing/argo/",
                         ## can also use this, but is slower: source_url = "ftp://ftp.ifremer.fr/ifremer/argo/",
                         method = list("bb_handler_argo", profile_type = profile_type, institutions = institutions, parameters = parameters, latitude_filter = latitude_filter, longitude_filter = longitude_filter),
                         postprocess = NULL,
                         collection_size = NA, ## unknown yet
                         data_group = "Oceanographic"))
    }

    if (is.null(name) || any(name %in% tolower(c("Effects of Sound on the Marine Environment", "ESME")))) {
        out <- rbind(out,
                     bb_source(
                         name = "Effects of Sound on the Marine Environment",
                         id = "ESME",
                         description = "ESME uses publically available environmental data sources that provide detailed information about the ocean, in the form of four primary databases supplied by the Oceanographic and Atmospheric Master Library (OAML). (1) Bottom Sediment Type (BST) v 2.0 : This database provides information on the type of sediment on the ocean bottom, which affects its acoustic reflectivity. Available data resolutions: 2 min, 0.1 min. (2) Digital Bathymetry Database (DBDB) v 5.4 : This database provides information on the depth of the water column. Available data resolutions: 2 min, 1 min, .5 min, .1 min, 0.05 min. (3) Generalized Digital Environment Model (GDEM) v 3.0 : This database provides water temperature and water salinity data for a selected month or months of time, which is used to calculate the changes in the speed of sound in water. Available data resolution: 15 min. (4) Surface Marine Gridded Climatology (SMGC) v 2.0 : This database provides wind speed data for a selected month or months. Wind speed, and consequently surface roughness and wave height, affect the surface's acoustic reflectivity. Available data resolution: 60 min.",
                         doc_url = "https://esme.bu.edu/index.shtml",
                         citation = "Not given",
                         license = "Not specified",
                         source_url = "https://esme.bu.edu/download/index.shtml",
                         method = list("bb_handler_rget", level = 1, accept_download = "data/.*\\.zip", no_parent = FALSE),
                         postprocess = list("bb_unzip"),
                         comment = "Postprocessing (unzipping) of the SMGC data is quite slow due to the large number of files (> 190k)",
                         collection_size = 5,
                         data_group = "Oceanographic"))
    }

    out
}
