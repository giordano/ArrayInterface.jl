
@testset "Range Constructors" begin
    @test @inferred(static(1):static(10)) == 1:10
    @test @inferred(ArrayInterfaceCore.SUnitRange{1,10}()) == 1:10
    @test @inferred(static(1):static(2):static(10)) == 1:2:10
    @test @inferred(1:static(2):static(10)) == 1:2:10
    @test @inferred(static(1):static(2):10) == 1:2:10
    @test @inferred(static(1):2:static(10)) == 1:2:10
    @test @inferred(1:2:static(10)) == 1:2:10
    @test @inferred(1:static(2):10) == 1:2:10
    @test @inferred(static(1):2:10) == 1:2:10
    @test @inferred(static(1):UInt(10)) === static(1):10
    @test @inferred(UInt(1):static(1):static(10)) === 1:static(10)
    @test ArrayInterfaceCore.SUnitRange(1, 10) == 1:10
    @test @inferred(ArrayInterfaceCore.OptionallyStaticUnitRange{Int,Int}(1:10)) == 1:10
    @test @inferred(ArrayInterfaceCore.OptionallyStaticUnitRange(1:10)) == 1:10

    @inferred(ArrayInterfaceCore.OptionallyStaticUnitRange(1:10))

    @test @inferred(ArrayInterfaceCore.OptionallyStaticStepRange(static(1), static(1), static(1))) == 1:1:1
    @test @inferred(ArrayInterfaceCore.OptionallyStaticStepRange(static(1), 1, UInt(10))) == static(1):1:10
    @test @inferred(ArrayInterfaceCore.OptionallyStaticStepRange(UInt(1), 1, static(10))) == static(1):1:10
    @test @inferred(ArrayInterfaceCore.OptionallyStaticStepRange(1:10)) == 1:1:10

    @test_throws ArgumentError ArrayInterfaceCore.OptionallyStaticUnitRange(1:2:10)
    @test_throws ArgumentError ArrayInterfaceCore.OptionallyStaticUnitRange{Int,Int}(1:2:10)
    @test_throws ArgumentError ArrayInterfaceCore.OptionallyStaticStepRange(1, 0, 10)

    @test @inferred(static(1):static(1):static(10)) === ArrayInterfaceCore.OptionallyStaticUnitRange(static(1), static(10))
    @test @inferred(static(1):static(1):10) === ArrayInterfaceCore.OptionallyStaticUnitRange(static(1), 10)
    @test @inferred(1:static(1):10) === ArrayInterfaceCore.OptionallyStaticUnitRange(1, 10)
    @test length(static(-1):static(-1):static(-10)) == 10 == lastindex(static(-1):static(-1):static(-10))

    @test UnitRange(ArrayInterfaceCore.OptionallyStaticUnitRange(static(1), static(10))) === UnitRange(1, 10)
    @test UnitRange{Int}(ArrayInterfaceCore.OptionallyStaticUnitRange(static(1), static(10))) === UnitRange(1, 10)

    @test AbstractUnitRange{Int}(ArrayInterfaceCore.OptionallyStaticUnitRange(static(1), static(10))) isa ArrayInterfaceCore.OptionallyStaticUnitRange
    @test AbstractUnitRange{UInt}(ArrayInterfaceCore.OptionallyStaticUnitRange(static(1), static(10))) isa Base.OneTo
    @test AbstractUnitRange{UInt}(ArrayInterfaceCore.OptionallyStaticUnitRange(static(2), static(10))) isa UnitRange

    @test @inferred((static(1):static(10))[static(2):static(3)]) === static(2):static(3)
    @test @inferred((static(1):static(10))[static(2):3]) === static(2):3
    @test @inferred((static(1):static(10))[2:3]) === 2:3
    @test @inferred((1:static(10))[static(2):static(3)]) === 2:3

    @test Base.checkindex(Bool, static(1):static(10), static(1):static(5))
    @test -(static(1):static(10)) === static(-1):static(-1):static(-10)

    @test reverse(static(1):static(10)) === static(10):static(-1):static(1)
    @test reverse(static(1):static(2):static(9)) === static(9):static(-2):static(1)
end

# iteration
@test iterate(static(1):static(5), 5) === nothing
@test iterate(static(2):static(5), 5) === nothing

@test isnothing(@inferred(ArrayInterfaceCore.known_first(typeof(1:4))))
@test isone(@inferred(ArrayInterfaceCore.known_first(Base.OneTo(4))))
@test isone(@inferred(ArrayInterfaceCore.known_first(typeof(Base.OneTo(4)))))
@test isone(@inferred(ArrayInterfaceCore.known_first(typeof(static(1):2:10))))

@test isnothing(@inferred(ArrayInterfaceCore.known_last(1:4)))
@test isnothing(@inferred(ArrayInterfaceCore.known_last(typeof(1:4))))
@test isone(@inferred(ArrayInterfaceCore.known_last(typeof(static(-1):static(2):static(1)))))

# CartesianIndices
CI = CartesianIndices((2, 2))
@test @inferred(ArrayInterfaceCore.known_first(typeof(CI))) == CartesianIndex(1, 1)
@test @inferred(ArrayInterfaceCore.known_last(typeof(CI))) === nothing

CI = CartesianIndices((static(1):static(2), static(1):static(2)))
@test @inferred(ArrayInterfaceCore.known_first(typeof(CI))) == CartesianIndex(1, 1)
@test @inferred(ArrayInterfaceCore.known_last(typeof(CI))) == CartesianIndex(2, 2)

@test isnothing(@inferred(ArrayInterfaceCore.known_step(typeof(1:0.2:4))))
@test isone(@inferred(ArrayInterfaceCore.known_step(1:4)))
@test isone(@inferred(ArrayInterfaceCore.known_step(typeof(1:4))))
@test isone(@inferred(ArrayInterfaceCore.known_step(typeof(Base.Slice(1:4)))))
@test isone(@inferred(ArrayInterfaceCore.known_step(typeof(view(1:4, 1:2)))))

@testset "length" begin
    @test @inferred(length(ArrayInterfaceCore.OptionallyStaticUnitRange(1, 0))) == 0
    @test @inferred(length(ArrayInterfaceCore.OptionallyStaticUnitRange(1, 10))) == 10
    @test @inferred(length(ArrayInterfaceCore.OptionallyStaticUnitRange(static(1), 10))) == 10
    @test @inferred(length(ArrayInterfaceCore.OptionallyStaticUnitRange(static(0), 10))) == 11
    @test @inferred(length(ArrayInterfaceCore.OptionallyStaticUnitRange(static(1), static(10)))) == 10
    @test @inferred(length(ArrayInterfaceCore.OptionallyStaticUnitRange(static(0), static(10)))) == 11

    @test @inferred(length(static(1):static(2):static(0))) == 0
    @test @inferred(length(static(0):static(-2):static(1))) == 0

    @test @inferred(ArrayInterfaceCore.known_length(typeof(ArrayInterfaceCore.OptionallyStaticStepRange(static(1), 2, 10)))) === nothing
    @test @inferred(ArrayInterfaceCore.known_length(typeof(ArrayInterfaceCore.SOneTo{-10}()))) === 0
    @test @inferred(ArrayInterfaceCore.known_length(typeof(ArrayInterfaceCore.OptionallyStaticStepRange(static(1), static(1), static(10))))) === 10
    @test @inferred(ArrayInterfaceCore.known_length(typeof(ArrayInterfaceCore.OptionallyStaticStepRange(static(2), static(1), static(10))))) === 9
    @test @inferred(ArrayInterfaceCore.known_length(typeof(ArrayInterfaceCore.OptionallyStaticStepRange(static(2), static(2), static(10))))) === 5
    @test @inferred(ArrayInterfaceCore.known_length(Int)) === 1

    @test @inferred(length(ArrayInterfaceCore.OptionallyStaticStepRange(static(1), 2, 10))) == 5
    @test @inferred(length(ArrayInterfaceCore.OptionallyStaticStepRange(static(1), static(1), static(10)))) == 10
    @test @inferred(length(ArrayInterfaceCore.OptionallyStaticStepRange(static(2), static(1), static(10)))) == 9
    @test @inferred(length(ArrayInterfaceCore.OptionallyStaticStepRange(static(2), static(2), static(10)))) == 5
end

@test @inferred(getindex(ArrayInterfaceCore.OptionallyStaticUnitRange(static(1), 10), 1)) == 1
@test @inferred(getindex(ArrayInterfaceCore.OptionallyStaticUnitRange(static(0), 10), 1)) == 0
@test_throws BoundsError getindex(ArrayInterfaceCore.OptionallyStaticUnitRange(static(1), 10), 0)
@test_throws BoundsError getindex(ArrayInterfaceCore.OptionallyStaticStepRange(static(1), 2, 10), 0)
@test_throws BoundsError getindex(ArrayInterfaceCore.OptionallyStaticUnitRange(static(1), 10), 11)
@test_throws BoundsError getindex(ArrayInterfaceCore.OptionallyStaticStepRange(static(1), 2, 10), 11)

@test ArrayInterfaceCore.static_first(Base.OneTo(one(UInt))) === static(1)
@test ArrayInterfaceCore.static_step(Base.OneTo(one(UInt))) === static(1)

@test Base.setindex(1:5, [6,2], 1:2) == [6,2,3,4,5]

@test @inferred(eachindex(static(-7):static(7))) === static(1):static(15)
@test @inferred((static(-7):static(7))[first(eachindex(static(-7):static(7)))]) == -7

@test @inferred(firstindex(128:static(-1):1)) == 1

@test identity.(static(1):5) isa Vector{Int}
@test (static(1):5) .+ (1:3)' isa Matrix{Int}
@test similar(Array{Int}, (static(1):(4),)) isa Vector{Int}
@test similar(Array{Int}, (static(1):(4), Base.OneTo(4))) isa Matrix{Int}
@test similar(Array{Int}, (Base.OneTo(4), static(1):(4))) isa Matrix{Int}

@testset "indices" begin
    A23 = ones(2,3);
    SA23 = MArray(A23);
    A32 = ones(3,2);
    SA32 = MArray(A32)

    @test @inferred(ArrayInterfaceCore.indices(A23, (static(1),static(2)))) === (Base.Slice(StaticInt(1):2), Base.Slice(StaticInt(1):3))
    @test @inferred(ArrayInterfaceCore.indices((A23, A32))) == 1:6
    @test @inferred(ArrayInterfaceCore.indices((SA23, A32))) == 1:6
    @test @inferred(ArrayInterfaceCore.indices((A23, SA32))) == 1:6
    @test @inferred(ArrayInterfaceCore.indices((SA23, SA32))) == 1:6
    @test @inferred(ArrayInterfaceCore.indices(A23)) == 1:6
    @test @inferred(ArrayInterfaceCore.indices(SA23)) == 1:6
    @test @inferred(ArrayInterfaceCore.indices(A23, 1)) == 1:2
    @test @inferred(ArrayInterfaceCore.indices(SA23, StaticInt(1))) === Base.Slice(StaticInt(1):StaticInt(2))
    @test @inferred(ArrayInterfaceCore.indices((A23, A32), (1, 2))) == 1:2
    @test @inferred(ArrayInterfaceCore.indices((SA23, A32), (StaticInt(1), 2))) === Base.Slice(StaticInt(1):StaticInt(2))
    @test @inferred(ArrayInterfaceCore.indices((A23, SA32), (1, StaticInt(2)))) === Base.Slice(StaticInt(1):StaticInt(2))
    @test @inferred(ArrayInterfaceCore.indices((SA23, SA32), (StaticInt(1), StaticInt(2)))) === Base.Slice(StaticInt(1):StaticInt(2))
    @test @inferred(ArrayInterfaceCore.indices((A23, A23), 1)) == 1:2
    @test @inferred(ArrayInterfaceCore.indices((SA23, SA23), StaticInt(1))) === Base.Slice(StaticInt(1):StaticInt(2))
    @test @inferred(ArrayInterfaceCore.indices((SA23, A23), StaticInt(1))) === Base.Slice(StaticInt(1):StaticInt(2))
    @test @inferred(ArrayInterfaceCore.indices((A23, SA23), StaticInt(1))) === Base.Slice(StaticInt(1):StaticInt(2))
    @test @inferred(ArrayInterfaceCore.indices((SA23, SA23), StaticInt(1))) === Base.Slice(StaticInt(1):StaticInt(2))

    @test_throws AssertionError ArrayInterfaceCore.indices((A23, ones(3, 3)), 1)
    @test_throws AssertionError ArrayInterfaceCore.indices((A23, ones(3, 3)), (1, 2))
    @test_throws AssertionError ArrayInterfaceCore.indices((SA23, ones(3, 3)), StaticInt(1))
    @test_throws AssertionError ArrayInterfaceCore.indices((SA23, ones(3, 3)), (StaticInt(1), 2))
    @test_throws AssertionError ArrayInterfaceCore.indices((SA23, SA23), (StaticInt(1), StaticInt(2)))

    @test size(similar(ones(2, 4), ArrayInterfaceCore.indices(ones(2, 4), 1), ArrayInterfaceCore.indices(ones(2, 4), 2))) == (2, 4)
    @test axes(ArrayInterfaceCore.indices(ones(2,2))) === (StaticInt(1):4,)
    @test axes(Base.Slice(StaticInt(2):4)) === (Base.IdentityUnitRange(StaticInt(2):4),)
    @test Base.axes1(ArrayInterfaceCore.indices(ones(2,2))) === StaticInt(1):4
    @test Base.axes1(Base.Slice(StaticInt(2):4)) === Base.IdentityUnitRange(StaticInt(2):4)

    x = vec(A23); y = vec(A32);
    @test ArrayInterfaceCore.indices((x',y'),StaticInt(1)) === Base.Slice(StaticInt(1):StaticInt(1))
    @test ArrayInterfaceCore.indices((x,y), StaticInt(2)) === Base.Slice(StaticInt(1):StaticInt(1))
end

