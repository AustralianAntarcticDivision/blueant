#' Sea surface temperature data sources
#'
#' Data sources providing SST data.
#'
#' \itemize{
#'   \item "NOAA OI 1/4 Degree Daily SST AVHRR": Sea surface temperature at 0.25 degree daily resolution, from 1-Sep-1981 to present (this is v2.1 of the daily OI SST product)
#'   \item "NOAA OI 1/4 Degree Daily SST AVHRR v2": Superseded by v2.1, above. Sea surface temperature at 0.25 degree daily resolution, from 1-Sep-1981 to Apr-2020
#'   \item "NOAA OI SST V2 High Resolution": Weekly and monthly mean and long-term monthly mean SST data from Optimum Interpolation Sea Surface Temperature (OISST), 0.25-degree resolution, 1981 to present. Ice concentration data are also included, which are the ice concentration values input to the SST analysis
#'   \item "NOAA OI SST V2": Superseded by NOAA OI SST V2 High Resolution, above. Weekly and monthly mean and long-term monthly mean SST data, 1-degree resolution, 1981 to present. Ice concentration data are also included, which are the ice concentration values input to the SST analysis
#'   \item "NOAA Extended Reconstructed SST V3b": A global monthly SST analysis from 1854 to the present derived from ICOADS data with missing data filled in by statistical methods
#'   \item "NOAA Extended Reconstructed SST V5": A global monthly sea surface temperature dataset derived from the International Comprehensive Ocean-Atmosphere Dataset
#'   \item "Oceandata MODIS Terra Level-3 mapped monthly 9km SST": Monthly remote-sensing sea surface temperature from the MODIS Terra satellite at 9km spatial resolution
#'   \item "Oceandata MODIS Aqua Level-3 mapped monthly 9km SST": Monthly remote-sensing SST from the MODIS Aqua satellite at 9km spatial resolution
#'   \item "GHRSST Level 4 MUR Global Foundation SST v4.1": A Group for High Resolution Sea Surface Temperature (GHRSST) Level 4 sea surface temperature analysis produced as a retrospective dataset (four day latency) on a global 0.011 degree grid
#'   \item "CMEMS Global Ocean OSTIA Sea Surface Temperature and Sea Ice Analysis": for the global ocean,  the OSTIA global foundation Sea Surface Temperature product provides daily gap-free maps of: Foundation Sea Surface Temperature at 0.05 degree horizontal grid resolution, using in-situ and satellite data from both infrared and microwave radiometers
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
#' @seealso \code{\link{sources_altimetry}}, \code{\link{sources_biological}}, \code{\link{sources_meteorological}}, \code{\link{sources_ocean_colour}}, \code{\link{sources_oceanographic}}, \code{\link{sources_reanalysis}}, \code{\link{sources_sdm}}, \code{\link{sources_seaice}}, \code{\link{sources_topography}}
#'
#' @return a tibble with columns as specified by \code{\link{bb_source}}
#'
#' @examples
#' \dontrun{
#' ## define a configuration and add the OIv2 SST data to it
#' cf <- bb_config("/my/file/root")
#' src <- sources_sst("NOAA OI SST V2")
#' cf <- bb_add(cf,src)
#' }
#'
#' @export
sources_sst <- function(name,formats,time_resolutions, ...) {
    if (!missing(name) && !is.null(name)) {
        assert_that(is.character(name))
        name <- tolower(name)
    } else {
        name <- NULL
    }
    out <- tibble()

    if (is.null(name) || any(name %in% tolower(c("NOAA OI 1/4 Degree Daily SST AVHRR","10.7289/V5SQ8XB5")))) {
        ## notes: files initially appear as e.g. "oisst-avhrr-v02r01.20230127_preliminary.nc" but then are replaced by e.g. "oisst-avhrr-v02r01.20230127.nc"
        ## TODO clean up unneeded preliminary files in postprocess function?
        out <- rbind(out,
                     bb_source(
                         name = "NOAA OI 1/4 Degree Daily SST AVHRR",
                         id = "10.7289/V5SQ8XB5",
                         description = "Sea surface temperature at 0.25 degree daily resolution, from 1-Sep-1981 to present",
                         doc_url = "https://www.ncei.noaa.gov/metadata/geoportal/rest/metadata/item/gov.noaa.ncdc:C00844/html",
                         citation = "Richard W. Reynolds, Viva F. Banzon, and NOAA CDR Program (2008): NOAA Optimum Interpolation 1/4 Degree Daily Sea Surface Temperature (OISST) Analysis, Version 2.1. [indicate subset used]. NOAA National Climatic Data Center. doi:10.7289/V5SQ8XB5 [access date]",
                         source_url = "https://www.ncei.noaa.gov/data/sea-surface-temperature-optimum-interpolation/v2.1/access/avhrr/",
                         license = "Please cite",
                         method = list("bb_handler_rget", level = 2),
                         postprocess = NULL,
                         access_function = "raadtools::readsst",
                         collection_size = 25,
                         data_group = "Sea surface temperature"))
    }
    if (is.null(name) || any(name %in% tolower(c("NOAA OI 1/4 Degree Daily SST AVHRR v2","10.7289/V5SQ8XB5v2")))) {
        out <- rbind(out,
                     bb_source(
                         name = "NOAA OI 1/4 Degree Daily SST AVHRR v2",
                         id = "10.7289/V5SQ8XB5",
                         description = "Sea surface temperature at 0.25 degree daily resolution, from 1-Sep-1981 to Apr-2020",
                         doc_url = "https://www.ncei.noaa.gov/metadata/geoportal/rest/metadata/item/gov.noaa.ncdc:C00844/html",
                         citation = "Richard W. Reynolds, Viva F. Banzon, and NOAA CDR Program (2008): NOAA Optimum Interpolation 1/4 Degree Daily Sea Surface Temperature (OISST) Analysis, Version 2. [indicate subset used]. NOAA National Climatic Data Center. doi:10.7289/V5SQ8XB5 [access date]",
                         source_url = "https://www.ncei.noaa.gov/data/sea-surface-temperature-optimum-interpolation/v2/access/avhrr-only/",
                         license = "Please cite",
                         method = list("bb_handler_rget", level = 2),
                         postprocess = NULL,
                         access_function = "raadtools::readsst",
                         collection_size = 140,
                         data_group = "Sea surface temperature"))
    }
    if (is.null(name) || any(name %in% tolower(c("NOAA OI SST V2 High Resolution", "oisst.v2.highres")))) {
        out <- rbind(out,
                     bb_source(
                         name = "NOAA OI SST V2 High Resolution",
                         id = "oisst.v2.highres",
                         description = "Weekly and monthly mean and long-term monthly mean SST data from Optimum Interpolation Sea Surface Temperature (OISST), 0.25-degree resolution, 1981 to present. Ice concentration data are also included, which are the ice concentration values input to the SST analysis",
                         doc_url = "https://psl.noaa.gov/data/gridded/data.noaa.oisst.v2.highres.html",
                         citation = "Huang B, Liu C, Banzon V, Freeman E, Graham G, Hankins B, Smith T, Zhang H-M (2021) Improvements of the Daily Optimum Interpolation Sea Surface Temperature (DOISST) Version 2.1. Journal of Climate 34:2923-2939. doi: 10.1175/JCLI-D-20-0166.1",
                         source_url = "https://downloads.psl.noaa.gov/Datasets/noaa.oisst.v2.highres/",
                         license = "Please cite",
                         method = list("bb_handler_rget", level = 1, accept_download = "\\.(mon|week|ltm)\\..+\\.nc$|lsmask.*\\.nc$"), ## monthly, weekly, and long-term mean files only (not daily, those can be better obtained from the v2.1 OISST Daily source)
                         postprocess = NULL,
                         access_function = "raadtools::readsst",
                         collection_size = 0.9,
                         data_group = "Sea surface temperature"))
    }

    if (is.null(name) || any(name %in% tolower(c("NOAA OI SST V2", "oisst.v2")))) {
        out <- rbind(out,
                     bb_source(
                         name = "NOAA OI SST V2",
                         id = "oisst.v2",
                         description = "Weekly and monthly mean and long-term monthly mean SST data, 1-degree resolution, 1981 to present. Ice concentration data are also included, which are the ice concentration values input to the SST analysis",
                         doc_url = "http://www.esrl.noaa.gov/psd/data/gridded/data.noaa.oisst.v2.html",
                         citation = "NOAA_OI_SST_V2 data provided by the NOAA/OAR/ESRL PSD, Boulder, Colorado, USA, from their web site at http://www.esrl.noaa.gov/psd/",
                         source_url = "ftp://ftp.cdc.noaa.gov/Datasets/noaa.oisst.v2/",
                         license = "Please cite",
                         method = list("bb_handler_rget", level = 1),
                         postprocess = NULL,
                         access_function = "raadtools::readsst",
                         collection_size = 0.9,
                         comment = "Note: superseded by NOAA OI SST V2 High Resolution",
                         data_group = "Sea surface temperature"))
    }
    if (is.null(name) || any(name %in% tolower(c("NOAA Extended Reconstructed SST V3b","ersstv3")))) {
        out <- rbind(out,
                     bb_source(
                         name="NOAA Extended Reconstructed SST V3b",
                         id="ersstv3",
                         description="A global monthly SST analysis from 1854 to the present derived from ICOADS data with missing data filled in by statistical methods",
                         doc_url="http://www.esrl.noaa.gov/psd/data/gridded/data.noaa.ersst.html",
                         citation="NOAA_ERSST_V3 data provided by the NOAA/OAR/ESRL PSD, Boulder, Colorado, USA, from their web site at http://www.esrl.noaa.gov/psd/",
                         source_url="ftp://ftp.cdc.noaa.gov/Datasets/noaa.ersst/",
                         license="Please cite",
                         method=list("bb_handler_rget", level = 1),
                         postprocess=NULL,
                         collection_size=0.3,
                         data_group="Sea surface temperature"))
    }
    if (is.null(name) || any(name %in% tolower(c("NOAA Extended Reconstructed SST V5", "ersstv5", "10.7289/V5T72FNM")))) {
        out <- rbind(out,
                     bb_source(
                         name = "NOAA Extended Reconstructed SST V5",
                         id = "10.7289/V5T72FNM",
                         description = "A global monthly sea surface temperature dataset derived from the International Comprehensive Ocean-Atmosphere Dataset (ICOADS)",
                         doc_url = "https://www.ncdc.noaa.gov/data-access/marineocean-data/extended-reconstructed-sea-surface-temperature-ersst-v5",
                         citation = "Huang B, Thorne PW, Banzon VF, Boyer T, Chepurin G, Lawrimore JH, Menne MJ, Smith TM, Vose RS, Zhang H-M (2017) NOAA Extended Reconstructed Sea Surface Temperature (ERSST), Version 5. [indicate subset used]. NOAA National Centers for Environmental Information. doi:10.7289/V5T72FNM [access date].",
                         comment = "Publications using this dataset should also reference the following journal article: Huang, B., Peter W. Thorne, Viva F. Banzon, Tim Boyer, Gennady Chepurin, Jay H. Lawrimore, Matthew J. Menne, Thomas M. Smith, Russell S. Vose, and Huai-Min Zhang, 2017: Extended Reconstructed Sea Surface Temperature version 5 (ERSSTv5), Upgrades, validations, and intercomparisons. J. Climate, https://doi.org/10.1175/JCLI-D-16-0836.1. In review.",
                         source_url = "https://downloads.psl.noaa.gov/Datasets/noaa.ersst.v5/",
                         license = "Please cite",
                         method = list("bb_handler_rget", level = 1),
                         postprocess = NULL,
                         collection_size = 0.3,
                         data_group = "Sea surface temperature"))
    }
    if (is.null(name) || any(name %in% tolower(c("Oceandata MODIS Terra Level-3 mapped monthly 9km SST", "TERRA_L3m_MO_SST_sst_9km")))) {
        out <- rbind(out,
                     bb_source(
                         name = "Oceandata MODIS Terra Level-3 mapped monthly 9km SST",
                         id = "TERRA_L3m_MO_SST_sst_9km",
                         description = "Monthly remote-sensing sea surface temperature from the MODIS Terra satellite at 9km spatial resolution",
                         doc_url = "http://oceancolor.gsfc.nasa.gov/",
                         citation = "See https://oceancolor.gsfc.nasa.gov/citations",
                         license = "Please cite",
                         method = list("bb_handler_oceandata", search = "TERRA_MODIS*L3m.MO.SST.sst.9km.nc", sensor = "terra", dtype = "L3m"),
                         postprocess = NULL,
                         collection_size = 7,
                         data_group = "Sea surface temperature"))
    }
    if (is.null(name) || any(name %in% tolower(c("Oceandata MODIS Aqua Level-3 mapped monthly 9km SST", "MODISA_L3m_MO_SST_sst_9km")))) {
        out <- rbind(out,
                     bb_source(
                         name = "Oceandata MODIS Aqua Level-3 mapped monthly 9km SST",
                         id = "MODISA_L3m_MO_SST_sst_9km",
                         description = "Monthly remote-sensing SST from the MODIS Aqua satellite at 9km spatial resolution",
                         doc_url = "http://oceancolor.gsfc.nasa.gov/",
                         citation = "See https://oceancolor.gsfc.nasa.gov/citations",
                         license = "Please cite",
                         method = list("bb_handler_oceandata", search="AQUA_MODIS*L3m.MO.SST.sst.9km.nc", sensor = "aqua", dtype = "L3m"),
                         postprocess = NULL,
                         collection_size = 7,
                         data_group = "Sea surface temperature"))
    }
    if (is.null(name) || any(name %in% tolower(c("GHRSST Level 4 MUR Global Foundation SST v4.1", "GHRSST-MUR-SST_v4.1")))) {
        out <- rbind(out,
                     bb_source(
                         name = "GHRSST Level 4 MUR Global Foundation SST v4.1",
                         id = "GHRSST-MUR-SST_v4.1",
                         description = "A Group for High Resolution Sea Surface Temperature (GHRSST) Level 4 sea surface temperature analysis produced as a retrospective dataset (four day latency) at the JPL Physical Oceanography DAAC using wavelets as basis functions in an optimal interpolation approach on a global 0.011 degree grid. The version 4 Multiscale Ultrahigh Resolution (MUR) L4 analysis is based upon nighttime GHRSST L2P skin and subskin SST observations from several instruments including the NASA Advanced Microwave Scanning Radiometer-EOS (AMSRE), the Moderate Resolution Imaging Spectroradiometer (MODIS) on the NASA Aqua and Terra platforms, the US Navy microwave WindSat radiometer and in situ SST observations from the NOAA iQuam project. The ice concentration data are from the archives at the EUMETSAT Ocean and Sea Ice Satellite Application Facility (OSI SAF) High Latitude Processing Center and are also used for an improved SST parameterization for the high-latitudes. This data set is funded by the NASA MEaSUREs program (http://earthdata.nasa.gov/our-community/community-data-system-programs/measures-projects), and created by a team led by Dr. Toshio Chin from JPL.",
                         doc_url = "https://podaac.jpl.nasa.gov/dataset/MUR-JPL-L4-GLOB-v4.1",
                         citation = "Cite as: US NASA; Jet Propulsion Laboratory; Physical Oceanography Distributed Active Archive Center (JPL PO.DAAC) (2002). GHRSST Level 4 MUR Global Foundation Sea Surface Temperature Analysis (v4.1) (GDS versions 1 and 2). National Oceanographic Data Center, NOAA. Dataset. [access date]",
                         source_url = "https://cmr.earthdata.nasa.gov/virtual-directory/collections/C1996881146-POCLOUD/temporal",
                         license = "Please cite",
                         comment = "Note: this collection is large! You may wish to specify one or more source_url values with only particular years, e.g. https://cmr.earthdata.nasa.gov/virtual-directory/collections/C1996881146-POCLOUD/temporal/2023. Note that you will also need to modify the method `accept_follow` parameter in this case",
                         authentication_note = "Requires Earthdata login, see https://urs.earthdata.nasa.gov/. Note that you will also need to authorize the PODAAC application (see 'My Applications' at https://urs.earthdata.nasa.gov/profile)",
                         method = list("bb_handler_earthdata", level = 3, accept_follow = "/virtual-directory/collections/C1996881146-POCLOUD/temporal/", allow_unrestricted_auth = TRUE),
                         user = "",
                         password = "",
                         collection_size = 2000,
                         data_group = "Sea surface temperature", warn_empty_auth = FALSE))
    }

    if (is.null(name) || any(name %in% tolower(c("CMEMS Global Ocean OSTIA Sea Surface Temperature and Sea Ice Analysis", "SST_GLO_SST_L4_NRT_OBSERVATIONS_010_001", "10.48670/moi-00165")))) {
        out <- rbind(out,
                     bb_source(
                         name = "CMEMS Global Ocean OSTIA Sea Surface Temperature and Sea Ice Analysis",
                         id = "SST_GLO_SST_L4_NRT_OBSERVATIONS_010_001",
                         description = "For the Global Ocean- the OSTIA global foundation Sea Surface Temperature product provides daily gap-free maps of: Foundation Sea Surface Temperature at 0.05 degree x 0.05 degree horizontal grid resolution, using in-situ and satellite data from both infrared and microwave radiometers.",
                         doc_url = "https://data.marine.copernicus.eu/product/SST_GLO_SST_L4_NRT_OBSERVATIONS_010_001/description",
                         citation = "In case of any publication, the Licensee will ensure credit the Copernicus Marine Service and cite the DOIs links guaranteeing the traceability of the scientific studies and experiments, in the following manner: \"This study has been conducted using E.U. Copernicus Marine Service Information; https://doi.org/10.48670/moi-00165\"",
                         license = "See http://marine.copernicus.eu/services-portfolio/service-commitments-and-licence/",
                         method = list("bb_handler_copernicus", product = "SST_GLO_SST_L4_NRT_OBSERVATIONS_010_001"),
                         authentication_note = "Copernicus Marine login required, see http://marine.copernicus.eu/services-portfolio/register-now/",
                         user = "",
                         password = "",
                         ##access_function = "raadtools::readsst",
                         collection_size = 80,
                         data_group = "Sea surface temperature", warn_empty_auth = FALSE))
    }

    out
}
