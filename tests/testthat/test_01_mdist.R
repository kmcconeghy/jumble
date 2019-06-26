mdist_rman <- function(x_t, x_c) {
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

mdist_rbase <- function(x_t, x_c) {
  ssc <- (nrow(x_t) * nrow(x_c)) / (nrow(x_t) + nrow(x_c))

  X_t <- colMeans(x_t)

  X_c <- colMeans(x_c)

  M <- mahalanobis(X_t, X_c, cov(bind_rows(x_t, x_c)))

  return(as.numeric(M))
}

mdist_cpp <- cxxfunction(signature(tm="NumericMatrix",
                                 tm2="NumericMatrix"),
                       plugin="RcppEigen",
                       body="
NumericMatrix tm22(tm2);
NumericMatrix tmm(tm);

const Eigen::Map<Eigen::MatrixXd> ttm(as<Eigen::Map<Eigen::MatrixXd> >(tmm));
const Eigen::Map<Eigen::MatrixXd> ttm2(as<Eigen::Map<Eigen::MatrixXd> >(tm22));

Eigen::MatrixXd prod = ttm*ttm2;
return(wrap(prod));
                 ")

set.seed(123)
M1 <- matrix(sample(1e3),ncol=50)
M2 <- matrix(sample(1e3),nrow=50)

identical(etest(M1,M2), M1 %*% M2)
[1] TRUE
res <- microbenchmark(
  +   etest(M1,M2),
  +   M1 %*% M2,
  +   times=10000L)

res

Unit: microseconds
expr    min    lq      mean median     uq    max neval
etest(M1, M2)  5.709  6.61  7.414607  6.611  7.211 49.879 10000
M1 %*% M2 11.718 12.32 13.505272 12.621 13.221 58.592 10000
