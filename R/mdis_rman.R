#' @title mdis_grps: Matrix algebra in base R for covariate balance using Mahalanobis distance of two datasets
#'
#' @description This function will compute M-distance for two datasets by covariate means
#'
#' @usage mdis_grps(x_t, x_c)
#'
#' @param x_t a dataframe or matrix class object, all numeric
#'
#' @param x_c a dataframe or matrix class object, all numeric
#'
#' @return a numeric vector of length one, the M-distance multiplied by a constance for sample size
#'
#' @examples
#' require(jumble)
#' df_t <- jumble::ACTG175[ACTG175$arms==1, c('age', 'gender', 'race', 'msm')]
#' df_c <- jumble::ACTG175[ACTG175$arms==0, c('age', 'gender', 'race', 'msm')]
#'
#' mdis_grps(df_t, df_c)
#' @import tidyverse stats magrittr dplyr
#' @export
mdis_grps <- function(x_t, x_c) {

  X_t <- colMeans(x_t)

  X_c <- colMeans(x_c)

  X_dlta <- X_t - X_c

  X_cov <- rbind(x_t, x_c) %>%
    cov(.) %>%
    solve(.)

  M = t(X_dlta) %*% (X_cov %*% X_dlta)  #Not taking ^0.5 to follow Morgan

  return(as.numeric(M))
}
#' @title mdis_chrt: Matrix algebra in base R for covariate balance using Mahalanobis distance of a point to its distribution
#'
#' @description This function will compute M-distance for a covariate matrix to its mean
#'
#' @usage mdis_chrt(x_i)
#'
#' @param x_i A vector or covariate matrix
#'
#' @return a numeric vector of length equal to x_i
#'
#' @examples
#' require(jumble)
#' df_x <- ACTG175[, c('age', 'gender', 'race', 'msm')]
#'
#' mdis_chrt(df_x)
#'
#' @export
mdis_chrt <- function(x_i) {
  X_delta <- apply(x_i, 2, function(x) x - mean(x))

  X_cov <- x_i %>%
    cov(.) %>%
    solve(.)

  M <-  sqrt(diag(tcrossprod((X_delta %*% X_cov), X_delta)))

  return(as.numeric(M))
}
