include("encoding.jl")
using PicoSAT

function DIMACS(G::AbstractMatrix{Bool})
    """not up-to-date"""
    cnfs = build_cnf(G)
    numcnf = length(cnfs)
    numvari = length(G)
    open("formula.cnf", "w") do io
        println(io, "p cnf $numvari $numcnf")
        for cnf in cnfs
            println(io, join(cnf, " ")*" 0")
        end
    end
end

function SATsol(G::AbstractMatrix{Bool})
    sol = PicoSAT.solve(build_cnf(G))
    if sol == :unsatisfiable
        return sol
    else
        X = Matrix(reshape(sol .> 0, size(G)))
        return X
    end
end



