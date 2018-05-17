#' Oceanographic data sources
#'
#' Data sources providing oceanographic data.
#'
#' \itemize{
#'   \item "CSIRO Atlas of Regional Seas 2009": CARS is a digital climatology, or atlas of seasonal ocean water properties
#'   \item "World Ocean Atlas 2009": World Ocean Atlas 2009 is included here for convenience but has been superseded by the World Ocean Atlas 2013 V2
#'   \item "World Ocean Atlas 2013 V2": World Ocean Atlas 2013 version 2 (WOA13 V2) is a set of objectively analyzed (1 degree grid) climatological fields of in situ temperature, salinity, dissolved oxygen, Apparent Oxygen Utilization (AOU), percent oxygen saturation, phosphate, silicate, and nitrate at standard depth levels for annual, seasonal, and monthly compositing periods for the World Ocean. It also includes associated statistical fields of observed oceanographic profile data interpolated to standard depth levels on 5 degree, 1 degree, and 0.25 degree grids
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
#' @seealso \code{\link{sources_altimetry}}, \code{\link{sources_meteorological}}, \code{\link{sources_ocean_colour}}, \code{\link{sources_reanalysis}}, \code{\link{sources_seaice}}, \code{\link{sources_sst}}, \code{\link{sources_topography}}
#'
#' @return a tibble with columns as specified by \code{\link{bb_source}}
#'
#' @examples
#' \dontrun{
#' ## define a configuration and add the Atlas of Regional Seas data to it
#' cf <- bb_config("/my/file/root")
#' src <- sources_oceanographic("CSIRO Atlas of Regional Seas 2009")
#' cf <- bb_add(cf,src)
#' }
#'
#' @export
sources_oceanographic <- function(name,formats,time_resolutions, ...) {
    if (!missing(name) && !is.null(name)) {
        assert_that(is.character(name))
        name <- tolower(name)
    } else {
        name <- NULL
    }
    out <- tibble()

    if (is.null(name) || any(name %in% tolower(c("CSIRO Atlas of Regional Seas 2009","cars2009")))) {
        out <- rbind(out,
                     bb_source(
                         name="CSIRO Atlas of Regional Seas 2009",
                         id="cars2009",
                         description="CARS is a digital climatology, or atlas of seasonal ocean water properties.",
                         doc_url="http://www.marine.csiro.au/~dunn/cars2009/",
                         citation="Ridgway K.R., J.R. Dunn, and J.L. Wilkin, Ocean interpolation by four-dimensional least squares -Application to the waters around Australia, J. Atmos. Ocean. Tech., Vol 19, No 9, 1357-1375, 2002",
                         source_url="http://www.marine.csiro.au/atlas/",
                         license="Please cite",
                         method=list("bb_handler_wget",accept_regex=".*2009.*.nc.gz",robots_off=TRUE), ## --recursive --level=1
                         postprocess=list("bb_gunzip"),
                         collection_size=2.8,
                         data_group="Oceanographic"))
    }

    if (is.null(name) || any(name %in% tolower(c("World Ocean Atlas 2009","WOA09")))) {
        out <- rbind(out,
                     bb_source(
                         name="World Ocean Atlas 2009",
                         id="WOA09",
                         description="World Ocean Atlas 2009 (WOA09) is a set of objectively analyzed (1 degree grid) climatological fields of in situ temperature, salinity, dissolved oxygen, Apparent Oxygen Utilization (AOU), percent oxygen saturation, phosphate, silicate, and nitrate at standard depth levels for annual, seasonal, and monthly compositing periods for the World Ocean. It also includes associated statistical fields of observed oceanographic profile data interpolated to standard depth levels on both 1 degree and 5 degree grids",
                         doc_url="http://www.nodc.noaa.gov/OC5/WOA09/pr_woa09.html",
                         citation="Citation for WOA09 Temperature: Locarnini, R. A., A. V. Mishonov, J. I. Antonov, T. P. Boyer, and H. E. Garcia, 2010. World Ocean Atlas 2009, Volume 1: Temperature. S. Levitus, Ed. NOAA Atlas NESDIS 68, U.S. Government Printing Office, Washington, D.C., 184 pp.\nCitation for WOA09 Salinity: Antonov, J. I., D. Seidov, T. P. Boyer, R. A. Locarnini, A. V. Mishonov, and H. E. Garcia, 2010. World Ocean Atlas 2009, Volume 2: Salinity. S. Levitus, Ed. NOAA Atlas NESDIS 69, U.S. Government Printing Office, Washington, D.C., 184 pp.\nCitation for WOA09 Oxygen: Garcia, H. E., R. A. Locarnini, T. P. Boyer, and J. I. Antonov, 2010. World Ocean Atlas 2009, Volume 3: Dissolved Oxygen, Apparent Oxygen Utilization, and Oxygen Saturation. S. Levitus, Ed. NOAA Atlas NESDIS 70, U.S. Government Printing Office, Washington, D.C., 344 pp.\nCitation for WOA09 Nutrients: Garcia, H. E., R. A. Locarnini, T. P. Boyer, and J. I. Antonov, 2010. World Ocean Atlas 2009, Volume 4: Nutrients (phosphate, nitrate, silicate). S. Levitus, Ed. NOAA Atlas NESDIS 71, U.S. Government Printing Office, Washington, D.C., 398 pp.",
                         license="Please cite",
                         source_url="https://data.nodc.noaa.gov/woa/WOA09/NetCDFdata/",
                         method=list("bb_handler_wget",robots_off=TRUE,reject="index.html*"), ## --recursive --no-parent
                         postprocess=NULL,
                         collection_size=6.0,
                         data_group="Oceanographic"))
    }

    if (is.null(name) || any(name %in% tolower(c("World Ocean Atlas 2013 V2","WOA13V2")))) {
        out <- rbind(out,
                     bb_source(
                         name="World Ocean Atlas 2013 V2",
                         id="WOA13V2",
                         description="World Ocean Atlas 2013 version 2 (WOA13 V2) is a set of objectively analyzed (1 degree grid) climatological fields of in situ temperature, salinity, dissolved oxygen, Apparent Oxygen Utilization (AOU), percent oxygen saturation, phosphate, silicate, and nitrate at standard depth levels for annual, seasonal, and monthly compositing periods for the World Ocean. It also includes associated statistical fields of observed oceanographic profile data interpolated to standard depth levels on 5 degree, 1 degree, and 0.25 degree grids",
                         doc_url="https://www.nodc.noaa.gov/OC5/woa13/",
                         citation="Citation for WOA13 Temperature:\nLocarnini, R. A., A. V. Mishonov, J. I. Antonov, T. P. Boyer, H. E. Garcia, O. K. Baranova, M. M. Zweng, C. R. Paver, J. R. Reagan, D. R. Johnson, M. Hamilton, and D. Seidov, 2013. World Ocean Atlas 2013, Volume 1: Temperature. S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 73, 40 pp.\nCitation for WOA13 Salinity:\nZweng, M.M, J.R. Reagan, J.I. Antonov, R.A. Locarnini, A.V. Mishonov, T.P. Boyer, H.E. Garcia, O.K. Baranova, D.R. Johnson, D.Seidov, M.M. Biddle, 2013. World Ocean Atlas 2013, Volume 2: Salinity. S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 74, 39 pp.\nCitation for WOA13 Oxygen:\nGarcia, H. E., R. A. Locarnini, T. P. Boyer, J. I. Antonov, O.K. Baranova, M.M. Zweng, J.R. Reagan, D.R. Johnson, 2014. World Ocean Atlas 2013, Volume 3: Dissolved Oxygen, Apparent Oxygen Utilization, and Oxygen Saturation. S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 75, 27 pp.\nCitation for WOA13 Nutrients:\nGarcia, H. E., R. A. Locarnini, T. P. Boyer, J. I. Antonov, O.K. Baranova, M.M. Zweng, J.R. Reagan, D.R. Johnson, 2014. World Ocean Atlas 2013, Volume 4: Dissolved Inorganic Nutrients (phosphate, nitrate, silicate). S. Levitus, Ed., A. Mishonov Technical Ed.; NOAA Atlas NESDIS 76, 25 pp.",
                         license="Please cite",
                         source_url="https://data.nodc.noaa.gov/woa/WOA13/DATAv2/",
                         method=list("bb_handler_wget",level=5,robots_off=TRUE,reject="index.html*",reject_regex="/(ascii|csv|shape|5564|6574|7584|8594|95A4|A5B2)/"), ## --recursive --no-parent
                         comment="Only the long-term (not per-decade) netcdf files are retrieved here: adjust the method reject_regex parameter if you want ascii, csv, or shapefiles, or per-decade files.",
                         postprocess=NULL,
                         collection_size=57,
                         data_group="Oceanographic"))
    }
    out
}
