context("general tests around data sources")

test_that("predefined sources work", {
    src <- blueant_sources(c("NSIDC passive microwave supporting files"))
    expect_s3_class(src,"data.frame")
    expect_equal(nrow(src),1)

    src_all <- blueant_sources()
    expect_gt(nrow(src_all),0)
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

test_that("selection by name or ID works",{
    temp1 <- blueant_sources("CNES-CLS2013 MDT")
    temp2 <- blueant_sources("CNES-CLS2013 Mean Dynamic Topography")
    expect_identical(temp1,temp2)
})

test_that("multiple selections work",{
    temp1 <- blueant_sources(c("CNES-CLS2013 MDT","NIC_daily_charts_antarctic"))
    expect_true(setequal(temp1$name,c("National Ice Center Antarctic daily sea ice charts","CNES-CLS2013 Mean Dynamic Topography")))
})
