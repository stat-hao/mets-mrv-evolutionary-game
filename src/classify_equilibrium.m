function info = classify_equilibrium(u,p,tol)
%CLASSIFY_EQUILIBRIUM Linearization classification, not a general ESS proof.
if nargin<3, tol=1e-8; end
info.residual=norm(mets_rhs(0,u,p),inf);
info.eigenvalues=eig(mets_jacobian(u,p));
if any(u<0) || any(u>1)
    info.status='outside_state_space';
elseif info.residual>tol
    info.status='not_equilibrium';
elseif any(real(info.eigenvalues)>tol)
    info.status='unstable';
elseif all(real(info.eigenvalues)<-tol)
    info.status='locally_asymptotically_stable';
else
    info.status='nonhyperbolic_further_analysis_required';
end
end
