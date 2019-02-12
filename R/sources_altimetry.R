#' Altimetry data sources
#'
#' Data sources providing (typically satellite-derived) altimetry data.
#'
#' \itemize{
#'   \item "CMEMS global gridded SSH reprocessed (1993-ongoing)": Global Ocean - Multimission altimeter satellite gridded sea surface heights and derived variables computed with respect to a twenty-year mean. All the missions are homogenized with respect to a reference mission which is currently OSTM/Jason-2
#'   \item "CMEMS global gridded SSH near-real-time": near-real-time version of 'CMEMS global gridded SSH reprocessed (1993-ongoing)'
#'   \item "CNES-CLS2013 Mean Dynamic Topography": CNES-CLS2013 Mean dynamic topography over the 1993-2012 period of the sea surface height above geoid. The MDT_CNES-CLS13 is an estimate of the ocean MDT for the 1993-2012 period. Since April 2014 (Duacs 2014, v15.0 version), the Ssalto/Duacs (M)SLA products are computed relative to 1993-2012 period that is consistent with this new MDT CNES-CLS13. Based on 2 years of GOCE data, 7 years of GRACE data, and 20 years of altimetry and in-situ data (hydrologic and drifters data)
#'   \item "Near-real-time finite size Lyapunov exponents": These products provide the exponential rate of separation of particle trajectories initialized nearby and advected by altimetry velocities. FSLEs highlight the transport barriers that control the horizontal exchange of water in and out of eddy cores.
#'   \item "Delayed-time finite size Lyapunov exponents": These products provide the exponential rate of separation of particle trajectories initialized nearby and advected by altimetry velocities. FSLEs highlight the transport barriers that control the horizontal exchange of water in and out of eddy cores.
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
#' @seealso \code{\link{sources_biological}}, \code{\link{sources_meteorological}}, \code{\link{sources_ocean_colour}}, \code{\link{sources_oceanographic}}, \code{\link{sources_reanalysis}}, \code{\link{sources_sdm}}, \code{\link{sources_seaice}}, \code{\link{sources_sst}}, \code{\link{sources_topography}}
#'
#' @return a tibble with columns as specified by \code{\link{bb_source}}
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
    if (is.null(name) || any(name %in% tolower(c("CMEMS global gridded SSH reprocessed (1993-ongoing)", "SEALEVEL_GLO_PHY_L4_REP_OBSERVATIONS_008_047")))) {
        out <- rbind(out,
                     bb_source(
                         name = "CMEMS global gridded SSH reprocessed (1993-ongoing)",
                         id = "SEALEVEL_GLO_PHY_L4_REP_OBSERVATIONS_008_047",
                         description = "For the Global Ocean - Multimission altimeter satellite gridded sea surface heights and derived variables computed with respect to a twenty-year mean. Previously distributed by Aviso+, no change in the scientific content. All the missions are homogenized with respect to a reference mission which is currently OSTM/Jason-2.\nVARIABLES\n- sea_surface_height_above_sea_level (SSH)\n- surface_geostrophic_eastward_sea_water_velocity_assuming_sea_level_for_geoid (UVG)\n- surface_geostrophic_northward_sea_water_velocity_assuming_sea_level_for_geoid (UVG)\n- sea_surface_height_above_geoid (SSH)\n- surface_geostrophic_eastward_sea_water_velocity (UVG)\n- surface_geostrophic_northward_sea_water_velocity (UVG)",
                         doc_url = "http://marine.copernicus.eu/services-portfolio/access-to-products/?option=com_csw&view=details&product_id=SEALEVEL_GLO_PHY_L4_REP_OBSERVATIONS_008_047",
                         citation = "In case of any publication, the Licensee will ensure credit the Copernicus Marine Service in the following manner: \"This study has been conducted using E.U. Copernicus Marine Service Information\"",
                         source_url = "ftp://my.cmems-du.eu/Core/SEALEVEL_GLO_PHY_L4_REP_OBSERVATIONS_008_047/dataset-duacs-rep-global-merged-allsat-phy-l4/",
                         license = "See http://marine.copernicus.eu/services-portfolio/service-commitments-and-licence/",
                         method = list("bb_handler_rget", level = 3),
                         authentication_note = "Copernicus Marine login required, see http://marine.copernicus.eu/services-portfolio/register-now/",
                         user = "",
                         password = "",
                         access_function = "raadtools::readssh",
                         collection_size = 310,
                         data_group = "Altimetry", warn_empty_auth = FALSE))
    }

    if (is.null(name) || any(name %in% tolower(c("CMEMS global gridded SSH near-real-time", "SEALEVEL_GLO_PHY_L4_NRT_OBSERVATIONS_008_046")))) {
        out <- rbind(out,
                     bb_source(
                         name = "CMEMS global gridded SSH near-real-time",
                         id = "SEALEVEL_GLO_PHY_L4_NRT_OBSERVATIONS_008_046",
                         description = "For the Global Ocean - Multimission altimeter satellite gridded sea surface heights and derived variables computed with respect to a twenty-year mean. Previously distributed by Aviso+, no change in the scientific content. All the missions are homogenized with respect to a reference mission which is currently Jason-3. The acquisition of various altimeter data is a few days at most.\nVARIABLES\n- sea_surface_height_above_sea_level (SSH)\n- surface_geostrophic_eastward_sea_water_velocity_assuming_sea_level_for_geoid (UVG)\n- surface_geostrophic_northward_sea_water_velocity_assuming_sea_level_for_geoid (UVG)\n- sea_surface_height_above_geoid (SSH)\n- surface_geostrophic_eastward_sea_water_velocity (UVG)\n- surface_geostrophic_northward_sea_water_velocity (UVG)",
                         doc_url = "http://marine.copernicus.eu/services-portfolio/access-to-products/?option=com_csw&view=details&product_id=SEALEVEL_GLO_PHY_L4_NRT_OBSERVATIONS_008_046",
                         citation = "In case of any publication, the Licensee will ensure credit the Copernicus Marine Service in the following manner: \"This study has been conducted using E.U. Copernicus Marine Service Information\"",
                         source_url = "ftp://nrt.cmems-du.eu/Core/SEALEVEL_GLO_PHY_L4_NRT_OBSERVATIONS_008_046/dataset-duacs-nrt-global-merged-allsat-phy-l4/",
                         license = "See http://marine.copernicus.eu/services-portfolio/service-commitments-and-licence/",
                         method = list("bb_handler_rget", level = 4),
                         authentication_note = "Copernicus Marine login required, see http://marine.copernicus.eu/services-portfolio/register-now/",
                         user = "",
                         password = "",
                         access_function = "raadtools::readssh",
                         collection_size = 3,
                         data_group = "Altimetry", warn_empty_auth = FALSE))
    }

    if (is.null(name) || any(name %in% tolower(c("CNES-CLS2013 Mean Dynamic Topography", "CNES-CLS2013 MDT")))) {
        out <- rbind(out,
                     bb_source(
                         name = "CNES-CLS2013 Mean Dynamic Topography",
                         id = "CNES-CLS2013 MDT",
                         description = "CNES-CLS2013 Mean dynamic topography over the 1993-2012 period of the sea surface height above geoid. The MDT_CNES-CLS13 is an estimate of the ocean MDT for the 1993-2012 period. Since April 2014 (Duacs 2014, v15.0 version), the Ssalto/Duacs (M)SLA products are computed relative to 1993-2012 period that is consistent with this new MDT CNES-CLS13. Based on 2 years of GOCE data, 7 years of GRACE data, and 20 years of altimetry and in-situ data (hydrologic and drifters data).",
                         doc_url = "https://www.aviso.altimetry.fr/en/data/products/auxiliary-products/mdt.html",
                         citation = "Rio, M-H, P. Schaeffer, G. Moreaux, J-M Lemoine, E. Bronner (2009) : A new Mean Dynamic Topography computed over the global ocean from GRACE data, altimetry and in-situ measurements . Poster communication at OceanObs09 symposium, 21-25 September 2009, Venice.",
                         source_url = "ftp://ftp-access.aviso.altimetry.fr/auxiliary/mdt/mdt_cnes_cls2013_global/",
                         license = "See https://www.aviso.altimetry.fr/fileadmin/documents/data/License_Aviso.pdf",
                         ##method = list("bb_handler_wget"), ## --recursive --level=1 --no-parent
                         method = list("bb_handler_rget", level = 1),
                         postprocess = list("bb_gunzip"),
                         authentication_note = "AVISO login required, see https://www.aviso.altimetry.fr/en/data/data-access/endatadata-accessregistration-form.html",
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
    out
}
