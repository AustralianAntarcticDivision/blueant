#' Handler for AMPS data (Antarctic mesoscale prediction system)
#'
#' @references http://www2.mmm.ucar.edu/rt/amps/
#' @param config bb_config: a bowerbird configuration (as returned by \code{bb_config}) with a single data source
#' @param verbose logical: if TRUE, provide additional progress output
#' @param local_dir_only logical: if TRUE, just return the local directory into which files from this data source would be saved
#'
#' @return the directory if local_dir_only is TRUE, otherwise TRUE on success
#'
#' @export
amps_get <- function(config,verbose=FALSE,local_dir_only=FALSE) {
    assert_that(is(config,"bb_config"))
    assert_that(nrow(bb_data_sources(config))==1)
    assert_that(is.flag(verbose))
    assert_that(is.flag(local_dir_only))
    ## shouldn't need any specific method_flags for this
    ## --timestamping not needed (handled through clobber config setting)
    ## --recursive, etc not needed
    temp <- bb_data_sources(config)
    temp$source_url <- "http://www2.mmm.ucar.edu/rt/amps/wrf_grib/" ## this is fixed for this handler
    bb_data_sources(config) <- temp

    if (local_dir_only) return(bb_handler_wget(config,verbose=verbose,local_dir_only=TRUE))

    x <- html_session(bb_data_sources(config)$source_url)
    n <- html_attr(html_nodes(x,"a"),"href")
    idx <- grepl("[[:digit:]]+",n,ignore.case=TRUE) ## links that are all digits
    accept <- function(z) grepl("\\.txt$",html_attr(z,"href"),ignore.case=TRUE) || grepl("d[12]_f(000|003|006|009|012|015|018|021|024|027)\\.grb$",html_attr(z,"href"),ignore.case=TRUE) ## which files to accept
    this_path_no_trailing_sep <- sub("[\\/]$","",bowerbird:::directory_from_url(bb_data_sources(config)$source_url))
    for (i in idx) { ## loop through directories
        target_dir <- sub("/$","",n[i])
        target_dir <- file.path(this_path_no_trailing_sep,sub("(00|12)$","",target_dir))
        ## make target_dir if it doesn't exist
        if (!dir.exists(target_dir)) {
            ok <- dir.create(target_dir)
            if (!ok) {
                stop(sprintf("Could not create target directory %s: aborting.\n",target_dir))
            }
        }
        x2 <- jump_to(x,n[i])
        files <- html_attr(Filter(accept,html_nodes(x2,"a")),"href")
        ## change into target directory, with no recursive fetch, to allow --timestamping on retrievals
        settings <- bowerbird:::save_current_settings()
        on.exit({ bowerbird:::restore_settings(settings) })
        setwd(target_dir)
        for (f in files) {
            ## loop through files to download
            file_url <- xml2::url_absolute(f,x2$url)
            dummy <- config
            temp <- bb_data_sources(dummy)
            temp$source_url <- file_url
            bb_data_sources(dummy) <- temp
            bb_handler_wget(dummy,verbose=verbose)
        }
    }
}
