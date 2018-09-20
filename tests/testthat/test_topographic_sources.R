context("topographic data sources")

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

test_that("source nsidc0082 still works under ftp (may be moved to https)",{
    skip_on_cran()
    skip_on_travis() ## this randomly fails for no good reason on travis and appveyor, so just run locally
    skip_on_appveyor()
    fnm <- dlcheck("ftp://sidads.colorado.edu/pub/DATASETS/nsidc0082_radarsat_dem_v02/200M/BINARY/ramp200dem_osu_v2.hdr", accept_download = "hdr$")
    expect_true(file.exists(fnm))
    fi <- file.info(fnm)
    expect_gt(fi$size,1e3)
})

