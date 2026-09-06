function save_figure(fig,outDir,baseName)
%SAVE_FIGURE Export publication-friendly PDF and preview PNG.
if ~exist(outDir,'dir'), mkdir(outDir); end
exportgraphics(fig,fullfile(outDir,[baseName '.pdf']),'ContentType','vector');
exportgraphics(fig,fullfile(outDir,[baseName '.png']),'Resolution',180);
close(fig);
end
