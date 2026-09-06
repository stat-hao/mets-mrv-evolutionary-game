function du = mets_rhs(~,u,p)
%METS_RHS Original four replicator equations, with a named parameter struct.
u=u(:);
du = u.*(1-u).*mets_payoff_advantages(u,p);
end
