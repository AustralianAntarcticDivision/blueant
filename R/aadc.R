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
    stop("bb_handler_aadc is hard-deprecated due to changes on the AADC servers. Use bb_aadc_source (see e.g. `sources('GVDEM_2008')` for an example)")
}
