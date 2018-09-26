struct LinkStream{T<:Real} <: AbstractStreamGraph
    α::T
    ω::T
    nodes::Int
    links::Dict{Tuple{Int, Int}, Tuple{T, T}}
end

function StreamGraph(ls::LinkStream{<:AbstractFloat})
    timenodes = Dict{Int, Tuple{Float64, Float64}}()
    for node in 1:ls.nodes
        push!(timenodes, node => (ls.α, ls.ω))
    end
    StreamGraph(ls.α, ls.ω, ls.nodes, timenodes, ls.links)
end

function string(ls::LinkStream{<:AbstractFloat})
    str = "Link Stream from α = $(ls.α) to β = $(ls.ω) with $(ls.nodes) nodes\n"
    for link in ls.links
        u, v = link[1]
        a, b = link[2]
        str *= "\t$u ⇒ $v : $a ↝ $b\n"
    end
    return str
end
