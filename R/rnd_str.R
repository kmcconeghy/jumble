#' @title rnd_str: Random assignment by strata
#'
#' @description Take a dataset and assign treatment by a specified stratum
#'
#' @usage rnd_str(df, strata, id)
#'
#' @param df a dataframe, containing strata variable
#'
#' @param strata a column in df naming the stratification variable, can be character or numeric
#'
#' @param id A variable identify unit of randomization
#'
#' @return dataframe with new column assigning treatment
#'
#' @export
#'
#' @examples
#' df <- jumble::ACTG175
#' rnd_str(df, symptom, pidnum)
#'
rnd_str <- function(df, strata, id) {

  # Tidy eval
  enq_strata <- rlang::enquo(strata)
  enq_id <- rlang::enquo(id)

  # compute vals
  sampsi <- nrow(df) # length of assign vector
  str_num <- nrow(distinct(df, !!enq_strata))

  assign <- df %>%
    select(!!enq_strata, !!enq_id) %>%
    group_split(!!enq_strata) %>%
    map(~rnd_allot(.[[2]])) %>%
    bind_rows(.)

  df_return <- df %>%
    select(!!enq_strata, !!enq_id) %>%
    arrange(!!enq_strata, !!enq_id) %>%
    bind_cols(., group = assign$group)

  return(df_return)
}
