# Maritime ETS–MRV evolutionary game

Minimal MATLAB package for the manuscript's numerical figures and underlying simulation data. Parameters are illustrative scenario assumptions, not empirical observations.

## Run

Use MATLAB R2022a (base MATLAB; no additional toolbox required). Open this folder as the current folder and run:

```matlab
outputDir = run_all;
```

Outputs are written to a new timestamped `results/` folder: PDF/PNG figures, CSV/MAT simulation data, parameter table, and run settings/log. The 100-by-100 joint scan requires 10,000 ODE integrations and is the longest experiment.

## Files and manuscript mapping

| Files | Purpose / outputs |
|---|---|
| `run_all.m` | Single entry for the numerical experiments |
| `config/mets_parameters.m` | Seven pure-equilibrium scenarios and two mixed-population examples |
| `config/reproduction_settings.m` | Solver tolerances, output sampling, grids and seed |
| `src/` | Replicator equations, Jacobian, classification, integration and exports |
| `experiments/run_pure_scenarios.m` | E1, E2, E3, E8 (two settings), E9 and E16; 3D projections and time series (E8: two time-series panels) |
| `experiments/run_sensitivity.m` | Initial government share; DeltaC1–DeltaC4, P1, F1, S and V |
| `experiments/run_heatmaps.m` | Initial government share versus P1: four shares at model time 10 |
| `experiments/run_mixed_examples.m` | Boundary mixed equilibrium and equilibrium-line examples |

Figure basenames identify experiments independently of changing manuscript figure numbers. Shared numerical routines are dependencies of the experiments; no archives, bibliography checks, exploratory scans, diagram assets or symbolic derivation scripts are included.

## Numerical settings and interpretation

State order is `[x,y,z,r]`: government, shipping companies, platforms and MRV agencies; entries are active-strategy population shares. `ode45` uses RelTol=1e-8, AbsTol=1e-10, MaxStep=0.25. Standard trajectories use 501 output times. Model time is not calendar time.

Pure 3D panels use 125 initial conditions: x,y from five points in [0.01,0.99], z from five points in [0.1,0.99], r=0.5; horizon [0,50]. Pure time-series panels start at [0.01,0.99,0.99,0.99], horizon [0,20]. These common settings are explicit reconstruction choices generalized from supplied scripts, because the original scripts did not preserve every panel's initial conditions. Check them against the final manuscript; exact recovery of every originally submitted curve is not claimed.

Sensitivity experiments use E8_case1 parameters, initial shares 0.5 and horizon [0,10], changing only the named parameter (or x(0)). The joint scan uses the same baseline, x(0) in [0,1] and P1 in [0,10], with 100 values per axis. Its endpoints are finite-time shares, not equilibrium classifications.

The mixed-boundary trajectories use seed 252 (a documented reconstruction choice; the original random seed was not saved), ten initial points on z=r=0, and horizon [0,50]. The example (1/3,2/3,0,0) is unstable in the full system. The point (1,0.4213,0,0) belongs to an equilibrium line and is not an isolated asymptotically stable attractor. Exact-equilibrium time-series plots alone do not demonstrate attraction. The package retains these examples with corrected labels.

The package has been statically checked for MATLAB R2022a syntax and required project dependencies. Native MATLAB execution has not been performed in the packaging environment; verify exported panels against the final manuscript before submission.
