#' @title rnd_str: Random assignment by strata
#'
#' @description Take a dataset and assign treatment by a specified stratum
#'
#' @usage rnd_str(df, strata)
#'
#' @param df a dataframe, containing strata variable
#'
#' @param strata a column in df naming the stratification variable, can be character or numeric
#'
#' @return dataframe with new column assigning treatment
#'
#' @export
#'
#' @examples
#'
rnd_str <- function(df, strata) {

  # Tidy eval
    enq_strata <- rlang::enquo(strata)

  # compute vals
    sampsi <- nrow(df) # length of assign vector
    str_num <- nrow(distinct(df, !!enq_strata))

    assign <- df %>%
      group_by(!!enq_strata) %>%
      mutate(assign = sample(0:1, n(), replace=T))

    bind_cols(assign) %>%
    return(.)
}
