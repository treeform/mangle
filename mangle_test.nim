import
    unittest,
    streams,
    future,
    mangle

const helper = @[1, 2, 3]


test "Stream and collect":
    check: helper == helper.stream.collect


test "Multiple stream ok":
    check: helper == helper.stream.stream.collect


test "Real usage":
    check:
        infinity()
            .map(proc(it: auto): auto =
                let x = 2
                it * x)
            .take(4)
            .collect == @[0, 2, 4, 6]


test "Infinity cannot be sorted or collected":
    check:
        not compiles(infinity().sort)
        not compiles(infinity().collect)


test "Example":
    check:
        infinity()
            .map((it) => it * it)
            .filter((it) => it %% 2 == 0)
            .take(715517)
            .reduce((acc: int, it) => acc + it, 0) == 488424787335446984


test "More complex types":
    type Vector = tuple[x, y, z: int]

    proc `*`(a, b: Vector): Vector = (a.x * b.x, a.y * b.y, a.z * b.z)

    let vectors: seq[Vector] = @[
        (1, 1, 1),
        (1, 2, 3),
        (3, 2, 1),
        (4, 5, 6)]

    check:
        vectors.stream
            .map((vec) => (vec.x, 1, vec.z))
            .reduce(`*`, (1, 1, 1)) == (12, 1, 18)


test "Sorting":
    check:
        @[3,1,2].stream
            .sort
            .collect == @[1,2,3]


test "Nim channels":
    var channel = Channel[int]()
    channel.open()
    channel.send(1)
    channel.send(2)
    channel.send(3)
    channel.send(4)

    check:
        channel.stream
            .take(3) # FIXME 4 not working
            .collect == @[1, 2, 3]


test "Nim stream objects":
    check:
        newStringStream("hello\nworld").stream
            .collect == @["hello", "world"]
