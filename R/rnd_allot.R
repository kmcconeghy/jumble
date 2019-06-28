#' @title rnd_allot: Random allotment into one of two groups of equal sample size
#'
#' @description Used when equal sized groups are desired, if the cohort size is odd then
#' it will randomly assign the odd one out to one of the groups. Currently only 2
#' groups.
#'
#' @usage rnd_allot(x, seed)
#'
#' @param x a Vector to assign
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
#' rnd_allot(x, as.integer(ymd('2016-01-01')))
#'
#' @import tidyverse stats
rnd_allot <- function(x, seed=NULL) {

  if (is.null(seed)) seed <- as.integer(Sys.Date() + runif(1, 0, 100))

  #checks
  stopifnot(is.vector(x))
  stopifnot(is.integer(seed))
  set.seed(seed)

  #Parameters
  groups <- letters[1:2]
  chrt_sz <- length(x)
  grp_sz <- chrt_sz / 2

  #determine odd unit assignment
  #rbinom is faster, but use sample here for consistency
  if (is.integer(grp_sz)==F) { # if not even number
    grp_sz_floor <- floor(chrt_sz / 2)
    grp_sz_ceiling <- ceiling(chrt_sz / 2)
    grp_rnd <- if (sample(0:1, 1)) {grp_sz_floor} else {grp_sz_ceiling}
  } else {grp_rnd <- grp_sz}

  assign_grp <- rep(c('a','b'), c(chrt_sz - grp_rnd, grp_rnd))

  assign <- bind_cols(id=x,
                      group = sample(assign_grp))

  attr(assign, 'seed') <- seed

  return(assign)
}
