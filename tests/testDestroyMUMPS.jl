# Factorize two different matrices (one real, one complex) and solve for multiple rhs and free memory
@everywhere using MUMPS
using Base.Test
include("getDivGrad.jl");

Ar = getDivGrad(30,31,33);
n  = size(Ar,1);
Ac  = Ar + im*spdiagm(rand(n),0);

nrhs = 10;
rhsr = randn(n,nrhs) + im*randn(n,nrhs);
rhsc = randn(n,nrhs);


# println("Factorize real matrix on main instance and destroy")
# tic();
# fact = 0;
# for i=1:100;
# 	fact = factorMUMPS(Ar,1)
# 	destroyMUMPS(fact)
# end
# toc();

println("Factorize real matrix on remote worker and destroy")
tic();
fact = 0;
for i=1:100;
	fact = remotecall_fetch( workers()[1] ,factorMUMPS, Ar,1)
	remotecall_fetch(workers()[1],destroyMUMPS,fact)
end
toc();

println("DONE!")


