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
    stop("bb_handler_aadc is hard-deprecated due to changes on the AADC servers. Use bb_handler_rget (see e.g. `sources('GVDEM_2008')` for an example) or bb_handler_aws_s3 (see `sources('SO-CPR')`)")
}

## not exported, for internal use
get_json <- function(url) {
    out <- curl::curl_fetch_memory(url, handle = curl::new_handle(ssl_verifypeer = 0L))
    jsonlite::fromJSON(rawToChar(out$content))
}
get_aadc_md <- function(metadata_id) {
    get_json(paste0("https://data.aad.gov.au/metadata/records/", metadata_id, "?format=json"))
}

get_aadc_doi <- function(metadata_id) {
    md <- get_aadc_md(metadata_id)
    tryCatch(sub("^doi:", "", md$data$data_set_citation$dataset_doi), error = function(e) NULL)
}

bb_aadc_s3_source_gen <- function(metadata_id, name = NULL, id = NULL, doi = NULL, description, citation, method_args = list(), collection_size = NULL, data_group = NULL, access_function = NULL) {
    assert_that(is.string(metadata_id))
    if (grepl("^http", metadata_id)) metadata_id <- basename(metadata_id)
    murl <- paste0("https://data.aad.gov.au/metadata/records/", metadata_id)
    pretty_name <- gsub("[[:punct:]_]+", " ", metadata_id)
    rgs <- list(name = if (!is.null(name)) name else pretty_name,
                id = if (!is.null(id)) id else if (length(doi) > 0) doi else metadata_id,
                description = description,
                doc_url = paste0("https://doi.org/", doi),
                citation = if (!is.null(citation)) citation else "See documentation URL",
                license = "CC-BY",
                method = c(list("bb_handler_aws_s3", bucket = "datasets", base_url = "public.services.aad.gov.au", region = "", prefix = paste0("science/", metadata_id), use_https = FALSE, bucketlist_json = paste0("http://data.aad.gov.au/s3/api/bucket/datasets/science/", metadata_id, "/")), method_args),
                ## bucketlist_json is a workaround for AADC servers not supporting the usual aws.s3::get_bucket method              postprocess = NULL,
                collection_size = collection_size,
                data_group = data_group)
    if (!is.null(access_function)) rgs$access_function <- access_function
    do.call(bb_source, rgs)
}

