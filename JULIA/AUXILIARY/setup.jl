import Pkg
Pkg.activate(pwd())
Pkg.add(["Primes","GaloisFields","SparseArrays"])

using Primes, GaloisFields, SparseArrays

function Setup(q)
    if isprime(q)
        G = GaloisField(q)
    elseif length(factor(Set,q)) == 1
        G, β = GaloisField(q, :β)
    else
        throw(DomainError(q, "order must be either prime or prime power"))
    end

    v = collect(G)
    #lv = length(v)

    dict = Dict{G, Int}(zip(G, 1:q))

    return v,dict,G
end