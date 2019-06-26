#' @title mdist: Fast calculation for covariate balance using Mahalanobis distance of two datasets
#'
#' @description This function will compute M-distance for two datasets by covariate means
#'
#' @usage mdist(x_t, x_c)
#'
#' @param x_t a dataframe or matrix class object, all numeric
#'
#' @param x_c a dataframe or matrix class object, all numeric
#'
#' @return a numeric vector of length one, the M-distance multiplied by a constance for sample size
#'
#' @export
#'
#' @examples
#' require(jumble)
#' df_t <- jumble::ATCG175[ATCG175$arms==1, c('age', 'gender', 'race', 'msm')]
#' df_c <- jumble::ATCG175[ATCG175$arms==0, c('age', 'gender', 'race', 'msm')]
#'
#' mdist(df_t, df_c)
#'
mdist <- function(x_t, x_c) {
  ssc <- (nrow(x_t) * nrow(x_c)) / (nrow(x_t) + nrow(x_c))

  X_t <- colMeans(x_t)

  X_c <- colMeans(x_c)

  X_dlta <- X_t - X_c

  X_cov <- rbind(x_t, x_c) %>%
    cov(.) %>%
    solve(.)

  M = ssc * (t(X_dlta) %*% (X_cov %*% X_dlta))

  return(as.numeric(M))
}
