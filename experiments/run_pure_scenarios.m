function results = run_pure_scenarios(outDir,cfg)
%RUN_PURE_SCENARIOS All seven parameter sets; 3D projections and time series.
if ~exist(outDir,'dir'), mkdir(outDir); end
ids={'E1','E2','E3','E8_case1','E8_case2','E9','E16'};
targets=[1 1 1 1;1 1 1 0;1 1 0 1;1 0 0 0;1 0 0 0;0 1 1 1;0 0 0 0];
summary=cell(7,7);
results=struct();
for k=1:numel(ids)
    id=ids{k}; p=mets_parameters(id);
    info=classify_equilibrium(targets(k,:)',p,cfg.eigenTolerance);
    assert(strcmp(info.status,'locally_asymptotically_stable'));
    if ~strncmp(id,'E8',2)
        % Same supplied E1 grid generalized explicitly to the other plotted scenarios.
        v=linspace(.01,.99,cfg.pureGridN);
        w=linspace(.1,.99,cfg.pureGridN);
        [a,b,c]=ndgrid(v,v,w);
        initials=[a(:) b(:) c(:) .5*ones(numel(a),1)];
        trajectories=cell(size(initials,1),1);
        fig=figure('Visible',cfg.figureVisible,'Color','w'); hold on;
        for j=1:size(initials,1)
            s=simulate_mets(p,initials(j,:),[0 50],cfg);
            trajectories{j}=s;
            plot3(s.u(:,1),s.u(:,2),s.u(:,3),'LineWidth',.55);
        end
        xlabel('Government (x)'); ylabel('Shipping companies (y)');
        zlabel('Platforms (z)'); view(3); grid on; axis([0 1 0 1 0 1]);
        title([strrep(id,'_',' ') ': projection; r evolves'],'Interpreter','none');
        save_figure(fig,outDir,['Fig_' id 'a']);
        writetable(array2table(initials,'VariableNames',{'x0','y0','z0','r0'}), ...
            fullfile(outDir,[id '_3d_initials.csv']));
        save(fullfile(outDir,[id '_3d_data.mat']),'trajectories','initials','p');
    end
    % This initial state and horizon are explicit standardized choices for the
    % revision package; only E8_case2 has this exact original supplied script.
    series=simulate_mets(p,[.01;.99;.99;.99],[0 20],cfg);
    fig=figure('Visible',cfg.figureVisible,'Color','w');
    plot(series.t,series.u,'LineWidth',1.5); grid on;
    xlabel('Model time'); ylabel('Active-strategy population share');
    legend('Government','Shipping companies','Platforms','MRV','Location','best');
    base=['Fig_' id 'b'];
    if strcmp(id,'E8_case1'), base='Fig_E8_Scenario4'; end
    if strcmp(id,'E8_case2'), base='Fig_E8_Scenario8'; end
    save_figure(fig,outDir,base);
    write_trajectory(fullfile(outDir,[base '.csv']),series);
    lam=diag(mets_jacobian(targets(k,:)',p));
    summary(k,:)={id,targets(k,1),targets(k,2),targets(k,3),targets(k,4), ...
                  info.status,series.finalResidual};
    results.(id)=struct('target',targets(k,:),'eigenvalues',lam,'series',series);
    fprintf('%s: %s; time-series terminal residual %.3g\n',id,info.status,series.finalResidual);
end
T=cell2table(summary,'VariableNames',{'Scenario','x','y','z','r','Stability','TerminalResidual'});
writetable(T,fullfile(outDir,'pure_scenario_summary.csv'));
end
