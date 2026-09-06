function run_mixed_examples(outDir,cfg)
%RUN_MIXED_EXAMPLES Reproduce original examples with precise stability labels.
if ~exist(outDir,'dir'), mkdir(outDir); end
previous=rng; cleanup=onCleanup(@()rng(previous)); %#ok<NASGU>
rng(cfg.seed,'twister');
p=mets_parameters('mixed_boundary');
uStar=[1/3;2/3;0;0]; info=classify_equilibrium(uStar,p,cfg.eigenTolerance);
initials=rand(10,4); initials(:,3:4)=0;
fig=figure('Visible',cfg.figureVisible,'Color','w'); hold on;
data=cell(10,1);
for k=1:10
    data{k}=simulate_mets(p,initials(k,:),[0 50],cfg);
    plot(data{k}.u(:,1),data{k}.u(:,2),'LineWidth',1);
end
plot(uStar(1),uStar(2),'ko','MarkerFaceColor','k'); grid on;
xlabel('Government (x)'); ylabel('Shipping companies (y)');
title('Trajectories on invariant face z = r = 0');
save_figure(fig,outDir,'MixedStrategy_Trajectories');
save(fullfile(outDir,'mixed_boundary_data.mat'),'data','initials','p','uStar','info');
write_exact_example(p,uStar,150,'MixedStrategy',outDir,cfg);

p=mets_parameters('mixed_line');
uStar=[1;.4213;0;0];
% Original stable suffix is deliberately replaced: this point belongs to a
% continuum of equilibria and has a zero eigenvalue, not a unique attractor.
write_exact_example(p,uStar,15,'EquilibriumLine',outDir,cfg);

end

function write_exact_example(p,u0,T,prefix,outDir,cfg)
s=simulate_mets(p,u0,[0 T],cfg);
info=classify_equilibrium(u0,p,cfg.eigenTolerance);
fig=figure('Visible',cfg.figureVisible,'Color','w');
plot(s.t,s.u,'LineWidth',1.5); grid on;
xlabel('Model time'); ylabel('Active-strategy population share');
legend('Government','Shipping companies','Platforms','MRV','Location','best');
save_figure(fig,outDir,[prefix '_TimeTrajectories']);
write_trajectory(fullfile(outDir,[prefix '_TimeTrajectories.csv']),s);
fig=figure('Visible',cfg.figureVisible,'Color','w');
plot(s.u(:,1),s.u(:,2),'b-'); hold on; plot(u0(1),u0(2),'ro'); grid on;
xlabel('Government (x)'); ylabel('Shipping companies (y)');
title('Initialization exactly at equilibrium');
save_figure(fig,outDir,[prefix '_PhaseDiagram']);
ev=info.eigenvalues;
writetable(table(real(ev),imag(ev),'VariableNames',{'RealPart','ImaginaryPart'}), ...
    fullfile(outDir,[prefix '_eigenvalues.csv']));
fprintf('%s: %s; eigenvalues = ',prefix,info.status); disp(ev.');
end
