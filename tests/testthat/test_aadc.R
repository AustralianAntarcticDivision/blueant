context("AADC sources")
test_that("The AADC S3 source generator works", {
    src <- sources_biological("SO-CPR")
    temp_root <- tempdir()
    cf <- bb_add(bb_config(local_file_root = temp_root), src)
    expect_equal(length(bb_data_source_dir(cf)), 1) ## should only be one data set. The metadata record should link to the actual (current) data plus the logbooks, but the latter are filtered out by the source constructor
    expect_true(grepl("data.aad.gov.au/eds/api/dataset/[^/]+/AADC-00099/?$", bb_data_source_dir(cf)))
    status <- bb_sync(cf, confirm_downloads_larger_than = NULL)
    expect_gt(nrow(status$files[[1]]), 1L) ## at least two files
    expect_true(all(file.exists(status$files[[1]]$file)))
    fi <- file.size(status$files[[1]]$file)
    expect_true(all(fi > 1e3))
    expect_true(any(grepl("csv$", status$files[[1]]$file))) ## at least one csv
})
