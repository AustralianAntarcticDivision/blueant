#' Handler for Polarview Sentinel-1 data
#'
#' This is a handler function to be used with Sentinel-1 data from https://polarview.aq. This function is not intended to be called directly, but rather is specified as a \code{method} option in \code{\link{bb_source}}.
#'
#' @references https://polarview.aq
#'
#' @param ... : parameters passed to \code{\link{bb_rget}}
#'
#' @return \code{TRUE} on success
#'
#' @export
bb_handler_polarview <- function(...) {
    bb_handler_polarview_inner(...)
}

# @param config bb_config: a bowerbird configuration (as returned by \code{bb_config}) with a single data source
# @param verbose logical: if TRUE, provide additional progress output
# @param local_dir_only logical: if TRUE, just return the local directory into which files from this data source would be saved
# @return the directory if local_dir_only is TRUE, otherwise TRUE on success
bb_handler_polarview_inner <- function(config, verbose = FALSE, local_dir_only = FALSE, ...) {
    assert_that(is(config, "bb_config"))
    assert_that(nrow(bb_data_sources(config)) == 1)
    assert_that(is.flag(verbose), !is.na(verbose))
    assert_that(is.flag(local_dir_only), !is.na(local_dir_only))

    if (local_dir_only) {
        temp <- bb_data_sources(config)
        temp$source_url[[1]] <- "https://www.polarview.aq/images" ## the source_url values are populated dynamically, but they (currently) all start with this. If we don't hard-code this, then we'd have to run the catalogue search (bb_polarview_search, below) which might not actually return any images from which to extract the path
        bb_data_sources(config) <- temp
        return(bb_handler_rget(config, verbose = verbose, local_dir_only = TRUE, ...))
    }

    ## deal with polarview-specific parameters
    parms <- list(...)
    if (is.null(parms$acquisition_date)) parms$acquisition_date <- Sys.Date() + -3:0
    pv_urls <- bb_polarview_search(parms$acquisition_date, formats = parms$formats, polygon = parms$polygon)

    ## other parms get passed to rget
    rget_parms <- parms[!names(parms) %in% c("acquisition_date", "formats", "polygon")]

    adl <- c(if ("jpg" %in% parms$formats) "\\.(jpg|jp2)$", if ("geotiff" %in% parms$formats) "\\.gz$")
    if (packageVersion("bowerbird") > "0.10.99") {
        ## all in one go
        temp <- bb_data_sources(config)
        temp$source_url <- list(pv_urls)
        bb_data_sources(config) <- temp
        do.call(bb_handler_rget, Filter(length, c(list(config, verbose = verbose, accept_download = adl, rget_parms))))
    } else {
        ## iterate one by one
        all_ok <- TRUE
        msg <- c()
        downloads <- tibble(url = character(), file = character(), was_downloaded = logical())
        for (thisurl in pv_urls) {
            temp <- bb_data_sources(config)
            temp$source_url <- thisurl
            bb_data_sources(config) <- temp
            this <- do.call(bb_handler_rget, Filter(length, c(list(config, verbose = verbose, accept_download = adl, rget_parms))))
            all_ok <- all_ok && this$ok
            if (nrow(this$files[[1]])>0) downloads <- rbind(downloads, this$files[[1]])
            if (nzchar(this$message)) msg <- c(msg, this$message)
        }
        if (length(msg)<1) msg <- ""
        tibble(ok = all_ok, files = list(downloads), message = msg)
    }
}
