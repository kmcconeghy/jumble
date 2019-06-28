
library(tidyverse)
library(jumble)

## Build

devtools::document()
devtools::test()
devtools::check()

pkgbuild::build()

pkgdown::build_site()

