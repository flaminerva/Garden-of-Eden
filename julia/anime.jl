include("life.jl")
include("solver.jl")

using Plots

G = rand(Bool,5,10)
X = SATsol(G)
if X == :unsatisfiable
    display(G)
    print("Congrats! The Logos, you have created a Garden of Eden :) .")
else
    anim = @animate for i in 1:10
        heatmap(X; axis = nothing, border = :none, cbar = false, ratio = :equal)
        evolve!(X)
    end
    gif(anim, "gameoflife.gif"; fps = 1)
end
