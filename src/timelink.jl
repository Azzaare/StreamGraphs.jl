abstract type AbstractTimeLink end

# To keep consistency with a total order on bound
# false means open set and true closed set
struct IntervalTimeLink{T<:AbstractFloat} <: AbstractTimeLink
    interval::Interval{T}
    link::Tuple{Int, Int}
end
