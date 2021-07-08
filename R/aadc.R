get_aadc_md <- function(metadata_id) {
    get_json(paste0("https://data.aad.gov.au/metadata/records/", metadata_id, "?format=json"))
}

get_aadc_doi <- function(metadata_id) {
    md <- get_aadc_md(metadata_id)
    tryCatch(sub("^doi:", "", md$data$data_set_citation$dataset_doi), error = function(e) NULL)
}

get_json <- function(url) {
    out <- curl::curl_fetch_memory(url, handle = curl::new_handle(ssl_verifypeer = 0L))
    jsonlite::fromJSON(rawToChar(out$content))
}

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

#' Generate a bowerbird data source object for an Australian Antarctic Data Centre data set
#'
#' @param metadata_id string: the metadata ID of the data set. Browse the AADC's collection at https://data.aad.gov.au/metadata/records/ to find the relevant \code{metadata_id}
#'
#' @return A tibble containing the data source definition, as would be returned by \code{\link[bowerbird]{bb_source}}
#'
#' @seealso \code{\link{bb_source}}
#'
#' @examples
#' \dontrun{
#'   ## generate the source def for the "AADC-00009" dataset
#'   ##  (Antarctic Fur Seal Populations on Heard Island, Summer 1987-1988)
#'   src <- bb_aadc_source("AADC-00009")
#'
#'   ## download it to a temporary directory
#'   data_dir <- tempfile()
#'   dir.create(data_dir)
#'   res <- bb_get(src, local_file_root = data_dir, verbose = TRUE)
#'   res$files
#' }
#'
#' @export
bb_aadc_source <- function(metadata_id) {
    assert_that(is.string(metadata_id))
    if (grepl("^http", metadata_id)) metadata_id <- basename(metadata_id)
    md <- get_aadc_md(metadata_id)
    murl <- paste0("https://data.aad.gov.au/metadata/records/", metadata_id)
    doi <- tryCatch(sub("^doi:", "", md$data$data_set_citation$dataset_doi), error = function(e) NULL)
    ## get collection size from the S3 API
    postproc <- list()
    csize <- tryCatch({
        s3x <- get_json(paste0("https://data.aad.gov.au/s3/api/bucket/datasets/science/", metadata_id)) ## , "/?export=json")) ## query parm no longer needed?
        if (any(grepl("\\.zip$", s3x$name, ignore.case = TRUE))) postproc <- c(postproc, list("unzip"))
        if (any(grepl("\\.gz$", s3x$name, ignore.case = TRUE))) postproc <- c(postproc, list("gunzip"))
        sz <- sum(s3x$size, na.rm = TRUE)/1024^3 ## in GB
        if (!is.na(sz)) ceiling(sz*10)/10 else NULL
    }, error = function(e) NULL)
    bb_source(name = md$data$entry_title,
              id = if (length(doi) > 0) doi else metadata_id,
              description = md$data$summary$abstract,
              doc_url = if (length(doi) > 0) paste0("https://doi.org/", doi) else murl,
              citation = md$data$citation,
              license = "CC-BY",
              method = list("bb_handler_aws_s3", bucket = "datasets", base_url = "services.aad.gov.au", region = "public", prefix = paste0("science/", metadata_id), use_https = FALSE),
              comment = "Source definition created by bb_aadc_source",
              postprocess = postproc,
              collection_size = csize)
}

## not exported, for internal use
bb_aadc_s3_source_gen <- function(metadata_id, name = NULL, id = NULL, doi = NULL, description, citation, method_args = list(), collection_size = NULL, data_group = NULL, access_function = NULL) {
    assert_that(is.string(metadata_id))
    if (grepl("^http", metadata_id)) metadata_id <- basename(metadata_id)
    murl <- paste0("https://data.aad.gov.au/metadata/records/", metadata_id)
    pretty_name <- gsub("[[:punct:]_]+", " ", metadata_id)
    bb_source(name = if (!is.null(name)) name else pretty_name,
              id = if (!is.null(id)) id else if (length(doi) > 0) doi else metadata_id,
              description = description,
              doc_url = paste0("https://doi.org/", doi),
              citation = if (!is.null(citation)) citation else "See documentation URL",
              license = "CC-BY",
              method = c(list("bb_handler_aws_s3", bucket = "datasets", base_url = "services.aad.gov.au", region = "public", prefix = paste0("science/", metadata_id), use_https = FALSE), method_args),
              postprocess = NULL,
              collection_size = collection_size,
              data_group = data_group,
              if (!is.null(access_function)) access_function = access_function)
}

