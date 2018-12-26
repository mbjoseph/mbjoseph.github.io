
data{
  int n;
  int nobs;
  real xobs[nobs];
  real y[n];
  int indx[nobs];
}

parameters {
  real alpha;
  real beta;
  real<lower=0> sigmay;
  real<lower=0> sigmax;
  real x[n];
}

model {
  // priors
  alpha ~ normal(0, 1);
  beta ~ normal(0, 1);
  sigmay ~ normal(0, 1);
  sigmax ~ normal(0, 1);

  // model structure  
  for (i in 1:nobs){
    xobs[i] ~ normal(x[indx[i]], sigmax);
  }
  for (i in 1:n){
    y[i] ~ normal(alpha + beta*x[i], sigmay);
  }
}

  