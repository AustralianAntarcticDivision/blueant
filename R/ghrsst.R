#' Handler for GHRSST data sources
#'
#' @references https://podaac.jpl.nasa.gov/Multi-scale_Ultra-high_Resolution_MUR-SST
#' @param cfrow data.frame: a single row from a bowerbird configuration (as returned by \code{bb_config})
#' @param verbose logical: if TRUE, provide additional progress output
#' @param local_dir_only logical: if TRUE, just return the local directory into which files from this data source would be saved
#'
#' @return the directory if local_dir_only is TRUE, otherwise TRUE on success
#'
#' @export
ghrsst_get <- function(cfrow,verbose=FALSE,local_dir_only=FALSE) {

    ## The data source is ftp://podaac-ftp.jpl.nasa.gov/allData/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/
    ## with yearly subdirectories
    ## within yearly directories, days are subdirectories
    ## BUT the daily subdirectories are symlinks and recursive wget won't recurse symlinked directories (known limitation of wget)

    ## hence use a custom handler, at least for now

    ## we can use wget within a daily directory, e.g.:
    ## wget --recursive --level=inf --no-parent --timestamping ftp://ftp.nodc.noaa.gov/pub/data.nodc/ghrsst/L4/GLOB/JPL/MUR/2015/051/

    ## we expect that the provided source URL is either pointing to the root of the collection:
    ## ftp://podaac-ftp.jpl.nasa.gov/allData/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/
    ## or to a particular year (multiple years will need multiple source_urls)
    ## ftp://podaac-ftp.jpl.nasa.gov/allData/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/2015/
    ##
    ## for the former, we will loop from 2002 to present here
    ## for the latter, just hit that specific yearly directory

    assert_that(is.data.frame(cfrow))
    assert_that(nrow(cfrow)==1)
    assert_that(is.list(cfrow$method_flags))
    assert_that(is.character(cfrow$method_flags[[1]]))
    assert_that(is.flag(verbose))
    assert_that(is.flag(local_dir_only))

    method_flags <- cfrow$method_flags[[1]]

    if (!grepl("\\d\\d\\d\\d/?$",cfrow$source_url)) {
        ## pointing to root
        yearlist <- seq(from=2002,to=as.numeric(format(Sys.Date(),"%Y")),by=1)
        if (local_dir_only) {
            ## all years, so return the root dir
            dummy <- cfrow
            dummy$source_url <- "ftp://podaac-ftp.jpl.nasa.gov/allData/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/"
            return(bb_wget(dummy,verbose=verbose,local_dir_only=TRUE))
        }
    } else {
        ## a specific year
        if (local_dir_only) return(bb_wget(cfrow,verbose=verbose,local_dir_only=TRUE))
        yearlist <- as.numeric(basename(cfrow$source_url))
    }
    yearlist <- na.omit(yearlist)
    if (length(yearlist)<1) warning("ghrsst: empty yearlist")
    ## make sure method_flags include --recursive --no-parent
    if (!any(tolower(method_flags) %in% c("--recursive","-r")))
        method_flags <- c(method_flags,"--recursive")
    if (!any(tolower(method_flags) %in% c("--no-parent","-np")))
        method_flags <- c(method_flags,"--no-parent")
    cfrow$method_flags <- list(method_flags)
    for (thisyear in yearlist) {
        daylist <- if (thisyear==2002) 152:365 else 1:366
        if (thisyear==as.numeric(format(Sys.Date(),"%Y"))) daylist <- daylist[daylist<=as.numeric(format(Sys.Date(),"%j"))]
        for (thisday in daylist) {
            dummy <- cfrow
            dummy$source_url <- paste0("ftp://podaac-ftp.jpl.nasa.gov/allData/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/",thisyear,"/",sprintf("%03d",thisday),"/")
            bb_wget(dummy,verbose=verbose)
        }
    }
}



