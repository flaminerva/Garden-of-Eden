using Pkg; Pkg.add("Combinatorics") 
using Combinatorics



function allworld(m::Int,n::Int)
    res = []
    for k in 0:511
        bits = digits(k,base=2,pad=9)
        mat = reshape(Bool.(bits), m, n)
        push!(res,mat)
    end
    return res
end

function neighbours(world::AbstractMatrix{Bool},rowc::Int,colc::Int)
    m,n = size(world)
    num = 0
    for di in -1:1
        for dj in -1:1
            state = world[mod1(rowc+di,m),mod1(colc+dj,n)]
            if state == 1 && (di,dj)!= (0,0)
                num+=1
            end
        end
    end
    return num
end


function neighbours(world::AbstractMatrix{Bool})
    m,n = size(world)
    res_mat= [neighbours(world,i,j) for i in 1:m, j in 1:n]
    return res_mat
end


function willsurvive(state::Bool,num::Int)
    if state==1 && (num==2 || num==3)
        return true
    elseif state==0 && num==3
        return true
    else
        return false
    end
end

function checksurvalc(world::AbstractMatrix{Bool})
    neib_mat = neighbours(world)
    return willsurvive(world[2,2],neib_mat[2,2])    
end


function langp(world::AbstractMatrix{Bool})
    """return language P::Dict{tuple->Int}"""
    m,n = size(world)
    p = Dict()
    num = 1
    for i in 1:m
        for j in 1:n
            get!(p,(i,j),num)
            num+=1
        end
    end
    return p
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


function check()
    l = allworld(3,3)
    p = langp(l[1])
    c = p[(2,2)]
    neibs = setdiff(1:9, [c]) 
    d = clauses_d(c,neibs)
    a = clauses_a(c,neibs)
    invalid = []
    for world in l
        state_next = checksurvalc(world)
        v = vec(world)
        if state_next==0
            evalcnf(d,v)==1&&evalcnf(a,v)==0 ? continue : push!(invalid,world)
        else
            evalcnf(d,v)==0&&evalcnf(a,v)==1 ? continue : push!(invalid,world)
        end
    end
    return invalid
end

check()