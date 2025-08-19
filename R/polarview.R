#' Search the PolarView catalogue
#'
#' This function is used by [bb_handler_polarview()]. Users probably won't need to use it directly.
#'
#' @references <https://www.polarview.aq>
#' @param acquisition_date Date: the allowable image acquisition dates
#' @param formats character: one or more of "jpg" (jpg preview images) "jp2" or "geotiff". Note that the geotiffs are much larger than the jpg previews
#' @param polygon string or sfc_POLYGON: either an \code{sfc_POLYGON} or a string giving a polygon in WKT format and EPSG:3031 projection. Only images intersecting this polygon will be returned
#' @param max_results integer: maximum number of results to return
#' @param verbose logical: if `TRUE`, show additional progress output
#'
#' @return A character vector of image URLs
#'
#' @export
bb_polarview_search <- function(acquisition_date = Sys.Date() + -14:0, formats = c("jpg", "geotiff"), polygon = NULL, max_results = 200L, verbose = FALSE) {
    if (!is.null(polygon)) {
        if (inherits(polygon, "sfc_POLYGON")) polygon <- sf::st_as_text(sf::st_transform(polygon, "EPSG:3031"))
        assert_that(is.string(polygon))
    }
    assert_that(is.character(formats))
    formats <- tolower(formats)
    if (!all(formats %in% c("jpg", "jp2", "geotiff", "tif"))) stop("formats must be one or more of 'jpg', 'jp2', 'geotiff'") ## silently accept "tif" for backwards-compatibility
    assert_that(is.numeric(max_results), max_results > 0)
    ## base URLs
    geo_url <- "https://geos.polarview.aq/geoserver/polarview/ows"
    jpg_url <- "https://www.polarview.aq/images/106_S1jpgsmall"
    tif_url <- "https://www.polarview.aq/images/104_S1geotiff"
    jp2_url <- "https://www.polarview.aq/images/113_S1jpeg2000full16bit"
    out <- character()
    for (didx in seq_along(acquisition_date)) {
        acq_ym <- format(acquisition_date[didx], "%Y%m") ## e.g. 201808
        acq_date <- format(acquisition_date[didx], "%Y-%m-%d") ## e.g. 2018-08-19
        if (verbose) cat(sprintf("fetching image index for %s ... ", acq_date))
        index_url <- httr::parse_url(geo_url)
        index_url$query <- list(service = "WFS", version = "1.0.0", request = "GetFeature", typeName = "polarview:vw_s1subsets", maxFeatures = as.integer(max_results), srsName = "EPSG:4326", outputFormat = "csv", cql_filter = paste0("acqtime>=", acq_date, "T00:00:00.000 AND acqtime<=", acq_date, "T23:59:59.999", if (!is.null(polygon)) paste0(" AND INTERSECTS(geom, ", polygon, ")")))
        index_url <- httr::build_url(index_url)
        ##index_url <- paste0(geo_url, "?service=WFS&version=1.0.0&request=GetFeature&typeName=polarview:vw_last200s1subsets&srsName=EPSG:4326&outputFormat=csv&cql_filter=acqtime>=", acq_date, "T00:00:00.000 AND acqtime<=", acq_date, "T23:59:59.999 AND INTERSECTS(geom, ", sector_polygon_3031, ")")
        this <- httr::GET(index_url)
        this <- read.csv(text = httr::content(this, as = "text"), stringsAsFactors = FALSE)
        if (nrow(this) > 0) {
            if (verbose) cat(sprintf("%d images\n", nrow(this)))
            this <- sub("\\.tif", "", this$filename, ignore.case = TRUE)
            ## list of URLs for each desired format
            if ("jpg" %in% formats) out <- c(out, file.path(jpg_url, acq_ym, paste0(this, ".jpg")))
            if (any(c("geotiff", "tif") %in% formats)) out <- c(out, file.path(tif_url, paste0(this, ".tif.tar.gz")))
            if ("jp2" %in% formats) out <- c(out, file.path(jp2_url, acq_ym, paste0(this, ".16bit.jp2")))
        } else {
            if (verbose) cat("no images\n")
        }
    }
    out
}
