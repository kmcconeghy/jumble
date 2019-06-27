library(jumble)
df_t <- jumble::ACTG175[ACTG175$arms==1, c('age', 'gender', 'race', 'msm')]
df_c <- jumble::ACTG175[ACTG175$arms==0, c('age', 'gender', 'race', 'msm')]

context("M-distance")

test_that("test Mahalanobis distance functions - Accuracy ", {

  M1 <- mdis_grps(df_t, df_c)
  M2 <- mdis_rbase(df_t, df_c)
  M3 <- Rfast::mahala(colMeans(df_t), colMeans(df_c), cov(bind_rows(df_t, df_c)))

  expect_true(all.equal(M1, M2, M3))
})
