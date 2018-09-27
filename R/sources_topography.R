#' Topographical data sources
#'
#' Data sources providing topographical data.
#'
#' \itemize{
#'   \item "Smith and Sandwell bathymetry": Global seafloor topography from satellite altimetry and ship depth soundings
#'   \item "ETOPO1 bathymetry": ETOPO1 is a 1 arc-minute global relief model of Earth's surface that integrates land topography and ocean bathymetry
#'   \item "ETOPO2 bathymetry": 2-Minute Gridded Global Relief Data (ETOPO2v2c)
#'   \item "Bedmap2": Bedmap2 is a suite of gridded products describing surface elevation, ice-thickness and the sea floor and subglacial bed elevation of the Antarctic south of 60S
#'   \item "Kerguelen Plateau bathymetric grid 2010": digital elevation model (DEM) for the Kerguelen Plateau region
#'   \item "George V bathymetry": Digital Elevation Models (DEMs) of varying resolutions for the George V and Terre Adelie continental margin, derived by incorporating all available singlebeam and multibeam point depth data
#'   \item "Geoscience Australia multibeam bathymetric grids of the Macquarie Ridge": This is a compilation of all the processed multibeam bathymetry data that are publicly available in Geoscience Australia's data holding for the Macquarie Ridge
#'   \item "IBCSO bathymetry": The International Bathymetric Chart of the Southern Ocean (IBCSO) Version 1.0 is a digital bathymetric model portraying the seafloor of the circum-Antarctic waters south of 60S. IBCSO Version 1.0 has been compiled from all available bathymetric data collectively gathered by more than 30 institutions from 15 countries, including multibeam and single-beam echo soundings, digitized depths from nautical charts, regional bathymetric gridded compilations, and predicted bathymetry
#'   \item "IBCSO chart for printing": The IBCSO Poster, 2013, is a polar stereographic view of the Southern Ocean displaying bathymetric contours south of 60S at a scale of 1:7,000,000
#'   \item "RTOPO-1 Antarctic ice shelf topography": a consistent dataset of Antarctic ice sheet topography, cavity geometry, and global bathymetry
#'   \item "Radarsat Antarctic digital elevation model V2": The high-resolution Radarsat Antarctic Mapping Project (RAMP) digital elevation model (DEM) combines topographic data from a variety of sources to provide consistent coverage of all of Antarctica. Version 2 improves upon the original version by incorporating new topographic data, error corrections, extended coverage, and other modifications
#'   \item "New Zealand Regional Bathymetry 2016": The NZ 250m gridded bathymetric data set and imagery, Mitchell et al. 2012, released 2016
#'   \item "Cryosat-2 digital elevation model": a digital elevation model of Antarctica derived from 6 years of continuous CryoSat-2 measurements
#'   \item "Natural Earth 10m physical vector data": Natural Earth is a public domain map dataset available at 1:10m, 1:50m, and 1:110 million scales
#'   \item "GSHHG coastline data": a Global Self-consistent, Hierarchical, High-resolution Geography Database
#'   \item "Shuttle Radar Topography Mission elevation data SRTMGL1 V3": Global 1-arc-second topographic data generated from NASA's Shuttle Radar Topography Mission. Version 3.0 (aka SRTM Plus or Void Filled) removes all of the void areas by incorporating data from other sources such as the ASTER GDEM
#'   \item "Reference Elevation Model of Antarctica mosaic tiles": The Reference Elevation Model of Antarctica (REMA) is a high resolution, time-stamped digital surface model of Antarctica at 8-meter spatial resolution (and reduced-resolution, resampled versions). Accepts a single \code{spatial_resolution} value of "1km", "200m" [default], "100m", "8m"
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
#' @seealso \code{\link{sources_altimetry}}, \code{\link{sources_biological}}, \code{\link{sources_meteorological}}, \code{\link{sources_ocean_colour}}, \code{\link{sources_oceanographic}}, \code{\link{sources_reanalysis}}, \code{\link{sources_sdm}}, \code{\link{sources_seaice}}, \code{\link{sources_sst}}
#'
#' @return a tibble with columns as specified by \code{\link{bb_source}}
#'
#' @examples
#' \dontrun{
#' ## define a configuration and add the Smith and Sandwell bathymetry
#' cf <- bb_config("/my/file/root") %>%
#'   bb_add(sources_topography("Smith and Sandwell bathymetry"))
#' }
#' @export
sources_topography <- function(name,formats,time_resolutions, ...) {
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
    if (is.null(name) || any(name %in% tolower(c("Smith and Sandwell bathymetry", "global_topo_1min")))) {
        out <- rbind(out,
                     bb_source(
                         name = "Smith and Sandwell bathymetry",
                         id = "global_topo_1min",
                         description = "Global seafloor topography from satellite altimetry and ship depth soundings",
                         doc_url = "http://topex.ucsd.edu/WWW_html/mar_topo.html",
                         citation = "Smith, W. H. F., and D. T. Sandwell, Global seafloor topography from satellite altimetry and ship depth soundings, Science, v. 277, p. 1957-1962, 26 Sept., 1997",
                         ##source_url = "ftp://topex.ucsd.edu/pub/global_topo_1min/*",
                         source_url = "ftp://topex.ucsd.edu/pub/global_topo_1min/",
                         license = "See ftp://topex.ucsd.edu/pub/global_topo_1min/COPYRIGHT.txt",
                         ##method = list("bb_handler_wget"), ## --recursive  --level=1 --no-parent
                         method = list("bb_handler_rget", level = 1, accept_download_extra = "img$"),
                         postprocess = NULL,
                         access_function = "raadtools::readbathy",
                         collection_size = 1.4,
                         data_group = "Topography"))
    }

    if (is.null(name) || any(name %in% tolower(c("ETOPO1 bathymetry", "10.7289/V5C8276M")))) {
        out <- rbind(out,
                     bb_source(
                         name = "ETOPO1 bathymetry",
                         id = "10.7289/V5C8276M",
                         description = "ETOPO1 is a 1 arc-minute global relief model of Earth's surface that integrates land topography and ocean bathymetry.",
                         doc_url = "http://www.ngdc.noaa.gov/mgg/global/global.html",
                         citation = "Amante, C. and B.W. Eakins, 2009. ETOPO1 1 Arc-Minute Global Relief Model: Procedures, Data Sources and Analysis. NOAA Technical Memorandum NESDIS NGDC-24. National Geophysical Data Center, NOAA. doi:10.7289/V5C8276M [access date]",
                         license = "Please cite",
                         source_url = "https://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/ice_surface/grid_registered/netcdf/",
                         ##method = list("bb_handler_wget", level=3, accept="*gdal*,*.txt", robots_off=TRUE), ## --recursive --no-parent
                         method = list("bb_handler_rget", level = 1, reject_download = "gmt4"),
                         postprocess = list("bb_gunzip"),
                         access_function = "raadtools::readtopo",
                         collection_size = 1.3,
                         data_group = "Topography"))
    }

    if (is.null(name) || any(name %in% tolower(c("ETOPO2 bathymetry", "ETOPO2v2c")))) {
        out <- rbind(out,
                     bb_source(
                         name = "ETOPO2 bathymetry",
                         id = "ETOPO2v2c",
                         description = "2-Minute Gridded Global Relief Data (ETOPO2v2c)",
                         doc_url = "http://www.ngdc.noaa.gov/mgg/global/etopo2.html",
                         citation = "",
                         license = "Not given",
##                         source_url = c("https://www.ngdc.noaa.gov/mgg/global/relief/ETOPO2/ETOPO2v2-2006/ETOPO2v2c/netCDF/ETOPO2v2c_f4_netCDF.zip", "https://www.ngdc.noaa.gov/mgg/global/relief/ETOPO2/ETOPO2v2-2006/ETOPO2v2c/ETOPO2v2c_ReadMe.txt"),
                         ##method = list("bb_handler_wget", robots_off=TRUE), ## --recursive --level=1 --no-parent
                         source_url = "https://www.ngdc.noaa.gov/mgg/global/relief/ETOPO2/ETOPO2v2-2006/ETOPO2v2c/",
                         method = list("bb_handler_rget", level = 2, accept_follow = "netCDF"),
                         postprocess = list("bb_unzip"),
                         access_function = "raadtools::readtopo",
                         collection_size = 0.3,
                         data_group = "Topography"))
    }

    if (is.null(name) || any(name %in% tolower(c("Bedmap2")))) {
        out <- rbind(out,
                     bb_source(
                         name = "Bedmap2",
                         id = "Bedmap2",
                         description = "Bedmap2 is a suite of gridded products describing surface elevation, ice-thickness and the sea floor and subglacial bed elevation of the Antarctic south of 60S.",
                         doc_url = "http://www.antarctica.ac.uk/bas_research/our_research/az/bedmap2/",
                         citation = "Fretwell et al. (2013) Bedmap2: improved ice bed, surface and thickness datasets for Antarctica. The Cryosphere 7:375-393. doi:10.5194/tc-7-375-2013",
                         license = "Please cite",
                         source_url = "https://secure.antarctica.ac.uk/data/bedmap2/",
                         ##method = list("bb_handler_wget",robots_off=TRUE,accept="*bin.zip,*tiff.zip,*.txt,*.rtf",no_check_certificate=TRUE), ## --recursive --no-parent
                         method = list("bb_handler_rget", reject_download = "gdb|ascii", accept_download = "\\.(rtf|zip|txt)$", level = 1),
                         postprocess=list("bb_unzip"),
                         collection_size=3.3,
                         data_group="Topography"))
    }

    if (is.null(name) || any(name %in% tolower(c("Kerguelen Plateau bathymetric grid 2010", "gcat_71552")))) {
        out <- rbind(out,
                     bb_source(
                         name = "Kerguelen Plateau bathymetric grid 2010",
                         id = "gcat_71552",
                         description = "This data replaces the digital elevation model (DEM) for the Kerguelen Plateau region produced in 2005 (Sexton 2005). The revised grid has been gridded at a grid pixel resolution of 0.001-arc degree (about 100 m). The new grid utilised the latest data sourced from ship-based multibeam and singlebeam echosounder surveys, and satellite remotely-sensed data. Report Reference: Beaman, R.J. and O'Brien, P.E., 2011. Kerguelen Plateau bathymetric grid, November 2010. Geoscience Australia, Record, 2011/22, 18 pages.",
                         doc_url = "http://www.ga.gov.au/metadata-gateway/metadata/record/gcat_71552",
                         citation = "Beaman, R.J. & O'Brien, P., 2011. Kerguelen Plateau Bathymetric Grid, November 2010. Record  2011/022. Geoscience Australia, Canberra",
                         source_url = "http://ftt.jcu.edu.au/deepreef/kergdem/gmt/kerg_dem_gmt.zip",
                         license = "CC-BY",
                         ##method = list("bb_handler_wget"), ## --recursive --no-parent
                         method = list("bb_handler_rget"),
                         postprocess = list("bb_unzip"),
                         collection_size = 0.7,
                         data_group = "Topography"))
    }

    if (is.null(name) || any(name %in% tolower(c("George V bathymetry", "GVdem_2008")))) {
        out <- rbind(out,
                     bb_source(
                         name = "George V bathymetry",
                         id = "GVdem_2008",
                         description = "This dataset comprises Digital Elevation Models (DEMs) of varying resolutions for the George V and Terre Adelie continental margin, derived by incorporating all available singlebeam and multibeam point depth data.",
                         doc_url = "https://data.aad.gov.au/metadata/records/GVdem_2008",
                         citation = "Beaman, Robin (2009, updated 2015) A bathymetric Digital Elevation Model (DEM) of the George V and Terre Adelie continental shelf and margin Australian Antarctic Data Centre - CAASM Metadata (https://data.aad.gov.au/aadc/metadata/metadata_redirect.cfm?md=/AMD/AU/GVdem_2008)",
                         license = "CC-BY",
                         source_url = "https://data.aad.gov.au/eds/file/4494/", ## migrate to https://data.aad.gov.au/eds/3403/download if we prefer that form
                         ##method = list("bb_handler_aadc"),
                         method = list("bb_handler_rget", force_local_filename = "download.zip", no_check_certificate = TRUE),
                         comment = "server certificate is valid but not recognized as such by some systems (e.g. Ubuntu)",
                         postprocess = list("bb_unzip"),
                         collection_size = 0.2,
                         data_group = "Topography"))
    }

    if (is.null(name) || any(name %in% tolower(c("Geoscience Australia multibeam bathymetric grids of the Macquarie Ridge", "10.4225/25/53D9B12E0F96E")))) {
        out <- rbind(out,
                     bb_source(
                         name = "Geoscience Australia multibeam bathymetric grids of the Macquarie Ridge",
                         id = "10.4225/25/53D9B12E0F96E",
                         description = "This is a compilation of all the processed multibeam bathymetry data that are publicly available in Geoscience Australia's data holding for the Macquarie Ridge.",
                         doc_url = "https://doi.org/10.4225/25/53D9B12E0F96E",
                         citation = "Spinoccia, M., 2012. XYZ multibeam bathymetric grids of the Macquarie Ridge. Geoscience Australia, Canberra.",
                         source_url = "http://www.ga.gov.au/corporate_data/73697/Macquarie_ESRI_Raster.zip",
                         license = "CC-BY 4.0",
                         ##method = list("bb_handler_wget",accept="zip"), ## --recursive --level=1 --no-parent
                         method = list("bb_handler_rget"),
                         postprocess = list("bb_unzip"),
                         collection_size = 0.4,
                         data_group = "Topography"))
    }

    if (is.null(name) || any(name %in% tolower(c("IBCSO bathymetry", "10.1594/PANGAEA.805734")))) {
        out <- rbind(out,
                     bb_source(
                         name = "IBCSO bathymetry",
                         id = "10.1594/PANGAEA.805734",##IBCSO_v1
                         description = "The International Bathymetric Chart of the Southern Ocean (IBCSO) Version 1.0 is a new digital bathymetric model (DBM) portraying the seafloor of the circum-Antarctic waters south of 60S. IBCSO is a regional mapping project of the General Bathymetric Chart of the Oceans (GEBCO). The IBCSO Version 1.0 DBM has been compiled from all available bathymetric data collectively gathered by more than 30 institutions from 15 countries. These data include multibeam and single-beam echo soundings, digitized depths from nautical charts, regional bathymetric gridded compilations, and predicted bathymetry. Specific gridding techniques were applied to compile the DBM from the bathymetric data of different origin, spatial distribution, resolution, and quality. The IBCSO Version 1.0 DBM has a resolution of 500 x 500 m, based on a polar stereographic projection, and is publicly available together with a digital chart for printing from the project website (www.ibcso.org) and at http://dx.doi.org/10.1594/PANGAEA.805736.",
                         doc_url = "http://www.ibcso.org/",
                         citation = "Arndt, J.E., H. W. Schenke, M. Jakobsson, F. Nitsche, G. Buys, B. Goleby, M. Rebesco, F. Bohoyo, J.K. Hong, J. Black, R. Greku, G. Udintsev, F. Barrios, W. Reynoso-Peralta, T. Morishita, R. Wigley, The International Bathymetric Chart of the Southern Ocean (IBCSO) Version 1.0 - A new bathymetric compilation covering circum-Antarctic waters, 2013, Geophysical Research Letters, Vol. 40, p. 3111-3117, doi: 10.1002/grl.50413",
                         license = "CC-BY",
                         source_url = c("http://hs.pangaea.de/Maps/bathy/IBCSO_v1/IBCSO_v1_bed_PS71_500m_grd.zip", "http://hs.pangaea.de/Maps/bathy/IBCSO_v1/IBCSO_v1_is_PS71_500m_grd.zip", "http://hs.pangaea.de/Maps/bathy/IBCSO_v1/IBCSO_v1_sid_PS71_500m_grd.zip", "http://hs.pangaea.de/Maps/bathy/IBCSO_v1/IBCSO_v1_is_PS71_500m_tif.zip", "http://hs.pangaea.de/Maps/bathy/IBCSO_v1/IBCSO_background_hq.zip"),
                         ##method=list("bb_handler_wget"), ## --recursive --level=1 --no-parent
                         method = list("bb_handler_rget"),
                         postprocess = list("bb_unzip"),
                         collection_size = 4.3,
                         data_group = "Topography"))
    }

    if (is.null(name) || any(name %in% tolower(c("IBCSO chart for printing", "10.1594/PANGAEA.805735")))) {
        out <- rbind(out,
                     bb_source(
                         name = "IBCSO chart for printing",
                         id = "10.1594/PANGAEA.805735",
                         description = "The IBCSO Poster, 2013, is a polar stereographic view of the Southern Ocean displaying bathymetric contours south of 60S at a scale of 1:7,000,000. The poster size is 39.25 x 47.125 inches.",
                         doc_url = "http://www.ibcso.org/",
                         citation = "Arndt, J.E., H. W. Schenke, M. Jakobsson, F. Nitsche, G. Buys, B. Goleby, M. Rebesco, F. Bohoyo, J.K. Hong, J. Black, R. Greku, G. Udintsev, F. Barrios, W. Reynoso-Peralta, T. Morishita, R. Wigley, The International Bathymetric Chart of the Southern Ocean (IBCSO) Version 1.0 - A new bathymetric compilation covering circum-Antarctic waters, 2013, Geophysical Research Letters, Vol. 40, p. 3111-3117, doi: 10.1002/grl.50413",
                         license = "CC-BY",
                         source_url = "http://hs.pangaea.de/Maps/bathy/IBCSO_v1/IBCSO_v1_digital_chart_pdfA.pdf",
                         ##method = list("bb_handler_wget"), ## --recursive --level=1 --no-parent
                         method = list("bb_handler_rget"),
                         postprocess = NULL,
                         collection_size = 0.2,
                         data_group = "Topography"))
    }

    if (is.null(name) || any(name %in% tolower(c("RTOPO-1 Antarctic ice shelf topography", "hdl:10013/epic.39674")))) {
        out <- rbind(out,
                     bb_source(
                         name = "RTOPO-1 Antarctic ice shelf topography",
                         id = "hdl:10013/epic.39674",
                         description = "Sub-ice shelf circulation and freezing/melting rates in ocean general circulation models depend critically on an accurate and consistent representation of cavity geometry. The goal of this work is to compile independent regional fields into a global data set. We use the S-2004 global 1-minute bathymetry as the backbone and add an improved version of the BEDMAP topography for an area that roughly coincides with the Antarctic continental shelf. Locations of the merging line have been carefully adjusted in order to get the best out of each data set. High-resolution gridded data for upper and lower ice surface topography and cavity geometry of the Amery, Fimbul, Filchner-Ronne, Larsen C and George VI Ice Shelves, and for Pine Island Glacier have been carefully merged into the ambient ice and ocean topographies. Multibeam survey data for bathymetry in the former Larsen B cavity and the southeastern Bellingshausen Sea have been obtained from the data centers of Alfred Wegener Institute (AWI), British Antarctic Survey (BAS) and Lamont-Doherty Earth Observatory (LDEO), gridded, and again carefully merged into the existing bathymetry map.",
                         doc_url = "http://epic.awi.de/30738/",
                         citation = "Timmermann, Ralph; Le Brocq, Anne M; Deen, Tara J; Domack, Eugene W; Dutrieux, Pierre; Galton-Fenzi, Ben; Hellmer, Hartmut H; Humbert, Angelika; Jansen, Daniela; Jenkins, Adrian; Lambrecht, Astrid; Makinson, Keith; Niederjasper, Fred; Nitsche, Frank-Oliver; N\uf8st, Ole Anders; Smedsrud, Lars Henrik; Smith, Walter (2010): A consistent dataset of Antarctic ice sheet topography, cavity geometry, and global bathymetry. Earth System Science Data, 2(2), 261-273, doi:10.5194/essd-2-261-2010",
                         license = "CC-BY",
                         source_url = c("http://store.pangaea.de/Publications/TimmermannR_et_al_2010/RTopo105b_data.nc", "http://store.pangaea.de/Publications/TimmermannR_et_al_2010/RTopo105b_aux.nc", "http://store.pangaea.de/Publications/TimmermannR_et_al_2010/RTopo105b_50S.nc", "http://store.pangaea.de/Publications/TimmermannR_et_al_2010/RTopo105_coast.asc", "http://store.pangaea.de/Publications/TimmermannR_et_al_2010/RTopo105_gl.asc", "http://store.pangaea.de/Publications/TimmermannR_et_al_2010/RTopo105_bathy.jpg", "http://store.pangaea.de/Publications/TimmermannR_et_al_2010/RTopo105_draft.jpg", "http://store.pangaea.de/Publications/TimmermannR_et_al_2010/RTopo105_height.jpg", "http://store.pangaea.de/Publications/TimmermannR_et_al_2010/RTopo105_famask.jpg"),
                         ##method = list("bb_handler_wget"), ## --recursive --level=1 --no-parent
                         method = list("bb_handler_rget", accept_download = "(jpg|nc|asc)$"),
                         postprocess = NULL,
                         collection_size = 4.1,
                         data_group = "Topography"))
    }

    if (is.null(name) || any(name %in% tolower(c("Radarsat Antarctic digital elevation model V2", "nsidc0082")))) {
        out <- rbind(out,
                     bb_source(
                         name = "Radarsat Antarctic digital elevation model V2",
                         id = "nsidc0082",
                         description = "The high-resolution Radarsat Antarctic Mapping Project (RAMP) digital elevation model (DEM) combines topographic data from a variety of sources to provide consistent coverage of all of Antarctica. Version 2 improves upon the original version by incorporating new topographic data, error corrections, extended coverage, and other modifications.",
                         doc_url = "http://nsidc.org/data/nsidc-0082",
                         citation = "Liu, H., K. Jezek, B. Li, and Z. Zhao. 2001. Radarsat Antarctic Mapping Project Digital Elevation Model Version 2. [indicate subset used]. Boulder, Colorado USA: National Snow and Ice Data Center. http://dx.doi.org/10.5067/PXKC81A7WAXD",
                         license = "Please cite",
                         ##source_url = "ftp://sidads.colorado.edu/pub/DATASETS/nsidc0082_radarsat_dem_v02/*",
                         source_url = "ftp://sidads.colorado.edu/pub/DATASETS/nsidc0082_radarsat_dem_v02/",
                         ##method = list("bb_handler_wget",level=3,reject="*.txt.gz"),
                         method = list("bb_handler_rget", level = 3, accept_download_extra = "\\.hdr$", reject_download = "\\.txt\\.gz$"),
                         postprocess = list("bb_gunzip"),
                         collection_size = 5.3,
                         data_group = "Topography"))
    }

    if (is.null(name) || any(name %in% tolower(c("New Zealand Regional Bathymetry 2016", "NZBathy_DTM_2016_binary_grid")))) {
        out <- rbind(out,
                     bb_source(
                         name = "New Zealand Regional Bathymetry 2016",
                         id = "NZBathy_DTM_2016_binary_grid",
                         description = "The NZ 250m gridded bathymetric data set and imagery, Mitchell et al. 2012, released 2016.",
                         doc_url = "https://www.niwa.co.nz/our-science/oceans/bathymetry/further-information",
                         citation = "Mitchell, J.S., Mackay, K.A., Neil, H.L., Mackay, E.J., Pallentin, A., Notman P., 2012. Undersea New Zealand, 1:5,000,000. NIWA Chart, Miscellaneous Series No. 92",
                         source_url = "ftp://ftp.niwa.co.nz/bathymetry/NZBathy_DTM_2016_binary_grid.zip",
                         license = "NIWA Open Data Licence BY-NN-NC-SA version 1, see https://www.niwa.co.nz/environmental-information/licences/niwa-open-data-licence-by-nn-nc-sa-version-1",
                         ##method = list("bb_handler_wget"), ##--recursive --level=1 --no-parent
                         method = list("bb_handler_rget"),
                         postprocess = list("bb_unzip"),
                         collection_size = 1.3,
                         data_group = "Topography"))
    }

    if (is.null(name) || any(name %in% tolower(c("Cryosat-2 digital elevation model", "cpom_cryosat2_antarctic_dem")))) {
        out <- rbind(out,
                     bb_source(
                         name = "Cryosat-2 digital elevation model",
                         id = "cpom_cryosat2_antarctic_dem",
                         description = "A New Digital Elevation Model of Antarctica derived from 6 years of continuous CryoSat-2 measurements",
                         doc_url = "https://doi.org/10.5194/tc-2017-223",
                         citation = "Slater T, Shepherd A, McMillan M, Muir A, Gilbert L, Hogg AE, Konrad H, Parrinello T (2017) A new Digital Elevation Model of Antarctica derived from CryoSat-2 altimetry. The Cryosphere Discussions. https://doi.org/10.5194/tc-2017-223",
                         license = "Please cite",
                         source_url = "https://earth.esa.int/documents/10174/3082676/Antarctica-DEM-CryoSat",
                         ##method = list("bb_handler_wget",extra_flags=c("--content-disposition")),
                         method = list("bb_handler_rget", force_local_filename = "download.zip"),
                         postprocess = list(list("bb_unzip"), list("bb_cleanup", recursive = TRUE, all_files = TRUE, pattern = "^\\._")),
                         collection_size = 0.2,
                         data_group = "Topography"))
    }

    if (is.null(name) || any(name %in% tolower(c("Natural Earth 10m physical vector data", "NE-10m-physical-vectors")))) {
        out <- rbind(out,
                     bb_source(
                         name = "Natural Earth 10m physical vector data",
                         id = "NE-10m-physical-vectors",
                         description = "Natural Earth is a public domain map dataset available at 1:10m, 1:50m, and 1:110 million scales.",
                         doc_url = "http://www.naturalearthdata.com/downloads/10m-physical-vectors/",
                         citation = "No permission is needed to use Natural Earth. Crediting the authors is unnecessary. However, if you wish to cite the map data, simply use one of the following. Short text: Made with Natural Earth. Long text: Made with Natural Earth. Free vector and raster map data @ naturalearthdata.com.",
                         license = "PD-CC",
                         source_url = "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/10m_physical.zip",
                         ##method = list("bb_handler_wget"), ## --recursive --level=1 --no-parent
                         method = list("bb_handler_rget"),
                         postprocess = list("bb_unzip"),
                         collection_size = 0.2,
                         data_group = "Topography"))
    }

    if (is.null(name) || any(name %in% tolower(c("GSHHG coastline data", "gshhg_coastline")))) {
        out <- rbind(out,
                     bb_source(
                         name = "GSHHG coastline data",
                         id = "gshhg_coastline",
                         description = "A Global Self-consistent, Hierarchical, High-resolution Geography Database",
                         doc_url = "http://www.soest.hawaii.edu/pwessel/gshhg",
                         citation = "Wessel, P., and W. H. F. Smith, A Global Self-consistent, Hierarchical, High-resolution Shoreline Database, J. Geophys. Res., 101, 8741-8743, 1996",
                         ##source_url = "ftp://ftp.soest.hawaii.edu/gshhg/*",
                         source_url = "ftp://ftp.soest.hawaii.edu/gshhg/",
                         license = "LGPL",
                         ##method = list("bb_handler_wget",accept="*bin*.zip,README.TXT"), ## --recursive --level=1
                         method = list("bb_handler_rget", level = 1, accept_download = "README|bin.*\\.zip$"),
                         postprocess = list("bb_unzip"),
                         collection_size = 0.6,
                         data_group = "Topography"))
    }

    if (is.null(name) || any(name %in% tolower(c("Shuttle Radar Topography Mission elevation data SRTMGL1 V3","10.5067/measures/srtm/srtmgl1.003")))) {
        out <- rbind(out,
                     bb_source(
                         name="Shuttle Radar Topography Mission elevation data SRTMGL1 V3",
                         id="10.5067/measures/srtm/srtmgl1.003",
                         description="Global 1-arc-second topographic data generated from NASA's Shuttle Radar Topography Mission. Version 3.0 (aka SRTM Plus or Void Filled) removes all of the void areas by incorporating data from other sources such as the ASTER GDEM.",
                         doc_url="https://lpdaac.usgs.gov/dataset_discovery/measures/measures_products_table/srtmgl1_v003",
                         source_url="https://e4ftl01.cr.usgs.gov/SRTM/SRTMGL1.003/2000.02.11/",
                         citation="NASA JPL. (2013). NASA Shuttle Radar Topography Mission Global 1 arc second [Data set]. NASA LP DAAC. https://doi.org/10.5067/measures/srtm/srtmgl1.003",
                         license="Please cite, see https://lpdaac.usgs.gov/node/51",
                         authentication_note="Requires Earthdata login, see https://urs.earthdata.nasa.gov/",
                         method=list("bb_handler_earthdata"), ## --recursive --level=1 --no-parent
                         user="",
                         password="",
                         postprocess=list("bb_unzip"),
                         collection_size=620,
                         data_group="Topography",warn_empty_auth=FALSE))
    }

    if (is.null(name) || any(name %in% tolower(c("Reference Elevation Model of Antarctica","REMA_R1_mosaic")))) {
        spatial_resolution <- ss_args$spatial_resolution
        if (is.null(spatial_resolution)) spatial_resolution <- "200m"
        assert_that(is.string(spatial_resolution))
        spatial_resolution <- match.arg(tolower(spatial_resolution), c("1km", "200m", "100m", "8m"))
        switch(spatial_resolution,
               "8m" = {
                   csize = 1500
                   pp <- list("bb_unzip", "bb_untar")
                   src_url <- c("ftp://ftp.data.pgc.umn.edu/elev/dem/setsm/REMA/mosaic/v1.0/8m/", "ftp://ftp.data.pgc.umn.edu/elev/dem/setsm/REMA/indexes/")
               },
               "100m" = {
                   csize <- 0.4
                   src_url <- "ftp://ftp.data.pgc.umn.edu/elev/dem/setsm/REMA/mosaic/v1.0/100m/"
                   pp <- NULL
               },
               "200m" = {
                   csize <- 1.2
                   src_url <- "ftp://ftp.data.pgc.umn.edu/elev/dem/setsm/REMA/mosaic/v1.0/200m/" ##"ftp://ftp.data.pgc.umn.edu/elev/dem/setsm/REMA/mosaic/v1.0/200m/"
                   pp <- NULL
               },
               "1km" = {
                   csize = 0.15
                   src_url <- "ftp://ftp.data.pgc.umn.edu/elev/dem/setsm/REMA/mosaic/v1.0/1km/"
                   pp <- NULL
               },
               stop("unexpected spatial_resolution: ", spatial_resolution))
        out <- rbind(out,
                     bb_source(
                         name = "Reference Elevation Model of Antarctica mosaic tiles",
                         id = "REMA_R1_mosaic",
                         description = "The Reference Elevation Model of Antarctica (REMA) is a high resolution, time-stamped digital surface model of Antarctica at 8-meter spatial resolution. REMA is constructed from hundreds of thousands of individual stereoscopic Digital Elevation Models (DEM) extracted from pairs of submeter (0.32 to 0.5 m) resolution DigitalGlobe satellite imagery. Version 1 of REMA includes approximately 98% of the contiguous continental landmass extending to maximum of roughly 88 degrees S. Output DEM raster files are being made available as both 'strip' files as they are output directly from SETSM that preserve the original source material temporal resolution, as well as mosaic tiles that are compiled from multiple strips that have been co-registered, blended, and feathered to reduce edge-matching artifacts.",
                         doc_url = "https://www.pgc.umn.edu/data/rema/",
                         comment = "Note that the 100m version only provides coverage of the Antarctic Peninsula region",
                         source_url = src_url,
                         citation = "DEMs provided by the Byrd Polar and Climate Research Center and the Polar Geospatial Center under NSF-OPP awards 1543501, 1810976, 1542736, 1559691, 1043681, 1541332, 0753663, 1548562, 1238993 and NASA award NNX10AN61G. Computer time provided through a Blue Waters Innovation Initiative. DEMs produced using data from DigitalGlobe, Inc",
                         license = "Please cite, see https://www.pgc.umn.edu/guides/user-services/acknowledgement-policy/",
                         method = list("bb_handler_rget", level = 2, accept_follow = "/[[:digit:]]+_[[:digit:]]+/?$"),
                         postprocess = pp,
                         collection_size = csize,
                         data_group = "Topography"))
    }
    out
}
