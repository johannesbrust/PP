# PP - PolynomialPools
function ComputeDesign!(
    I::AbstractVector{Int},
    J::AbstractVector{Int},
    v::AbstractVector{T},
    dc::AbstractDict{T,Int},   
    lv::Int,
    d::Int,
    G::Type{T}) where T

    function g(b::T, d::Int,::Type{T}) where T
        y = zeros(T, d-2)
        for (i,c) in enumerate((d-1):-1:2) # highest exponent first
            y[i] = b^(c)
        end
        y
    end
    
    if d > 2
        coeffs = Iterators.product(ntuple(i->v, d-2)...)
    else
        coeffs = zero(T)
    end

    for i=1:lv # layer index / slope
        for (l,c) in enumerate(coeffs)
            for j=1:lv # y-intercept
                for k=1:lv # x index, in-pool
                    id = (i-1)*lv^d + (l-1)*lv^2 + (j-1)*lv + k # linear index
                    I[ id ] = (i-1)*lv + j
                    J[ id ] = (k-1)*lv + (l-1)*lv^2 + dc[ (sum(c .* g(v[i],d,G)) + v[i]*v[k] + v[j]) ]

                end
            end
        end
    end

    # Singular layer, corresponds to slope infinity
    I[lv^(d+1)+1:end] = reshape(repeat((lv^2+1) : lv*(lv+1), 1, lv^(d-1))', lv^d,1)
    J[lv^(d+1)+1:end] = 1:lv^d
    nothing

end

# full design q+1 "layers"
function PP(q, d)
    
    v,dict,G = Setup(q)
    
    ne = q^d*(q+1) 

    I = Vector{Int}(undef, ne)
    J = Vector{Int}(undef, ne)

    ComputeDesign!(I, J, v, dict, q, d, G)
    sparse(I, J, ones(Int, ne))
    
end

# partial design to detect k positives
function ComputeDesign!(
    I::AbstractVector{Int},
    J::AbstractVector{Int},
    v::AbstractVector{T},
    dc::AbstractDict{T,Int},   
    q::Int,
    d::Int,
    k::Int,
    G::Type{T}) where T

    function g(b::T, d::Int,::Type{T}) where T
        y = zeros(T, d-2)
        for (i,c) in enumerate((d-1):-1:2) # highest exponent first
            y[i] = b^(c)
        end
        y
    end
    
    if d > 2
        coeffs = Iterators.product(ntuple(i->v, d-2)...)
    else
        coeffs = zero(T)
    end

    # number of layers
    nl = (d-1)*k+1
    @assert nl <= q+1 "for order q=$q, dimension d=$d max. k=$(q÷(d-1)) posititves can be detected"

    #for i=1:q # layer index / slope
    for i=1:nl # layer index / slope

        if i<=q # regular layer            
            for (l,c) in enumerate(coeffs)
                for j=1:q # y-intercept
                    for k=1:q # x index, in-pool
                        id = (i-1)*q^d + (l-1)*q^2 + (j-1)*q + k # linear index
                        I[ id ] = (i-1)*q + j
                        J[ id ] = (k-1)*q + (l-1)*q^2 + dc[ (sum(c .* g(v[i],d,G)) + v[i]*v[k] + v[j]) ]

                    end
                end
            end

        else # i=q+1, Singular layer, corresponds to slope infinity            
            I[q^(d+1)+1:end] = reshape(repeat((q^2+1) : q*(q+1), 1, q^(d-1))', q^d,1)
            J[q^(d+1)+1:end] = 1:q^d
        end
    end
    nothing
end

# PP - PolynomialPools
# partial design to detect k positives
function PP(q, d, k)
    
    v,dict,G = Setup(q)
    
    ne = q^d*((d-1)*k+1)
    #ne = q^d*(q+1)

    I = Vector{Int}(undef, ne)
    J = Vector{Int}(undef, ne)

    ComputeDesign!(I, J, v, dict, q, d, k, G)
    sparse(I, J, ones(Int, ne))
    
end