### Types

# Discrete time sets
struct Instants{T<:Real}
    timeset::Vector{T}
    timenodes::SparseVector{Bool}
    timelinks::SparseMatrix{Bool}
end

struct Steps{T<:Real}
    timeset::AbstractRange
    timenodes::SparseVector{Bool}
    timelinks::SparseMatrix{Bool}
end

# Continuous time set
struct Interval{T<:AbstractFloat} <: AbstractInterval
    start::Tuple{T,Bool}
    finish::Tuple{T,Bool}
end

struct TimeNodes{T<:AbstractFloat}
    time_node::OrderedDict{Interval{T}, Int}
    node_time::Dict{Int, Interval{T}}
end

struct TimeLinks{T<:AbstractFloat}
    time_link::OrderedDict{Interval{T}, Tuple{Int, Int}}
    link_time::Dict{Tuple{Int, Int}, Interval{T}}
end

struct Intervals{T<:AbstractFloat}
    timeset::Interval{T}
    timenodes::TimeNodes{T}
    timelinks::TimeLinks{T}
end

# Supertype time set
const TimeComponent = Union{Instants, Steps, Intervals}

### Functions

# show (overload)
# function show(io::IO, tc::Instants)
#     show_default(io, Instants)
# end
