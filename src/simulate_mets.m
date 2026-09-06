function s = simulate_mets(p,u0,tspan,cfg)
%SIMULATE_METS ode45 with explicit tolerances; no clipping or state freezing.
u0=u0(:);
assert(numel(u0)==4 && all(isfinite(u0)) && all(u0>=0 & u0<=1));
assert(numel(tspan)==2 && tspan(2)>tspan(1));
opts=odeset('RelTol',cfg.relTol,'AbsTol',cfg.absTol,'MaxStep',cfg.maxStep);
times=linspace(tspan(1),tspan(2),cfg.pointCount);
[s.t,s.u]=ode45(@(t,u)mets_rhs(t,u,p),times,u0,opts);
s.initial=u0;
s.parameters=p;
s.finalResidual=norm(mets_rhs(s.t(end),s.u(end,:)',p),inf);
s.boundViolation=max([0; -s.u(:); s.u(:)-1]);
assert(all(isfinite(s.u(:))),'METS:Nonfinite','Nonfinite solver output.');
assert(s.boundViolation<1e-6,'METS:Bounds','State escaped [0,1] beyond numerical tolerance.');
% A small terminal derivative alone does not establish convergence or stability.
end
