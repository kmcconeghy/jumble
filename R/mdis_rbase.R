#' @title mdis_rbase: Matrix algebra in base R for covariate balance using Mahalanobis distance of two datasets
#'
#' @description This function will compute M-distance for two datasets by covariate means
#'
#' @usage mdis_rbase(x_t, x_c)
#'
#' @param x_t a dataframe or matrix class object, all numeric
#'
#' @param x_c a dataframe or matrix class object, all numeric
#'
#' @return a numeric vector of length one, the M-distance multiplied by a constance for sample size
#'
#' @export
#' @import stats
mdis_rbase <- function(x_t, x_c) {
  X_t <- colMeans(x_t)

  X_c <- colMeans(x_c)

  M = mahalanobis(X_t, X_c, cov(bind_rows(x_t, x_c)))

  return(as.numeric(M))
}
