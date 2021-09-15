#' Search the PolarView catalogue
#'
#' @references 
#' @param acquisition_date: 
#' @param formats: 
#' @param polygon: 
#' @param verbose: 
#'
#' @return 
#'
#' @seealso \code{\link{}}
#'
#' @examples
#'
#' @export
bb_polarview_search <- function(acquisition_date = Sys.Date() + -14:0, formats = c("jpg", "tif"), polygon = NULL, verbose = FALSE) {
    if (!is.null(polygon)) {
        if (inherits(polygon, "sfc_POLYGON")) polygon <- st_as_text(st_transform(polygon, "epsg:3031"))
        assert_that(is.string(polygon))
    }
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
        index_url$query <- list(service = "WFS", version = "1.0.0", request = "GetFeature", typeName = "polarview:vw_last200s1subsets", srsName = "EPSG:4326", outputFormat = "csv", cql_filter = paste0("acqtime>=", acq_date, "T00:00:00.000 AND acqtime<=", acq_date, "T23:59:59.999", if (!is.null(polygon)) paste0(" AND INTERSECTS(geom, ", polygon, ")")))
        index_url <- httr::build_url(index_url)
        ##index_url <- paste0(geo_url, "?service=WFS&version=1.0.0&request=GetFeature&typeName=polarview:vw_last200s1subsets&srsName=EPSG:4326&outputFormat=csv&cql_filter=acqtime>=", acq_date, "T00:00:00.000 AND acqtime<=", acq_date, "T23:59:59.999 AND INTERSECTS(geom, ", sector_polygon_3031, ")")
        this <- httr::GET(index_url)
        this <- read.csv(text = httr::content(this, as = "text"), stringsAsFactors = FALSE)
        if (nrow(this) > 0) {
            if (verbose) cat(sprintf("%d images\n", nrow(this)))
            this <- sub("\\.tif", "", this$filename, ignore.case = TRUE)
            ## list of URLs for each desired format
            if ("jpg" %in% formats)
                out <- c(out, file.path(jpg_url, acq_ym, paste0(this, ".jpg")))
            if ("tif" %in% formats)
                out <- c(out, file.path(tif_url, paste0(this, ".tif.tar.gz")))
            if ("jp2" %in% formats)
                out <- c(out, file.path(jp2_url, acq_ym, paste0(this, ".16bit.jp2")))
        } else {
            if (verbose) cat("no images\n")
        }
    }
    out
}
