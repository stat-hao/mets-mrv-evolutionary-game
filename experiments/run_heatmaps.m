function summary = run_heatmaps(outDir, cfg)
%RUN_HEATMAPS Plot finite-time strategy shares from supplied two-factor scans.
% Manuscript grid: x(0)-P1.
% cfg.heatmapN sets points per axis (original full grids use 100).
% All matrices contain shares at t=10, not verified equilibrium classes.

if ~exist(outDir, 'dir'), mkdir(outDir); end
validateattributes(cfg.heatmapN,{'numeric'},{'scalar','integer','>=',2});
p0 = mets_parameters('E8_case1');
n = cfg.heatmapN;

% Matrix rows correspond to the plotted vertical-axis values.
specs = struct('rowName','x0','rowRange',[0 1], ...
    'colName','P1','colRange',[0 10], ...
    'rowLabel','Initial government share x(0)', ...
    'colLabel','Shipping-company incentive P_1', ...
    'base','Fig_Heatmap_x0_P1_FourActors');

actors = {'Government','Shipping companies','Platforms','MRV agencies'};
integrationCfg = cfg;
integrationCfg.pointCount = 2; % No dense output grid; ode45 remains adaptive.
summary = struct('figureBase',{},'gridSize',{},'maxFinalResidual',{});
for k = 1:numel(specs)
    spec = specs(k);
    rowValues = linspace(spec.rowRange(1),spec.rowRange(2),n);
    colValues = linspace(spec.colRange(1),spec.colRange(2),n);
    finalShares = zeros(n,n,4);
    finalResiduals = zeros(n,n);
    for i = 1:n
        for j = 1:n
            p = p0;
            u0 = 0.5*ones(4,1);
            if strcmp(spec.rowName,'x0')
                u0(1) = rowValues(i);
            else
                p.(spec.rowName) = rowValues(i);
            end
            p.(spec.colName) = colValues(j);
            s = simulate_mets(p,u0,[0 10],integrationCfg);
            finalShares(i,j,:) = reshape(s.u(end,:),1,1,4);
            finalResiduals(i,j) = s.finalResidual;
        end
    end

    fig = figure('Visible',cfg.figureVisible,'Color','w', ...
        'Position',[100 100 1600 410]);
    layout = tiledlayout(fig,1,4,'TileSpacing','compact','Padding','compact');
    for actor = 1:4
        ax = nexttile(layout);
        imagesc(ax,colValues,rowValues,finalShares(:,:,actor),[0 1]);
        set(ax,'YDir','normal');
        colormap(ax,parula);
        cb = colorbar(ax);
        cb.Label.String = 'Active-strategy share at t = 10';
        xlabel(ax,spec.colLabel,'Interpreter','tex');
        ylabel(ax,spec.rowLabel,'Interpreter','tex');
        title(ax,actors{actor},'FontWeight','normal');
    end
    save_figure(fig,outDir,spec.base);

    [rowGrid,colGrid] = ndgrid(rowValues,colValues);
    flat = [rowGrid(:),colGrid(:),reshape(finalShares,n*n,4),finalResiduals(:)];
    endpoints = array2table(flat,'VariableNames', ...
        {spec.rowName,spec.colName,'x_t10','y_t10','z_t10','r_t10','FinalResidual'});
    writetable(endpoints,fullfile(outDir,[spec.base '_endpoints.csv']));
    baselineParameters = p0; %#ok<NASGU>
    solverConfiguration = integrationCfg; %#ok<NASGU>
    horizon = [0 10]; %#ok<NASGU>
    save(fullfile(outDir,[spec.base '_data.mat']), ...
        'spec','rowValues','colValues','finalShares','finalResiduals', ...
        'baselineParameters','solverConfiguration','horizon');
    summary(k) = struct('figureBase',spec.base,'gridSize',[n n], ...
        'maxFinalResidual',max(finalResiduals(:)));
end
end
