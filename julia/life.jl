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

function evolve!(world::AbstractMatrix{Bool})
    m,n = size(world)
    neib_mat = neighbours(world)
    new_world = [willsurvive(world[i,j],neib_mat[i,j]) for i in 1:m,j in 1:n]
    world .= new_world
end

using Plots

anim = @animate for i in 1:300
    heatmap(world; axis = nothing, border = :none, cbar = false, ratio = :equal)
    evolve!(world)
end
gif(anim, "gameoflife.gif"; fps = 10)