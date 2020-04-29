data {
  int<lower = 1> N;
  int<lower = 1> K;
  int<lower = 0, upper = K> y[N];
}

parameters {
  real<lower = 0, upper = 1> p;
  real<lower = 0, upper = 1> psi;
}

transformed parameters {
  vector[N] log_lik;
  
  for (i in 1:N) {
    if (y[i] > 0) {
      log_lik[i] = log(psi) + binomial_lpmf(y[i] | K, p);
    } else {
      log_lik[i] = log_sum_exp(
        log(psi) + binomial_lpmf(y[i] | K, p), 
        log1m(psi)
      );
    }
  }
}

model {
  target += sum(log_lik);
  target += uniform_lpdf(p | 0, 1);
  target += uniform_lpdf(psi | 0, 1);
}

