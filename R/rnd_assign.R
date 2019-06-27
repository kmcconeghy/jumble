#' @title rnd_assign: Randomly assign one unit into one of K groups
#'
#' @description A simple randomizer, provides equal probability of assignment to
#' one of many groups
#'
#' @usage rnd_assign(x, k, seed)
#'
#' @param x a Vector to assign
#'
#' @param k Number of groups to assign
#'
#' @param seed A seed for random assignment reproducibility
#'
#' @return An array with x, k assignment groups, and the seed as an attribute
#'
#' @export
#'
#' @examples
#' require(jumble)
#' x <- 1:100
#' rnd_assign(x, 2, as.integer(ymd('2016-01-01')))
#'
#' @import tidyverse stats
rnd_assign <- function(x, k, seed=NULL) {

  if (is.null(seed)) seed <- as.integer(Sys.Date() + runif(1, 0, 100))

  #checks
  stopifnot(is.vector(x))
  stopifnot(is.vector(k))
  stopifnot(is.integer(seed))

  groups <- letters[1:k]

  set.seed(seed)
  assign <- bind_cols(id=x,
                      group = sample(groups, length(x), replace = T))

  attr(assign, 'seed') <- seed

  return(assign)
}
