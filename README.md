# Minimum Wage and Restaurant Employment: Difference-in-Differences

## Overview
This project estimates the effect of **2015Q1 state minimum-wage increases on restaurant employment** using a state-level Difference-in-Differences design.

The analysis compares treated states with never-treated controls and then tests sensitivity to alternative counterfactual groups and weighting schemes.

## Research Design
- State and quarter fixed effects
- Standard errors clustered at the state level
- Event-study estimates and pre-trend diagnostics
- Geographic robustness using bordering never-treated states
- Propensity-score Horvitz-Thompson ATT weighting
- Wage outcome as an additional validation exercise

## Main Results
The baseline DiD estimate is negative and statistically significant, but the effect becomes smaller and statistically insignificant when using geographically more comparable controls or propensity-score weighting.

The main methodological takeaway is that causal conclusions can be sensitive to the construction of the counterfactual group even when baseline pre-trend diagnostics appear reassuring.

## Repository Structure
- `minimum_wage_did_portfolio.R` — recruiter-facing portfolio version of the empirical workflow
- `data/README.md` — panel-data documentation

## Skills Demonstrated
Difference-in-Differences · Event studies · Fixed effects · Cluster-robust inference · Propensity-score weighting · Robustness analysis · R

## Author
Daniele Terzi — MSc Analytics and Data Science for Economics and Management, University of Brescia
