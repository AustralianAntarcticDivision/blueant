#' Ocean colour data sources
#'
#' Data sources providing ocean colour data.
#'
#' \itemize{
#'   \item "Oceandata SeaWiFS Level-3 mapped monthly 9km chl-a": Monthly remote-sensing chlorophyll-a from the SeaWiFS satellite at 9km spatial resolution
#'   \item "Oceandata MODIS Aqua Level-3 mapped daily 4km chl-a": Daily remote-sensing chlorophyll-a from the MODIS Aqua satellite at 4km spatial resolution
#'   \item "Oceandata MODIS Aqua Level-3 mapped monthly 9km chl-a": Monthly remote-sensing chlorophyll-a from the MODIS Aqua satellite at 9km spatial resolution
#'   \item "Oceandata VIIRS Level-3 mapped daily 4km chl-a": Daily remote-sensing chlorophyll-a from the VIIRS satellite at 4km spatial resolution
#'   \item "Oceandata VIIRS Level-3 mapped monthly 9km chl-a": Monthly remote-sensing chlorophyll-a from the VIIRS satellite at 9km spatial resolution
#'   \item "Oceandata VIIRS Level-3 mapped seasonal 9km chl-a": Seasonal remote-sensing chlorophyll-a from the VIIRS satellite at 9km spatial resolution
#'   \item "Oceandata VIIRS Level-3 binned daily RRS": Daily remote-sensing reflectance from VIIRS. RRS is used to produce standard ocean colour products such as chlorophyll concentration
#'   \item "Oceandata MODIS Aqua Level-3 binned daily RRS": Daily remote-sensing reflectance from MODIS Aqua. RRS is used to produce standard ocean colour products such as chlorophyll concentration
#'   \item "Oceandata SeaWiFS Level-3 binned daily RRS": Daily remote-sensing reflectance from SeaWiFS. RRS is used to produce standard ocean colour products such as chlorophyll concentration
#'   \item "Oceandata VIIRS Level-3 mapped 32-day 9km chl-a": Rolling 32-day composite remote-sensing chlorophyll-a from the VIIRS satellite at 9km spatial resolution
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
#' \dontrun{
#' ## define a configuration and add the monthly SeaWiFS data to it
#' cf <- bb_config("/my/file/root")
#' src <- sources_ocean_colour("Oceandata SeaWiFS Level-3 mapped monthly 9km chl-a")
#' cf <- bb_add(cf,src)
#' }
#'
#' @export
sources_ocean_colour <- function(name,formats,time_resolutions, ...) {
    if (!missing(name) && !is.null(name)) {
        assert_that(is.character(name))
        name <- tolower(name)
    } else {
        name <- NULL
    }
    out <- tibble()

    if (is.null(name) || any(name %in% tolower(c("Oceandata SeaWiFS Level-3 mapped monthly 9km chl-a","SeaWiFS_L3m_MO_CHL_chlor_a_9km")))) {
        out <- rbind(out,
                     bb_source(
                         name="Oceandata SeaWiFS Level-3 mapped monthly 9km chl-a",
                         id="SeaWiFS_L3m_MO_CHL_chlor_a_9km",
                         description="Monthly remote-sensing chlorophyll-a from the SeaWiFS satellite at 9km spatial resolution",
                         doc_url="http://oceancolor.gsfc.nasa.gov/",
                         citation="See https://oceancolor.gsfc.nasa.gov/citations",
                         license="Please cite",
                         method=list("bb_handler_oceandata",search="S*L3m_MO_CHL_chlor_a_9km.nc"),
                         postprocess=NULL,
                         collection_size=7.2,
                         data_group="Ocean colour"))
    }

    if (is.null(name) || any(name %in% tolower(c("Oceandata MODIS Aqua Level-3 mapped daily 4km chl-a","MODISA_L3m_DAY_CHL_chlor_a_4km")))) {
        out <- rbind(out,
                     bb_source(
                         name="Oceandata MODIS Aqua Level-3 mapped daily 4km chl-a",
                         id="MODISA_L3m_DAY_CHL_chlor_a_4km",
                         description="Daily remote-sensing chlorophyll-a from the MODIS Aqua satellite at 4km spatial resolution",
                         doc_url="http://oceancolor.gsfc.nasa.gov/",
                         citation="See https://oceancolor.gsfc.nasa.gov/citations",
                         license="Please cite",
                         method=list("bb_handler_oceandata",search="A*L3m_DAY_CHL_chlor_a_4km.nc"),
                         postprocess=NULL,
                         collection_size=40,
                         data_group="Ocean colour"))
    }

    if (is.null(name) || any(name %in% tolower(c("Oceandata MODIS Aqua Level-3 mapped monthly 9km chl-a","MODISA_L3m_MO_CHL_chlor_a_9km")))) {
        out <- rbind(out,
                     bb_source(
                         name="Oceandata MODIS Aqua Level-3 mapped monthly 9km chl-a",
                         id="MODISA_L3m_MO_CHL_chlor_a_9km",
                         description="Monthly remote-sensing chlorophyll-a from the MODIS Aqua satellite at 9km spatial resolution",
                         doc_url="http://oceancolor.gsfc.nasa.gov/",
                         citation="See https://oceancolor.gsfc.nasa.gov/citations",
                         license="Please cite",
                         method=list("bb_handler_oceandata",search="A*L3m_MO_CHL_chlor_a_9km.nc"),
                         postprocess=NULL,
                         collection_size=8,
                         data_group="Ocean colour"))
    }

    if (is.null(name) || any(name %in% tolower(c("Oceandata VIIRS Level-3 mapped daily 4km chl-a","VIIRS_L3m_DAY_NPP_CHL_chlor_a_4km")))) {
        out <- rbind(out,
                     bb_source(
                         name="Oceandata VIIRS Level-3 mapped daily 4km chl-a",
                         id="VIIRS_L3m_DAY_NPP_CHL_chlor_a_4km",
                         description="Daily remote-sensing chlorophyll-a from the VIIRS satellite at 4km spatial resolution",
                         doc_url="http://oceancolor.gsfc.nasa.gov/",
                         citation="See https://oceancolor.gsfc.nasa.gov/citations",
                         license="Please cite",
                         method=list("bb_handler_oceandata",search="V2016*L3m_DAY_NPP_CHL_chlor_a_4km.nc"),
                         postprocess=NULL,
                         collection_size=1,
                         data_group="Ocean colour"))
    }

    if (is.null(name) || any(name %in% tolower(c("Oceandata VIIRS Level-3 mapped monthly 9km chl-a","VIIRS_L3m_MO_SNPP_CHL_chlor_a_9km")))) {
        out <- rbind(out,
                     bb_source(
                         name="Oceandata VIIRS Level-3 mapped monthly 9km chl-a",
                         id="VIIRS_L3m_MO_SNPP_CHL_chlor_a_9km",
                         description="Monthly remote-sensing chlorophyll-a from the VIIRS satellite at 9km spatial resolution",
                         doc_url="http://oceancolor.gsfc.nasa.gov/",
                         citation="See https://oceancolor.gsfc.nasa.gov/citations",
                         license="Please cite",
                         method=list("bb_handler_oceandata",search="V*L3m_MO_SNPP_CHL_chlor_a_9km.nc"),
                         postprocess=NULL,
                         collection_size=1,
                         data_group="Ocean colour"))
    }

    if (is.null(name) || any(name %in% tolower(c("Oceandata VIIRS Level-3 mapped seasonal 9km chl-a","VIIRS_L3m_SNxx_SNPP_CHL_chlor_a_9km")))) {
        out <- rbind(out,
                     bb_source(
                         name="Oceandata VIIRS Level-3 mapped seasonal 9km chl-a",
                         id="VIIRS_L3m_SNxx_SNPP_CHL_chlor_a_9km",
                         description="Seasonal remote-sensing chlorophyll-a from the VIIRS satellite at 9km spatial resolution",
                         doc_url="http://oceancolor.gsfc.nasa.gov/",
                         citation="See https://oceancolor.gsfc.nasa.gov/citations",
                         license="Please cite",
                         method=list("bb_handler_oceandata",search="V*L3m_SN*_SNPP_CHL_chlor_a_9km.nc"),
                         postprocess=NULL,
                         collection_size=0.5,
                         data_group="Ocean colour"))
    }

    if (is.null(name) || any(name %in% tolower(c("Oceandata VIIRS Level-3 binned daily RRS","VIIRS_L3b_DAY_SNPP_RRS")))) {
        out <- rbind(out,
                     bb_source(
                         name="Oceandata VIIRS Level-3 binned daily RRS",
                         id="VIIRS_L3b_DAY_SNPP_RRS",
                         description="Daily remote-sensing reflectance from VIIRS. RRS is used to produce standard ocean colour products such as chlorophyll concentration",
                         doc_url="http://oceancolor.gsfc.nasa.gov/",
                         citation="See https://oceancolor.gsfc.nasa.gov/citations",
                         license="Please cite",
                         method=list("bb_handler_oceandata",search="V*L3b_DAY_SNPP_RRS.nc"),
                         postprocess=NULL,
                         access_function="roc::readL3",
                         collection_size=180,
                         data_group="Ocean colour"))
    }

    if (is.null(name) || any(name %in% tolower(c("Oceandata MODIS Aqua Level-3 binned daily RRS","MODISA_L3b_DAY_RRS")))) {
        out <- rbind(out,
                     bb_source(
                         name="Oceandata MODIS Aqua Level-3 binned daily RRS",
                         id="MODISA_L3b_DAY_RRS",
                         description="Daily remote-sensing reflectance from MODIS Aqua. RRS is used to produce standard ocean colour products such as chlorophyll concentration",
                         doc_url="http://oceancolor.gsfc.nasa.gov/",
                         citation="See https://oceancolor.gsfc.nasa.gov/citations",
                         license="Please cite",
                         method=list("bb_handler_oceandata",search="A*L3b_DAY_RRS.nc"),
                         postprocess=NULL,
                         access_function="roc::readL3",
                         collection_size=800,
                         data_group="Ocean colour"))
    }

    if (is.null(name) || any(name %in% tolower(c("Oceandata SeaWiFS Level-3 binned daily RRS","SeaWiFS_L3b_DAY_RRS")))) {
        out <- rbind(out,
                     bb_source(
                         name="Oceandata SeaWiFS Level-3 binned daily RRS",
                         id="SeaWiFS_L3b_DAY_RRS",
                         description="Daily remote-sensing reflectance from SeaWiFS. RRS is used to produce standard ocean colour products such as chlorophyll concentration",
                         doc_url="http://oceancolor.gsfc.nasa.gov/",
                         citation="See https://oceancolor.gsfc.nasa.gov/citations",
                         license="Please cite",
                         method=list("bb_handler_oceandata",search="S*L3b_DAY_RRS.nc"),
                         postprocess=NULL,
                         access_function="roc::readL3",
                         collection_size=130,
                         data_group="Ocean colour"))
    }

    if (is.null(name) || any(name %in% tolower(c("Oceandata VIIRS Level-3 mapped 32-day 9km chl-a","VIIRS_L3m_R32_SNPP_CHL_chlor_a_9km")))) {
        out <- rbind(out,
                     bb_source(
                         name="Oceandata VIIRS Level-3 mapped 32-day 9km chl-a",
                         id="VIIRS_L3m_R32_SNPP_CHL_chlor_a_9km",
                         description="Rolling 32-day composite remote-sensing chlorophyll-a from the VIIRS satellite at 9km spatial resolution",
                         doc_url="http://oceancolor.gsfc.nasa.gov/",
                         citation="See https://oceancolor.gsfc.nasa.gov/citations",
                         license="Please cite",
                         method=list("bb_handler_oceandata",search="V*L3m_R32_SNPP_CHL_chlor_a_9km.nc"),
                         postprocess=NULL,
                         collection_size=4,
                         data_group="Ocean colour"))
    }
    out
}

#' @rdname sources_ocean_colour
#' @export
sources_ocean_color <- sources_ocean_colour
