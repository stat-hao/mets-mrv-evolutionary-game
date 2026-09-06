function summary = run_sensitivity(outDir, cfg)
%RUN_SENSITIVITY Reproduce the nine manuscript one-factor experiments.
% Parameters, initial shares and horizon follow the supplied sensitivity.m.
% Numerical endpoints
% at t=10 are not classified as equilibria. Requires base MATLAB only.

if ~exist(outDir, 'dir'), mkdir(outDir); end
p0 = mets_parameters('E8_case1');
names = {'x0','DeltaC1','DeltaC2','DeltaC3','DeltaC4','P1','F1','S','V'};
values = {[.1 .3 .5 .7 .9], [1 5 10 15 20], [1 5 10 15 20], ...
    [.5 1 5 10 15], [1 5 10 15 20], [1 3 4 5 6 7], ...
    [.5 1 1.5 2 2.5], [1 5 10 15 20], [1 5 10 15 20]};
labels = {'x(0)','\Delta C_1','\Delta C_2','\Delta C_3', ...
    '\Delta C_4','P_1','F_1','S','V'};
actors = {'Government','Shipping companies','Platforms','MRV agencies'};
summary = struct('name',{},'values',{},'maxFinalResidual',{},'figureBase',{});

for k = 1:numel(names)
    name = names{k};
    scan = values{k};
    colors = lines(numel(scan));
    solutions = cell(numel(scan),1);
    endpointRows = zeros(numel(scan),6);
    trajectoryRows = cell(numel(scan),1);
    for j = 1:numel(scan)
        p = p0;
        u0 = 0.5 * ones(4,1);
        if strcmp(name,'x0')
            u0(1) = scan(j);
        else
            p.(name) = scan(j);
        end
        s = simulate_mets(p,u0,[0 10],cfg);
        solutions{j} = s;
        endpointRows(j,:) = [scan(j),s.u(end,:),s.finalResidual];
        trajectoryRows{j} = [repmat(scan(j),numel(s.t),1),s.t(:),s.u];
    end

    fig = figure('Visible',cfg.figureVisible,'Color','w', ...
        'Position',[100 100 1550 370]);
    layout = tiledlayout(fig,1,4,'TileSpacing','compact','Padding','compact');
    for actor = 1:4
        ax = nexttile(layout);
        hold(ax,'on');
        for j = 1:numel(scan)
            s = solutions{j};
            plot(ax,s.t,s.u(:,actor),'Color',colors(j,:),'LineWidth',1.3, ...
                'DisplayName',sprintf('%s = %g',labels{k},scan(j)));
        end
        xlabel(ax,'Model time');
        ylabel(ax,'Active-strategy share');
        title(ax,actors{actor},'FontWeight','normal');
        xlim(ax,[0 10]); ylim(ax,[0 1]); grid(ax,'on');
        legend(ax,'Location','best','Interpreter','tex','FontSize',8);
    end
    if strcmp(name,'x0')
        base = 'Fig_InitialWillingness';
    else
        base = ['Fig_' name];
    end
    save_figure(fig,outDir,base);

    endpoints = array2table(endpointRows,'VariableNames', ...
        {'ScannedValue','x_t10','y_t10','z_t10','r_t10','FinalResidual'});
    trajectories = array2table(vertcat(trajectoryRows{:}),'VariableNames', ...
        {'ScannedValue','Time','x','y','z','r'});
    writetable(endpoints,fullfile(outDir,[base '_endpoints.csv']));
    writetable(trajectories,fullfile(outDir,[base '_trajectories.csv']));
    baselineParameters = p0; %#ok<NASGU>
    scannedParameter = name; %#ok<NASGU>
    scannedValues = scan; %#ok<NASGU>
    solverConfiguration = cfg; %#ok<NASGU>
    save(fullfile(outDir,[base '_data.mat']), ...
        'solutions','baselineParameters','scannedParameter', ...
        'scannedValues','solverConfiguration');
    summary(k) = struct('name',name,'values',scan, ...
        'maxFinalResidual',max(endpointRows(:,6)),'figureBase',base);
end
end
