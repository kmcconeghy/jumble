#' @title rand_strata: Random assignment by strata
#'
#' @description Take a dataset and assign treatment by a specified stratum
#'
#' @usage rand_strata(df, strata, seed)
#'
#' @param df a dataframe, containing strata variable
#'
#' @param strata a column in df naming the stratification variable, can be character or numeric
#'
#' @param seed A seed for random assignment reproducibility
#'
#' @return dataframe with new column assigning treatment
#'
#' @export
#'
#' @examples
#' require(jumble)
#' rand_strata()
#'
rand_strata <- function(df, strata, seed=NULL) {

  # Seed
    if (is.null(seed)) seed <- as.integer(Sys.time())
    set.seed(seed)

  # Tidy eval
    enq_strata <- rlang::enquo(strata)

  # compute vals
    sampsi <- nrow(df) # length of assign vector
    str_num <- nrow(distinct(df, !!enq_strata))

  # map
    assign <- df %>%
      group_split(!!enq_strata) %>%
      map(~rbinom(nrow(.), 1, prob=0.5)) %>%
      combine(.)

    bind_cols(df, assign = assign) %>%
    return(.)
}
