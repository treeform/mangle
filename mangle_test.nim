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


test "head":
    check:
        infinity().head() == 0


test "tail":
    check:
        infinity()
            .tail()
            .take(1)
            .head() == 1


test "unique":
    check:
        @[1,1,2,3,2].stream()
            .unique()
            .collect == @[1,2,3]


test "concat":
    check:
        infinity()
            .take(3)
            .concat(infinity().take(3))
            .collect == @[0,1,2,0,1,2]


test "some":
    check:
        infinity()
            .drop(3)
            .take(999)
            .some((x) => x == 666) == true


test "all":
    check:
        infinity()
            .drop(3)
            .take(999)
            .all((x) => x > 2) == true


test "reverse":
    check:
        infinity()
            .take(3)
            .reverse()
            .collect == @[2,1,0]


test "drop":
    check:
        infinity()
            .drop(3)
            .take(3)
            .collect == @[3,4,5]


test "zip":
    check:
        infinity().zip(infinity()
                .map((it) => it * it))
            .take(4)
            .collect == @[
                (0, 0),
                (1, 1),
                (2, 4),
                (3, 9)]


test "Example":
    check:
        infinity()
            .drop(1337)
            .concat(infinity()
                .map((it) => it * 2)
                .take(42))
            .map((it) => it * it)
            .filter((it) => it %% 2 == 0)
            .unique()
            .take(9999)
            .reduce(0, (acc, it) => acc + it) == 1618153795104


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
            .reduce((1, 1, 1), `*`) == (12, 1, 18)


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

