#' @title rnd_rerand: Re-randomization on mahalanobis and acceptance criteria
#'
#' @description Conduct a re-randomization procedure using a specified set of covariates,
#' for each random assignment a mahalanobis distance of group means will be computed
#' with a sample size adjustment, and the user can either allow the program to find
#' a cut-off from a chi-square distribution for an given acceptance probability,
#' default probability is 0.001.  Otherwise specify the cutoff, M-distance.
#'
#' @usage rnd_rerand(x, cutoff, pr_a, seed)
#'
#' @param x an id, vector to assign groups to
#'
#' @param cutoff Mahalanobis distance cut-off
#'
#' @param pr_a Probability of acceptance, used if cutoff is null; default is 0.001
#'
#' @param seed A seed for random assignment reproducibility
#'
#' @return A dataframe, contains id, group assignment, and
#' attributes giving the seed, cut-off, randomization date, number of iterations
#' needed to achieve randomization
#'
#' @export
#'
#' @import tidyverse stats Rfast
rnd_rerand <- function(x, cutoff=NULL, pr_a=0.001, seed=NULL) {

  #set seed
    if (is.null(seed)) seed <- as.integer(as.Date(Sys.Date()) + runif(1, 0, 100))
    set.seed(seed)

  #checks
    stopifnot(is.integer(seed))

  #Groups assigned
    grp <- letters[1:2] #Assignment groups

  # Set Parameters
    X_k <- ncol(x) #No. covariates
    if ( is.null(cutoff)) cutoff <- qchisq(Pa, X_k) #Cut-off for M-distance
    x_n <- nrow(x) #No. random assignments
    x_i <- 1:x_n
    iter <- 0L
    cut_off_i <- Inf

  # Assign
    while (cut_off_i > cutoff) {
      iter <- iter + 1L

      rnd_list <- rnd_allot(x_i)

      x_rnd <- bind_cols(rnd_list, x)
      x_a <- x_rnd[x_rnd$group=='a', colnames(x)]
      x_b <- x_rnd[x_rnd$group=='b', colnames(x)]

      ssc <-(nrow(x_a) * nrow(x_b)) / x_n # sample size correction

      cut_off_i <- Rfast::mahala(colMeans(x_a), colMeans(x_b), sigma=cov(x)) * ssc

    } # when it finds an acceptable randomization it will continue

    attr(x_rnd, 'seed') <- seed + iter #iter correction
    attr(x_rnd, 'iter') <- iter
    attr(x_rnd, 'time') <- Sys.Date()

  return(x_rnd)

}
