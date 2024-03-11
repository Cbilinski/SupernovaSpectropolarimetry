function err = myerrorfun(c,qval,uval,wavval,lmax,K)

%K = -1.13 + 0.000405lmax from Cikota 2018 paper, lmax in angstroms, already calculated externally before being fed in


theta = 0.5 .* atan(c(2)./c(1));
q =exp((-1.*K) .* (log(lmax./wavval)).^2).*(c(1).*(cos(2.*theta)).^2 + c(2).*(sin(2.*theta).*cos(2.*theta)));
u =exp((-1.*K) .* (log(lmax./wavval)).^2).*(c(1).*(sin(2.*theta).*cos(2.*theta)) + c(2).*(sin(2.*theta)).^2);
err = sum((qval - q).^2) + sum((uval - u).^2);
%not actually using norm, was just comparing
norm(qval - q,2)^2 + norm(uval - u,2)^2;