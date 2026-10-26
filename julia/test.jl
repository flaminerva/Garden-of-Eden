include("life.jl")
include("encoding.jl")

function allworld(m::Int,n::Int)
    res = []
    for k in 0:511
        bits = digits(k,base=2,pad=9)
        mat = reshape(Bool.(bits), m, n)
        push!(res,mat)
    end
    return res
end

function checksurvalc(world::AbstractMatrix{Bool})
    neib_mat = neighbours(world)
    return willsurvive(world[2,2],neib_mat[2,2])    
end


function check()
    l = allworld(3,3)
    c, neibs = neib_id(2, 2, 3, 3) 
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


println("local 512 check, invalid count: ", length(check()))
