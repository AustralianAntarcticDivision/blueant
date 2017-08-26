#' Handler for files downloaded from the Australian Antarctic Data Centre EDS system
#'
#' AADC EDS files have a URL of the form https://data.aad.gov.au/eds/file/wxyz/ or https://data.aad.gov.au/eds/wxyz/download where wxyz is a numeric file identifier.
#'
#' @references http://data.aad.gov.au
#' @param config bb_config: a bowerbird configuration (as returned by \code{bb_config}) with a single data source
#' @param verbose logical: if TRUE, provide additional progress output
#' @param local_dir_only logical: if TRUE, just return the local directory into which files from this data source would be saved
#'
#' @return TRUE on success
#'
#' @export
aadc_eds_get <- function(config,verbose=FALSE,local_dir_only=FALSE) {
    assert_that(is(config,"bb_config"))
    assert_that(nrow(config$data_sources)==1)
    assert_that(is.list(config$data_sources$method_flags))
    assert_that(is.character(config$data_sources$method_flags[[1]]))
    assert_that(is.flag(verbose))
    assert_that(is.flag(local_dir_only))

    method_flags <- config$data_sources$method_flags[[1]]

    slidx <- !grepl("/download$",config$data_sources$source_url) & !grepl("/$",config$data_sources$source_url)
    if (any(slidx)) {
        warning("each source_url for data sources using the aadc_eds_get method should have a trailing /. These will be added now")
        config$data_sources$source_url[slidx] <- paste0(config$data_sources$source_url[slidx],"/")
    }
    ## clumsy way to get around AADC EDS file naming issues
    ## e.g. if we ask for http://data.aad.gov.au/eds/file/4494
    ## then we get local file named data.aad.gov.au/eds/file/4494
    ## (which is most likely a zipped file)
    ## if we unzip this here, we get this zip's files mixed with others
    ## change into subdirectory named by file_id of file,
    ## so that we don't get files mixed together in data.aad.gov.au/eds/file/
    ## note that this requires the "--recursive" flag NOT TO BE USED
    if (grepl("/download",config$data_sources$source_url)) {
        this_file_id <- str_match(config$data_sources$source_url,"/eds/(\\d+)/download$")[2]
        if (is.na(this_file_id)) stop("could not determine AADC EDS file_id")
        trailing_path <- file.path("data.aad.gov.au","eds",this_file_id)
    } else {
        this_file_id <- str_match(config$data_sources$source_url,"/eds/file/(\\d+)/?$")[2]
        if (is.na(this_file_id)) stop("could not determine AADC EDS file_id")
        trailing_path <- file.path("data.aad.gov.au","eds","file",this_file_id)
        if (!grepl("/$",config$data_sources$source_url))
            config$data_sources$source_url <- paste0(config$data_sources$source_url,"/") ## this form needs trgailing /
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
    ##  or "index.html" (for the /eds/file/wxyz/ form). But these are still valid zip files
    ##
    ##if (!grepl("--content-disposition",method_flags,ignore.case=TRUE)) {
    ##    method_flags <- paste(method_flags,"--content-disposition",sep=" ")
    ##}
    ## don't use --recursive, since we're handling the destination directory explicitly
    method_flags <- setdiff(method_flags,c("--recursive","-r"))
    config$data_sources$method_flags <- list(method_flags)
    bb_wget(config,verbose=verbose)
}
