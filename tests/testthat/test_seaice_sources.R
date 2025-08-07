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

test_that("seaice AMSR format options work",{
    src <- sources_seaice("AMSR-E_ASI_s6250")
    expect_equal(nrow(src), 1)
    expect_equal(length(src$source_url[[1]]), 1)
})

test_that("polarview search works", {
    ## polygon as sfc
    target_sector <- data.frame(lon = c(30, seq(30, 150, length.out = 10), 150, 30),
                                lat = c(-77, rep(-50, 10), -77, -77))
    target_sector <- sf::st_sfc(sf::st_polygon(list(as.matrix(target_sector))), crs = "EPSG:4326")

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

test_that("ifremer SSMI sea ice works", {
    src <- sources("CERSAT_SSMI") %>%
        bb_modify_source(source_url = "ftp://ftp.ifremer.fr/ifremer/cersat/products/gridded/psi-concentration/data/antarctic/daily/netcdf/2025/",
                         method = list(accept_download = "2025080.\\.nc\\.Z", level = 1))
    td <- tempfile()
    dir.create(td)
    res <- bb_get(src, local_file_root = td, confirm_downloads_larger_than = -1)
    chk <- dir(file.path(td, "ftp.ifremer.fr/ifremer/cersat/products/gridded/psi-concentration/data/antarctic/daily/netcdf/2025"), full.names = TRUE)
    ## should have .nc file for each .nc.Z file
    expect_true(all(table(sub("\\.Z$", "", chk)) == 2))
    unlink(td, recursive = TRUE)
})
