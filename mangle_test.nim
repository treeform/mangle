import
    unittest,
    streams,
    future,
    mangle

const helper = @[1, 2, 3]


test "Stream and toSeq":
    check: helper == helper.stream.toSeq


test "Multiple stream ok":
    check: helper == helper.stream.stream.toSeq


test "Real usage":
    check:
        infinity()
            .map(proc(it: auto): auto =
                let x = 2
                it * x)
            .take(4)
            .toSeq == @[0, 2, 4, 6]


test "Example":
    check:
        infinity()
            .map((it) => it * it)
            .filter((it) => it %% 2 == 0)
            .take(715517)
            .reduce((acc: int, it) => acc + it, 0) == 488424787335446984


test "More complex types":
    type Vector = tuple[
        x, y, z: int]

    proc `*`(a, b: Vector): Vector = (a.x * b.x, a.y * b.y, a.z * b.z)

    proc `$`(self: Vector): string =
        $self.x & ":" & $self.y & ":" & $self.z

    let vectors: seq[Vector] = @[
        (1, 1, 1),
        (1, 2, 3),
        (3, 2, 1),
        (4, 5, 6)]

    check:
        vectors.stream
            .each(proc(vec: var Vector) = vec.y = 1)
            .reduce(`*`, (1, 1, 1)) == (12, 1, 18)


test "Sorting":
    check:
        @[3,1,2].stream
            .sort
            .toSeq == @[1,2,3]


test "Nim stream objects":
    check:
        newStringStream("hello\nworld").stream
            .toSeq == @["hello", "world"]
