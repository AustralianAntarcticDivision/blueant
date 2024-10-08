% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sources_topography.R
\name{sources_topography}
\alias{sources_topography}
\title{Topographical data sources}
\usage{
sources_topography(name, formats, time_resolutions, ...)
}
\arguments{
\item{name}{character vector: only return data sources with name or id matching these values}

\item{formats}{character: for some sources, the format can be specified. See the list of sources above for details}

\item{time_resolutions}{character: for some sources, the time resolution can be specified. See the list of sources above for details}

\item{...}{: additional source-specific parameters. See the list of sources above for details}
}
\value{
a tibble with columns as specified by \code{\link{bb_source}}
}
\description{
Data sources providing topographical data.
}
\details{
\itemize{
  \item "Smith and Sandwell bathymetry": Global seafloor topography from satellite altimetry and ship depth soundings
  \item "GEBCO 2014 bathymetry": Global bathymetric grid at 30 arc-second intervals
  \item "GEBCO 2019 bathymetry": Global bathymetric grid at 15 arc-second intervals
  \item "GEBCO 2021 bathymetry": The GEBCO_2021 Grid is a global terrain model for ocean and land, providing elevation data, in meters, on a 15 arc-second interval grid. It includes a number of additonal data sets compared to the GEBCO_2020 Grid. The grid is accompanied by a Type Identifier (TID) Grid, giving information on the types of source data that the GEBCO_2021 Grid is based on. The primary GEBCO_2021 grid contains land and ice surface elevation information - as provided for previous GEBCO grid releases. In addition, for the 2021 release, we have made available a version with under-ice topography/bathymetry information for Greenland and Antarctica
  \item "GECO 2024 bathymetry": The GEBCO_2024 Grid is a global terrain model for ocean and land, providing elevation data, in meters, on a 15 arc-second interval grid of 43200 rows x 86400 columns, giving 3,732,480,000 data points. The data values are pixel-centre registered i.e. they refer to elevations, in meters, at the centre of grid cells.
  \item "ETOPO1 bathymetry": ETOPO1 is a 1 arc-minute global relief model of Earth's surface that integrates land topography and ocean bathymetry
  \item "ETOPO2 bathymetry": 2-Minute Gridded Global Relief Data (ETOPO2v2c)
  \item "Bedmap2": Bedmap2 is a suite of gridded products describing surface elevation, ice-thickness and the sea floor and subglacial bed elevation of the Antarctic south of 60S
  \item "Revision of the Kerguelen Plateau bathymetric grid": digital elevation model (DEM) for the Kerguelen Plateau region. Superseded by "AusBathyTopo (Kerguelen Plateau) 100m 2022"
  \item "AusBathyTopo (Kerguelen Plateau) 100m 2022": bathymetry (depth) products from the compilation of all available source bathymetry data within the Kerguelen Plateau into a 100 m-resolution Digital Elevation Mode. Supersedes "Revision of the Kerguelen Plateau bathymetric grid"
  \item "George V bathymetry": Digital Elevation Models (DEMs) of varying resolutions for the George V and Terre Adelie continental margin, derived by incorporating all available singlebeam and multibeam point depth data
  \item "Geoscience Australia multibeam bathymetric grids of the Macquarie Ridge": This is a compilation of all the processed multibeam bathymetry data that are publicly available in Geoscience Australia's data holding for the Macquarie Ridge
  \item "IBCSO bathymetry": The International Bathymetric Chart of the Southern Ocean (IBCSO) Version 1.0 is a digital bathymetric model portraying the seafloor of the circum-Antarctic waters south of 60S. IBCSO Version 1.0 has been compiled from all available bathymetric data collectively gathered by more than 30 institutions from 15 countries, including multibeam and single-beam echo soundings, digitized depths from nautical charts, regional bathymetric gridded compilations, and predicted bathymetry
  \item "IBCSO chart for printing": The IBCSO Poster, 2013, is a polar stereographic view of the Southern Ocean displaying bathymetric contours south of 60S at a scale of 1:7,000,000
  \item "IBCSOv2 bathymetry": The International Bathymetric Chart of the Southern Ocean Version 2 (IBCSO v2) is a digital bathymetric model for the area south of 50S with special emphasis on the bathymetry of the Southern Ocean. IBCSO v2 has a resolution of 500 m x 500 m in a Polar Stereographic projection. The total data coverage of the seafloor is 23.79% with a multibeam-only data coverage of 22.32%. The remaining 1.47% include singlebeam and other data. IBCSO v2 is the most authoritative seafloor map of the area south of 50S.
  \item "RTOPO-1 Antarctic ice shelf topography": a consistent dataset of Antarctic ice sheet topography, cavity geometry, and global bathymetry
  \item "Radarsat Antarctic digital elevation model V2": The high-resolution Radarsat Antarctic Mapping Project (RAMP) digital elevation model (DEM) combines topographic data from a variety of sources to provide consistent coverage of all of Antarctica. Version 2 improves upon the original version by incorporating new topographic data, error corrections, extended coverage, and other modifications
  \item "New Zealand Regional Bathymetry 2016": The NZ 250m gridded bathymetric data set and imagery, Mitchell et al. 2012, released 2016
  \item "Cryosat-2 digital elevation model": a digital elevation model of Antarctica derived from 6 years of continuous CryoSat-2 measurements
  \item "Natural Earth 10m physical vector data": Natural Earth is a public domain map dataset available at 1:10m, 1:50m, and 1:110 million scales
  \item "GSHHG coastline data": a Global Self-consistent, Hierarchical, High-resolution Geography Database
  \item "Shuttle Radar Topography Mission elevation data SRTMGL1 V3": Global 1-arc-second topographic data generated from NASA's Shuttle Radar Topography Mission. Version 3.0 (aka SRTM Plus or Void Filled) removes all of the void areas by incorporating data from other sources such as the ASTER GDEM
  \item "Reference Elevation Model of Antarctica mosaic tiles": The Reference Elevation Model of Antarctica (REMA) is a high resolution, time-stamped digital surface model of Antarctica at 8-meter spatial resolution (and reduced-resolution, resampled versions). Accepts a single \code{spatial_resolution} value of "1km", "200m" [default], "100m", "8m"
  \item "EGM2008 GIS Data": Global 2.5 Minute Geoid Undulations.
  \item "AAS_4116_Coastal_Complexity": This dataset provides a characterisation of Antarctic coastal complexity. At each point, a complexity metric is calculated at length scales from 1 to 256 km, giving a multiscale estimate of the magnitude and direction of undulation or complexity at each point location along the entire coastline.
}

The returned tibble contains more information about each source.
}
\examples{
\dontrun{
## define a configuration and add the Smith and Sandwell bathymetry
cf <- bb_config("/my/file/root") \%>\%
  bb_add(sources_topography("Smith and Sandwell bathymetry"))
}
}
\references{
See the \code{doc_url} and \code{citation} field in each row of the returned tibble for references associated with these particular data sources
}
\seealso{
\code{\link{sources_altimetry}}, \code{\link{sources_biological}}, \code{\link{sources_meteorological}}, \code{\link{sources_ocean_colour}}, \code{\link{sources_oceanographic}}, \code{\link{sources_reanalysis}}, \code{\link{sources_sdm}}, \code{\link{sources_seaice}}, \code{\link{sources_sst}}
}
