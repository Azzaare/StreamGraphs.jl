### Types

# Abstract supertype
abstract type AbstractTimeComponent end

# Discrete time sets
struct Instants{T<:Real} <: AbstractTimeComponent
    timeset::Vector{T}
    timenodes::SparseVector{Bool}
    timelinks::SparseMatrix{Bool}
end

struct Steps{R<:AbstractRange} <: AbstractTimeComponent
    timeset::R
    timenodes::SparseVector{Bool}
    timelinks::SparseMatrix{Bool}
end

# Continuous time set
struct TimeNodes{T<:AbstractFloat}
    time_node::OrderedDict{Interval{T}, OrderedSet{Int}}
    node_time::Dict{Int, OrderedSet{Interval{T}}}
end

struct TimeLinks{T<:AbstractFloat}
    time_link::OrderedDict{Interval{T}, OrderedSet{Tuple{Int, Int}}}
    link_time::Dict{Tuple{Int, Int}, OrderedSet{Interval{T}}}
end

struct Intervals{T<:AbstractFloat} <: AbstractTimeComponent
    timeset::Interval{T}
    timenodes::TimeNodes{T}
    timelinks::TimeLinks{T}
end

### Functions

const EmptySet = OrderedSet()

## add_timenode!
function add_timenode!(
    tc::Intervals{T},
    tn::IntervalTimeNode{T}
    ) where {T<:AbstractFloat}
    if haskey(tc.timenodes.time_node, tn.interval)
        push!(tc.timenodes.time_node[tn.interval], tn.node)
    else
        push!(tc.timenodes.time_node, tn.interval => OrderedSet(tn.node))
    end
    if haskey(tc.timenodes.node_time, tn.node)
        push!(tc.timenodes.node_time[tn.node], tn.interval)
    else
        push!(tc.timenodes.node_time, tn.node => OrderedSet(tn.interval))
    end
end

## add_timelink!
function add_timelink!(
    tc::Intervals{T},
    tl::IntervalTimeLink{T}
    ) where {T <: AbstractFloat}
    if haskey(tc.timenodes.time_node, tn.interval)
        push!(tc.timenodes.time_node[tn.interval], tn.node)
    else
        push!(tc.timenodes.time_node, tn.interval => OrderedSet(tn.node))
    end
    if haskey(tc.timenodes.node_time, tn.node)
        push!(tc.timenodes.node_time[tn.node], tn.interval)
    else
        push!(tc.timenodes.node_time, tn.node => OrderedSet(tn.interval))
    end
end

## rem_timenode!
function rem_timenode!(
    tc::Intervals{T},
    tn::IntervalTimeNode{T}
    ) where {T <: AbstractFloat}
