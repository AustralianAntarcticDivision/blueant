#' Handler for files downloaded from the Australian Antarctic Data Centre EDS system
#'
#' This is a handler function to be used with data from the Australian Antarctic Data Centre. This function is not intended to be called directly, but rather is specified as a \code{method} option in \code{\link{bb_source}}. AADC EDS files have a URL of the form https://data.aad.gov.au/eds/file/wxyz/ or https://data.aad.gov.au/eds/wxyz/download where wxyz is a numeric file identifier.
#'
#' @references http://data.aad.gov.au
#'
#' @param ... : parameters passed to \code{\link{bb_wget}}
#'
#' @return TRUE on success
#'
#' @export
bb_handler_aadc <- function(...) {
    bb_handler_aadc_inner(...)
}

# @param config bb_config: a bowerbird configuration (as returned by \code{bb_config}) with a single data source
# @param verbose logical: if TRUE, provide additional progress output
# @param local_dir_only logical: if TRUE, just return the local directory into which files from this data source would be saved
bb_handler_aadc_inner <- function(config,verbose=FALSE,local_dir_only=FALSE,...) {
    assert_that(is(config,"bb_config"))
    assert_that(nrow(bb_data_sources(config))==1)
    assert_that(is.flag(verbose),!is.na(verbose))
    assert_that(is.flag(local_dir_only),!is.na(local_dir_only))

    temp <- bb_data_sources(config)
    slidx <- !grepl("/download$",temp$source_url[[1]]) & !grepl("/$",temp$source_url[[1]])
    if (any(slidx)) {
        warning("each source_url for data sources using the bb_handler_aadc method should have a trailing /. These will be added now")
        temp$source_url[[1]][slidx] <- paste0(temp$source_url[[1]][slidx],"/")
        bb_data_sources(config) <- temp
    }
    ## clumsy way to get around AADC EDS file naming issues
    ## e.g. if we ask for http://data.aad.gov.au/eds/file/4494
    ## then we get local file named data.aad.gov.au/eds/file/4494
    ## (which is most likely a zipped file)
    ## if we unzip this here, we get this zip's files mixed with others
    ## change into subdirectory named by file_id of file,
    ## so that we don't get files mixed together in data.aad.gov.au/eds/file/
    ## note that this requires the "--recursive" flag NOT TO BE USED
    url_form <- -1
    if (grepl("/download",bb_data_sources(config)$source_url[[1]])) {
        url_form <- 1
        this_file_id <- str_match(bb_data_sources(config)$source_url[[1]],"/eds/(\\d+)/download$")[2]
        if (is.na(this_file_id)) stop("could not determine AADC EDS file_id")
        trailing_path <- file.path("data.aad.gov.au","eds",this_file_id)
    } else {
        url_form <- 2
        this_file_id <- str_match(bb_data_sources(config)$source_url[[1]],"/eds/file/(\\d+)/?$")[2]
        if (is.na(this_file_id)) stop("could not determine AADC EDS file_id")
        trailing_path <- file.path("data.aad.gov.au","eds","file",this_file_id)
        if (!grepl("/$",bb_data_sources(config)$source_url[[1]])) {
            temp <- bb_data_sources(config)
            temp$source_url[[1]] <- paste0(temp$source_url[[1]],"/") ## this form needs trailing /
            bb_data_sources(config) <- temp
        }

    }
    if (local_dir_only) return(file.path(bb_settings(config)$local_file_root,trailing_path))
    if (!file.exists(file.path(bb_settings(config)$local_file_root,trailing_path))) {
        dir.create(file.path(bb_settings(config)$local_file_root,trailing_path),recursive=TRUE)
    }
    settings <- bowerbird:::save_current_settings()
    on.exit({ bowerbird:::restore_settings(settings) })
    setwd(file.path(bb_settings(config)$local_file_root,trailing_path))

    ## don't set the --content-disposition flag. It seems to cause problems with used with --timestamping on large files, and
    ##  isn't really needed anyway. Without it, we just get the downloaded file names as "download" (for the /download url form)
    ##  or "index.html" (for the /eds/file/wxyz/ form). But these are still valid zip files - just need to rename them so that postprocess finds them
    ##
    ##if (!grepl("--content-disposition",method_flags,ignore.case=TRUE)) {
    ##    method_flags <- paste(method_flags,"--content-disposition",sep=" ")
    ##}
    #temp <- bb_data_sources(config)
    ## don't use --recursive, since we're handling the destination directory explicitly
    #temp$method[[1]]$recursive <- FALSE
    #bb_data_sources(config) <- temp
    ok <- bb_handler_wget(config,verbose=verbose,recursive=FALSE,no_check_certificate=TRUE,...)
    ## rename files. Note that this relies on the download being a zip file, so test it first with unzip(...,list=TRUE)
    is_zip <- function(filename) {
        zip <- FALSE
        try({blah <- unzip(filename,list=TRUE); zip <- TRUE },silent=TRUE)
        zip
    }
    downloaded_file <- if (url_form==1) "download" else "index.html" ## expected name of downloaded file
    if (file.exists(downloaded_file) && is_zip(downloaded_file)) {
        zname <- paste0(downloaded_file,".zip")
        if (file.exists(zname)) file.remove(zname)
        ok <- ok && file.rename(downloaded_file,zname)
    }
    ok
}
