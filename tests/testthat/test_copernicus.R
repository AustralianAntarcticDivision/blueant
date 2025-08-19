context("Copernicus Marine data sources")
test_that("Copernicus data sources works",{
    ## until https://github.com/pepijn-devries/CopernicusMarine/issues/66 resolved
    ## src <- bb_modify_source(sources("SEALEVEL_GLO_PHY_MDT_008_063"), user = "test", password = "test")
    ## cf <- bb_add(bb_config(local_file_root = tempdir()), src)
    ## res <- bb_sync(cf, dry_run = TRUE)
    ## expect_equal(nrow(res$files[[1]]), 1)

    src <- bb_modify_source(sources("SEALEVEL_GLO_PHY_L4_NRT_008_046"), user = "test", password = "test")
    cf <- bb_add(bb_config(local_file_root = tempdir()), src)
    res <- bb_sync(cf, dry_run = TRUE)
    expect_gt(nrow(res$files[[1]]), 50) ## expect lots of files

})
