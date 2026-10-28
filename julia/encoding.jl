using Combinatorics

function neib_id(i,j,m,n)
    c = (j-1)*m+i
    neibs = []
    for di in -1:1
        for dj in -1:1
            if di!=0 || dj!=0
                ii,jj = mod1(i+di,m),mod1(j+dj,n)
                ind = (jj-1)*m+ii
                push!(neibs,ind)
            end
        end
    end
    return c,neibs
end


function E(neibs::AbstractArray,k::Int)
    """return E_k"""
    alives = collect(combinations(neibs, k))
    res = []
    for alive in alives
        term = []
        for neib in neibs
            neib in alive ? push!(term,+neib) : push!(term,-neib)
        end
        push!(res,term)
    end
    return res
end

function clauses_d(c::Int,neibs::AbstractArray)
    """G=0 neg(α_{i,j}) in CNF"""
    E_2 = E(neibs,2)
    E_3 = E(neibs,3)
    for e2 in E_2
        push!(e2,c)
    end
    clause1 = .-E_2
    clause2 = .-E_3
    clauses = vcat(clause1,clause2)
    return clauses
end

function clauses_a(c::Int, neibs::AbstractArray)
    """G=1 negδ_{i,j} in CNF"""
    notin23 = setdiff(0:8, [2, 3])
    notin3 = setdiff(0:8,[3])
    terms1 = []
    terms2 = []
    for k in notin23
        E_k = E(neibs,k)
        for ek in E_k
            push!(ek,c)
        end
        append!(terms1,E_k)
    end
    for k in notin3
        E_k = E(neibs,k)
        for ek in E_k
            push!(ek,-c)
        end
        append!(terms2,E_k)
    end
    clause1 = .-terms1
    clause2 = .-terms2
    clauses = vcat(clause1,clause2)
    return clauses
end


function evalcnf(clauses::AbstractArray,v::AbstractArray{Bool})
    cnftf = true
    for clause in clauses
        clausetf = false
        for p in clause
            if p>0 && v[p]
                clausetf = true
            elseif p<0 && !v[-p]
                clausetf = true
            end
        end
        if clausetf==false
            cnftf = false
        end
    end
    return cnftf
end

function build_cnf(G::AbstractMatrix{Bool})
    m,n = size(G)
    CNF = []
    for i in 1:m
        for j in 1:n
            c,neibs = neib_id(i,j,m,n)
            if G[i,j]==1
                append!(CNF,clauses_a(c,neibs))
            else
                append!(CNF,clauses_d(c,neibs))
            end
        end 
    end
    return CNF
end