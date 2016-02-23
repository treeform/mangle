import
    sets,
    algorithm,
    streams


type
    Iterable*[T] = object
        it: iterator: T


template iterate[T](iterable: Iterable[T], body: expr): expr =
    while true:
        var it {.inject.} = iterable.it()
        if finished(iterable.it): break
        body


proc stream*[T](channel: var Channel[T]): Iterable[T] {.inline.} =
    ## Creates an iterator from possible sources
    var chptr = channel.addr
    result.it = iterator(): T =
        while chptr[].peek() != -1: yield chptr[].recv


proc stream*(iterable: Stream): Iterable[string] {.inline.} =
    ## Creates an iterator from possible sources
    var line = ""
    result.it = iterator(): string =
        while iterable.readLine(line): yield line


proc stream*[T](generator: proc(): T): Iterable[T] {.inline.} =
    ## Creates an iterator from possible sources
    result.it = iterator(): T =
        while true: yield generator()


proc stream*[T](generator: proc(idx: int): T): Iterable[T] {.inline.} =
    ## Creates an iterator from possible sources
    var idx = 0
    result.it = iterator(): T =
        while true:
            yield generator(idx)
            inc idx


proc stream*[T](iterable: seq[T]): Iterable[T] {.inline.} =
    ## Creates an iterator from possible sources
    result.it = iterator(): T =
        for it in iterable: yield it


proc stream*[T](iterable: Iterable[T]): Iterable[T] {.inline.} =
    ## Creates an iterator from possible sources
    iterable


proc infinity*(start = 0): Iterable[int] {.inline.} =
    ## Returns an iterator starting from `start`
    result.it = iterator: int {.closure.} =
        var idx: int = start
        while true:
            yield idx
            idx.inc


proc collect*[T](iterable: Iterable[T]): seq[T] {.inline.} =
    ## Collects iterator into a seq
    result = @[];
    while true:
        var it = iterable.it()
        if finished(iterable.it): break
        result.add it


proc sort*[T](iterable: Iterable[T], cmpfn: proc(a, b: T): int {.closure.}): Iterable[T] {.inline.} =
    ## Reads the stream into a seq, sorts it and returns an iterator
    var values: seq[T] = @[];
    iterate iterable:
        values.add it
    algorithm.sort(values, cmpfn)
    result.it = iterator: T {.closure.} =
        for it in values: yield it


proc sort*[T](iterable: Iterable[T]): Iterable[T] {.inline.} =
    ## Reads the stream into a seq, sorts it and returns an iterator
    var values: seq[T] = @[];
    iterate iterable:
        values.add it
    algorithm.sort(values, cmp[T])
    result.it = iterator: T {.closure.} =
        for it in values: yield it


# proc map*[T](iterable: Iterable[T], t: typedesc): Iterable[t] {.inline.} =
#     ## Transforms single valuable in the stream
#     result.it = iterator: t {.closure.} =
#         iterate iterable: yield (t.type)it


proc map*[T, G](iterable: Iterable[T], op: proc(a: T): G {.closure.}): Iterable[G] {.inline.} =
    ## Transforms single valuable in the stream
    result.it = iterator: G {.closure.} =
        iterate iterable: yield op(it)


proc filter*[T](iterable: Iterable[T], val: T): Iterable[T] {.inline.} =
    ## Filters elements stream by op
    result.it = iterator: T {.closure.} =
        iterate iterable:
            if it == val: yield it


proc filter*[T](iterable: Iterable[T], op: proc(a: T): bool {.closure.}): Iterable[T] {.inline.} =
    ## Filters elements stream by op
    result.it = iterator: T {.closure.} =
        iterate iterable:
            if op(it): yield it


proc reject*[T](iterable: Iterable[T], op: proc(a: T): bool {.closure.}): Iterable[T] {.inline.} =
    ## Rejects elements in stream by op
    result.it = iterator: T {.closure.} =
        iterate iterable:
            if not op(it): yield it


proc reject*[T](iterable: Iterable[T], val: T): Iterable[T] {.inline.} =
    ## Filters elements stream by op
    result.it = iterator: T {.closure.} =
        iterate iterable:
            if not it == val: yield it


proc reduce*[T, G](iterable: Iterable[T], acc: G, op: proc(acc: G, next: T): G): G {.inline.} =
    ## Reduces stream with accumulator
    ## ``acc`` initial accumulator value
    result = acc
    iterate iterable:
        result = op(result, it)


proc take*[T](iterable: Iterable[T], amount: int): Iterable[T] {.inline.} =
    ## Takes ``amount`` of elements from the stream returnin a new iterator
    var value = amount
    result.it = iterator: T {.closure.} =
        iterate iterable:
            if value == 0: return
            else:
                dec value
                yield it


proc print*[T](iterable: Iterable[T]): Iterable[T] {.inline.} =
    ## Prints all passing values in the stream
    result.it = iterator: T {.closure.} =
        iterate iterable:
            it.echo
            yield it


proc tap*[T](iterable: Iterable[T], op: proc(a: T) {.closure.}): Iterable[T] {.inline.} =
    ## Allows to check on the immutable alues in the stream
    result.it = iterator: T {.closure.} =
        iterate iterable:
            op(it)
            yield it


proc zip*[A, B](a: Iterable[A], b: Iterable[B]): Iterable[(A, B)] {.inline.} =
    result.it = iterator: (A, B) {.closure.} =
        while true:
            let x = (a: a.it(), b: b.it())
            if finished(a.it) or finished(b.it): break
            yield x


proc drop*[T](iterable: Iterable[T], amount: int): Iterable[T] {.inline.} =
    ## Drops ``amount`` from the iterable
    var value = amount
    result.it = iterator: T {.closure.} =
        iterate iterable:
            if value == 0: yield it
            else: dec value


proc reverse*[T](iterable: Iterable[T]): Iterable[T] {.inline.} =
    ## Reverses all in seq
    var values: seq[T] = @[];
    iterate iterable: values.add it
    algorithm.reverse(values)
    result.it = iterator: T {.closure.} =
        for it in values:
            yield it


proc head*[T](iterable: Iterable[T]): T =
    ## Returns the first value of a stream
    return iterable.it()


proc tail*[T](iterable: Iterable[T]): Iterable[T] {.inline.} =
    ## Drops first item from the iterable
    discard iterable.it()
    return iterable


proc all*[T](iterable: Iterable[T], pred: proc(x: T): bool): bool =
    ## Checks that all elements in iterable satisfy predicate
    iterate iterable:
        if not pred(it): return false
    return true


proc some*[T](iterable: Iterable[T], pred: proc(x: T): bool): bool =
    ## Checks that some elements in iterable satisfy predicate
    iterate iterable:
        if pred(it): return true
    return false 

proc concat*[T](a, b: Iterable[T]): Iterable[T] {.inline.} =
    ## Concats two iterables
    ## Nim is unable to capture varargs so this will have to do
    result.it = iterator: T {.closure.} =
        iterate a: yield it
        iterate b: yield it


proc unique*[T](iterable: Iterable[T]): Iterable[T] =
    ## Passes only unique values trough
    ## ``Warning: O(n) more memory needed``
    var uniqvals = initSet[T]()
    result.it = iterator: T {.closure.} =
        iterate iterable:
            if uniqvals.containsOrIncl(it): continue
            else: yield it


# proc zipTable*[T](iterable: Iterable[T]): iterator: T = quit "Not implemented yet"
# proc groupBy*[T](iterable: Iterable[T]): iterator: T = quit "Not implemented yet"
