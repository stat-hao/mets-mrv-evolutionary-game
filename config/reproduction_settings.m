function cfg = reproduction_settings()
%REPRODUCTION_SETTINGS Explicit numerical settings for all experiments.
cfg.relTol=1e-8;
cfg.absTol=1e-10;
cfg.maxStep=.25;
cfg.eigenTolerance=1e-8;
cfg.pointCount=501;
cfg.seed=252;
cfg.figureVisible='off';
cfg.pureGridN=5;
cfg.heatmapN=100;
end
