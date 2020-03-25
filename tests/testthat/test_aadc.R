context("AADC sources")
test_that("A small AADC source works", {
    src <- bb_aadc_source("AADC-00009")
    temp_root <- tempdir()
    cf <- bb_add(bb_config(local_file_root = temp_root), src)
    expect_true(grepl("public.services.aad.gov.au/datasets/science/AADC-00009/?$", bb_data_source_dir(cf)))
    status <- bb_sync(cf, confirm_downloads_larger_than = NULL)
    expect_equal(nrow(status$files[[1]]), 6)
    expect_true(all(file.exists(status$files[[1]]$file)))
    fi <- file.size(status$files[[1]]$file)
    expect_true(all(fi > 1e3))
})