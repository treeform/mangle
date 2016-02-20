import
    unittest,
    future,
    mangle

const helper = @[1, 2, 3]

test "stream and toSeq":
    check: helper == helper.stream.toSeq

test "multiple stream ok":
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
