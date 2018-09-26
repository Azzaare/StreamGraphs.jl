abstract type AbstractStreamGraph end

struct StreamGraph{T<:AbstractFloat} <: AbstractStreamGraph
    α::T
    ω::T
    nodes::Int
    timenodes::Dict{Int, Tuple{T, T}}
    links::Dict{Tuple{Int, Int}, Tuple{T, T}}
end

function string(sg::StreamGraph{<:AbstractFloat})
    str  = "Stream Graph from α = $(sg.α) to β = $(sg.ω) with $(sg.nodes) nodes\n"
    str *= "\tList of Time Nodes\n"
    for timenode in sg.timenodes
        u = timenode[1]
        a, b = timenode[2]
        str *= "\t\t$u : $a ↝ $b\n"
    end
    str *= "\tList of Time Links\n"
    for link in sg.links
        u, v = link[1]
        a, b = link[2]
        str *= "\t\t$u ⇒ $v : $a ↝ $b\n"
    end
    return str
end
