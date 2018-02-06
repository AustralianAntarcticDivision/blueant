context("data sources")

test_that("predefined sources work", {
    src <- blueant_sources(c("NSIDC passive microwave supporting files"))
    expect_s3_class(src,"data.frame")
    expect_equal(nrow(src),1)

    src_all <- blueant_sources()
    expect_gt(nrow(src_all),0)
    src_si <- blueant_sources(data_group="Sea ice")
    expect_gt(nrow(src_si),0)
    expect_lt(nrow(src_si),nrow(src_all))
    expect_true(all(src_si$data_group=="Sea ice"))
})

test_that("sources with authentication have an authentication_note entry", {
    src <- blueant_sources()
    na_or_empty <- function(z) is.na(z) | !nzchar(z)
    idx <- (!is.na(src$user) | !is.na(src$password)) & na_or_empty(src$authentication_note)
    expect_false(any(idx),sprintf("%d data sources with non-NA authentication but no authentication_note entry",sum(idx)))
})

test_that("authentication checks work",{
    expect_warning(bb_source(
        id="bilbobaggins",
        name="Test",
        description="blah",
        doc_url="blah",
        citation="blah",
        source_url="blah",
        license="blah",
        authentication_note="auth note",
        method=list("bb_handler_wget"),
        postprocess=NULL,
        data_group="blah"))

    expect_warning(bb_source(
        id="bilbobaggins",
        name="Test",
        description="blah",
        doc_url="blah",
        citation="blah",
        source_url="blah",
        license="blah",
        authentication_note="auth note",
        user="",
        method=list("bb_handler_wget"),
        postprocess=NULL,
        data_group="blah"))

    expect_warning(bb_source(
        id="bilbobaggins",
        name="Test",
        description="blah",
        doc_url="blah",
        citation="blah",
        source_url="blah",
        license="blah",
        authentication_note="auth note",
        password="",
        method=list("bb_handler_wget"),
        postprocess=NULL,
        data_group="blah"))

    ## no warning
    bb_source(
        id="bilbobaggins",
        name="Test",
        description="blah",
        doc_url="blah",
        citation="blah",
        source_url="blah",
        license="blah",
        authentication_note="auth note",
        user="user",
        password="password",
        method=list("bb_handler_wget"),
        postprocess=NULL,
        data_group="blah")
})

test_that("source nsidc0051 still works under ftp (due to be moved to https)",{
    skip_on_cran()
    temp_root <- tempdir()
    cf <- bb_config(local_file_root=temp_root)
    tmp <- blueant_sources(name="NSIDC SMMR-SSM/I Nasateam sea ice concentration")
    tmp$source_url[[1]] <- "ftp://sidads.colorado.edu/pub/DATASETS/nsidc0051_gsfc_nasateam_seaice/final-gsfc/south/daily/1978/nt_19781231_n07_v1.1_s.bin"
    cf <- bb_add(cf,tmp)
    bb_sync(cf)
    fnm <- file.path(temp_root,"sidads.colorado.edu/pub/DATASETS/nsidc0051_gsfc_nasateam_seaice/final-gsfc/south/daily/1978/nt_19781231_n07_v1.1_s.bin")
    expect_true(file.exists(fnm))
    fi <- file.info(fnm)
    expect_gt(fi$size,50e3)
})

test_that("source nsidc0081 still works under ftp (due to be moved to https)",{
    skip_on_cran()
    temp_root <- tempdir()
    target_file <- format(Sys.Date()-10,"nt_%Y%m%d_f18_nrt_s.bin")
    cf <- bb_config(local_file_root=temp_root)
    tmp <- blueant_sources(name="NSIDC SMMR-SSM/I Nasateam near-real-time sea ice concentration")
    tmp$source_url[[1]] <- paste0("ftp://sidads.colorado.edu/pub/DATASETS/nsidc0081_nrt_nasateam_seaice/south/",target_file)
    cf <- bb_add(cf,tmp)
    bb_sync(cf)
    fnm <- file.path(temp_root,"sidads.colorado.edu/pub/DATASETS/nsidc0081_nrt_nasateam_seaice/south",target_file)
    expect_true(file.exists(fnm))
    fi <- file.info(fnm)
    expect_gt(fi$size,50e3)
})

test_that("source nsidc0082 still works under ftp (due to be moved to https)",{
    skip_on_cran()
    temp_root <- tempdir()
    cf <- bb_config(local_file_root=temp_root)
    tmp <- blueant_sources(name="Radarsat Antarctic digital elevation model V2")
    tmp$source_url[[1]] <- "ftp://sidads.colorado.edu/pub/DATASETS/nsidc0082_radarsat_dem_v02/200M/BINARY/ramp200dem_osu_v2.hdr"
    cf <- bb_add(cf,tmp)
    bb_sync(cf)
    fnm <- file.path(temp_root,"sidads.colorado.edu/pub/DATASETS/nsidc0082_radarsat_dem_v02/200M/BINARY/ramp200dem_osu_v2.hdr")
    expect_true(file.exists(fnm))
    fi <- file.info(fnm)
    expect_gt(fi$size,1e3)
})

test_that("selection by name or ID works",{
    temp1 <- blueant_sources("CNES-CLS09 MDT")
    temp2 <- blueant_sources("CNES-CLS09 Mean Dynamic Topography")
    expect_identical(temp1,temp2)
})


