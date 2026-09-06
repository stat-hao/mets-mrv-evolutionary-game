function J = mets_jacobian(u,p)
%METS_JACOBIAN Analytic Jacobian; no Symbolic Math Toolbox required.
u=u(:); q=u.*(1-u);
J=diag((1-2*u).*mets_payoff_advantages(u,p));
J(1,2)=-q(1)*(p.F1+p.P1);
J(1,3)=-q(1)*p.P2;
J(1,4)=-q(1)*(p.F3+p.P3);
J(2,1)=q(2)*(p.P1+p.F1);
J(3,1)=q(3)*p.P2;
J(4,1)=q(4)*(p.P3+p.F3);
end
