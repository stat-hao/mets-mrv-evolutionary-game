# Maritime ETS–MRV evolutionary game

MATLAB implementation for **Emissions Trading and MRV Mechanism for Maritime Decarbonization: A Four-Party Evolutionary Analysis**.

The code computes evolutionary trajectories and local equilibrium stability for four populations: governments, shipping companies, carbon-trading platforms and MRV agencies. The state vector is `[x,y,z,r]`, where each component is the population share adopting the corresponding active strategy.

## Run all experiments

Use MATLAB R2022a with base MATLAB; no additional toolbox is required. Set the repository root as the current folder and run:

```matlab
outputDir = run_all;
```

This runs the four experiment scripts below and saves figures and numerical data in a timestamped `results/` folder, together with the scenario parameters and numerical settings.

## Which file should I use?

| What to calculate or change | MATLAB file | What it does |
|---|---|---|
| Evolutionary trajectories under the pure-equilibrium scenarios | [run_pure_scenarios.m](experiments/run_pure_scenarios.m) | Simulates E1, E2, E3, E8 (two parameter sets), E9 and E16; generates time series and the associated 3D projections |
| Sensitivity to a parameter or initial government share | [run_sensitivity.m](experiments/run_sensitivity.m) | Runs the nine one-factor experiments for x(0), DeltaC1–DeltaC4, P1, F1, S and V; scan values are specified in this file |
| Joint effects of initial government share and company incentives | [run_heatmaps.m](experiments/run_heatmaps.m) | Varies x(0) and P1 on a 100-by-100 grid and computes all four strategy shares at time 10 |
| Mixed-population examples | [run_mixed_examples.m](experiments/run_mixed_examples.m) | Simulates the boundary mixed equilibrium and equilibrium-line examples |
| View or change scenario parameters | [mets_parameters.m](config/mets_parameters.m) | Defines the seven pure-scenario configurations and two mixed-example configurations |
| Change solver tolerances, grid resolution or random seed | [reproduction_settings.m](config/reproduction_settings.m) | Defines settings shared by the numerical experiments |
| Evaluate active-versus-passive payoff differences | [mets_payoff_advantages.m](src/mets_payoff_advantages.m) | Computes the four payoff advantages used in the replicator equations |
| Evaluate the replicator equations | [mets_rhs.m](src/mets_rhs.m) | Computes the derivative of `[x,y,z,r]` |
| Calculate the Jacobian and its eigenvalues | [mets_jacobian.m](src/mets_jacobian.m) | Evaluates the analytical Jacobian numerically; use MATLAB `eig` for its eigenvalues |
| Check a candidate equilibrium and its local stability | [classify_equilibrium.m](src/classify_equilibrium.m) | Checks the equilibrium residual and classifies the Jacobian eigenvalues; nonhyperbolic cases require further analysis |
| Simulate a custom parameter set and initial state | [simulate_mets.m](src/simulate_mets.m) | Integrates the replicator equations using `ode45` and returns the time vector and strategy shares |

## Run one experiment

From the repository root, initialize the paths and settings once:

```matlab
addpath('src', 'config', 'experiments');
cfg = reproduction_settings;
```

Then run the experiment you need:

```matlab
% Pure-equilibrium scenarios
run_pure_scenarios(fullfile('results','pure'), cfg);

% One-factor sensitivity experiments
run_sensitivity(fullfile('results','sensitivity'), cfg);

% Joint x(0)-P1 experiment: 10,000 ODE integrations
run_heatmaps(fullfile('results','heatmaps'), cfg);

% Mixed-population examples
run_mixed_examples(fullfile('results','mixed'), cfg);
```

Each function saves its figures and data in the specified folder. Initial states and time horizons are defined in the corresponding experiment script. Reusing an output folder overwrites files with the same names; `run_all` creates a new folder for each run.

## Check an equilibrium or calculate a custom trajectory

After the path initialization above:

```matlab
% Load a scenario and check the candidate E1 equilibrium
p = mets_parameters('E1');
uStar = [1; 1; 1; 1];
info = classify_equilibrium(uStar, p);
disp(info.status);
disp(info.eigenvalues);

% Integrate from a chosen initial population distribution
u0 = [0.2; 0.4; 0.6; 0.8];
s = simulate_mets(p, u0, [0 20], cfg);
% s.t: time vector; s.u: columns x, y, z, r
```

Available scenario identifiers are `E1`, `E2`, `E3`, `E8_case1`, `E8_case2`, `E9`, `E16`, `mixed_boundary` and `mixed_line`. For a custom scenario, load one configuration and change its fields, for example `p.P1 = 2`, before calling `simulate_mets`.

## Interpretation and reproducibility

Parameters are illustrative scenario assumptions, not empirical estimates. Model time is not calendar time, and finite-time strategy shares are not automatically equilibrium outcomes. The boundary point (1/3,2/3,0,0) is unstable in the full system; (1,0.4213,0,0) belongs to an equilibrium line rather than an isolated asymptotically stable attractor.

Common pure-panel initial conditions and random seed 252 are documented reconstruction choices because the original scripts did not preserve every panel's initial conditions or random seed. Exact recovery of every original curve is therefore not claimed. The package passed static MATLAB R2022a syntax checks; native MATLAB execution was not performed in the packaging environment.

Uploaded manuscript illustrations are available in [figures/](figures/). Newly computed results are saved separately in `results/`.
