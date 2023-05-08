#' Handler for Argo profile data sources
#'
#' This is a handler function to be used with Argo data. Tested with the Global Data Access Centre in Monterey, USA (US Global Ocean Data Assimilation Experiment) and Ifremer data centre, not yet tested with others. This function is not intended to be called directly, but rather is specified as a \code{method} option in \code{\link{bb_source}}.
#'
#' This handler can take several \code{method} arguments as specified in the \code{\link[bowerbird]{bb_source}} constructor:
#' \itemize{
#'   \item profile_type string: either "merge" [default] or "synthetic" (currently only available from certain DACs)
#'   \item institutions character: vector of institution codes. Only profiles from these institutions will be downloaded (current institution codes are "AO", "BO", "IF", "HZ", "CS", "IN")
#'   \item parameters character: vector of parameter codes. Only profiles with one or more of these parameters will be downloaded (current parameter set is "BBP470", "BBP532", "BBP700", "BISULFIDE", "CDOM", "CHLA", "CNDC", "CP660", "DOWN_IRRADIANCE380", "DOWN_IRRADIANCE412", "DOWN_IRRADIANCE443", "DOWN_IRRADIANCE490", "DOWN_IRRADIANCE555", "DOWNWELLING_PAR", "DOXY", "NITRATE", "PH_IN_SITU_TOTAL", "PRES", "PSAL", "TEMP", "TURBIDITY", "UP_RADIANCE412", "UP_RADIANCE443", "UP_RADIANCE490", "UP_RADIANCE555")
#'   \item latitude_filter function: this function is applied to each profile's \code{latitude} value; only profiles for which this function returns \code{TRUE} will be downloaded
#'   \item longitude_filter function: as for \code{latitude_filter}, but applied to longitude
#' }
#'
#' See \code{\link{sources_oceanographic}} for more details and examples.
#'
#' @references <https://wwz.ifremer.fr/en/Research-Technology/Scientific-departments/Department-of-Marine-and-Digital-Infrastructures/The-French-ARGO-Data-Centre>, <http://www.argodatamgt.org/Documentation>
#' @param ... : parameters passed to \code{\link{bb_rget}}
#'
#' @return TRUE on success
#'
#' @export
bb_handler_argo <- function(...) {
    bb_handler_argo_inner(...)
}

# @param config bb_config: a bowerbird configuration (as returned by \code{bb_config}) with a single data source
# @param verbose logical: if TRUE, provide additional progress output
# @param local_dir_only logical: if TRUE, just return the local directory into which files from this data source would be saved
#
# @return TRUE on success or the directory name if local_dir_only is TRUE
bb_handler_argo_inner <- function(config, verbose = FALSE, local_dir_only = FALSE, ...) {

    ## ARGO from ifremer, see notes at https://github.com/AustralianAntarcticDivision/blueant/issues/13
    ## * get file list in an `argo_handler`   "ftp.ifremer.fr/ifremer/argo/argo_merge-profile_index.txt.gz" - ar_greylist.txt are marked as "problems"
    ## * get the index file for processing by raadfiles
    ## * apply filters "aoml", "bodc", "coriolis", "csio", "csiro", "incois" (codes "AO", "BO", "IF", "HZ", "CS", "IN")
    ## * apply filter latitude < -40
    ## * apply filter anything with parameter including "CHLA" (current parameter set is BBP470, BBP532, BBP700, BISULFIDE, CDOM, CHLA, CNDC, CP660, DOWN_IRRADIANCE380, DOWN_IRRADIANCE412, DOWN_IRRADIANCE443, DOWN_IRRADIANCE490, DOWN_IRRADIANCE555, DOWNWELLING_PAR, DOXY, NITRATE, PH_IN_SITU_TOTAL, PRES, PSAL, TEMP, TURBIDITY, UP_RADIANCE412, UP_RADIANCE443, UP_RADIANCE490, UP_RADIANCE555)
    ## * want all dates, all longitudes, all institutions, all profile types
    ## * get files in ftp.ifremer.fr/argo/ifremer/argo/dac/[provider]/[float]/profiles/
    ## * and get file in ftp.ifremer.fr/argo/ifremer/argo/dac/[provider]/[float]/[float]_meta.nc

    assert_that(is(config,"bb_config"))
    assert_that(nrow(bb_data_sources(config))==1)
    assert_that(is.flag(verbose),!is.na(verbose))
    assert_that(is.flag(local_dir_only),!is.na(local_dir_only))

    force_use_wget <- FALSE
    no_check_cert <- TRUE ## currently the usgodae certficate is valid for usgodae.org but invalid for www.usgodae.org, so skip the certificate check at least temporarily
    get_fun <- if (force_use_wget) bb_handler_wget else bb_handler_rget

    if (local_dir_only) return(bb_handler_rget(config, verbose = verbose, local_dir_only = TRUE))

    parms <- bb_data_sources(config)$method[[1]][-1]
    source_url_no_trailing_sep <- sub("/+$", "", bb_data_sources(config)$source_url[[1]])

    ## first get the greylist and index files
    ## greylist file - we don't do anything with it, but it's there for the user if they care to look at it
    greylist_file <- argo_get_index_file(config, index_type = "greylist", get_fun = get_fun, stop_on_failure = FALSE, no_check_cert = no_check_cert, verbose = verbose)
    ## index file
    if ("profile_type" %in% names(parms) && !is.null(parms$profile_type)) {
        profile_type <- match.arg(tolower(parms$profile_type), c("merge", "synthetic"))
    } else {
        profile_type <- "merge"
    }
    dummy <- config
    temp <- bb_settings(config)
    temp$dry_run <- FALSE ## must download index file
    bb_settings(dummy) <- temp
    idxfile <- argo_get_index_file(dummy, index_type = profile_type, get_fun = get_fun, no_check_cert = no_check_cert, verbose = verbose)
    idx <- argo_parse_index_file(idxfile, verbose = verbose)
    if (verbose) cat("Total number of profiles in index: ", nrow(idx), "\n")
    idx0 <- idx
    ## apply filters
    if ("institutions" %in% names(parms) && !is.null(parms$institutions)) {
        idx <- idx[idx$institution %in% parms$institutions, ]
        if (verbose) cat("Number of profiles after applying institution filter: ", nrow(idx), "\n")
    }
    if ("parameters" %in% names(parms) && !is.null(parms$parameters)) {
        idx_parms <- idx$parameters
        pidx <- vapply(seq_len(nrow(idx)), function(z) any(strsplit(idx_parms[[z]], " ")[[1]] %in% parms$parameters), FUN.VALUE = TRUE, USE.NAMES = FALSE)
        idx <- idx[pidx, ]
        if (verbose) cat("Number of profiles after applying parameter filter: ", nrow(idx), "\n")
    }
    if ("latitude_filter" %in% names(parms) && !is.null(parms$latitude_filter)) {
        idx <- idx[parms$latitude_filter(idx$latitude), ]
        if (verbose) cat("Number of profiles after applying latitude filter: ", nrow(idx), "\n")
    }
    if ("longitude_filter" %in% names(parms) && !is.null(parms$longitude_filter)) {
        idx <- idx[parms$longitude_filter(idx$longitude), ]
        if (verbose) cat("Number of profiles after applying longitude filter: ", nrow(idx), "\n")
    }
    if (verbose) cat("Number of profiles to retrieve: ", nrow(idx), "\n")

    ## now, this lists multiple profiles within individual folders
    ## pull out the folder name
    idx$url <- str_match(idx$file, "^([^/]+/[^/]+)/.+")[, 2]
    idx0$url <- str_match(idx0$file, "^([^/]+/[^/]+)/.+")[, 2]

    ## if were to just get entire folders, rather than bother selecting individual profiles within folders, how many unique folders do we need to get?
    uurl <- na.omit(unique(idx$url))

    ## if we did that, how many unnecessary files would we be downloading?
    unn <- idx0$url %in% uurl & !idx0$file %in% idx$file
    ## if this is not too many unnecessary files, we can request by folder rather than file - this would probably be faster
    ## TODO, perhaps?

    ## for each one:
    ## * get files in [source_url]/dac/[provider]/[float]/profiles/
    ## * and get file in ftp.ifremer.fr/argo/ifremer/argo/dac/[provider]/[float]/[float]_meta.nc
    ## * and for synthetic profiles, get ftp.ifremer.fr/argo/ifremer/argo/dac/[provider]/[float]/[float]_Sprof.nc
    ## each meta file
    status <- list(ok = TRUE, files = list(NULL), msg = "")
    for (thisurl in uurl) {
        dummy <- config
        temp <- bb_data_sources(dummy)
        this_float <- strsplit(thisurl, "/")[[1]][2]
        if (!is.null(this_float) && !is.na(this_float)) {
            temp$source_url <- file.path(source_url_no_trailing_sep, "dac", thisurl, paste0(this_float, "_meta.nc"))
            temp$method <- list(list("bb_handler_rget", level = 1, no_check_certificate = no_check_cert))
            bb_data_sources(dummy) <- temp
            this_status <- get_fun(dummy, verbose = verbose, no_check_certificate = no_check_cert)
            status <- tibble(ok = status$ok && this_status$ok, files = list(rbind(status$files[[1]], this_status$files[[1]])), msg = paste(status$msg, this_status$message))
            ## Sprof file
            if (profile_type == "synthetic") {
                temp$source_url <- file.path(source_url_no_trailing_sep, "dac", thisurl, paste0(this_float, "_Sprof.nc"))
                temp$method <- list(list("bb_handler_rget", level = 1, no_check_certificate = no_check_cert))
                bb_data_sources(dummy) <- temp
                this_status <- get_fun(dummy, verbose = verbose, no_check_certificate = no_check_cert)
                ## not all profiles have this Sprof file, so don't change the 'ok' value on failure (??)
                status <- tibble(ok = status$ok, files = list(rbind(status$files[[1]], this_status$files[[1]])), msg = paste(status$msg, this_status$message))
            }
        }
    }
    ## and each profile file
    for (thisurl in idx$file) {
        if (!is.na(thisurl)) {
            dummy <- config
            temp <- bb_data_sources(dummy)
            temp$source_url <- file.path(source_url_no_trailing_sep, "dac", thisurl)
            temp$method <- list(list("bb_handler_rget", level = 1, no_check_certificate = no_check_cert))
            bb_data_sources(dummy) <- temp
            ##        cat(str(dummy))
            this_status <- get_fun(dummy, verbose = verbose, no_check_certificate = no_check_cert)
            status <- tibble(ok = status$ok && this_status$ok, files = list(rbind(status$files[[1]], this_status$files[[1]])), msg = paste(status$msg, this_status$msg))
        }
    }
    status
}


## retrieve an index file and return its local path
argo_get_index_file <- function(config, index_type = "merge", get_fun = bb_handler_rget, stop_on_failure = TRUE, no_check_cert = FALSE, verbose = FALSE) {
    index_type <- match.arg(tolower(index_type), c("merge", "synthetic", "greylist"))
    dummy <- config
    temp <- bb_data_sources(dummy)
    source_url_no_trailing_sep <- sub("/+$", "", temp$source_url[[1]])
    if (index_type == "greylist") {
        fname <- "ar_greylist.txt"
    } else {
        fname <- paste0("argo_", index_type, "-profile_index.txt.gz")
    }
    temp$source_url <- file.path(source_url_no_trailing_sep, fname)
    temp$method <- list(list("bb_handler_rget", level = 0, no_check_certificate = no_check_cert))
    bb_data_sources(dummy) <- temp
    if (verbose) cat("Downloading profile", index_type, "index file\n")
    this <- get_fun(dummy, verbose = verbose, level = 0, no_check_certificate = no_check_cert)
    if (!this$ok) stop("error retrieving profile ", index_type, " index file")
    file.path(bb_data_source_dir(config), fname)
}

argo_parse_index_file <- function(local_index_file, verbose = FALSE) {
    ## annoyingly, the header in this csv file is corrupted on the USGODAE GDAC site, but not on ifremer
    ## GRrrrrrrr
    ##idx <- read.csv(gzfile(file.path(bb_settings(config)$local_file_root, this$files[[1]]$file)), stringsAsFactors = FALSE, comment.char = "#")
    con <- if (grepl("gz$", local_index_file, ignore.case = TRUE)) gzfile(local_index_file) else local_index_file
    temp_hdr <- readLines(con, 20)
    skip_count <- sum(grepl("^#", temp_hdr)) + 1 ## skip comment lines plus one to skip the actual header
        idx <- read.table(con, sep = ",", header = FALSE, skip = skip_count, stringsAsFactors = FALSE, comment.char = "#")
    ## expect 10 cols
    if (ncol(idx) == 10) {
        colnames(idx) <- c("file", "date", "latitude", "longitude", "ocean", "profiler_type", "institution", "parameters", "parameter_data_mode", "date_update")
    } else {
        stop("failure reading index file")
    }
    idx
}

