context("reanalysis data sources")
test_that("NCEP2 source works",{
    src <- sources_reanalysis()
    ## default to monthly
    expect_equal(nrow(src),1)
    expect_identical(src$name,"NCEP-DOE Reanalysis 2 monthly averages")
    ## can have 6h or daily, too
    src <- sources_reanalysis("NCEP-DOE Reanalysis 2",time_resolutions=c("month","day","6h"))
    expect_equal(nrow(src),3)
    expect_error(sources_reanalysis("NCEP-DOE Reanalysis 2",time_resolutions="monkey"))
    expect_equal(nrow(sources_reanalysis("monkey")),0) ## nothing matching
})
