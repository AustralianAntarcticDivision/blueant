#' Reanalysis data sources
#'
#' Data sources providing data from global reanalysis models.
#'
#' \itemize{
#'   \item "NCEP-DOE Reanalysis 2": NCEP-DOE Reanalysis 2 is an improved version of the NCEP Reanalysis I model that fixed errors and updated paramterizations of of physical processes. Accepts \code{time_resolution} values of "6 hour", "day", and/or "month" (default). The 6-hourly data is the original output time resolution. Daily and monthly averages are calculated from the 6-hourly model output
#' }
#'
#' The returned tibble contains more information about each source.
#'
#' @param name character vector: only return data sources with name or id matching these values
#' @param formats character: for some sources, the format can be specified. See the list of sources above for details.
#' @param time_resolutions character: for some sources, the time resolution can be specified. See the list of sources above for details.
#'
#' @references See the \code{doc_url} and \code{citation} field in each row of the returned tibble for references associated with these particular data sources
#'
#' @seealso \code{\link{sources_altimetry}}, \code{\link{sources_meteorological}}, \code{\link{sources_ocean_colour}}, \code{\link{sources_oceanographic}}, \code{\link{sources_seaice}}, \code{\link{sources_sst}}, \code{\link{sources_topography}}
#' @return a tibble with columns as specified by \code{\link{bb_source}}
#'
#' @examples
#' \dontrun{
#' ## define a configuration and add the monthly NCEP2 data to it
#' cf <- bb_config("/my/file/root") %>%
#'   bb_add(sources_reanalysis("NCEP-DOE Reanalysis 2",time_resolution="month"))
#' }
#' @export
sources_reanalysis <- function(name,formats,time_resolutions) {
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
                             name="NCEP-DOE Reanalysis 2 6-hourly data",
                             id="ncep.reanalysis2",
                             description="NCEP-DOE Reanalysis 2 is an improved version of the NCEP Reanalysis I model that fixed errors and updated paramterizations of of physical processes. The 6-hourly data is the original output time resolution.",
                             doc_url="http://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis2.html",
                             citation="NCEP_Reanalysis 2 data provided by the NOAA/OAR/ESRL PSD, Boulder, Colorado, USA, from their web site at http://www.esrl.noaa.gov/psd/",
                             source_url="ftp://ftp.cdc.noaa.gov/Datasets/ncep.reanalysis2/",
                             license="Please cite",
                             method=list("bb_handler_wget",level=3), ## --recursive --no-parent
                             postprocess=NULL,
                             collection_size=NA, ## haven't downloaded full collection yet, so don't have a figure for this
                             data_group="Reanalysis"))
        }
        if ("day" %in% time_resolutions) {
            out <- rbind(out,
                         bb_source(
                             name="NCEP-DOE Reanalysis 2 daily averages",
                             id="ncep.reanalysis2.dailyavgs",
                             description="NCEP-DOE Reanalysis 2 is an improved version of the NCEP Reanalysis I model that fixed errors and updated paramterizations of of physical processes. Daily averages are calculated from the 6-hourly model output.",
                             doc_url="http://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis2.html",
                             citation="NCEP_Reanalysis 2 data provided by the NOAA/OAR/ESRL PSD, Boulder, Colorado, USA, from their web site at http://www.esrl.noaa.gov/psd/",
                             source_url="ftp://ftp.cdc.noaa.gov/Datasets/ncep.reanalysis2.dailyavgs/",
                             license="Please cite",
                             method=list("bb_handler_wget",level=3), ## --recursive --no-parent
                             postprocess=NULL,
                             collection_size=50,
                             data_group="Reanalysis"))
        }
        if ("month" %in% time_resolutions) {
            out <- rbind(out,
                         bb_source(
                             name="NCEP-DOE Reanalysis 2 monthly averages",
                             id="ncep.reanalysis2.derived",
                             description="NCEP-DOE Reanalysis 2 is an improved version of the NCEP Reanalysis I model that fixed errors and updated paramterizations of of physical processes. Monthly averages are calculated from the 6-hourly model output.",
                             doc_url="http://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis2.html",
                             citation="NCEP_Reanalysis 2 data provided by the NOAA/OAR/ESRL PSD, Boulder, Colorado, USA, from their web site at http://www.esrl.noaa.gov/psd/",
                             source_url="ftp://ftp.cdc.noaa.gov/Datasets/ncep.reanalysis2.derived/",
                             license="Please cite",
                             method=list("bb_handler_wget",level=3), ## --recursive --no-parent
                             postprocess=NULL,
                             collection_size=2,
                             data_group="Reanalysis"))
        }
    }
    out
}
