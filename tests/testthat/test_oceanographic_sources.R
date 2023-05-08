context("oceanographic data sources")
test_that("Argo ocean basin data source works",{
    skip("skipping all Argo tests temporarily")
    ## unexpected region
    expect_error(sources_oceanographic("Argo ocean basin data (USGODAE)", region="notavalidregion"))
    expect_equal(nrow(sources_oceanographic("Argo ocean basin data (USGODAE)")), 1)
    src <- sources_oceanographic("Argo ocean basin data (USGODAE)", region=c("indian", "pacific", "atlantic"))
    expect_equal(nrow(src), 1)
    expect_equal(length(src$source_url[[1]]), 3)

    src <- sources_oceanographic("Argo ocean basin data (USGODAE)", region=c("indian", "pacific", "atlantic"), years=2017)
    expect_equal(nrow(src), 1)
    expect_equal(length(src$source_url[[1]]), 3)

    src <- sources_oceanographic("Argo ocean basin data (USGODAE)", region=c("indian", "pacific", "atlantic"), years=c(2017, 2018))
    expect_equal(nrow(src), 1)
    expect_equal(length(src$source_url[[1]]), 6)

    expect_error(sources_oceanographic("Argo ocean basin data (USGODAE)", years=NULL))
    src <- sources_oceanographic("Argo ocean basin data (USGODAE)", years="2018")
    expect_equal(nrow(src), 1)
    expect_equal(length(src$source_url[[1]]), 1)

    skip("skipping Argo data source test temporarily")
    ## is timing out
    src <- sources("10.17882/42182", region = "indian", years = 1999)
    cf <- bb_add(bb_config("c:/temp/data/bbtest"), src)
    res <- bb_sync(cf, dry_run = TRUE)
    expect_equal(nrow(res$files[[1]]), 30)
})
