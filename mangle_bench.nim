import
    sequtils,
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
        .collect


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


bench(filteringControl, m):
    var col: seq[int] = @[]
    for x in 0..m*2:
        col.add(x)
    discard sequtils.filter(col, (it) => it %% 2 == 0)

benchRelative(filteringMangle, m):
    discard infinity()
        .take(m)
        .filter((it) => it %% 2 == 0)
        .collect


bench(mapsOne, m):
    discard infinity()
        .take(m)
        .map(proc(it: auto): auto =
            var x = it
            x *= 2
            x *= 2
            x *= 2
            x *= 2
            x *= 2
            x *= 2
            x *= 2
            x *= 2
            x *= 2
            x *= 2
            return x)
        .collect

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
        .map((it) => it * 2)
        .collect


runBenchmarks()
