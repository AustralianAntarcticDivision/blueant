#' Bowerbird configurations for various Antarctic and Southern Ocean data sources
#'
#' @param name character vector: only return data sources with name or id matching these values
#' @param data_group character vector: only return data sources belonging to these data groups
#'
#' @references See \code{reference} and \code{citation} field in each row of the returned tibble
#'
#' @return tibble
#'
#' @seealso \code{\link{bb_config}}
#'
#' @examples
#' blueant_sources()
#'
#' @export
blueant_sources <- function(name,data_group) {
    if (!missing(name)) assert_that(is.character(name))
    if (!missing(data_group)) assert_that(is.character(data_group))
    out <- rbind(
        if (missing(data_group) || (!missing(data_group) && "sea ice" %in% tolower(data_group))) sources_seaice(),
        if (missing(data_group) || (!missing(data_group) && "topography" %in% tolower(data_group))) sources_topography(),
        if (missing(data_group) || (!missing(data_group) && "sea surface temperature" %in% tolower(data_group))) sources_sst(),
        if (missing(data_group) || (!missing(data_group) && "altimetry" %in% tolower(data_group))) sources_altimetry(),
        if (missing(data_group) || (!missing(data_group) && "oceanographic" %in% tolower(data_group))) sources_oceanographic(),
        if (missing(data_group) || (!missing(data_group) && any(c("ocean colour","ocean color") %in% tolower(data_group)))) sources_ocean_colour(),
        if (missing(data_group) || (!missing(data_group) && "meteorological" %in% tolower(data_group))) sources_meteorological(),
        if (missing(data_group) || (!missing(data_group) && "reanalysis" %in% tolower(data_group))) sources_reanalysis()
        )
    if (!missing(name)) out <- out[tolower(out$name) %in% tolower(name) | tolower(out$id) %in% tolower(name),]
    out
}
