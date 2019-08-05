library(rstan)
setwd("D:/Google Drive/R/rstan/airflow")
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())
source('stan_utility.R')
writeLines(readLines("airflow_model.stan"))

###mydata
sys_config <- c(1, 2, 3)
t_cfm <- c(1125, 850, 1125)
tesp <- c(0.7, .45, .65)
dl <- c(225, 190, 200)
t_mea_cfm <- c(709, 608, 799)
N <- 3
N_sys_config <- 3
stan_rdump(c("sys_config", "t_cfm", "tesp", "dl", "t_mea_cfm", "N", "N_sys_config"), file="airflow.data.R")
mydata <- read_rdump("airflow.data.R") #data can be read in

fit <- stan(file='airflow_model_ver4.stan', data=mydata, seed=194838,
            control = list(max_treedepth = 15, adapt_delta = 0.99))

#table
print(fit, depth = 2)

#diagnostics
check_treedepth(fit) #treedepth
check_energy(fit) #Checking E-BFMI
check_div(fit) #Checking Divergences
library(shinystan)
launch_shinystan(fit)

#visualizations
posterior <- as.matrix(fit)
library(bayesplot)
plot_title <- ggtitle("Posterior distributions", "with medians and 80% intervals")
color_scheme_set("red")
mcmc_areas(posterior,
           pars = c("sys_sig", "sigma"),
           prob = 0.8) + plot_title

