using Test
@test 1 == 1

### TimeSet

# Intervals
EmptyInterval = StreamGraphs.EmptyInterval()
interval1 = StreamGraphs.Interval((0., true), (1., true))
interval2 = StreamGraphs.Interval((2., true), (3., true))
interval3 = StreamGraphs.Interval((3., false), (4., true))
interval4 = StreamGraphs.Interval((4., true), (5., false))
interval5 = StreamGraphs.Interval((5., false), (7., true))
interval6 = StreamGraphs.Interval((6., true), (8., true))

intervalset1 = StreamGraphs.IntervalSet{Float64}()
push!(intervalset1, interval1, interval3, interval5)
intervalset2 = StreamGraphs.IntervalSet{Float64}()
push!(intervalset2, interval2, interval4, interval6)

intervalset3 = StreamGraphs.union(intervalset1, intervalset2)
println(StreamGraphs.string(intervalset3))

intervalset4 = StreamGraphs.intersect(intervalset1, intervalset2)
println(StreamGraphs.string(intervalset4))

# TimeStep
T1 = StreamGraphs.TimeStepSet([1., 4.3, 9.8])
T2 = StreamGraphs.TimeStepSet([1.3, 4.3, 5., 29.6])

T3 = StreamGraphs.union(T1, T2)
println(StreamGraphs.string(T3))

T4 = StreamGraphs.intersect(T1, T2)
println(StreamGraphs.string(T4))

### LinkStream
timenodes_ls = Dict(
    (1, 2) => (0., 2.),
    (1, 3) => (2., 4.),
    (1, 4) => (4., 6.),
    (2, 5) => (5., 7.),
    (3, 5) => (6., 8.),
    (4, 5) => (8., 10.)
)
LS = StreamGraphs.LinkStream(0., 10., 5, timenodes_ls)
println(StreamGraphs.string(LS))

### StreamGraph
SG = StreamGraphs.StreamGraph(LS)
println(StreamGraphs.string(SG))
