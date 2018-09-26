### Types

abstract type AbstractTimeSet end
abstract type AbstractInterval <: AbstractTimeSet end

# To keep consistency with a total order on bound
# false means open set and true closed set
struct Interval{T<:AbstractFloat} <: AbstractInterval
    α::Tuple{T,Bool}
    ω::Tuple{T,Bool}
end

struct EmptyInterval <: AbstractInterval end

IntervalSet{T<:AbstractFloat} = Vector{Interval{T}}

function IntervalSet(interval::EmptyInterval)
    return IntervalSet{Float64}()
end
function IntervalSet(interval::Interval{<:AbstractFloat})
    is = IntervalSet{Float64}()
    push!(is, interval)
    return is
end

struct TimeStepSet{T<:Real} <: AbstractTimeSet
    steps::Vector{T}
end

### Functions

## Unions
function union(is1::IntervalSet{<:AbstractFloat}, is2::IntervalSet{<:AbstractFloat})
    result = IntervalSet{Float64}()
    buffer = EmptyInterval()
    next1 = iterate(is1)
    next2 = iterate(is2)

    while next1 != nothing || next2 != nothing || buffer != EmptyInterval()
        if next1 != nothing
            (interval1, state1) = next1
        end
        if next2 != nothing
            (interval2, state2) = next2
        end

        if buffer == EmptyInterval()
            if interval1.α > interval2.α
                buffer = interval2
                next2 = iterate(is2, state2)
            else
                buffer = interval1
                next1 = iterate(is1, state1)
            end
        elseif next1 != nothing && (buffer.ω == interval1.α && buffer.ω[2] || buffer.ω > interval1.α)
            buffer = Interval(buffer.α, max(buffer.ω, interval1.ω))
            next1 = iterate(is1, state1)
        elseif next2 != nothing && (buffer.ω == interval2.α && buffer.ω[2] || buffer.ω > interval2.α)
            buffer = Interval(buffer.α, max(buffer.ω, interval2.ω))
            next2 = iterate(is2, state2)
        else
            push!(result, buffer)
            buffer = EmptyInterval()
        end
    end
    return result
end

function union(T1::TimeStepSet, T2::TimeStepSet)
    return sort!(Base.union(T1.steps, T2.steps))
end

## Intersections
function intersect(is1::IntervalSet{<:AbstractFloat}, is2::IntervalSet{<:AbstractFloat})
    result = IntervalSet{Float64}()
    next1 = iterate(is1)
    next2 = iterate(is2)

    while next1 != nothing || next2 != nothing
        if next1 != nothing
            (interval1, state1) = next1
            if next2 != nothing
                (interval2, state2) = next2
                α = max(interval1.α, interval2.α)
                ω = min(interval1.ω, interval2.ω)
                if interval1.ω > interval2.ω
                    next2 = iterate(is2, state2)
                else
                    next1 = iterate(is1, state1)
                end
            else
                α = interval1.α
                ω = interval1.ω
                next1 = iterate(is1, state1)
            end
        else
            (interval2, state2) = next2
            α = interval2.α
            ω = interval2.ω
            next2 = iterate(is2, state2)
        end
        if (α == ω && α[2]) || α[1] < ω[1]
            push!(result, Interval(α, ω))
        end
    end
    return result
end

function intersect(T1::TimeStepSet, T2::TimeStepSet)
    return sort!(Base.intersect(T1.steps, T2.steps))
end

## String and print

function string(TS::TimeStepSet)
    return "{" * mapreduce(x -> Base.string(x), (x,y) -> x*";"*y, TS.steps) * "}"
end


function string(interval::Interval{<:AbstractFloat})
    str = ""
    if interval.α[2]
        str *= "["
    else
        str *= "("
    end
    str *= "$(interval.α[1]),$(interval.ω[1])"
    if interval.ω[2]
        str *= "]"
    else
        str *= ")"
    end
    return str
end

function string(intervalset::IntervalSet{<:AbstractFloat})
    return "{" * mapreduce(x -> string(x), (x,y) -> x*";"*y, intervalset, init = "") * "}"
end

# function printstream(timeset::AbstractTimeSet)
#     print(string(timeset))
# end
#
# function printlnstream(timeset::AbstractTimeSet)
#     println(string(timeset))
# end
