# ----------------------------- COMP_PT -------------------------------------#
#  Combinatorial Orthogonal Matching Pursuit (w/o noise)
#   
#  Algorithm for pooling tests (e.g., mixed COVID samples) with
#  problem representation:
#
#    M * x = y, (goal to recover x given known M and y)
#
#  where [t,n]=size(M), t<n, M is a binary matrix with tests (rows)
#  and patients (sometimes called items) in its columns.
#
#  INPUTS:
#  M: Matrix (t x n)
#  y: Measured outcomes (t x 1)
#  pars: Struct with optional parameters
#    pars.print: Flag to print infos
#    pars.d: Number of defectives
#
#  OUTPUTS:
#  x: Computed solution
#  out: Struct with output values
#    out.time: Computational time
#    out.d_final: Computed defectives
# --------------------------------------------------------------------------#

function COMP_PT( M, y, pars )
    
    ctime = @elapsed begin

        # Problem data
        (t,n) = size(M);
        
        # Retrieve optional parameter values

        if !isnothing(pars)
            if haskey(pars, :print) 
                printInfo = pars.print
            else
                printInfo = 0
            end
            if haskey(pars, :def) 
                def = pars.def
            else
                def = -1
            end

        else
            printInfo = 0
            def = -1
        end

        
        x = zeros(Int,n)
        # Algorithm (column-wise)
        for i=1:n
            if sum(M[:,i]) > 0
                x[i] = ( sum(M[:,i]) == sum(1 .== y[M[:,i].==1]) )
            end
        end

    end
    
    if printInfo == 1
            
        println("\n----------- COMP Algorithm ----------- \n") # 41 chars       
        println("Problem Size")
        println("Tests:                 $t")
        println("Samples:               $n")
        println("Input Expct. Positive: $def \n")
        
        
    end

    out = (d_final=sum(x), time=ctime)
    
    if printInfo == 1
        
        println("OUTPUTS:################");
        println("Time (search):         $(out.time)");
        println("Positive items:        $(out.d_final)");
        println("########################");
        println("Identified Indices:    $(findall(x->x.==1,x))");
        println("\n");
    end
    (x,out)
end