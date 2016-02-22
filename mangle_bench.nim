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
        .reduce(0, (acc, val) => acc + val)

benchRelative(reduceReal, m):
    var sum = 1
    for v in 0..m:
        sum += v
    doNotOptimizeAway(sum)


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
        .take(99999)
        .collect

benchRelative(mapsMultiple, m):
    discard infinity()
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
        .take(99999)
        .collect

type
    Big = ref BigObj
    BigObj = object
        x: array[512, int]

bench(bigstructControl, m):
    var col = newSeq[BigObj](m)
    var res = newSeq[BigObj]()
    for idx, x in col:
        res.add x

benchRelative(bigstructMangle, m):
    discard newSeq[BigObj](m)
        .stream
        .collect

bench(bigstructRefControl, m):
    var col = newSeq[Big](m)
    var res = newSeq[Big]()
    for idx, x in col:
        res.add x

benchRelative(bigstructRefMangle, m):
    discard newSeq[Big](m)
        .stream
        .collect


runBenchmarks()
