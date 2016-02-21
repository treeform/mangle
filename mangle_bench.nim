import
    future,
    nimbench.nimbench,
    mangle


bench(basicControl, m):
    var d: seq[int] = @[]
    for v in 0..m:
        d.add(v)
benchRelative(basicMangle, m):
    discard infinity()
        .take(m)
        .toSeq


bench(reduceReal, m):
    var sum = 0
    for v in 0..m:
        sum += v
    doNotOptimizeAway(sum)
bench(reduceControl, m):
    var d: seq[int] = @[]
    for v in 0..m:
        d.add(v)
    var sum = 0
    for v in d:
        sum += v
    doNotOptimizeAway(sum)
benchRelative(reduceMangle, m):
    discard infinity()
        .take(m)
        .reduce((acc: int, val) => acc + val, 0)


bench(mapsOne, m):
    discard infinity()
        .take(m)
        .map((it) => it * 2)
        .toSeq
benchRelative(mapsMultiple, m):
    discard infinity()
        .take(m)
        .map((it) => it * 2)
        .map((it) => it * 2)
        .map((it) => it * 2)
        .map((it) => it * 2)
        .map((it) => it * 2)
        .map((it) => it * 2)
        .map((it) => it * 2)
        .map((it) => it * 2)
        .map((it) => it * 2)
        .toSeq


runBenchmarks()
