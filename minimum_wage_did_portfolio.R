# Minimum Wage and Restaurant Employment
# Portfolio version of the empirical analysis
# Author: Daniele Terzi

library(readxl)
library(dplyr)
library(fixest)
library(ggplot2)

# Data -----------------------------------------------------------------------
# Place the original state-quarter panel in data/minwage_qcew_state_panel.xlsx
df <- read_excel("data/minwage_qcew_state_panel.xlsx")

# The project focuses on the 2015Q1 treatment cohort and never-treated states.
# Variable names below follow the project dataset.
df <- df %>%
  mutate(
    post = as.integer(quarter_label >= "2015Q1"),
    did = treated_2015q1 * post,
    log_employment = log(employment),
    log_avg_weekly_wage = log(avg_weekly_wage)
  )

# Baseline Difference-in-Differences -----------------------------------------
baseline <- feols(
  log_employment ~ did | state_abbr + quarter_label,
  cluster = ~state_abbr,
  data = df
)

summary(baseline)

# Linear pre-trend diagnostic ------------------------------------------------
pre <- df %>% filter(quarter_label < "2015Q1")

pretrend <- feols(
  log_employment ~ pre_time * treated_2015q1 | state_abbr,
  cluster = ~state_abbr,
  data = pre
)

summary(pretrend)

# Event study ----------------------------------------------------------------
event_study <- feols(
  log_employment ~ i(event_time_2015, treated_2015q1, ref = -1) |
    state_abbr + quarter_label,
  cluster = ~state_abbr,
  data = df
)

iplot(
  event_study,
  main = "Minimum Wage Increase and Restaurant Employment",
  xlab = "Quarters relative to treatment",
  ylab = "Effect on log employment"
)

# Geographic robustness ------------------------------------------------------
# The original project restricts the control group to never-treated states
# bordering at least one treated state.
geo_df <- df %>% filter(geographic_sample == 1)

geo_did <- feols(
  log_employment ~ did | state_abbr + quarter_label,
  cluster = ~state_abbr,
  data = geo_df
)

summary(geo_did)

# Propensity-score ATT weighting ---------------------------------------------
# Weights were constructed from pre-treatment employment level/trend,
# minimum wage and mean employment characteristics.
weighted_did <- feols(
  log_employment ~ did | state_abbr + quarter_label,
  weights = ~ps_att_ht_weight,
  cluster = ~state_abbr,
  data = df
)

summary(weighted_did)

# Wage outcome ---------------------------------------------------------------
wage_model <- feols(
  log_avg_weekly_wage ~ did | state_abbr + quarter_label,
  cluster = ~state_abbr,
  data = df
)

summary(wage_model)

# Main interpretation --------------------------------------------------------
# The baseline employment estimate is negative and statistically significant,
# while geographically restricted and propensity-score weighted estimates are
# smaller and statistically insignificant. The project therefore emphasizes
# sensitivity to counterfactual/control-group construction.
