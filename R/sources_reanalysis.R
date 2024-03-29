#' Reanalysis data sources
#'
#' Data sources providing data from global reanalysis models.
#'
#' \itemize{
#'   \item "NCEP-DOE Reanalysis 2": NCEP-DOE Reanalysis 2 is an improved version of the NCEP Reanalysis I model that fixed errors and updated paramterizations of of physical processes. Accepts \code{time_resolution} values of "6 hour", "day", and/or "month" (default). The 6-hourly data is the original output time resolution. Daily and monthly averages are calculated from the 6-hourly model output
#'   \item "NCEP/NCAR Reanalysis 1": The NCEP/NCAR Reanalysis 1 project is using a state-of-the-art analysis/forecast system to perform data assimilation using past data from 1948 to the present. Only the monthly data are so far included here
#'   \item "CCMP Wind Product V2": The Cross-Calibrated Multi-Platform (CCMP) gridded surface vector winds are produced using satellite, moored buoy, and model wind data, and are a Level-3 ocean vector wind analysis product. The V2 CCMP processing combines Version-7 RSS radiometer wind speeds, QuikSCAT and ASCAT scatterometer wind vectors, moored buoy wind data, and ERA-Interim model wind fields using a Variational Analysis Method (VAM) to produce four maps daily of 0.25 degree gridded vector winds
#   \item "NOAA-CIRES-DOE Twentieth Century Reanalysis V3": NOAA-CIRES-DOE 20th Century Reanalysis V3 contains objectively-analyzed 4-dimensional weather maps and their uncertainty from the early 19th century to the 21st century
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
#' @seealso \code{\link{sources_altimetry}}, \code{\link{sources_biological}}, \code{\link{sources_meteorological}}, \code{\link{sources_ocean_colour}}, \code{\link{sources_oceanographic}}, \code{\link{sources_sdm}}, \code{\link{sources_seaice}}, \code{\link{sources_sst}}, \code{\link{sources_topography}}
#' @return a tibble with columns as specified by \code{\link{bb_source}}
#'
#' @examples
#' \dontrun{
#' ## define a configuration and add the monthly NCEP2 data to it
#' cf <- bb_config("/my/file/root") %>%
#'   bb_add(sources_reanalysis("NCEP-DOE Reanalysis 2",time_resolution="month"))
#' }
#' @export
sources_reanalysis <- function(name,formats,time_resolutions, ...) {
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
    if (is.null(name) || any(name %in% tolower(c("NCEP-DOE Reanalysis 2","ncep.reanalysis2")))) {
        if (!is.null(time_resolutions)) {
            chk <- !time_resolutions %in% c("day","month","6h","6hr","6 hour")
            if (any(chk)) stop("unrecognized time_resolutions value for the 'NCEP-DOE Reanalysis 2' source")
        } else {
            ## default to monthly
            time_resolutions <- "month"
        }
        if (any(grepl("6",time_resolutions))) {
            out <- rbind(out,
                         bb_source(
                             name = "NCEP-DOE Reanalysis 2 6-hourly data",
                             id = "ncep.reanalysis2",
                             description = "NCEP-DOE Reanalysis 2 is an improved version of the NCEP Reanalysis I model that fixed errors and updated paramterizations of of physical processes. The 6-hourly data is the original output time resolution.",
                             doc_url = "http://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis2.html",
                             citation = "NCEP_Reanalysis 2 data provided by the NOAA/OAR/ESRL PSD, Boulder, Colorado, USA, from their web site at http://www.esrl.noaa.gov/psd/",
                             source_url = "ftp://ftp.cdc.noaa.gov/Datasets/ncep.reanalysis2/",
                             license = "Please cite",
                             ##method = list("bb_handler_wget",level=3), ## --recursive --no-parent
                             method = list("bb_handler_rget", level = 3),
                             postprocess = NULL,
                             collection_size = NA, ## haven't downloaded full collection yet, so don't have a figure for this
                             data_group = "Reanalysis"))
        }
        if ("day" %in% time_resolutions) {
            out <- rbind(out,
                         bb_source(
                             name = "NCEP-DOE Reanalysis 2 daily averages",
                             id = "ncep.reanalysis2.dailyavgs",
                             description = "NCEP-DOE Reanalysis 2 is an improved version of the NCEP Reanalysis I model that fixed errors and updated paramterizations of of physical processes. Daily averages are calculated from the 6-hourly model output.",
                             doc_url = "http://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis2.html",
                             citation = "NCEP_Reanalysis 2 data provided by the NOAA/OAR/ESRL PSD, Boulder, Colorado, USA, from their web site at http://www.esrl.noaa.gov/psd/",
                             source_url = "ftp://ftp.cdc.noaa.gov/Datasets/ncep.reanalysis2.dailyavgs/",
                             license = "Please cite",
                             ##method = list("bb_handler_wget",level=3), ## --recursive --no-parent
                             method = list("bb_handler_rget", level = 3),
                             postprocess = NULL,
                             collection_size = 50,
                             data_group = "Reanalysis"))
        }
        if ("month" %in% time_resolutions) {
            out <- rbind(out,
                         bb_source(
                             name = "NCEP-DOE Reanalysis 2 monthly averages",
                             id = "ncep.reanalysis2.derived",
                             description = "NCEP-DOE Reanalysis 2 is an improved version of the NCEP Reanalysis I model that fixed errors and updated paramterizations of of physical processes. Monthly averages are calculated from the 6-hourly model output.",
                             doc_url = "http://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis2.html",
                             citation = "NCEP_Reanalysis 2 data provided by the NOAA/OAR/ESRL PSD, Boulder, Colorado, USA, from their web site at http://www.esrl.noaa.gov/psd/",
                             source_url = "ftp://ftp.cdc.noaa.gov/Datasets/ncep.reanalysis2.derived/",
                             license = "Please cite",
                             ##method = list("bb_handler_wget",level=3), ## --recursive --no-parent
                             method = list("bb_handler_rget", level = 3),
                             postprocess = NULL,
                             collection_size = 2,
                             data_group = "Reanalysis"))
        }
    }
    if (is.null(name) || any(name %in% tolower(c("NCEP/NCAR Reanalysis 1", "ncep.reanalysis", "ncep.reanalysis.derived")))) {
            out <- rbind(out,
                         bb_source(
                             name = "NCEP-DOE Reanalysis 1 monthly averages",
                             id = "ncep.reanalysis2.derived",
                             description = "The NCEP/NCAR Reanalysis 1 project is using a state-of-the-art analysis/forecast system to perform data assimilation using past data from 1948 to the present. Monthly averages are calculated from the 6-hourly model output.",
                             doc_url = "https://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis.html",
                             citation = "Kalnay et al.,The NCEP/NCAR 40-year reanalysis project, Bull. Amer. Meteor. Soc., 77, 437-470, 1996",
                             source_url = "ftp://ftp.cdc.noaa.gov/Datasets/ncep.reanalysis.derived/surface/",
                             license = "Please cite",
                             ##method = list("bb_handler_wget"),
                             method = list("bb_handler_rget", level = 1),
                             postprocess = NULL,
                             collection_size = 2,
                             data_group = "Reanalysis"))
    }
    if (is.null(name) || any(name %in% tolower(c("CCMP Wind Product V2", "CCMPv2")))) {
        out <- rbind(out,
                     bb_source(
                         name = "CCMP Wind Product V2",
                         id = "CCMPv2",
                         description = "The Cross-Calibrated Multi-Platform (CCMP) gridded surface vector winds are produced using satellite, moored buoy, and model wind data, and are a Level-3 ocean vector wind analysis product. The V2 CCMP processing combines Version-7 RSS radiometer wind speeds, QuikSCAT and ASCAT scatterometer wind vectors, moored buoy wind data, and ERA-Interim model wind fields using a Variational Analysis Method (VAM) to produce four maps daily of 0.25 degree gridded vector winds",
                         doc_url = "https://www.remss.com/measurements/ccmp/",
                         citation = "Wentz FJ, Scott J, Hoffman R, Leidner M, Atlas R, Ardizzone J (2015) Remote Sensing Systems Cross-Calibrated Multi-Platform (CCMP) 6-hourly ocean vector wind analysis product on 0.25 deg grid, Version 2.0, [indicate date subset, if used]. Remote Sensing Systems, Santa Rosa, CA. Available online at www.remss.com/measurements/ccmp\n\nMears CA, Scott J, Wentz FJ, Ricciardulli L, Leidner SM, Hoffman R, Atlas R (2019) A near real time version of the Cross Calibrated Multiplatform (CCMP) ocean surface wind velocity data set. Journal of Geophysical Research: Oceans. https://doi.org/10.1029/2019JC015367",
                         source_url = "https://data.remss.com/ccmp/",
                         license = "Please cite",
                         method = list("bb_handler_rget", level = 4, no_parent = FALSE, accept_follow = "data\\.remss\\.com/ccmp"),
                         postprocess = NULL,
                         collection_size = 120,
                         data_group = "Reanalysis"))
    }
    out
}
