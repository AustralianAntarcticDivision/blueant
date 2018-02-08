context("topographic data sources")

test_that("source nsidc0082 still works under ftp (due to be moved to https)",{
    skip_on_cran()
    temp_root <- tempdir()
    cf <- bb_config(local_file_root=temp_root)
    tmp <- sources(name="Radarsat Antarctic digital elevation model V2")
    tmp$source_url[[1]] <- "ftp://sidads.colorado.edu/pub/DATASETS/nsidc0082_radarsat_dem_v02/200M/BINARY/ramp200dem_osu_v2.hdr"
    cf <- bb_add(cf,tmp)
    bb_sync(cf,confirm_downloads_larger_than=-1)
    fnm <- file.path(temp_root,"sidads.colorado.edu/pub/DATASETS/nsidc0082_radarsat_dem_v02/200M/BINARY/ramp200dem_osu_v2.hdr")
    expect_true(file.exists(fnm))
    fi <- file.info(fnm)
    expect_gt(fi$size,1e3)
})
