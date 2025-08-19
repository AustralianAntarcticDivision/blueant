#' Handler for US National Ice Center charts
#'
#' This is a handler function to be used with US National Ice Center charts from <https://usicecenter.gov/Products/AntarcHome>. This function is not intended to be called directly, but rather is specified as a `method` option in [bowerbird::bb_source()].
#'
#' Note that the USNIC server does not support timestamp operations on requests, so it is not possible to download only files that have changed since last downloaded. Bowerbird configurations with `clobber = 1` (download if modified) are likely to download all files, even if those files exist locally and have not changed since last download. Consider using `clobber = 0` (don't download if file already exists).
#'
#' This handler can take a `method` argument as specified in the [bowerbird::bb_source()] constructor:
#' * chart_type string: either "filled" [default] or "vector"
#'
#' @references <https://usicecenter.gov/Products/AntarcHome>
#'
#' @param ... : parameters passed to [bowerbird::bb_rget()]
#'
#' @return `TRUE` on success
#'
#' @export
bb_handler_usnic <- function(...) {
    bb_handler_usnic_inner(...)
}

# @param config bb_config: a bowerbird configuration (as returned by [bowerbird::bb_config()]) with a single data source
# @param verbose logical: if TRUE, provide additional progress output
# @param local_dir_only logical: if TRUE, just return the local directory into which files from this data source would be saved
# @return the directory if local_dir_only is TRUE, otherwise `TRUE` on success
bb_handler_usnic_inner <- function(config, verbose = FALSE, local_dir_only = FALSE, ...) {
    assert_that(is(config, "bb_config"))
    assert_that(nrow(bb_data_sources(config)) == 1)
    assert_that(is.flag(verbose), !is.na(verbose))
    assert_that(is.flag(local_dir_only), !is.na(local_dir_only))

    if (local_dir_only) return(bb_handler_rget(config, verbose = verbose, local_dir_only = TRUE, ...))

    parms <- bb_data_sources(config)$method[[1]][-1]
    if (!is.null(parms$chart_type)) {
        chart_type <- match.arg(tolower(parms$chart_type), c("filled", "vector"))
    } else {
        chart_type <- "filled"
    }
    base_url <- "https://usicecenter.gov/File/DownloadProduct?products="
    if (chart_type == "filled") {
        data_start_date <- as.Date("2010-01-01") + 173L - 1L ## 2010173
        ##  https://usicecenter.gov/File/DownloadProduct?products=special%2Fkml_archive%2Fantarctic%2F2010&fName=antarctic_2010173.kmz
        query_format <- "special/kml_archive/antarctic/%Y&fName=antarctic_%Y%j.kmz"
    } else {
        data_start_date <- as.Date("2011-01-01") + 347L - 1L ## 2011347
        ##  https://usicecenter.gov/File/DownloadProduct?products=special%2Fkml_archive%2Fantarctic_line%2F2011&fName=antarctic_line_2011347.kmz
        query_format <- "special/kml_archive/antarctic_line/%Y&fName=antarctic_line_%Y%j.kmz"
    }

    dates <- seq(data_start_date, Sys.Date(), by = "day")

    if (!is.null(parms$years)) {
        dates <- dates[format(dates, "%Y") %in% parms$years]
    }

    target_dir <- sub("[\\/]$", "", bb_data_source_dir(config))
    if (!dir.exists(target_dir)) {
        ok <- dir.create(target_dir, recursive = TRUE)
        if (!ok) {
            stop(sprintf("Could not create target directory %s: aborting.\n", target_dir))
        }
    }
    all_ok <- TRUE
    msg <- c()
    downloads <- tibble(url = character(), file = character(), was_downloaded = logical())
    ## change into target directory, with no recursive fetch, to allow --timestamping on retrievals
    settings <- bowerbird:::save_current_settings()
    on.exit({ bowerbird:::restore_settings(settings) })
    setwd(target_dir)
    for (di in seq_along(dates)) {
        thisdate <- dates[di]
        ## loop through dates to download
        thislink <- paste0(base_url, gsub("/", "%2F", format(thisdate, query_format)))
        dummy <- config
        temp <- bb_data_sources(dummy)
        temp$source_url[[1]] <- thislink
        bb_data_sources(dummy) <- temp
        ## pass to the rget handler
        ## we could do it directly here with GET calls, but simpler to use the rget handler functionality
        fname <- sub(".*fName=", "", thislink)
        this <- bb_handler_rget(dummy, verbose = verbose, level = 0, use_url_directory = FALSE, force_local_filename = fname)
        ## we will fail for very recent days, because the data doesn't exist yet
        if (!this$ok && abs(as.numeric(thisdate - Sys.Date())) < 5) {
            ## ignore errors for recent days
            this$ok <- TRUE
        }
        all_ok <- all_ok && this$ok
        if (nrow(this$files[[1]])>0) downloads <- rbind(downloads, this$files[[1]])
        if (nzchar(this$message)) msg <- c(msg, this$message)
    }
    if (length(msg)<1) msg <- ""
    tibble(ok = all_ok, files = list(downloads), message = msg)
}
