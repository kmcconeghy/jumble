library('tidyverse')
library('usethis')

### Using AIDS Clinical Trials Group Study 175
# ACTG 175 was a randomized clinical trial to compare
# monotherapy with zidovudine or didanosine with combination
# therapy with zidovudine and didanosine or zidovudine and
# zalcitabine in adults infected with the human immunodeficiency
# virus type I whose CD4 T cell counts were between 200 and 500
# per cubic millimeter.

# Hammer SM, et al. (1996), "A trial comparing nucleoside
# monotherapy with combination therapy in HIV-infected adults
# with CD4 cell counts from 200 to 500 per cubic millimeter.",
# New England Journal of Medicine, 335:1081–1090.
#

  install.packages(speff2trial)
  library(speff2trial)

  rm(ACTG175) #mk sure not in active environment

  ACTG175 <- ACTG175 %>%
    rename(msm = homo) %>%
    dplyr::filter(arms <= 1) # only keep two treatment groups

  use_data(ACTG175, overwrite =T)

