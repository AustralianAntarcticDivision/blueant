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
#'   \item "Southern Ocean summer chlorophyll-a climatology (Johnson)": Climatological summer chlorophyll-a layer for the Southern Ocean south of 40S, following the OC3M algorithm of Johnson et al. (2013)
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
#' @seealso \code{\link{sources_altimetry}}, \code{\link{sources_biological}}, \code{\link{sources_meteorological}}, \code{\link{sources_oceanographic}}, \code{\link{sources_reanalysis}}, \code{\link{sources_sdm}}, \code{\link{sources_seaice}}, \code{\link{sources_sst}}, \code{\link{sources_topography}}
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
                         doc_url="https://oceancolor.gsfc.nasa.gov/",
                         citation="See https://oceancolor.gsfc.nasa.gov/citations",
                         license="Please cite",
                         method=list("bb_handler_oceandata", search="SEASTAR_SEAWIFS_GAC*L3m.MO.CHL.chlor_a.9km.nc", sensor = "seawifs", dtype = "L3m"),
                         postprocess=list("bb_oceandata_cleanup"),
                         collection_size=7.2,
                         user = "", password = "", warn_empty_auth = FALSE,
                         authentication_note = "Requires Earthdata login, see https://urs.earthdata.nasa.gov/. Note that you will also need to authorize the application 'OB.DAAC Data Access' (see 'My Applications' at https://urs.earthdata.nasa.gov/profile)",
                         data_group="Ocean colour"))
    }

    if (is.null(name) || any(name %in% tolower(c("Oceandata MODIS Aqua Level-3 mapped daily 4km chl-a","MODISA_L3m_DAY_CHL_chlor_a_4km")))) {
        out <- rbind(out,
                     bb_source(
                         name="Oceandata MODIS Aqua Level-3 mapped daily 4km chl-a",
                         id="MODISA_L3m_DAY_CHL_chlor_a_4km",
                         description="Daily remote-sensing chlorophyll-a from the MODIS Aqua satellite at 4km spatial resolution",
                         doc_url="https://oceancolor.gsfc.nasa.gov/",
                         citation="See https://oceancolor.gsfc.nasa.gov/citations",
                         license="Please cite",
                         method=list("bb_handler_oceandata",search="AQUA_MODIS*L3m.DAY.CHL.chlor_a.4km*.nc", sensor = "aqua", dtype = "L3m"),
                         postprocess=list("bb_oceandata_cleanup"),
                         collection_size=40,
                         user = "", password = "", warn_empty_auth = FALSE,
                         authentication_note = "Requires Earthdata login, see https://urs.earthdata.nasa.gov/. Note that you will also need to authorize the application 'OB.DAAC Data Access' (see 'My Applications' at https://urs.earthdata.nasa.gov/profile)",
                         data_group="Ocean colour"))
    }

    if (is.null(name) || any(name %in% tolower(c("Oceandata MODIS Aqua Level-3 mapped monthly 9km chl-a","MODISA_L3m_MO_CHL_chlor_a_9km")))) {
        out <- rbind(out,
                     bb_source(
                         name="Oceandata MODIS Aqua Level-3 mapped monthly 9km chl-a",
                         id="MODISA_L3m_MO_CHL_chlor_a_9km",
                         description="Monthly remote-sensing chlorophyll-a from the MODIS Aqua satellite at 9km spatial resolution",
                         doc_url="https://oceancolor.gsfc.nasa.gov/",
                         citation="See https://oceancolor.gsfc.nasa.gov/citations",
                         license="Please cite",
                         method=list("bb_handler_oceandata",search="AQUA_MODIS*L3m.MO.CHL.chlor_a.9km*.nc", sensor = "aqua", dtype = "L3m"),
                         postprocess=list("bb_oceandata_cleanup"),
                         collection_size=8,
                         user = "", password = "", warn_empty_auth = FALSE,
                         authentication_note = "Requires Earthdata login, see https://urs.earthdata.nasa.gov/. Note that you will also need to authorize the application 'OB.DAAC Data Access' (see 'My Applications' at https://urs.earthdata.nasa.gov/profile)",
                         data_group="Ocean colour"))
    }

    if (is.null(name) || any(name %in% tolower(c("Oceandata VIIRS Level-3 mapped daily 4km chl-a","VIIRS_L3m_DAY_NPP_CHL_chlor_a_4km")))) {
        out <- rbind(out,
                     bb_source(
                         name="Oceandata VIIRS Level-3 mapped daily 4km chl-a",
                         id="VIIRS_L3m_DAY_NPP_CHL_chlor_a_4km",
                         description="Daily remote-sensing chlorophyll-a from the VIIRS satellite at 4km spatial resolution",
                         doc_url="https://oceancolor.gsfc.nasa.gov/",
                         citation="See https://oceancolor.gsfc.nasa.gov/citations",
                         license="Please cite",
                         method=list("bb_handler_oceandata", search = "SNPP_VIIRS*L3m.DAY.CHL.chlor_a.4km*.nc", sensor = "viirs", dtype = "L3m"),
                         postprocess=list("bb_oceandata_cleanup"),
                         collection_size=50,
                         user = "", password = "", warn_empty_auth = FALSE,
                         authentication_note = "Requires Earthdata login, see https://urs.earthdata.nasa.gov/. Note that you will also need to authorize the application 'OB.DAAC Data Access' (see 'My Applications' at https://urs.earthdata.nasa.gov/profile)",
                         data_group="Ocean colour"))
    }

    if (is.null(name) || any(name %in% tolower(c("Oceandata VIIRS Level-3 mapped monthly 9km chl-a","VIIRS_L3m_MO_SNPP_CHL_chlor_a_9km")))) {
        out <- rbind(out,
                     bb_source(
                         name="Oceandata VIIRS Level-3 mapped monthly 9km chl-a",
                         id="VIIRS_L3m_MO_SNPP_CHL_chlor_a_9km",
                         description="Monthly remote-sensing chlorophyll-a from the VIIRS satellite at 9km spatial resolution",
                         doc_url="https://oceancolor.gsfc.nasa.gov/",
                         citation="See https://oceancolor.gsfc.nasa.gov/citations",
                         license="Please cite",
                         method=list("bb_handler_oceandata",search="SNPP_VIIRS*L3m.MO.CHL.chlor_a.9km*.nc", sensor = "viirs", dtype = "L3m"),
                         postprocess=list("bb_oceandata_cleanup"),
                         collection_size=1,
                         user = "", password = "", warn_empty_auth = FALSE,
                         authentication_note = "Requires Earthdata login, see https://urs.earthdata.nasa.gov/. Note that you will also need to authorize the application 'OB.DAAC Data Access' (see 'My Applications' at https://urs.earthdata.nasa.gov/profile)",
                         data_group="Ocean colour"))
    }

    if (is.null(name) || any(name %in% tolower(c("Oceandata VIIRS Level-3 mapped seasonal 9km chl-a","VIIRS_L3m_SNxx_SNPP_CHL_chlor_a_9km")))) {
        out <- rbind(out,
                     bb_source(
                         name="Oceandata VIIRS Level-3 mapped seasonal 9km chl-a",
                         id="VIIRS_L3m_SNxx_SNPP_CHL_chlor_a_9km",
                         description="Seasonal remote-sensing chlorophyll-a from the VIIRS satellite at 9km spatial resolution",
                         doc_url="https://oceancolor.gsfc.nasa.gov/",
                         citation="See https://oceancolor.gsfc.nasa.gov/citations",
                         license="Please cite",
                         method=list("bb_handler_oceandata",search="SNPP_VIIRS*L3m.SN*.CHL.chlor_a.9km*.nc", sensor = "viirs", dtype = "L3m"),
                         postprocess=list("bb_oceandata_cleanup"),
                         collection_size=0.5,
                         user = "", password = "", warn_empty_auth = FALSE,
                         authentication_note = "Requires Earthdata login, see https://urs.earthdata.nasa.gov/. Note that you will also need to authorize the application 'OB.DAAC Data Access' (see 'My Applications' at https://urs.earthdata.nasa.gov/profile)",
                         data_group="Ocean colour"))
    }

    if (is.null(name) || any(name %in% tolower(c("Oceandata VIIRS Level-3 binned daily RRS","VIIRS_L3b_DAY_SNPP_RRS")))) {
        out <- rbind(out,
                     bb_source(
                         name="Oceandata VIIRS Level-3 binned daily RRS",
                         id="VIIRS_L3b_DAY_SNPP_RRS",
                         description="Daily remote-sensing reflectance from VIIRS. RRS is used to produce standard ocean colour products such as chlorophyll concentration",
                         doc_url="https://oceancolor.gsfc.nasa.gov/",
                         citation="See https://oceancolor.gsfc.nasa.gov/citations",
                         license="Please cite",
                         method=list("bb_handler_oceandata", search = "SNPP_VIIRS*L3b.DAY.RRS.*.nc", sensor = "viirs", dtype = "L3b"),
                         postprocess=list("bb_oceandata_cleanup"),
                         access_function="roc::readL3",
                         collection_size=180,
                         user = "", password = "", warn_empty_auth = FALSE,
                         authentication_note = "Requires Earthdata login, see https://urs.earthdata.nasa.gov/. Note that you will also need to authorize the application 'OB.DAAC Data Access' (see 'My Applications' at https://urs.earthdata.nasa.gov/profile)",
                         data_group="Ocean colour"))
    }

    if (is.null(name) || any(name %in% tolower(c("Oceandata MODIS Aqua Level-3 binned daily RRS","MODISA_L3b_DAY_RRS")))) {
        out <- rbind(out,
                     bb_source(
                         name="Oceandata MODIS Aqua Level-3 binned daily RRS",
                         id="MODISA_L3b_DAY_RRS",
                         description="Daily remote-sensing reflectance from MODIS Aqua. RRS is used to produce standard ocean colour products such as chlorophyll concentration",
                         doc_url="https://oceancolor.gsfc.nasa.gov/",
                         citation="See https://oceancolor.gsfc.nasa.gov/citations",
                         license="Please cite",
                         method=list("bb_handler_oceandata",search="AQUA_MODIS*L3b.DAY.RRS.*.nc", sensor = "aqua", dtype = "L3b"),
                         postprocess=list("bb_oceandata_cleanup"),
                         access_function="roc::readL3",
                         collection_size=800,
                         user = "", password = "", warn_empty_auth = FALSE,
                         authentication_note = "Requires Earthdata login, see https://urs.earthdata.nasa.gov/. Note that you will also need to authorize the application 'OB.DAAC Data Access' (see 'My Applications' at https://urs.earthdata.nasa.gov/profile)",
                         data_group="Ocean colour"))
    }

    if (is.null(name) || any(name %in% tolower(c("Oceandata SeaWiFS Level-3 binned daily RRS","SeaWiFS_L3b_DAY_RRS")))) {
        out <- rbind(out,
                     bb_source(
                         name="Oceandata SeaWiFS Level-3 binned daily RRS",
                         id="SeaWiFS_L3b_DAY_RRS",
                         description="Daily remote-sensing reflectance from SeaWiFS. RRS is used to produce standard ocean colour products such as chlorophyll concentration",
                         doc_url="https://oceancolor.gsfc.nasa.gov/",
                         citation="See https://oceancolor.gsfc.nasa.gov/citations",
                         license="Please cite",
                         method=list("bb_handler_oceandata",search="SEASTAR_SEAWIFS_GAC*L3b.DAY.RRS.nc", sensor = "seawifs", dtype = "L3b"),
                         postprocess=list("bb_oceandata_cleanup"),
                         access_function="roc::readL3",
                         collection_size=130,
                         user = "", password = "", warn_empty_auth = FALSE,
                         authentication_note = "Requires Earthdata login, see https://urs.earthdata.nasa.gov/. Note that you will also need to authorize the application 'OB.DAAC Data Access' (see 'My Applications' at https://urs.earthdata.nasa.gov/profile)",
                         data_group="Ocean colour"))
    }

    if (is.null(name) || any(name %in% tolower(c("Oceandata VIIRS Level-3 mapped 32-day 9km chl-a","VIIRS_L3m_R32_SNPP_CHL_chlor_a_9km")))) {
        out <- rbind(out,
                     bb_source(
                         name="Oceandata VIIRS Level-3 mapped 32-day 9km chl-a",
                         id="VIIRS_L3m_R32_SNPP_CHL_chlor_a_9km",
                         description="Rolling 32-day composite remote-sensing chlorophyll-a from the VIIRS satellite at 9km spatial resolution",
                         doc_url="https://oceancolor.gsfc.nasa.gov/",
                         citation="See https://oceancolor.gsfc.nasa.gov/citations",
                         license="Please cite",
                         method=list("bb_handler_oceandata",search="SNPP_VIIRS*L3m.R32.CHL.chlor_a.9km*.nc", sensor = "viirs", dtype = "L3m"),
                         postprocess=list("bb_oceandata_cleanup"),
                         collection_size=4,
                         user = "", password = "", warn_empty_auth = FALSE,
                         authentication_note = "Requires Earthdata login, see https://urs.earthdata.nasa.gov/. Note that you will also need to authorize the application 'OB.DAAC Data Access' (see 'My Applications' at https://urs.earthdata.nasa.gov/profile)",
                         data_group="Ocean colour"))
    }

    if (is.null(name) || any(name %in% tolower(c("Southern Ocean summer chlorophyll-a climatology (Johnson)","10.4225/15/5906b48f70bf9")))) {
        this <- bb_aadc_source("AAS_4343_so_chlorophyll", data_group = "Ocean colour", access_function = "raster::raster")
        this$name <- "Southern Ocean summer chlorophyll-a climatology (Johnson)" ## backwards compat
        out <- rbind(out, this)
    }

    out
}

#' @rdname sources_ocean_colour
#' @export
sources_ocean_color <- sources_ocean_colour
