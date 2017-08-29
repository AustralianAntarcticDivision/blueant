library(testthat)
library(dplyr)
library(blueant)

if (.Platform$OS.type=="windows") {
    if (is.null(bb_find_wget())) {
        warning("At init of testing: could not find wget executable, installing.\n")
        bb_install_wget()
        if (is.null(bb_find_wget())) stop("could not install wget executable")
    }
}
test_check("blueant")
