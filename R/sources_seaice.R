#' Sea ice data sources
#'
#' Data sources providing (primarily satellite-derived) sea ice data:
#' \itemize{
#'   \item "NSIDC SMMR-SSM/I Nasateam sea ice concentration": Passive microwave estimates of sea ice concentration at 25km spatial resolution. Daily and monthly resolution, available from 1-Oct-1978 to near-present. Data undergo a quality checking process and are updated annually. More recent data are available via the 'NSIDC SMMR-SSM/I Nasateam near-real-time sea ice concentration' source. Accepts \code{hemisphere} values of "south", "north", "both". Accepts \code{time_resolution} values of "day" or "month". Accepts \code{years} parameter as a vector of years.
#'   \item "NSIDC SMMR-SSM/I Nasateam near-real-time sea ice concentration": Near-real-time passive microwave estimates of sea ice concentration at 25km, daily resolution. For older, quality-controlled data see the 'NSIDC SMMR-SSM/I Nasateam sea ice concentration' source
#'   \item "NSIDC passive microwave supporting files": Grids and other support files for NSIDC passive microwave sea ice data
#'   \item "Nimbus Ice Edge Points from Nimbus Visible Imagery": This data set (NmIcEdg2) estimates the location of the North and South Pole sea ice edges at various times during the mid to late 1960s, based on recovered Nimbus 1 (1964), Nimbus 2 (1966), and Nimbus 3 (1969) visible imagery
#'   \item "Artist AMSR-E sea ice concentration": Passive microwave estimates of daily sea ice concentration at 6.25km spatial resolution, from 19-Jun-2002 to 2-Oct-2011. Accepts formats "geotiff" and/or "hdf"
#'   \item "Artist AMSR-E supporting files": Grids and other support files for Artist AMSR-E passive microwave sea ice data
#'   \item "Artist AMSR2 near-real-time sea ice concentration": Near-real-time passive microwave estimates of daily sea ice concentration at 6.25km spatial resolution, from 24-July-2012 to present
#'   \item "Artist AMSR2 near-real-time 3.125km sea ice concentration": Near-real-time passive microwave estimates of daily sea ice concentration at 3.125km spatial resolution, from 24-July-2012 to present
#'   \item "Artist AMSR2 supporting files": Grids and landmasks for Artist AMSR2 passive microwave sea ice data
#'   \item "CERSAT SSM/I sea ice concentration": Passive microwave sea ice concentration data at 12.5km resolution, 3-Dec-1991 to present
#'   \item "CERSAT SSM/I sea ice concentration supporting files": Grids for the CERSAT SSM/I sea ice concentration data
#'   \item "MODIS Composite Based Maps of East Antarctic Fast Ice Coverage": Maps of East Antarctic landfast sea-ice extent, generated from approx. 250,000 1 km visible/thermal infrared cloud-free MODIS composite imagery (augmented with AMSR-E 6.25-km sea-ice concentration composite imagery when required). Coverage from 2000-03-01 to 2008-12-31
#'   \item "National Ice Center Antarctic daily sea ice charts": The USNIC Daily Ice Edge product depicts the daily sea ice pack in red (8-10/10ths or greater of sea ice), and the Marginal Ice Zone (MIZ) in yellow. The marginal ice zone is the transition between the open ocean (ice free) and pack ice. The MIZ is very dynamic and affects the air-ocean heat transport, as well as being a significant factor in navigational safety. The daily ice edge is analyzed by sea ice experts using multiple sources of near real time satellite data, derived satellite products, buoy data, weather, and analyst interpretation of current sea ice conditions. The product is a current depiction of the location of the ice edge vice a satellite derived ice edge product. Accepts a \code{formats} paramater of (one of) "filled" or "vector"
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
#' @seealso \code{\link{sources_altimetry}}, \code{\link{sources_biological}}, \code{\link{sources_meteorological}}, \code{\link{sources_ocean_colour}}, \code{\link{sources_oceanographic}}, \code{\link{sources_reanalysis}}, \code{\link{sources_sdm}}, \code{\link{sources_sst}}, \code{\link{sources_topography}}
#'
#' @return a tibble with columns as specified by \code{\link{bb_source}}
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
    out <- tibble()
    if (is.null(name) || any(name %in% tolower(c("NSIDC SMMR-SSM/I Nasateam sea ice concentration", "10.5067/8GQ8LZQVL0VL")))) {
        warning("The data download for the 'NSIDC SMMR-SSM/I Nasateam sea ice concentration' does not currently seem to be returning valid Last-Modified times, which means that we can't skip unchanged files. Even if you set clobber=1 (only download if the remote file is newer than the local copy), it may download every single file anyway. You might wish to use clobber=0 (do not overwrite existing files)")
        if (!is.null(time_resolutions)) {
            chk <- !time_resolutions %in% c("day","month")
            if (any(chk)) stop("unrecognized time_resolutions value for the 'NSIDC SMMR-SSM/I Nasateam sea ice concentration' source, expecting 'day' and/or 'month'")
        } else {
            ## default to both
            time_resolutions <- c("day", "month")
        }
        ## source-specific parms
        hemisphere <- ss_args$hemisphere
        if (is.null(hemisphere)) hemisphere <- "both"
        if (!is.null(hemisphere)) {
            assert_that(is.character(hemisphere))
            hemisphere <- match.arg(tolower(hemisphere), c("south", "north", "both"))
        }
        years <- ss_args$years
        if (!is.null(years)) {
            assert_that(is.numeric(years), noNA(years))
        }
        ## given hemisphere, time_resolutions, and years, construct appropriate source def
        ## URLs will be of the form
        ## https://n5eil01u.ecs.nsidc.org/PM/NSIDC-0051.001/YYYY.MM.DD/nt_19860113_n07_v1.1_[s|n].bin (for daily)
        ## https://n5eil01u.ecs.nsidc.org/PM/NSIDC-0051.001/YYYY.MM.DD/nt_198601_n07_v1.1_[s|n].bin (for monthly)
        reject_download <- "\\.png$" ## reject these always
        h <- switch(hemisphere, south = "s", north = "n", both = "[sn]")
        monthly_accept_follow <- if (!"day" %in% time_resolutions) "\\.01/" else character() ## only the first of the month for monthly
        yre <- if (!is.null(years)) paste0("/(", paste(years, collapse = "|"), ")\\.") else character()
        accept_follow <- paste0(yre, ".+", monthly_accept_follow)
        accept_download <- paste0(h, "\\.bin$")
        if (!"day" %in% time_resolutions) {
            ## monthly files only have YYYYMM, no DD
            accept_download <- paste0("_[[:digit:]]{6}_.+", accept_download)
        }
        out <- rbind(out,
                     bb_source(
                         name = "NSIDC SMMR-SSM/I Nasateam sea ice concentration",
                         id = "10.5067/8GQ8LZQVL0VL", ##nsidc0051
                         description = "Passive microwave estimates of sea ice concentration at 25km spatial resolution. Daily and monthly resolution, available from 1-Oct-1978 to present. Data undergo a quality checking process and are updated annually. More recent data if required are available via the \"NSIDC SMMR-SSM/I Nasateam near-real-time sea ice concentration\" source.",
                         doc_url = "http://nsidc.org/data/nsidc-0051.html",
                         source_url = "https://n5eil01u.ecs.nsidc.org/PM/NSIDC-0051.001/",
                         citation = "Cavalieri, D. J., C. L. Parkinson, P. Gloersen, and H. Zwally. 1996, updated yearly. Sea Ice Concentrations from Nimbus-7 SMMR and DMSP SSM/I-SSMIS Passive Microwave Data. [indicate subset used]. Boulder, Colorado USA: NASA National Snow and Ice Data Center Distributed Active Archive Center. http://dx.doi.org/10.5067/8GQ8LZQVL0VL",
                         license = "Please cite, see http://nsidc.org/about/use_copyright.html",
                         authentication_note = "Requires Earthdata login, see https://urs.earthdata.nasa.gov/. Note that you will also need to authorize the application 'NSIDC_DATAPOOL_OPS' (see 'My Applications' at https://urs.earthdata.nasa.gov/profile)",
                         method = list("bb_handler_earthdata", relative = TRUE, accept_follow = accept_follow, accept_download = accept_download, reject_download = reject_download, level = 2),
                         user = "",
                         password = "",
                         postprocess = NULL,
                         access_function = "raadtools::readice",
                         collection_size = 10,
                         data_group = "Sea ice", warn_empty_auth = FALSE))
    }

    if (is.null(name) || any(name %in% tolower(c("NSIDC SMMR-SSM/I Nasateam near-real-time sea ice concentration", "10.5067/U8C09DWVX9LM")))) {
        out <- rbind(out,
                     bb_source(
                         name = "NSIDC SMMR-SSM/I Nasateam near-real-time sea ice concentration",
                         id = "10.5067/U8C09DWVX9LM", ##nsidc0081
                         description = "Near-real-time passive microwave estimates of sea ice concentration at 25km, daily resolution. For older, quality-controlled data see the \"NSIDC SMMR-SSM/I Nasateam sea ice concentration\" source",
                         doc_url = "http://nsidc.org/data/nsidc-0081.html",
                         citation = "Maslanik, J. and J. Stroeve. 1999, updated daily. Near-Real-Time DMSP SSMIS Daily Polar Gridded Sea Ice Concentrations. [indicate subset used]. Boulder, Colorado USA: NASA National Snow and Ice Data Center Distributed Active Archive Center. http://dx.doi.org/10.5067/U8C09DWVX9LM",
                         source_url = "ftp://sidads.colorado.edu/pub/DATASETS/nsidc0081_nrt_nasateam_seaice/",
                         comment = "This data source may migrate to https access in the future, requiring an Earthdata login",
                         license = "Please cite, see http://nsidc.org/about/use_copyright.html",
                         method = list("bb_handler_rget", reject_follow = "/browse", level = 3),
                         postprocess = NULL,
                         access_function = "raadtools::readice",
                         collection_size = 0.6,
                         data_group = "Sea ice"))
    }

    if (is.null(name) || any(name %in% tolower(c("NSIDC passive microwave supporting files", "nsidc_seaice_grids")))) {
        out <- rbind(out,
                     bb_source(
                         name = "NSIDC passive microwave supporting files",
                         id = "nsidc_seaice_grids",
                         description = "Grids and other support files for NSIDC passive microwave sea ice data.",
                         doc_url = "http://nsidc.org/data/nsidc-0051.html",
                         citation = "See the citation details of the particular sea ice dataset used",
                         source_url = "ftp://sidads.colorado.edu/pub/DATASETS/seaice/polar-stereo/tools/",
                         license = "Please cite, see http://nsidc.org/about/use_copyright.html",
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
                         citation = "Gallaher, D. and G. Campbell. 2014. Nimbus Ice Edge Points from Nimbus Visible Imagery L2, CSV. [indicate subset used]. Boulder, Colorado USA: NASA National Snow and Ice Data Center Distributed Active Archive Center. http://dx.doi.org/10.5067/NIMBUS/NmIcEdg2",
                         source_url = "https://n5eil01u.ecs.nsidc.org/NIMBUS/NmIcEdg2.001/",
                         license = "Please cite, see http://nsidc.org/about/use_copyright.html",
                         authentication_note = "Requires Earthdata login, see https://urs.earthdata.nasa.gov/. Note that you will also need to authorize the application 'NSIDC_DATAPOOL_OPS' (see 'My Applications' at https://urs.earthdata.nasa.gov/profile)",
                         method = list("bb_handler_earthdata", level = 2, relative = TRUE),##,"--accept-regex=/NmIcEdg2.001/"), ##--recursive --no-parent
                         user = "",
                         password = "",
                         postprocess = NULL,
                         collection_size = 0.1,
                         data_group = "Sea ice", warn_empty_auth = FALSE))
    }

    if (is.null(name) || any(name %in% tolower(c("Artist AMSR-E sea ice concentration", "AMSR-E_ASI_s6250")))) {
        myformats <- formats
        if (!is.null(myformats)) {
            chk <- !myformats %in% c("geotiff", "hdf")
            if (any(chk)) stop("only 'geotiff' or 'hdf' formats are supported for the 'Artist AMSR-E sea ice concentration' source")
        } else {
            ## default to both hdf and geotiff
            myformats <- c("hdf", "geotiff")
        }
        src_url <- character()
        if ("geotiff" %in% myformats) src_url <- c(src_url, "ftp://ftp-projects.cen.uni-hamburg.de/seaice/AMSR-E_ASI_IceConc/no_landmask/geotiff/s6250/")
        if ("hdf" %in% myformats) src_url <- c(src_url, "ftp://ftp-projects.cen.uni-hamburg.de/seaice/AMSR-E_ASI_IceConc/no_landmask/hdf/s6250/")
        if (length(src_url)<1) {
            ## this should never happen, but something has gone wrong
            stop("error with 'Artist AMSR-E sea ice concentration' source - please notify the maintainers")
        }
        out <- rbind(out,
                     bb_source(
                         name = "Artist AMSR-E sea ice concentration",
                         id = "AMSR-E_ASI_s6250",
                         description = "Passive microwave estimates of daily sea ice concentration at 6.25km spatial resolution, from 19-Jun-2002 to 2-Oct-2011.",
                         doc_url = "https://icdc.cen.uni-hamburg.de/1/daten/cryosphere/seaiceconcentration-asi-amsre.html",
                         citation = "Include the acknowledgement: \"ASI Algorithm AMSR-E sea ice concentration were obtained for [PERIOD] from the Integrated Climate Date Center (ICDC, http://icdc.zmaw,de/), University of Hamburg, Hamburg, Germany.\" Also please cite: Spreen, G., L. Kaleschke, and G. Heygster (2008), Sea ice remote sensing using AMSR-E 89 GHz channels, J. Geophys. Res. 113, C02S03, doi:10.1029/2005JC003384",
                         source_url = src_url,
                         license = "Please cite",
                         ##method = list("bb_handler_wget",level=4), ##--recursive --follow-ftp
                         method = list("bb_handler_rget", level = 4),
                         postprocess = list("bb_gunzip"), ## nb only needed for hdfs
                         access_function = "raadtools::readice",
                         collection_size = 25,
                         data_group = "Sea ice"))
    }

    if (is.null(name) || any(name %in% tolower(c("Artist AMSR-E supporting files", "AMSR-E_ASI_grids")))) {
        out <- rbind(out,
                     bb_source(
                         name = "Artist AMSR-E supporting files",
                         id = "AMSR-E_ASI_grids",
                         description = "Grids and other support files for Artist AMSR-E passive microwave sea ice data.",
                         doc_url = "http://icdc.zmaw.de/1/daten/cryosphere/seaiceconcentration-asi-amsre.html",
                         citation = "See the citation details of the particular sea ice dataset used",
                         source_url = c("ftp://ftp-projects.cen.uni-hamburg.de/seaice/AMSR-E_ASI_IceConc/Landmasks/", "ftp://ftp-projects.cen.uni-hamburg.de/seaice/AMSR-E_ASI_IceConc/LonLatGrids/"),
                         license = "Please cite",
                         ##method = list("bb_handler_wget",level=2), ## --recursive --follow-ftp
                         method = list("bb_handler_rget", level = 2),
                         postprocess = NULL,
                         access_function = "raadtools::readice",
                         collection_size = 0.01,
                         data_group = "Sea ice"))
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
                         ##method = list("bb_handler_wget",level=5,accept=c("asi*.hdf","asi*.png","asi*.tif"),robots_off=TRUE), ##--recursive --no-parent
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
                         method = list("bb_handler_rget", level = 5, accept_download = "Antarctic3125/asi.*\\.(hdf|png|tif)"),
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
                         ##method = list("bb_handler_wget",level=2,accept="hdf",robots_off=TRUE), ## --recursive --no-parent
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
                         ##method = list("bb_handler_wget",level=3), ## --recursive --no-parent
                         method = list("bb_handler_rget", level = 3),
                         postprocess = list("bb_uncompress"),
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
                         ##method = list("bb_handler_wget"), ##--recursive --level=1 --no-parent
                         method = list("bb_handler_rget", level = 1),
                         postprocess = list("bb_gunzip"),
                         collection_size = 0.01,
                         data_group = "Sea ice"))
    }

    if (is.null(name) || any(name %in% tolower(c("MODIS Composite Based Maps of East Antarctic Fast Ice Coverage", "10.4225/15/5667AC726B224")))) {
        out <- rbind(out,
                     bb_aadc_s3_source_gen(metadata_id = "modis_20day_fast_ice",
                         name = "MODIS Composite Based Maps of East Antarctic Fast Ice Coverage",
                         doi = "10.4225/15/5667AC726B224",
                         description = "Maps of East Antarctic landfast sea-ice extent, generated from approx. 250,000 1 km visible/thermal infrared cloud-free MODIS composite imagery (augmented with AMSR-E 6.25-km sea-ice concentration composite imagery when required). Coverage from 2000-03-01 to 2008-12-31",
                         citation = "Fraser, AD, RA Massom, KJ Michael, BK Galton-Fenzi, and JL Lieser (2012) East Antarctic landfast sea ice distribution and variability, 2000-08. Journal of Climate, 25(4):1137-1156",
                         method_args = list(accept_download_extra = "(img|png)$"),
                         collection_size = 0.4,
                         data_group = "Sea ice"))
    }

    if (is.null(name) || any(name %in% tolower(c("National Ice Center Antarctic daily sea ice charts", "NIC_daily_charts_antarctic")))) {
        myformats <- formats
        if (!is.null(myformats)) {
            chk <- myformats %in% c("filled", "vector") && length(myformats) == 1
            if (!isTRUE(chk)) stop("formats must be one of 'filled' or 'vector'")
        } else {
            myformats <- "filled"
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
                         method = list("bb_handler_usnic", chart_type = myformats),
                         data_group = "Sea ice"))
    }
    out
}
