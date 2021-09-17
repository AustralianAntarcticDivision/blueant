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
    skip_on_travis() ## this randomly fails for no good reason on travis and appveyor, so just run locally
    skip_on_appveyor()
    fnm <- dlcheck("ftp://sidads.colorado.edu/pub/DATASETS/nsidc0051_gsfc_nasateam_seaice/final-gsfc/south/daily/1978/nt_19781231_n07_v1.1_s.bin")
    expect_true(file.exists(fnm))
    fi <- file.info(fnm)
    expect_true(fi$size > 50e3)
})

test_that("source nsidc0081 still works under ftp (may be moved to https)",{
    skip_on_cran()
    skip_on_travis() ## this randomly fails for no good reason on travis and appveyor, so just run locally
    skip_on_appveyor()
    target_file <- format(Sys.Date()-60,"nt_%Y%m%d_f18_nrt_s.bin")
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

test_that("polarview search works", {
    ## polygon as sfc
    target_sector <- data.frame(lon = c(30, seq(30, 150, length.out = 10), 150, 30),
                                lat = c(-77, rep(-50, 10), -77, -77))
    target_sector <- sf::st_sfc(sf::st_polygon(list(as.matrix(target_sector))), crs = "+proj=longlat")
    res1 <- bb_polarview_search(Sys.Date() - 3L, formats = "geotiff", polygon = target_sector)
    ## polygon as string
    res2 <- bb_polarview_search(Sys.Date() - 3L, formats = "geotiff", polygon = "POLYGON ((709163.9 1228308, 2262269 3918365, 3104926 3291029, 3780196 2486274, 4251675 1547483, 4493944 525266.8, 4493944 -525266.8, 4251675 -1547483, 3780196 -2486274, 3104926 -3291029, 2262269 -3918365, 709163.9 -1228308, 709163.9 1228308))")
    if (length(res1) > 0) {
        expect_equal(res1, res2)
        expect_true(all(grepl("tif\\.tar\\.gz$", res1)))
    } else {
        warning("no results for bb_polarview_search")
    }
    res3 <- bb_polarview_search(Sys.Date() - 3L, formats = c("jpg", "geotiff"))
    if (length(res3) > 0) {
        expect_true(all(grepl("(tif\\.tar\\.gz|jpg)$", res3)))
        if (length(res1) > 0) {
            expect_true(length(res3) >= length(res1))
        }
    }
})
