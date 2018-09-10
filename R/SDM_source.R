#' Dataset of environmental descriptors for Species Distribution Models applied for Southern Ocean case studies
#'
#' Environmental descriptors dataset (58 layers)
#' All environmental descriptors are set at a 0.1 degree grid-cell resolution, on the Southern Ocean extent (80 to 45 degrees S, -180 to 180 degrees). Provided as a collection of netCDF files. Sources and details are available in the attached metadata file.
#'
#' \itemsize{
#'   \item depth Bathymetry of the region (in meters)
#'   \item geomorphology Seafloor geomorphic feature dataset, 27 categories
#'    \item sediments Sediment features, 14 categories
#'    \item slope Seafloor slope, derived from bathymetry layer (in degrees)
#'    \item roughness Seafloor roughness, derived from bathymetry layer (unitless)
#'    \item mixed_layer_depth Summer mixed layer depth climatology from ARGOS data (in kilometers)
#'    \item seasurface_current_speed Current speed near the surface (2.5m depth); derived from the CAISOM model, based on ROMS
#'    \item seafloor_current_speed Current speed near the sea floor; derived from the CAISOM model, based on ROMS
#'    \item distance_antarctica Distance to the nearest part of Antarctic continent (in kilometers)
#'    \item distance_canyon Distance to the axis of the nearest canyon (in kilometers)
#'    \item distance_max_ice_edge Mean maximum winter sea ice extent derived from daily estimates of sea ice concentration (in kilometers)
#'    \item distance_shelf Distance to nearest area of sea floor of depth 500m or less (in kilometers)
#'    \item ice_cover_max Ice concentration fraction, maximum on 1957-2017 time period (unitless)
#'    \item ice_cover_mean Ice concentration fraction, mean on 1957-2017 time period (unitless)
#'    \item ice_cover_min Ice concentration fraction, minimum on 1957-2017 time period (unitless)
#'    \item ice_cover_range Ice concentration fraction, difference maximum-minimum on 1957-2017 time period (unitless)
#'    \item ice_thickness_max Ice thickness, maximum on 1957-2017 time period (in meters)
#'    \item ice_thickness_mean Ice thickness, mean on 1957-2017 time period (in meters)
#'    \item ice_thickness_min Ice thickness, minimum on 1957-2017 time period (in meters)
#'    \item ice_thickness_range Ice thickness, difference maximum-minimum on 1957-2017 time period (in meters)
#'    \item chla_ampli_alltime_2005_2012 Chlorophyll a concentrations obtained from MODIS satellite images. Amplitude of pixel values (difference between maximal and minimal values encountered by each pixel during all months of the period 2005-2012) (in mg.m-3)
#'    \item chla_max_alltime_2005_2012 Chlorophyll a concentrations obtained from MODIS satellite images. Maximal value encountered by each pixel during all months of the period 2005-2012 (in mg.m-3)
#'    \item chla_mean_alltime_2005_2012 Chlorophyll a concentrations obtained from MODIS satellite images. Mean value of each pixel during all months of the period 2005-2012 (in mg.m-3)
#'    \item chla_min_alltime_2005_2012 Chlorophyll a concentrations obtained from MODIS satellite images. Minimal value encountered by each pixel during all months of the period 2005-2012 (in mg.m-3)
#'    \item chla_sd_alltime_2005_2012 Chlorophyll a concentrations obtained from MODIS satellite images. Standard deviation value of each pixel during all months of the period 2005-2012 (in mg.m-3)
#'    \item POC_2005_2012_ampli Particulate organic carbon; model Lutz et al. (2007) [10]. Amplitude value (difference maximal and minimal values, see previous layers) of all average seasonal layers of 2005-2012 (in gC.m-2.d-1)
#'    \item POC_2005_2012_max Particulate organic carbon; model Lutz et al. (2007) [10]. Maximal value encountered on each pixel among all seasonal layers of 2005-2012 (in gC.m-2.d-1)
#'    \item POC_2005_2012_mean Particulate organic carbon; model Lutz et al. (2007) [10]. Mean of all seasonal layers of 2005-2012 (in gC.m-2.d-1)
#'    \item POC_2005_2012_min Particulate organic carbon; model Lutz et al. (2007) [10]. Minimal value encountered on each pixel among all seasonal layers of 2005-2012 (in gC.m-2.d-1)
#'    \item POC_2005_2012_sd Particulate organic carbon; model Lutz et al. (2007) [10]. Standard deviation all seasonal layers of 2005-2012 (in gC.m-2.d-1)
#'    \item seafloor_oxy_19552012_ampli Amplitude (difference max/ min) value encountered for each pixel on all month layers of seafloor temperature over 2005-2012 (in mL.L-1)
#'    \item seafloor_oxy_19552012_max Maximum value encountered for each pixel on all month layers of seafloor temperature over 2005-2012 (in mL.L-1)
#'    \item seafloor_oxy_19552012_mean Mean seafloor temperature over 2005-2012 (average of all monthly layers) (in mL.L-1)
#'    \item seafloor_oxy_19552012_min Minimum value encountered for each pixel on all month layers of seafloor temperature over 2005-2012 (in mL.L-1)
#'    \item seafloor_oxy_19552012_sd Standard deviation seafloor temperature over 2005-2012 (of all monthly layers) (in mL.L-1)
#'    \item seafloor_sali_2005_2012_ampli Amplitude (difference max/ min) value encountered for each pixel on all month layers of seafloor salinity over 2005-2012 (in PSS)
#'    \item seafloor_sali_2005_2012_max Maximum value encountered for each pixel on all month layers of seafloor salinity over 2005-2012 (in PSS)
#'    \item seafloor_sali_2005_2012_mean Mean seafloor salinity over 2005-2012 (average of all monthly layers) (in PSS)
#'    \item seafloor_sali_2005_2012_min Minimum value encountered for each pixel on all month layers of seafloor salinity over 2005-2012 (in PSS)
#'   \item seafloor_sali_2005_2012_sd Standard deviation seafloor salinity over 2005-2012 (of all monthly layers) (in PSS)
#'   \item seafloor_temp_2005_2012_ampli Amplitude (difference max/min) value encountered for each pixel on all month layers of seafloor temperature over 2005-2012 (in °C)
#'    \item seafloor_temp_2005_2012_max Maximum value encountered for each pixel on all monthly layers of seafloor temperature over 2005-2012 (in °C)
#'    \item seafloor_temp_2005_2012_mean Mean seafloor temperature over 2005-2012 (average of all monthly layers) (in °C)
#'    \item seafloor_temp_2005_2012_min Minimum value encountered for each pixel on all monthly layers of seafloor temperature over 2005-2012 (in °C)
#'    \item seafloor_temp_2005_2012_sd Standard deviation seafloor temperature over 2005-2012 (of all monthly layers) (in °C)
#'    \item extreme_event_max_chl_2005_2012_ampli Amplitude value (Maximum-Minimum) of the number of extreme events (maximal chlorophyll a concentrations) recorded between 2005 and 2012
#'    \item extreme_event_max_chl_2005_2012_max Maximum number of extreme events (maximal chlorophyll a concentrations) recorded between 2005 and 2012
#'    \item extreme_event_max_chl_2005_2012_mean Mean of the number of extreme events (maximal chlorophyll a concentrations) recorded between 2005 and 2012
#'    \item extreme_event_max_chl_2005_2012_min Minimum number of extreme events (maximal chlorophyll a concentrations) recorded between 2005 and 2012
#'    \item extreme_event_min_chl_2005_2012_ampli Amplitude value (Maximum-Minimum) of the number of extreme events (minimal chlorophyll a concentrations) recorded between 2005 and 2012
#'    \item extreme_event_min_chl_2005_2012_max Maximum number of extreme events (minimal chlorophyll a concentrations) recorded between 2005 and 2012
#'    \item extreme_event_min_chl_2005_2012_mean Mean of the number of extreme events (minimal chlorophyll a concentrations) recorded between 2005 and 2012
#'    \item extreme_event_min_chl_2005_2012_min Minimum number of extreme events (minimal chlorophyll a concentrations) recorded between 2005 and 2012
#'    \item extreme_event_min_oxy_1955_2012_nb Number of extreme events (minimal seafloor oxygen concentration records) that happened between January and December of the year
#'    \item extreme_event_max_sali_2005_2012_nb Number of extreme events (maximal seafloor salinity records) that happened between January and December of the year
#'    \item extreme_event_min_sali_2005_2012_nb Number of extreme events (minimal seafloor salinity records) that happened between January and December of the year
#'    \item extreme_event_max_temp_2005_2012_nb Number of extreme events (maximal seafloor temperature records) that happened between January and December of the year
#'    \item extreme_event_min_temp_2005_2012_nb Number of extreme events (minimal seafloor temperature records) that happened between January and December of the year
#'   }
#' A metadata file with extradocumentation and sources is provided in <xxx>
#'
#' @param name character vector: only return data sources with name or id matching these values
#' @param formats character: for some sources, the format can be specified. See the list of sources above for details
#' @param time_resolutions character: for some sources, the time resolution can be specified. See the list of sources above for details
#' @param ... : additional source-specific parameters. See the list of sources above for details
#'
#' @references See the \code{xx} field of the metadata file for references associated with these particular data sources
#'
#' @seealso \code{\link{sources_meteorological}}, \code{\link{sources_ocean_colour}}, \code{\link{sources_oceanographic}}, \code{\link{sources_reanalysis}}, \code{\link{sources_seaice}}, \code{\link{sources_sst}}, \code{\link{sources_topography}}
#'
#' @return a RasterStack with 58 environmental descriptors raster layers
#'
#' @examples
#' ## see the vignette
#'
