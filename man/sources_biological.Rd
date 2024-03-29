% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sources_biological.R
\name{sources_biological}
\alias{sources_biological}
\title{Biological data sources}
\usage{
sources_biological(name, formats, time_resolutions, ...)
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
Data sources providing selected Southern Ocean biological data sets. Please note that this is not intended to be a comprehensive collection of such data. Users are referred to the SCAR Standing Committee on Antarctic Data Management (\url{https://www.scar.org/data-products/scadm/}) and in particular the Antarctic Master Directory metadata catalogue (\url{http://gcmd.nasa.gov/portals/amd/}).
}
\details{
\itemize{
  \item "Southern Ocean Continuous Plankton Recorder": zooplankton species, numbers and abundance data are recorded on a continuous basis while vessels are in transit
  \item "SEAPODYM Zooplankton & Micronekton weekly potential and biomass distribution": outputs of the SEAPODYM Low and Mid-Trophic Levels (LMTL) model, which simulates the spatial and temporal dynamics of six micronekton and one zooplankton functional groups between the sea surface and ~1000m depth
  \item "SCAR RAATD model outputs": Single-species habitat importance maps for 17 species of Antarctic and subantarctic seabirds, marine mammals, and penguins
  \item "SCAR RAATD data filtered": Tracking data from 17 species of Antarctic and subantarctic seabirds, marine mammals, and penguins. This data set is the 'filtered' version of the data files
  \item "SCAR RAATD data standardised": Tracking data from 17 species of Antarctic and subantarctic seabirds, marine mammals, and penguins. This data set is the 'standardized' version of the data files
  \item "Myctobase": A circumpolar database of Southern Ocean mesopelagic fish surveys, including occurrence and abundance information, as well as trait-based information of individuals including standard length, weight and life stage
}

The returned tibble contains more information about each source.
}
\examples{
## our local directory to store the data
my_data_dir <- tempdir()
cf <- bb_config(my_data_dir)

## our data source to download
src <- sources("Myctobase")

## add to our config
cf <- bb_add(cf, src)

## and sync it
if (interactive()) {
  status <- bb_sync(cf)
}

## or equivalently
if (interactive()) {
  status <- bb_get(sources("Myctobase"), local_file_root = my_data_dir)
}

}
\references{
See the \code{doc_url} and \code{citation} field in each row of the returned tibble for references associated with these particular data sources
}
\seealso{
\code{\link{sources_altimetry}}, \code{\link{sources_meteorological}}, \code{\link{sources_oceanographic}}, \code{\link{sources_reanalysis}}, \code{\link{sources_sdm}}, \code{\link{sources_seaice}}, \code{\link{sources_sst}}, \code{\link{sources_topography}}
}
