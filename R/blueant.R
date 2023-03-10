#' \pkg{blueant}
#'
#' A collection of data source definitions that can be used with the bowerbird package. These sources define a range of environmental and other data sources useful to Antarctic and Southern Ocean studies.
#'
#' @name blueant
#' @docType package
#' @importFrom assertthat assert_that is.flag is.string noNA
#' @importFrom bowerbird bb_aadc_source bb_data_source_dir bb_data_sources bb_data_sources<- bb_source bb_handler_aws_s3 bb_handler_rget bb_handler_wget bb_handler_oceandata bb_install_wget bb_settings bb_settings<- bb_zenodo_source
#' @importFrom httr GET http_error http_status with_config write_disk
#' @importFrom magrittr %>%
#' @importFrom methods is
#' @importFrom rvest html_session jump_to html_attr html_nodes
#' @importFrom stats na.omit
#' @importFrom stringr str_match str_trim
#' @importFrom tibble tibble
#' @importFrom utils packageVersion read.csv read.table unzip
#' @importFrom xml2 url_absolute
NULL

