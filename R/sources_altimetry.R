#' Altimetry data sources
#'
#' Data sources providing (typically satellite-derived) altimetry data.
#'
#' * "CMEMS global gridded SSH reprocessed (1993-ongoing)": Global Ocean - Multimission altimeter satellite gridded sea surface heights and derived variables computed with respect to a twenty-year mean. All the missions are homogenized with respect to a reference mission which is currently OSTM/Jason-2
#' * "CMEMS global gridded SSH near-real-time": near-real-time version of 'CMEMS global gridded SSH reprocessed (1993-ongoing)'
#' * "CNES-CLS2013 Mean Dynamic Topography": CNES-CLS2013 Mean dynamic topography over the 1993-2012 period of the sea surface height above geoid. The MDT_CNES-CLS13 is an estimate of the ocean MDT for the 1993-2012 period. Since April 2014 (Duacs 2014, v15.0 version), the Ssalto/Duacs (M)SLA products are computed relative to 1993-2012 period that is consistent with this new MDT CNES-CLS13. Based on 2 years of GOCE data, 7 years of GRACE data, and 20 years of altimetry and in-situ data (hydrologic and drifters data)
#' * "Gridded Sea Level Heights and geostrophic currents - Antarctic Ocean": Experimental Ssalto/Duacs gridded multimission altimeter products dedicated to Antarctic Ocean
#' * "Near-real-time finite size Lyapunov exponents": These products provide the exponential rate of separation of particle trajectories initialized nearby and advected by altimetry velocities. FSLEs highlight the transport barriers that control the horizontal exchange of water in and out of eddy cores.
#' * "Delayed-time finite size Lyapunov exponents": These products provide the exponential rate of separation of particle trajectories initialized nearby and advected by altimetry velocities. FSLEs highlight the transport barriers that control the horizontal exchange of water in and out of eddy cores.
#' * "WAVERYS Global Ocean Waves Reanalysis": global wave reanalysis describing past sea states since years 1993.
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
#' ## define a configuration and add the CMEMS near-real-time data to it
#' cf <- bb_config("/my/file/root")
#' src <- sources_altimetry("CMEMS global gridded SSH near-real-time")
#' ## this source requires a username and login to the CMEMS system
#' src$user <- "your user name"
#' src$password <- "your password"
#' cf <- bb_add(cf,src)
#' }
#'
#' @export
sources_altimetry <- function(name,formats,time_resolutions, ...) {
    if (!missing(name) && !is.null(name)) {
        assert_that(is.character(name))
        name <- tolower(name)
    } else {
        name <- NULL
    }
    out <- tibble()
    if (is.null(name) || any(name %in% tolower(c("CMEMS global gridded SSH reprocessed (1993-ongoing)", "SEALEVEL_GLO_PHY_L4_MY_008_047", "10.48670/moi-00148")))) {
        ## monthly cmems_obs-sl_glo_phy-ssh_my_allsat-l4-duacs-0.125deg_P1M-m_202411
        ## daily "cmems_obs-sl_glo_phy-ssh_my_allsat-l4-duacs-0.125deg_P1D_202411"
        out <- rbind(out,
                     bb_source(
                         name = "CMEMS global gridded SSH reprocessed (1993-ongoing)",
                         id = "SEALEVEL_GLO_PHY_L4_MY_008_047",
                         description = "For the Global Ocean - Multimission altimeter satellite gridded sea surface heights and derived variables computed with respect to a twenty-year mean. Previously distributed by Aviso+, no change in the scientific content. All the missions are homogenized with respect to a reference mission which is currently OSTM/Jason-2.\nVARIABLES\n- sea_surface_height_above_sea_level (SSH)\n- surface_geostrophic_eastward_sea_water_velocity_assuming_sea_level_for_geoid (UVG)\n- surface_geostrophic_northward_sea_water_velocity_assuming_sea_level_for_geoid (UVG)\n- sea_surface_height_above_geoid (SSH)\n- surface_geostrophic_eastward_sea_water_velocity (UVG)\n- surface_geostrophic_northward_sea_water_velocity (UVG)",
                         doc_url = "https://data.marine.copernicus.eu/product/SEALEVEL_GLO_PHY_L4_MY_008_047/description",
                         citation = "In case of any publication, the Licensee will ensure credit the Copernicus Marine Service and cite the DOIs links guaranteeing the traceability of the scientific studies and experiments, in the following manner: \"This study has been conducted using E.U. Copernicus Marine Service Information; https://doi.org/10.48670/moi-00148\"",
                         license = "See http://marine.copernicus.eu/services-portfolio/service-commitments-and-licence/",
                         method = list("bb_handler_copernicus", product = "SEALEVEL_GLO_PHY_L4_MY_008_047", layer = "cmems_obs-sl_glo_phy-ssh_my_allsat-l4-duacs-0.125deg_P1D_202411"),
                         authentication_note = "Copernicus Marine login required, see http://marine.copernicus.eu/services-portfolio/register-now/",
                         user = "",
                         password = "",
                         access_function = "raadtools::readssh",
                         collection_size = 310,
                         data_group = "Altimetry", warn_empty_auth = FALSE))
    }

    if (is.null(name) || any(name %in% tolower(c("CMEMS global gridded SSH near-real-time", "SEALEVEL_GLO_PHY_L4_NRT_008_046", "10.48670/moi-00149")))) {
        ## 0.25 degree product (deprecated?): cmems_obs-sl_glo_phy-ssh_nrt_allsat-l4-duacs-0.25deg_P1D_202311
        ## 0.125 degree product: cmems_obs-sl_glo_phy-ssh_nrt_allsat-l4-duacs-0.125deg_P1D_202506
        out <- rbind(out,
                     bb_source(
                         name = "CMEMS global gridded SSH near-real-time",
                         id = "SEALEVEL_GLO_PHY_L4_NRT_008_046",
                         description = "Altimeter satellite gridded Sea Level Anomalies (SLA) computed with respect to a twenty-year [1993, 2012] mean. The SLA is estimated by Optimal Interpolation, merging the L3 along-track measurement from the different altimeter missions available. Part of the processing is fitted to the Global ocean. (see QUID document or http://duacs.cls.fr pages for processing details). The product gives additional variables (i.e. Absolute Dynamic Topography and geostrophic currents (absolute and anomalies)). It serves in delayed-time applications. This product is processed by the DUACS multimission altimeter data processing system.",
                         doc_url = "https://data.marine.copernicus.eu/product/SEALEVEL_GLO_PHY_L4_NRT_008_046/description",
                         citation = "In case of any publication, the Licensee will ensure credit the Copernicus Marine Service and cite the DOIs links guaranteeing the traceability of the scientific studies and experiments, in the following manner: \"This study has been conducted using E.U. Copernicus Marine Service Information; https://doi.org/10.48670/moi-00149\"",
                         license = "See http://marine.copernicus.eu/services-portfolio/service-commitments-and-licence/",
                         method = list("bb_handler_copernicus", product = "SEALEVEL_GLO_PHY_L4_NRT_008_046", layer = "cmems_obs-sl_glo_phy-ssh_nrt_allsat-l4-duacs-0.125deg_P1D_202506"),
                         authentication_note = "Copernicus Marine login required, see http://marine.copernicus.eu/services-portfolio/register-now/",
                         user = "",
                         password = "",
                         access_function = "raadtools::readssh",
                         collection_size = 3,
                         data_group = "Altimetry", warn_empty_auth = FALSE))
    }

    if (is.null(name) || any(name %in% tolower(c("Global Ocean Mean Dynamic Topography", "SEALEVEL_GLO_PHY_MDT_008_063", "10.48670/moi-00150")))) {
        out <- rbind(out,
                     bb_source(
                         name = "Global Ocean Mean Dynamic Topography",
                         id = "SEALEVEL_GLO_PHY_MDT_008_063",
                         description = "Mean Dynamic Topography that combines the global CNES-CLS-2022 MDT, the Black Sea CMEMS2020 MDT and the Med Sea CMEMS2020 MDT. It is an estimate of the mean over the 1993-2012 period of the sea surface height above geoid. This is consistent with the reference time period also used in the DUACS products.",
                         doc_url = "https://data.marine.copernicus.eu/product/SEALEVEL_GLO_PHY_MDT_008_063/description",
                         citation = "In case of any publication, the Licensee will ensure credit the Copernicus Marine Service and cite the DOIs links guaranteeing the traceability of the scientific studies and experiments, in the following manner: \"This study has been conducted using E.U. Copernicus Marine Service Information; https://doi.org/10.48670/moi-00150\"",
                         license = "See http://marine.copernicus.eu/services-portfolio/service-commitments-and-licence/",
                         method = list("bb_handler_copernicus", product = "SEALEVEL_GLO_PHY_MDT_008_063", ctype = "file"),
                         authentication_note = "Copernicus Marine login required, see http://marine.copernicus.eu/services-portfolio/register-now/",
                         user = "",
                         password = "",
                         access_function = "raster",
                         collection_size = 0.1,
                         data_group = "Altimetry", warn_empty_auth = FALSE))
    }

    if (is.null(name) || any(name %in% tolower(c("Near-real-time finite size Lyapunov exponents", "FSLE NRT")))) {
        ## https://www.aviso.altimetry.fr/fileadmin/documents/data/tools/FSLE_handbook.pdf
        out <- rbind(out,
                     bb_source(
                         name = "Near-real-time finite size Lyapunov exponents",
                         id = "FLSE NRT",
                         description = "The maps of Backward-in-time, Finite-Size Lyapunov Exponents (FSLEs) and Orientations of associated eigenvectors are computed over 21-year altimetry period and over global ocean within the SALP/Cnes project in collaboration with CLS, LOcean and CTOH. These products provide the exponential rate of separation of particle trajectories initialized nearby and advected by altimetry velocities. FSLEs highlight the transport barriers that control the horizontal exchange of water in and out of eddy cores.",
                         doc_url = "https://www.aviso.altimetry.fr/en/data/products/value-added-products/fsle-finite-size-lyapunov-exponents/fsle-description.html",
                         citation = "D'Ovidio F, Lopez C, Hernandez-Garcia E, Fernandez V (2004) Mixing structures in the Mediterranean sea from Finite-Size Lyapunov Exponents. Geophys. Res. Lett., 31, L17203",
                         source_url = "ftp://ftp-access.aviso.altimetry.fr/value-added/lyapunov/near-real-time/global/",
                         license = "See https://www.aviso.altimetry.fr/fileadmin/documents/data/License_Aviso.pdf",
                         method = list("bb_handler_rget", level = 2),
                         authentication_note = "AVISO login required, see https://www.aviso.altimetry.fr/en/data/data-access/endatadata-accessregistration-form.html",
                         user = "",
                         password = "",
                         access_function = "raster",
                         collection_size = 100,
                         comment = "File size 140MB per file, approx 50 GB per year",
                         data_group = "Altimetry", warn_empty_auth = FALSE))
    }
    if (is.null(name) || any(name %in% tolower(c("Delayed-time finite size Lyapunov exponents", "FSLE DT")))) {
        ## https://www.aviso.altimetry.fr/fileadmin/documents/data/tools/FSLE_handbook.pdf
        out <- rbind(out,
                     bb_source(
                         name = "Delayed-time finite size Lyapunov exponents",
                         id = "FLSE DT",
                         description = "The maps of Backward-in-time, Finite-Size Lyapunov Exponents (FSLEs) and Orientations of associated eigenvectors are computed over 21-year altimetry period and over global ocean within the SALP/Cnes project in collaboration with CLS, LOcean and CTOH. These products provide the exponential rate of separation of particle trajectories initialized nearby and advected by altimetry velocities. FSLEs highlight the transport barriers that control the horizontal exchange of water in and out of eddy cores.",
                         doc_url = "https://www.aviso.altimetry.fr/en/data/products/value-added-products/fsle-finite-size-lyapunov-exponents/fsle-description.html",
                         citation = "D'Ovidio F, Lopez C, Hernandez-Garcia E, Fernandez V (2004) Mixing structures in the Mediterranean sea from Finite-Size Lyapunov Exponents. Geophys. Res. Lett., 31, L17203",
                         source_url = "ftp://ftp-access.aviso.altimetry.fr/value-added/lyapunov/delayed-time/global/",
                         license = "See https://www.aviso.altimetry.fr/fileadmin/documents/data/License_Aviso.pdf",
                         method = list("bb_handler_rget", level = 2),
                         ##method = list("bb_handler_wget", level = 2),
                         authentication_note = "AVISO login required, see https://www.aviso.altimetry.fr/en/data/data-access/endatadata-accessregistration-form.html",
                         user = "",
                         password = "",
                         access_function = "raster",
                         comment = "File size 140MB per file, approx 50 GB per year",
                         collection_size = 1200,
                         data_group = "Altimetry", warn_empty_auth = FALSE))
    }

    if (is.null(name) || any(name %in% tolower(c("WAVERYS Global Ocean Waves Reanalysis", "GLOBAL_MULTIYEAR_WAV_001_032", "WAVERYS", "10.48670/moi-00022")))) {
        out <- rbind(out,
                     bb_source(
                         name = "WAVERYS Global Ocean Waves Reanalysis",
                         id = "GLOBAL_MULTIYEAR_WAV_001_032",
                         description = "Global wave reanalysis describing past sea states since years 1993. This product also bears the name of WAVERYS within the GLO-HR MFC. for correspondence to other global multi-year products like GLORYS. BIORYS. etc. The core of WAVERYS is based on the MFWAM model. a third generation wave model that calculates the wave spectrum. i.e. the distribution of sea state energy in frequency and direction on a 1/5 degree irregular grid. Average wave quantities derived from this wave spectrum. such as the SWH (significant wave height) or the average wave period. are delivered on a regular 1/5 degree grid with a 3h time step. The wave spectrum is discretized into 30 frequencies obtained from a geometric sequence of first member 0.035 Hz and a reason 7.5. WAVERYS takes into account oceanic currents from the GLORYS12 physical ocean reanalysis and assimilates significant wave height observed from historical altimetry missions and directional wave spectra from Sentinel 1 SAR from 2017 onwards.",
                         doc_url = "https://data.marine.copernicus.eu/product/GLOBAL_MULTIYEAR_WAV_001_032/description",
                         citation = "In case of any publication, the Licensee will ensure credit the Copernicus Marine Service and cite the DOIs links guaranteeing the traceability of the scientific studies and experiments, in the following manner: \"This study has been conducted using E.U. Copernicus Marine Service Information; https://doi.org/10.48670/moi-00022",
                         license = "See http://marine.copernicus.eu/services-portfolio/service-commitments-and-licence/",
                         method = list("bb_handler_copernicus", product = "GLOBAL_MULTIYEAR_WAV_001_032"),
                         authentication_note = "Copernicus Marine login required, see http://marine.copernicus.eu/services-portfolio/register-now/",
                         user = "",
                         password = "",
                         ##access_function = "",
                         collection_size = 1100,
                         data_group = "Altimetry", warn_empty_auth = FALSE))
    }

    if (is.null(name) || any(name %in% tolower(c("Gridded Sea Level Heights and geostrophic currents - Antarctic Ocean", "SLA Ant")))) {
        out <- rbind(out,
                     bb_source(
                         name = "Gridded Sea Level Heights and geostrophic currents - Antarctic Ocean",
                         id = "SLA Ant",
                         description = "Experimental Ssalto/Duacs gridded multimission altimeter products dedicated to Antarctic Ocean. This dataset is one of the experimental products which are available on the SSALTO/DUACS experimental products. Multimission sea level heights computed with respect to a twenty-year mean and associated geostrophic current anomalies. The formal error is also included.",
                         doc_url = "https://www.aviso.altimetry.fr/en/data/products/sea-surface-height-products/regional/antarctic-sea-level-heights.html",
                         citation = "Auger M, Prandi P, Sall\ue9e JB (2022) Southern Ocean sea level anomaly in the sea ice-covered sector from multimission satellite observations. Sci Data 9:70. 10.1038/s41597-022-01166-z\nand\nAuger M, Prandi P (2019) Sea Level Anomaly from a Multi-Altimeter Combination in the Ice-Covered Southern Ocean. OSTST 2019",
                         source_url = "ftp://ftp-access.aviso.altimetry.fr/duacs-experimental/dt-phy-grids/altimetry_antarctic/",
                         license = "See https://www.aviso.altimetry.fr/fileadmin/documents/data/License_Aviso.pdf",
                         method = list("bb_handler_rget", level = 2),
                         authentication_note = "AVISO login required, see https://www.aviso.altimetry.fr/en/data/data-access/endatadata-accessregistration-form.html",
                         user = "",
                         password = "",
                         access_function = "raster",
                         collection_size = 4.5,
                         data_group = "Altimetry", warn_empty_auth = FALSE))
    }

    out
}
