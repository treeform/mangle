import
    unittest,
    streams,
    future,
    mangle


test "mangle":
    const helper = @[1, 2, 3]
    check:
        mangle(1..5).collect == @[1,2,3,4,5]
        helper == helper.mangle.collect
        helper == helper.mangle.mangle.collect


test "generate":
    check:
        generate(() => 1)
            .take(3)
            .collect == @[1, 1, 1]

        generate((idx) => idx / 2)
            .map((it) => it.int)
            .take(4)
            .collect == @[0, 0, 1, 1]


test "head":
    check:
        infinity().head == 0


test "tail":
    check:
        infinity()
            .tail
            .take(1)
            .head == 1


test "map":
    check:
        @[1f, 2f, 3f].mangle()
            .map((x) => x * 2)
            .map(int)
            .mapIt(it * 2)
            .filterIt(it != 8)
            .sortIt(cmp(ita, itb))
            .collect == @[4,12]


test "reduce":
    check:
        @[1,1,2,3,2]
            .mangle
            .reduceIt(0, acc + it) == 9


test "unique":
    check:
        @[1,1,2,3,2]
            .mangle
            .unique
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
        infinity()
            .drop(3)
            .take(999)
            .someIt(it == 666) == true


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
            .reverse
            .collect == @[2,1,0]


test "drop":
    check:
        infinity()
            .dropIt(it < 5)
            .take(3)
            .collect == @[5,6,7]

        infinity()
            .drop(3)
            .take(3)
            .collect == @[3,4,5]


test "each":
    var arr = newSeq[int]()
    infinity()
        .mapIt(it * 2)
        .take(3)
        .eachIt(arr.add it)

    check: arr == @[0, 2, 4]


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
            .mapIt(it * it)
            .filterIt(it %% 2 == 0)
            .take(9999)
            .concat(infinity()
                .drop(2000)
                .mapIt(it * 2)
                .take(42))
            .unique
            .reduceIt(0, acc + it) == 1618153964826


test "More complex types":
    type Vector = tuple[x, y, z: int]

    proc `*`(a, b: Vector): Vector = (a.x * b.x, a.y * b.y, a.z * b.z)

    let vectors: seq[Vector] = @[
        (1, 1, 1),
        (1, 2, 3),
        (3, 2, 1),
        (4, 5, 6)]

    check:
        vectors.mangle
            .map((vec) => (vec.x, 1, vec.z))
            .reduce((1, 1, 1), `*`) == (12, 1, 18)


test "sort":
    check:
        @[3,1,2].mangle
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
        channel.mangle
            .take(3) # FIXME 4 not working
            .collect == @[1, 2, 3]


test "Nim mangle objects":
    check:
        newStringStream("hello\nworld").mangle
            .collect == @["hello", "world"]

