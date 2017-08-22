library(testthat)
library(dplyr)
library(blueant)

if (.Platform$OS.type=="windows") {
    tryCatch(wget_exe(),
             error=function(e) {
                 warning("At init of testing: could not find wget executable, installing.\n")
                 install_wget()
             })
}
test_check("blueant")
