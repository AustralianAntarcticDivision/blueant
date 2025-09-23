#' Sea ice data sources
#'
#' Data sources providing (primarily satellite-derived) sea ice data:
#' * "Sea Ice Concentrations from Nimbus-7 SMMR and DMSP SSM/I-SSMIS Passive Microwave Data, Version 2". Passive microwave estimates of sea ice concentration at 25km spatial resolution. Daily and monthly resolution, available from 1-Oct-1978 to near-present. Data undergo a quality checking process and are updated annually. Available only in netcdf format. Accepts `hemisphere` values of "south", "north", "both". More recent data are available via the 'Near-Real-Time DMSP SSMIS Daily Polar Gridded Sea Ice Concentrations, Version 2' source
#' * "Near-Real-Time DMSP SSMIS Daily Polar Gridded Sea Ice Concentrations, Version 2". Near-real-time passive microwave estimates of sea ice concentration at 25km, daily resolution. Available only in netcdf format. Accepts `hemisphere` values of "south", "north", "both". Accepts `time_resolution` values of "day" or "month". Accepts `years` parameter as a vector of years.
#' * "NSIDC passive microwave supporting files": Grids and other support files for NSIDC passive microwave sea ice data
#' * "Nimbus Ice Edge Points from Nimbus Visible Imagery": This data set (NmIcEdg2) estimates the location of the North and South Pole sea ice edges at various times during the mid to late 1960s, based on recovered Nimbus 1 (1964), Nimbus 2 (1966), and Nimbus 3 (1969) visible imagery
#' * "Artist AMSR-E sea ice concentration": Passive microwave estimates of daily sea ice concentration at 6.25km spatial resolution, from 19-Jun-2002 to 2-Oct-2011. Previously accepted formats "geotiff" and/or "hdf", but these are now ignored (the only file format available now is netcdf)
#' * "Artist AMSR2 near-real-time sea ice concentration": Near-real-time passive microwave estimates of daily sea ice concentration at 6.25km spatial resolution, from 24-July-2012 to present
#' * "Artist AMSR2 near-real-time 3.125km sea ice concentration": Near-real-time passive microwave estimates of daily sea ice concentration at 3.125km spatial resolution, from 24-July-2012 to present
#' * "Artist AMSR2 supporting files": Grids and landmasks for Artist AMSR2 passive microwave sea ice data
#' * "CERSAT SSM/I sea ice concentration": Passive microwave sea ice concentration data at 12.5km resolution, 3-Dec-1991 to present
#' * "CERSAT SSM/I sea ice concentration supporting files": Grids for the CERSAT SSM/I sea ice concentration data
#' * "Sea ice lead climatologies": Long-term relative sea ice lead frequencies for the Arctic (November - April 2002/03 - 2018/19) and Antarctic (April - September 2003 - 2019) derived from Moderate-Resolution Imaging Spectroradiometer (MODIS) imagery
#' * "MODIS Composite Based Maps of East Antarctic Fast Ice Coverage": Maps of East Antarctic landfast sea-ice extent, generated from approx. 250,000 1 km visible/thermal infrared cloud-free MODIS composite imagery (augmented with AMSR-E 6.25-km sea-ice concentration composite imagery when required). Coverage from 2000-03-01 to 2008-12-31
#' * "Circum-Antarctic landfast sea ice extent": maps of Antarctic landfast sea ice, derived from NASA MODIS imagery. There are 24 maps per year, spanning the 18 year period from March 2000 to Feb 2018
#' * "National Ice Center Antarctic daily sea ice charts": The USNIC Daily Ice Edge product depicts the daily sea ice pack in red (8-10/10ths or greater of sea ice), and the Marginal Ice Zone (MIZ) in yellow. The marginal ice zone is the transition between the open ocean (ice free) and pack ice. The MIZ is very dynamic and affects the air-ocean heat transport, as well as being a significant factor in navigational safety. The daily ice edge is analyzed by sea ice experts using multiple sources of near real time satellite data, derived satellite products, buoy data, weather, and analyst interpretation of current sea ice conditions. The product is a current depiction of the location of the ice edge vice a satellite derived ice edge product. Accepts a `formats` parameter which can be one of "filled" or "vector". Accepts a `years` parameter to restrict the data to certain years
#' * "Polarview Sentinel-1 imagery": Sentinel-1 imagery from polarview.aq. Accepts an `acquisition_date` parameter (default is the last four days including today), a `formats` parameter (one or both of "jpg", "geotiff", default is both), and a `polygon` parameter, which is a polygon within which to search - either a WKT polygon string in EPSG:3031 projection, or an object of class `sfc_POLYGON`, which will be converted to a WKT string internally
#' * "ATLAS/ICESat-2 L3B Daily and Monthly Gridded Sea Ice Freeboard, Version 4": daily and monthly gridded estimates of sea ice freeboard, derived from along-track freeboard estimates in the ATLAS/ICESat-2 L3A Sea Ice Freeboard product (ATL10)
#' * "NOAA/NSIDC Climate Data Record of Passive Microwave Sea Ice Concentration, Version 4": a Climate Data Record of sea ice concentration from passive microwave data. The CDR algorithm output is a rule-based combination of ice concentration estimates from two well-established algorithms: the NASA Team (NT) algorithm (Cavalieri et al. 1984) and NASA Bootstrap (BT) algorithm (Comiso 1986). The CDR is a consistent, daily and monthly time series of sea ice concentrations from 25 October 1978 through the most recent processing
#' * "Near-Real-Time NOAA/NSIDC Climate Data Record of Passive Microwave Sea Ice Concentration, Version 2": a near-real-time Climate Data Record (CDR) of sea ice concentration from passive microwave data. The Near-real-time NOAA/NSIDC Climate Data Record of Passive Microwave Sea Ice Concentration (NRT CDR) data set is the near-real-time version of the final NOAA/NSIDC Climate Data Record of Passive Microwave Sea Ice Concentration. The NRT CDR is designed to fill the temporal gap between updates of the final CDR, occurring every three to six months, and to provide the most recent data
#' * "OSI SAF Global Low Resolution Sea Ice Drift": ice motion vectors with a time span of 48 hours are estimated by an advanced cross-correlation method (the Continuous MCC, CMCC) on pairs of satellite images. The merged (multi-sensor) dataset is provided here
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
#' \dontrun{
#' ## define a configuration and add the AMSR-E data to it (geotiff format)
#' cf <- bb_config("/my/file/root") %>%
#'   bb_add(sources_seaice("Artist AMSR-E sea ice concentration",formats="geotiff"))
#'
#' ## the NSIDC SMMR-SSM/I Nasateam sea ice concentration, but only
#' ##    southern hemisphere, monthly data from 2013
#' cf <- bb_config("/my/file/root") %>%
#'   bb_add(sources_seaice("NSIDC SMMR-SSM/I Nasateam sea ice concentration",
#'                          time_resolutions = "month", hemisphere = "south", years = 2013))
#' }
#' @export

sources_seaice <- function(name, formats, time_resolutions, ...) {
    if (!missing(name) && !is.null(name)) {
        assert_that(is.character(name))
        name <- tolower(name)
    } else {
        name <- NULL
    }
    if (!missing(formats) && !is.null(formats)) {
        assert_that(is.character(formats))
        formats <- tolower(formats)
    } else {
        formats <- NULL
    }
    if (!missing(time_resolutions) && !is.null(time_resolutions)) {
        assert_that(is.character(time_resolutions))
        time_resolutions <- tolower(time_resolutions)
    } else {
        time_resolutions <- NULL
    }
    ss_args <- list(...)
    hemisphere <- ss_args$hemisphere
    if (is.null(hemisphere)) hemisphere <- "both"
    assert_that(is.character(hemisphere))
    hemisphere <- match.arg(tolower(hemisphere), c("south", "north", "both"))
    out <- tibble()
    if (is.null(name) || any(name %in% tolower(c("NSIDC SMMR-SSM/I Nasateam sea ice concentration", "10.5067/8GQ8LZQVL0VL")))) {
        warning("source 'NSIDC SMMR-SSM/I Nasateam sea ice concentration' is no longer available, use 'Sea Ice Concentrations from Nimbus-7 SMMR and DMSP SSM/I-SSMIS Passive Microwave Data, Version 2' instead")
    }

    if (is.null(name) || any(name %in% tolower(c("Sea Ice Concentrations from Nimbus-7 SMMR and DMSP SSM/I-SSMIS Passive Microwave Data, Version 2", "10.5067/MPYG15WAA4WX")))) {
        warning("The data download for the 'Sea Ice Concentrations from Nimbus-7 SMMR and DMSP SSM/I-SSMIS Passive Microwave Data, Version 2' does not currently seem to be returning valid Last-Modified times, which means that we can't skip unchanged files. Even if you set clobber=1 (only download if the remote file is newer than the local copy), it may download every single file anyway. You might wish to use clobber=0 (do not overwrite existing files)")
        if (!is.null(time_resolutions)) {
            chk <- !time_resolutions %in% c("day","month")
            if (any(chk)) stop("unrecognized time_resolutions value for the 'Sea Ice Concentrations from Nimbus-7 SMMR and DMSP SSM/I-SSMIS Passive Microwave Data, Version 2' source, expecting 'day' and/or 'month'")
        } else {
            ## default to both
            time_resolutions <- c("day", "month")
        }
        ## source-specific parms
        years <- ss_args$years
        if (!is.null(years)) {
            assert_that(is.numeric(years), noNA(years))
        }
        ## given hemisphere, time_resolutions, and years, construct appropriate source def
        ## URLs will be of the form
        ## https://n5eil01u.ecs.nsidc.org/PM/NSIDC-0051.002/1978.11.01/NSIDC0051_SEAICE_PS_S25km_197811_v2.0.nc (for monthly)
        ## https://n5eil01u.ecs.nsidc.org/PM/NSIDC-0051.002/1978.11.01/NSIDC0051_SEAICE_PS_S25km_19781101_v2.0.nc (for daily)
        h <- switch(hemisphere, south = "S", north = "N", both = "[SN]")
        monthly_accept_follow <- if (!"day" %in% time_resolutions) "01" else "[[:digit:]]{2}" ## only the first of the month for monthly
        yre <- paste0(if (!is.null(years)) paste0("(", paste(years, collapse = "|"), ")") else "[[:digit:]]{4}")
        accept_follow <- paste0(yre, "\\.[[:digit:]]{2}\\.", monthly_accept_follow, "/")
        accept_download <- paste0("PS_", h, "25km")
        reject_download <- "\\.(xml|png)$" ## reject these always
        if (!"day" %in% time_resolutions) {
            ## monthly files only have YYYYMM, no DD
            accept_download <- paste0(accept_download, "_[[:digit:]]{6}_")
        }
        accept_download <- paste0(accept_download, ".*\\.nc$")
        out <- rbind(out,
                     bb_source(
                         name = "Sea Ice Concentrations from Nimbus-7 SMMR and DMSP SSM/I-SSMIS Passive Microwave Data, Version 2",
                         id = "10.5067/MPYG15WAA4WX",
                         description = "Passive microwave estimates of sea ice concentration at 25km spatial resolution. Daily and monthly resolution, available from 1-Oct-1978 to present. Data undergo a quality checking process and are updated annually. Near-real-time data if required are available via the \"Near-Real-Time DMSP SSMIS Daily Polar Gridded Sea Ice Concentrations, Version 2\" source.",
                         doc_url = "https://nsidc.org/data/nsidc-0051/versions/2",
                         source_url = "https://n5eil01u.ecs.nsidc.org/PM/NSIDC-0051.002/",
                         citation = "DiGirolamo NE, Parkinson CL, Cavalieri DJ, Gloersen P, Zwally HJ (2022, updated yearly). Sea Ice Concentrations from Nimbus-7 SMMR and DMSP SSM/I-SSMIS Passive Microwave Data, Version 2. [Indicate subset used]. Boulder, Colorado USA. NASA National Snow and Ice Data Center Distributed Active Archive Center. https://doi.org/10.5067/MPYG15WAA4WX. [Date Accessed].",
                         license = "As a condition of using these data, you must include a citation.",
                         authentication_note = "Requires Earthdata login, see https://urs.earthdata.nasa.gov/. Note that you will also need to authorize the application 'NSIDC_DATAPOOL_OPS' (see 'My Applications' at https://urs.earthdata.nasa.gov/profile)",
                         method = list("bb_handler_earthdata", relative = TRUE, accept_follow = accept_follow, accept_download = accept_download, reject_download = reject_download, level = 2, allow_unrestricted_auth = TRUE),
                         user = "",
                         password = "",
                         postprocess = NULL,
                         access_function = "raadtools::readice",
                         collection_size = 5,
                         data_group = "Sea ice", warn_empty_auth = FALSE))
    }

    if (is.null(name) || any(name %in% tolower(c("NSIDC SMMR-SSM/I Nasateam near-real-time sea ice concentration", "10.5067/U8C09DWVX9LM")))) {
        warning("source 'NSIDC SMMR-SSM/I Nasateam near-real-time sea ice concentration' is no longer available, use 'Near-Real-Time DMSP SSMIS Daily Polar Gridded Sea Ice Concentrations, Version 2' instead")
    }

    if (is.null(name) || any(name %in% tolower(c("Near-Real-Time DMSP SSMIS Daily Polar Gridded Sea Ice Concentrations, Version 2", "10.5067/YTTHO2FJQ97K")))) {
        warning("The data download for the 'Near-Real-Time DMSP SSMIS Daily Polar Gridded Sea Ice Concentrations, Version 2' does not currently seem to be returning valid Last-Modified times, which means that we can't skip unchanged files. Even if you set clobber=1 (only download if the remote file is newer than the local copy), it may download every single file anyway. You might wish to use clobber=0 (do not overwrite existing files)")
        h <- switch(hemisphere, south = "S", north = "N", both = "[SN]")
        accept_download <- paste0("PS_", h, "25km.*\\.nc$")
        reject_download <- "\\.(xml|png)$" ## reject these always
        out <- rbind(out,
                     bb_source(
                         name = "Near-Real-Time DMSP SSMIS Daily Polar Gridded Sea Ice Concentrations, Version 2",
                         id = "10.5067/YTTHO2FJQ97K",
                         description = "Near-real-time passive microwave estimates of sea ice concentration at 25km, daily resolution. For older, quality-controlled data see the \"NSIDC SMMR-SSM/I Nasateam sea ice concentration\" source",
                         doc_url = "https://nsidc.org/data/nsidc-0081/versions/2",
                         citation = "Meier WN, Stewart JS, Wilcox H, Hardman MA, Scott DJ (2021) Near-Real-Time DMSP SSMIS Daily Polar Gridded Sea Ice Concentrations, Version 2. [Indicate subset used]. Boulder, Colorado USA. NASA National Snow and Ice Data Center Distributed Active Archive Center. https://doi.org/10.5067/YTTHO2FJQ97K. [Date Accessed].",
                         source_url = "https://n5eil01u.ecs.nsidc.org/PM/NSIDC-0081.002/",
                         license = "As a condition of using these data, you must include a citation.",
                         postprocess = NULL,
                         method = list("bb_handler_earthdata", relative = TRUE, accept_download = accept_download, reject_download = reject_download, level = 2, allow_unrestricted_auth = TRUE),
                         user = "",
                         password = "",
                         authentication_note = "Requires Earthdata login, see https://urs.earthdata.nasa.gov/. Note that you will also need to authorize the application 'NSIDC_DATAPOOL_OPS' (see 'My Applications' at https://urs.earthdata.nasa.gov/profile)",
                         access_function = "raadtools::readice",
                         collection_size = 0.2,
                         data_group = "Sea ice"))
    }

    if (is.null(name) || any(name %in% tolower(c("NSIDC passive microwave supporting files", "nsidc_seaice_grids")))) {
        out <- rbind(out,
                     bb_source(
                         name = "NSIDC passive microwave supporting files",
                         id = "nsidc_seaice_grids",
                         description = "Grids and other support files for NSIDC passive microwave sea ice data.",
                         doc_url = "https://nsidc.org/data/nsidc-0051/versions/2",
                         citation = "See the citation details of the particular sea ice dataset used",
                         source_url = "ftp://sidads.colorado.edu/pub/DATASETS/seaice/polar-stereo/tools/",
                         license = "Please cite, see https://nsidc.org/about/data-use-and-copyright",
                         method = list("bb_handler_rget", level = 1, accept_download_extra = "(dat|msk|ntb|stb|N17)$"),
                         postprocess = NULL,
                         access_function = "raadtools::readice",
                         collection_size = 0.1,
                         data_group = "Sea ice"))
    }

    if (is.null(name) || any(name %in% tolower(c("Nimbus Ice Edge Points from Nimbus Visible Imagery", "10.5067/NIMBUS/NmIcEdg2")))) {
        out <- rbind(out,
                     bb_source(
                         name = "Nimbus Ice Edge Points from Nimbus Visible Imagery",
                         id = "10.5067/NIMBUS/NmIcEdg2",
                         description = "This data set (NmIcEdg2) estimates the location of the North and South Pole sea ice edges at various times during the mid to late 1960s, based on recovered Nimbus 1 (1964), Nimbus 2 (1966), and Nimbus 3 (1969) visible imagery.",
                         doc_url = "http://nsidc.org/data/nmicedg2/",
                         citation = "Gallaher D and Campbell G (2014) Nimbus Ice Edge Points from Nimbus Visible Imagery L2, CSV. [indicate subset used]. Boulder, Colorado USA: NASA National Snow and Ice Data Center Distributed Active Archive Center. https://doi.org/10.5067/NIMBUS/NmIcEdg2",
                         license = "Please cite, see https://nsidc.org/about/data-use-and-copyright",
                         authentication_note = "Requires Earthdata login, see https://urs.earthdata.nasa.gov/. Note that you will also need to authorize the application 'NSIDC_DATAPOOL_OPS' (see 'My Applications' at https://urs.earthdata.nasa.gov/profile)",
                         method = list("bb_handler_earthdata_stac", stac_id = "NSIDC_CPRD", collection_id = "NmIcEdg2_1"),
                         user = "",
                         password = "",
                         postprocess = NULL,
                         collection_size = 0.1,
                         data_group = "Sea ice", warn_empty_auth = FALSE))
    }

    if (is.null(name) || any(name %in% tolower(c("Artist AMSR-E sea ice concentration", "AMSR-E_ASI_s6250")))) {
        myformats <- formats
        if (!is.null(myformats)) {
            warning("The 'Artist AMSR-E sea ice concentration' source no longer supports the 'formats' parameter, ignoring")
        }
        out <- rbind(out, bb_source(name = "Artist AMSR-E sea ice concentration",
                                    id = "AMSR-E_ASI_s6250",
                                    description = "Passive microwave estimates of daily sea ice concentration at 6.25km spatial resolution, from 19-Jun-2002 to 2-Oct-2011. Advanced Microwave Scanning Radiometer aboard EOS (AMSR-E) data have been used to produce a finer resolved sea-ice concentration data set gridded onto a polar-stereographic grid true at 70 degrees with 6.25 km grid resolution. The sea-ice concentration data available here have been computed by applying the ARTIST Sea Ice (ASI) algorithm to brightness temperatures measured with the 89 GHz AMSR-E channels. These channels have a considereably finer spatial resolution than the commonly used lower frequency channels.",
                                    doc_url = "https://www.cen.uni-hamburg.de/en/icdc/data/cryosphere/seaiceconcentration-asi-amsre.html",
                                    citation = "Please cite: Spreen G, Kaleschke L, Heygster G (2008) Sea ice remote sensing using AMSR-E 89 GHz channels. J. Geophys. Res. 113, C02S03, doi:10.1029/2005JC003384, and Kaleschke L et al. (2001) SSM/I sea ice remote sensing for meoscale ocean-atmosphere interaction analysis. Canad. J. Rem. Sens., 27, 526-537. Please include the acknowledgement: \"Thanks to ICDC, CEN, University of Hamburg for data support.\"",
                                    source_url = "ftp://ftp-icdc.cen.uni-hamburg.de/asi_amsre_iceconc/",
                                    license = "Please cite",
                                    method = list("bb_handler_rget", level = 2),
                                    postprocess = NULL,
                                    access_function = "raadtools::readice",
                                    collection_size = 25,
                                    data_group = "Sea ice"))
    }

    if (any(name %in% tolower(c("Artist AMSR-E supporting files", "AMSR-E_ASI_grids")))) {
        ## only throw error if this source was specifically requested. If `name` was NULL, just ignore this one
        stop("Artist AMSR-E supporting files are no longer available")
    }

    if (is.null(name) || any(name %in% tolower(c("Artist AMSR2 near-real-time sea ice concentration", "AMSR2_ASI_s6250")))) {
        out <- rbind(out,
                     bb_source(
                         name = "Artist AMSR2 near-real-time sea ice concentration",
                         id = "AMSR2_ASI_s6250",
                         description = "Near-real-time passive microwave estimates of daily sea ice concentration at 6.25km spatial resolution, from 24-July-2012 to present.",
                         doc_url = "https://seaice.uni-bremen.de/sea-ice-concentration/",
                         citation = "Spreen, G., L. Kaleschke, and G. Heygster (2008), Sea ice remote sensing using AMSR-E 89 GHz channels, J. Geophys. Res. 113, C02S03, doi:10.1029/2005JC003384",
                         source_url = "https://seaice.uni-bremen.de/data/amsr2/asi_daygrid_swath/s6250/",
                         license = "Please cite",
                         method = list("bb_handler_rget", level = 5, accept_download = "asi.*\\.(hdf|png|tif)"),
                         postprocess = NULL,
                         access_function = "raadtools::readice",
                         collection_size = 11,
                         data_group = "Sea ice"))
    }

    if (is.null(name) || any(name %in% tolower(c("Artist AMSR2 near-real-time 3.125km sea ice concentration", "AMSR2_ASI_s3125")))) {
        out <- rbind(out,
                     bb_source(
                         name = "Artist AMSR2 near-real-time 3.125km sea ice concentration",
                         id = "AMSR2_ASI_s3125",
                         description = "Near-real-time passive microwave estimates of daily sea ice concentration at 3.125km spatial resolution (full Antarctic coverage).",
                         doc_url = "https://seaice.uni-bremen.de/sea-ice-concentration/",
                         citation = "Spreen, G., L. Kaleschke, and G. Heygster (2008), Sea ice remote sensing using AMSR-E 89 GHz channels, J. Geophys. Res. 113, C02S03, doi:10.1029/2005JC003384",
                         source_url = "https://seaice.uni-bremen.de/data/amsr2/asi_daygrid_swath/s3125/",
                         license = "Please cite",
                         method = list("bb_handler_rget", level = 5, accept_download = "Antarctic3125/asi.*\\.(hdf|png|tif)", reject_follow = "(Amundsen|Antarctic3125NoLandMask|AntarcticPeninsula|Casey-Dumont|DavisSea|McMurdo|Neumayer|NeumayerEast|Polarstern|RossSea|ScotiaSea|WeddellSea|WestDavisSea)/"), ## ignore the regional sub-directories
                         postprocess = NULL,
                         access_function = "raadtools::readice",
                         collection_size = 100,
                         data_group = "Sea ice"))
    }

    if (is.null(name) || any(name %in% tolower(c("Artist AMSR2 supporting files", "AMSR2_ASI_grids")))) {
        out <- rbind(out,
                     bb_source(
                         name = "Artist AMSR2 supporting files",
                         id = "AMSR2_ASI_grids",
                         description = "Grids and landmasks for Artist AMSR2 passive microwave sea ice data.",
                         doc_url = "https://seaice.uni-bremen.de/sea-ice-concentration/",
                         citation = "See the citation details of the particular sea ice dataset used",
                         source_url = c("https://seaice.uni-bremen.de/data/grid_coordinates/","https://seaice.uni-bremen.de/data/amsre/landmasks/"),
                         license = "Please cite",
                         method = list("bb_handler_rget", level = 2),
                         postprocess = NULL,
                         collection_size = 0.02,
                         data_group = "Sea ice"))
    }

    if (is.null(name) || any(name %in% tolower(c("CERSAT SSM/I sea ice concentration", "CERSAT_SSMI")))) {
        out <- rbind(out,
                     bb_source(
                         name = "CERSAT SSM/I sea ice concentration",
                         id = "CERSAT_SSMI",
                         description = "Passive microwave sea ice concentration data at 12.5km resolution, 3-Dec-1991 to present",
                         doc_url = "http://cersat.ifremer.fr/data/tools-and-services/quicklooks/sea-ice/ssm-i-sea-ice-concentration-maps",
                         citation = "",
                         ##source_url = "ftp://ftp.ifremer.fr/ifremer/cersat/products/gridded/psi-concentration/data/antarctic/daily/netcdf/*",
                         source_url = "ftp://ftp.ifremer.fr/ifremer/cersat/products/gridded/psi-concentration/data/antarctic/daily/netcdf/",
                         license = "Unknown",
                         method = list("bb_handler_rget", level = 3),
                         postprocess = list("bb_inflate"),
                         access_function = "raadtools::readice",
                         collection_size = 2.5,
                         data_group = "Sea ice"))
    }

    if (is.null(name) || any(name %in% tolower(c("CERSAT SSM/I sea ice concentration supporting files", "CERSAT_SSMI_grids")))) {
        out <- rbind(out,
                     bb_source(
                         name = "CERSAT SSM/I sea ice concentration supporting files",
                         id = "CERSAT_SSMI_grids",
                         description = "Grids for the CERSAT SSM/I sea ice concentration data.",
                         doc_url = "http://cersat.ifremer.fr/data/tools-and-services/quicklooks/sea-ice/ssm-i-sea-ice-concentration-maps",
                         citation = "",
                         ##source_url = "ftp://ftp.ifremer.fr/ifremer/cersat/products/gridded/psi-concentration/data/*",
                         source_url = "ftp://ftp.ifremer.fr/ifremer/cersat/products/gridded/psi-concentration/data/",
                         license = "Unknown",
                         method = list("bb_handler_rget", level = 1),
                         postprocess = list("bb_gunzip"),
                         collection_size = 0.01,
                         data_group = "Sea ice"))
    }

    if (is.null(name) || any(name %in% tolower(c("MODIS Composite Based Maps of East Antarctic Fast Ice Coverage", "10.4225/15/5667AC726B224")))) {
        this <- bb_aadc_source("modis_20day_fast_ice", data_group = "Sea ice")
        this$name <- "MODIS Composite Based Maps of East Antarctic Fast Ice Coverage" ## backwards compat
        this$method[[1]]$accept_download_extra <- "(img|png)$"
        out <- rbind(out, this)
    }

    if (is.null(name) || any(name %in% tolower(c("Circum-Antarctic landfast sea ice extent", "10.26179/5d267d1ceb60c")))) {
        this <- bb_aadc_source("AAS_4116_Fraser_fastice_circumantarctic", data_group = "Sea ice")
        this$name <- "Circum-Antarctic landfast sea ice extent, 2000-2018 - version 2.2" ## backwards compat
        out <- rbind(out, this)
    }

    if (is.null(name) || any(name %in% tolower(c("Sea ice lead climatologies", "10.1594/PANGAEA.917588")))) {
        out <- rbind(out,
                     bb_source(
                         name = "Sea ice lead climatologies",
                         id = "10.1594/PANGAEA.917588",
                         description = "Long-term relative sea ice lead frequencies for the Arctic (November - April 2002/03 - 2018/19) and Antarctic (April - September 2003 - 2019). Ice surface temperature data (MYD/MOD29 col. 6) from the Moderate-Resolution Imaging Spectroradiometer are used to derive daily observations of sea ice leads in both polar regions. Sea ice leads are defined as significant local surface temperature anomalies and they are automatically identified during a two-stage process, including 1) the tile-based retrieval of potential sea ice leads and 2) the identification of cloud artefacts using fuzzy logic (see Reiser et al., 2020 for further details). Subsequently, all daily sea ice lead maps are combined to long-term averages showing the climatological distribution of leads in the Arctic and Antarctic. The dataset represents an update for the Arctic (Willmes & Heinemann, 2016) and is the first for the Antarctic. These maps reveal that multiple distinct features with increased lead frequencies are present that are related to bathymetric structures, e.g. the continental shelf break or ridges and troughs.",
                         doc_url = "https://doi.pangaea.de/10.1594/PANGAEA.917588",
                         citation = "Reiser F, Willmes S, Heinemann G (2020) Daily sea ice lead data for Arctic and Antarctic. PANGAEA, https://doi.org/10.1594/PANGAEA.917588",
                         source_url = "https://doi.pangaea.de/10.1594/PANGAEA.917588?format=html#download",
                         license = "CC-BY-4.0",
                         method = list("bb_handler_rget", level = 1, accept_download = "\\.nc$"),
                         collection_size = 0.25,
                         data_group = "Sea ice"))
    }

    if (is.null(name) || any(name %in% tolower(c("National Ice Center Antarctic daily sea ice charts", "NIC_daily_charts_antarctic")))) {
        warning("The data download for the NIC sea ice charts does not currently seem to be returning valid Last-Modified times, which means that we can't skip unchanged files. Even if you set clobber=1 (only download if the remote file is newer than the local copy), it may download every single file anyway. You might wish to use clobber=0 (do not overwrite existing files)")
        myformats <- formats
        if (!is.null(myformats)) {
            chk <- myformats %in% c("filled", "vector") && length(myformats) == 1
            if (!isTRUE(chk)) stop("formats must be one of 'filled' or 'vector'")
        } else {
            myformats <- "filled"
        }
        years <- ss_args$years
        if (!is.null(years)) {
            assert_that(is.numeric(years), noNA(years))
        }
        out <- rbind(out,
                     bb_source(
                         name = "National Ice Center Antarctic daily sea ice charts",
                         id = "NIC_daily_charts_antarctic",
                         description = "The USNIC Daily Ice Edge product depicts the daily sea ice pack in red (8-10/10ths or greater of sea ice), and the Marginal Ice Zone (MIZ) in yellow. The marginal ice zone is the transition between the open ocean (ice free) and pack ice. The MIZ is very dynamic and affects the air-ocean heat transport, as well as being a significant factor in navigational safety. The daily ice edge is analyzed by sea ice experts using multiple sources of near real time satellite data, derived satellite products, buoy data, weather, and analyst interpretation of current sea ice conditions. The product is a current depiction of the location of the ice edge vice a satellite derived ice edge product.",
                         doc_url = "https://usicecenter.gov/Products/AntarcHome",
                         citation = "Not known",
                         source_url = "https://usicecenter.gov/File/",
                         license = "Not known",
                         method = list("bb_handler_usnic", chart_type = myformats, years = years),
                         data_group = "Sea ice"))
    }

    if (is.null(name) || any(name %in% tolower(c("Polarview Sentinel-1 imagery", "polarview:vw_last200s1subsets")))) {
        myformats <- formats
        if (!is.null(myformats)) {
            chk <- !myformats %in% c("geotiff", "jpg")
            if (any(chk)) stop("only 'geotiff' or 'jpg' formats are supported for the 'Polarview Sentinel-1 imagery' source")
        } else {
            ## default to both jpg and geotiff
            myformats <- c("jpg", "geotiff")
        }

        out <- rbind(out, bb_source("Polarview Sentinel-1 imagery",
                                    id = "polarview:vw_last200s1subsets",
                                    description = "Sentinel-1 imagery from polarview.aq",
                                    doc_url = "https://www.polarview.aq/",
                                    citation = "See https://www.polarview.aq/",
                                    license = "Please cite",
                                    method = list("bb_handler_polarview", acquisition_date = ss_args$acquisition_date, formats = myformats, polygon = ss_args$polygon),
                                    comment = "Collection size unknown",
                                    data_group = "Sea ice"))
    }

    if (is.null(name) || any(name %in% tolower(c("ATLAS/ICESat-2 L3B Daily and Monthly Gridded Sea Ice Freeboard, Version 4", "10.5067/ATLAS/ATL20.004", "ATL20")))) {
        out <- rbind(out,
                     bb_source(
                         name = "ATLAS/ICESat-2 L3B Daily and Monthly Gridded Sea Ice Freeboard, Version 4",
                         id = "10.5067/ATLAS/ATL20.004",
                         description = "ATL20 contains daily and monthly gridded estimates of sea ice freeboard, derived from along-track freeboard estimates in the ATLAS/ICESat-2 L3A Sea Ice Freeboard product (ATL10). Data are gridded at 25 km using the SSM/I Polar Stereographic Projection.",
                         doc_url = "https://nsidc.org/data/atl20/versions/4",
                         citation = "Petty AA, Kwok R, Bagnardi M, Ivanoff A, Kurtz N, Lee J, Wimert J, Hancock D (2023) ATLAS/ICESat-2 L3B Daily and Monthly Gridded Sea Ice Freeboard, Version 4 [Data Set]. Boulder, Colorado USA. NASA National Snow and Ice Data Center Distributed Active Archive Center. https://doi.org/10.5067/ATLAS/ATL20.004",
                         source_url = "https://n5eil01u.ecs.nsidc.org/ATLAS/ATL20.004/",
                         license = "As a condition of using these data, you must cite the use of this data set",
                         authentication_note = "Requires Earthdata login, see https://urs.earthdata.nasa.gov/. Note that you will also need to authorize the application 'NSIDC_DATAPOOL_OPS' (see 'My Applications' at https://urs.earthdata.nasa.gov/profile)",
                         method = list("bb_handler_earthdata", level = 2, relative = TRUE, allow_unrestricted_auth = TRUE, accept_download_extra = "ATL20\\-02.*\\.h5$"),
                         comment = "Only southern hemisphere files will be downloaded (\"ATL20-02*.h5\" files). For northern hemisphere, adjust the accept_download_extra to include \"ATL20-01*.h5\" files",
                         user = "",
                         password = "",
                         postprocess = NULL,
                         collection_size = 0.2,
                         data_group = "Sea ice", warn_empty_auth = FALSE))
    }

    if (is.null(name) || any(name %in% tolower(c("NOAA/NSIDC Climate Data Record of Passive Microwave Sea Ice Concentration, Version 4", "G02202", "10.7265/efmz-2t65")))) {
        out <- rbind(out,
                     bb_source(
                         name = "NOAA/NSIDC Climate Data Record of Passive Microwave Sea Ice Concentration, Version 4",
                         id = "10.7265/efmz-2t65",
                         description = "This data set provides a Climate Data Record (CDR) of sea ice concentration from passive microwave data. The CDR algorithm output is a rule-based combination of ice concentration estimates from two well-established algorithms: the NASA Team (NT) algorithm (Cavalieri et al. 1984) and NASA Bootstrap (BT) algorithm (Comiso 1986). The CDR is a consistent, daily and monthly time series of sea ice concentrations from 25 October 1978 through the most recent processing for both the north and south polar regions. All data are on a 25 km x 25 km grid.",
                         doc_url = "https://nsidc.org/data/g02202/versions/4",
                         citation = "Meier WN, Fetterer F, Windnagel AK, Stewart JS (2021) NOAA/NSIDC Climate Data Record of Passive Microwave Sea Ice Concentration, Version 4 [Data Set]. Boulder, Colorado USA. National Snow and Ice Data Center. 10.7265/efmz-2t65",
                         source_url = c("https://noaadata.apps.nsidc.org/NOAA/G02202_V4/south/daily/", "https://noaadata.apps.nsidc.org/NOAA/G02202_V4/south/monthly/"),
                         license = "As a condition of using these data, you must cite the use of this data set",
                         method = list("bb_handler_rget", level = 2),
                         comment = "Only southern hemisphere files will be downloaded. For northern hemisphere, adjust the source_urls",
                         collection_size = 5,
                         data_group = "Sea ice"))
    }

    if (is.null(name) || any(name %in% tolower(c("Near-Real-Time NOAA/NSIDC Climate Data Record of Passive Microwave Sea Ice Concentration, Version 2", "G10016", "10.7265/tgam-yv28")))) {
        out <- rbind(out,
                     bb_source(
                         name = "Near-Real-Time NOAA/NSIDC Climate Data Record of Passive Microwave Sea Ice Concentration, Version 2",
                         id = "10.7265/tgam-yv28",
                         description = "This data set provides a near-real-time Climate Data Record (CDR) of sea ice concentration from passive microwave data. The Near-real-time NOAA/NSIDC Climate Data Record of Passive Microwave Sea Ice Concentration (NRT CDR) data set is the near-real-time version of the final NOAA/NSIDC Climate Data Record of Passive Microwave Sea Ice Concentration (G02202). The NRT CDR is designed to fill the temporal gap between updates of the final CDR, occurring every three to six months, and to provide the most recent data.",
                         doc_url = "https://nsidc.org/data/g10016/versions/2",
                         citation = "Meier WN, Fetterer F, Windnagel AK, Stewart JS (2021) Near-Real-Time NOAA/NSIDC Climate Data Record of Passive Microwave Sea Ice Concentration, Version 2 [Data Set]. Boulder, Colorado USA. National Snow and Ice Data Center. 10.7265/tgam-yv28",
                         source_url = c("https://noaadata.apps.nsidc.org/NOAA/G10016_V2/south/daily/", "https://noaadata.apps.nsidc.org/NOAA/G10016_V2/south/monthly/"),
                         license = "As a condition of using these data, you must cite the use of this data set",
                         method = list("bb_handler_rget", level = 2),
                         comment = "Only southern hemisphere files will be downloaded. For northern hemisphere, adjust the source_urls",
                         collection_size = 0.1,
                         data_group = "Sea ice"))
    }

    if (is.null(name) || any(name %in% tolower(c("OSI SAF Global Low Resolution Sea Ice Drift", "10.15770/EUM_SAF_OSI_NRT_2007")))) {
        out <- rbind(out,
                     bb_source(name = "OSI SAF Global Low Resolution Sea Ice Drift",
                               id = "10.15770/EUM_SAF_OSI_NRT_2007",
                               description = "Ice motion vectors with a time span of 48 hours are estimated by an advanced cross-correlation method (the Continuous MCC, CMCC) on pairs of satellite images. The merged (multi-sensor) dataset is provided here.",
                               doc_url = "https://osi-saf.eumetsat.int/products/osi-405-c",
                               source_url = "https://thredds.met.no/thredds/catalog/osisaf/met.no/ice/drift_lr/merged/catalog.html",
                               citation = "OSI SAF Global Low Resolution Sea Ice Drift, OSI-405-c, doi: 10.15770/EUM_SAF_OSI_NRT_2007. EUMETSAT Ocean and Sea Ice Satellite Application Facility",
                               license = "Please cite",
                               method = list("bb_handler_rget", no_parent_download = FALSE, level = 4, accept_download = ".*fileServer.*_sh_.*\\.nc$", accept_follow = "catalog\\.html", reject_follow = "_nh_"),
                               comment = "Only southern hemisphere files will be downloaded. For northern hemisphere, adjust the `accept_download` parameter",
                               collection_size = 4,
                               data_group = "Sea ice"))
    }

    out
}
