data{
    int<lower=1> N;
	int<lower=1> N_sys_config;
    real t_mea_cfm[N];
    int sys_config[N];
    real dl[N];
    real t_cfm[N];
    real tesp[N];
}

parameters{
    real b0;
    vector[N_sys_config] b1;
    real g0;
    real b_tesp;
    real b_sys_cfm;
    real<lower=0> sys_sig;
    real b_dl;
    real<lower=0> sigma;
}

model{
    vector[N] sys_mu;
    vector[N] mu;
    sigma ~ cauchy( 0 , 1 );
    b_dl ~ normal( 0 , 1 );
    sys_sig ~ cauchy( 0 , 1 );
    b_sys_cfm ~ normal( 0 , 1 );
    b_tesp ~ normal( 0 , 1 );
    g0 ~ normal( 0 , 1 );
    for ( i in 1:N ) {
        sys_mu[i] = g0 + b_tesp * tesp[i] + b_sys_cfm * t_cfm[i];
    }
    b1 ~ normal( sys_mu , sys_sig );
    b0 ~ normal( 0 , 5 );
    for ( i in 1:N ) {
        mu[i] = b0 + b1[sys_config[i]] + b_dl * dl[i];
    }
    t_mea_cfm ~ normal( mu , sigma );
}

