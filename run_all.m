function outputDir = run_all()
%RUN_ALL Generate manuscript numerical figures and their data.
root=fileparts(mfilename('fullpath'));
addpath(fullfile(root,'src'),fullfile(root,'config'),fullfile(root,'experiments'));
cfg=reproduction_settings();
outputDir=fullfile(root,'results',datestr(now,'yyyymmdd_HHMMSS'));
suffix=0; candidate=outputDir;
while exist(candidate,'dir')
    suffix=suffix+1; candidate=sprintf('%s_%d',outputDir,suffix);
end
outputDir=candidate; mkdir(outputDir);
diary(fullfile(outputDir,'run_log.txt'));
cleanup=onCleanup(@()diary('off')); %#ok<NASGU>
metadata.matlabVersion=version;
metadata.platform=computer;
metadata.toolboxes=ver;
metadata.startedAt=datestr(now,30);
metadata.settings=cfg;
save(fullfile(outputDir,'run_metadata.mat'),'metadata');
fprintf('MATLAB %s; output %s\n',version,outputDir);
export_configuration(outputDir);
run_pure_scenarios(fullfile(outputDir,'pure'),cfg);
run_sensitivity(fullfile(outputDir,'sensitivity'),cfg);
run_mixed_examples(fullfile(outputDir,'mixed'),cfg);
run_heatmaps(fullfile(outputDir,'heatmaps'),cfg);
fprintf('Completed. Outputs are in %s\n',outputDir);
end

function export_configuration(outDir)
ids={'E1','E2','E3','E8_case1','E8_case2','E9','E16','mixed_boundary','mixed_line'};
rows=struct([]);
for k=1:numel(ids)
    p=mets_parameters(ids{k}); p.Scenario=ids{k}; rows(k)=p; %#ok<AGROW>
end
writetable(struct2table(rows),fullfile(outDir,'scenario_parameters.csv'));
end
