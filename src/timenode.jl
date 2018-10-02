abstract type AbstractTimeNode end

# To keep consistency with a total order on bound
# false means open set and true closed set
struct IntervalTimeNode{T<:AbstractFloat} <: AbstractTimeNode
    interval::Interval{T}
    node::Int
end
