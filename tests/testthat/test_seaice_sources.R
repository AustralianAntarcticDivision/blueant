context("seaice data sources")

dlcheck <- function(file_url, ...) {
    cwd <- getwd()
    on.exit(setwd(cwd))
    temp_root <- tempdir()
    setwd(temp_root)
    status <- list(ok = FALSE)
    tries <- 0
    while (!status$ok && tries < 3) {
        tries <- tries + 1
        status <- bb_rget(file_url, ...)
    }
    if (!status$ok) {
        stop("failed to download file: ", file_url)
    } else {
        file.path(temp_root, status$files[[1]]$file)
    }
}

test_that("source nsidc0051 still works under ftp (may be moved to https)",{
    skip_on_cran()
    fnm <- dlcheck("ftp://sidads.colorado.edu/pub/DATASETS/nsidc0051_gsfc_nasateam_seaice/final-gsfc/south/daily/1978/nt_19781231_n07_v1.1_s.bin")
    expect_true(file.exists(fnm))
    fi <- file.info(fnm)
    expect_true(fi$size > 50e3)
})

test_that("source nsidc0081 still works under ftp (may be moved to https)",{
    skip_on_cran()
    target_file <- format(Sys.Date()-10,"nt_%Y%m%d_f18_nrt_s.bin")
    fnm <- dlcheck(paste0("ftp://sidads.colorado.edu/pub/DATASETS/nsidc0081_nrt_nasateam_seaice/south/",target_file))
    expect_true(file.exists(fnm))
    fi <- file.info(fnm)
    expect_true(fi$size > 50e3)
})

test_that("seaice AMSR format options work",{
    src <- sources_seaice("AMSR-E_ASI_s6250")
    expect_equal(nrow(src),1)
    expect_true(any(grepl("/hdf/",src$source_url[[1]],fixed=TRUE)),any(grepl("/geotiff/",src$source_url[[1]],fixed=TRUE))) ## defaults to both formats
    expect_error(sources_seaice("AMSR-E_ASI_s6250",formats="bananas"))
    src <- sources_seaice("AMSR-E_ASI_s6250",formats="geotiff")
    expect_equal(nrow(src),1)
    expect_true(grepl("/geotiff/",src$source_url[[1]],fixed=TRUE))
    expect_false(grepl("/hdf/",src$source_url[[1]],fixed=TRUE))
    src <- sources_seaice("AMSR-E_ASI_s6250",formats=c("hdf","geotiff"))
    expect_equal(nrow(src),1)
    expect_equal(length(src$source_url[[1]]),2)
    expect_true(any(grepl("/geotiff/",src$source_url[[1]],fixed=TRUE)))
    expect_true(any(grepl("/hdf/",src$source_url[[1]],fixed=TRUE)))
})
