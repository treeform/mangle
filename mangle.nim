import
    algorithm,
    streams,
    future


type Infinite*[T] = object
    it: iterator: T

type Finite*[T] = object
    it: iterator: T

type Iterable*[T] = Infinite[T] | Finite[T]


template iterate[T](iterable: Iterable[T], body: expr): expr =
    while true:
        var it {.inject.} = iterable.it()
        if finished(iterable.it): break
        body


proc stream*[T](channel: var Channel[T]): Finite[T] =
    ## Creates an iterator from possible sources
    var chptr = channel.addr
    result.it = iterator(): T =
        while chptr[].peek() != -1:
            yield chptr[].recv


proc stream*(iterable: Stream): Finite[string] =
    ## Creates an iterator from possible sources
    var line = ""
    result.it = iterator(): string =
        while iterable.readLine(line):
            yield line


proc stream*[T](iterable: seq[T]): Finite[T] =
    ## Creates an iterator from possible sources
    result.it = iterator(): T =
        for it in iterable:
            yield it


proc stream*[T](iterable: Iterable[T]): Finite[T] =
    ## Creates an iterator from possible sources
    iterable


proc infinity*(start = 0): Infinite[int] =
    ## Returns an iterator starting from `start`
    result.it = iterator: int {.closure.} =
        var idx: int = start
        while true:
            yield idx
            idx.inc


proc collect*[T](iterable: Finite[T]): seq[T] =
    ## Collects iterator into a seq
    result = @[];
    while true:
        var it = iterable.it()
        if finished(iterable.it): break
        result.add it


proc sort*[T](iterable: Finite[T], cmpfn: (T, T) -> int): Finite[T] =
    ## Reads the stream into a seq, sorts it and returns an iterator
    var values: seq[T] = @[];
    iterate iterable:
        values.add it
    algorithm.sort(values, cmpfn)
    result.it = iterator: T {.closure.} =
        for it in values:
            yield it


proc sort*[T](iterable: Finite[T]): Finite[T] =
    ## Reads the stream into a seq, sorts it and returns an iterator
    when iterable is Infinite[T]:
        static: error("One does not simply sort infinity")
    var values: seq[T] = @[];
    iterate iterable:
        values.add it
    algorithm.sort(values, cmp[T])
    result.it = iterator: T {.closure.} =
        for it in values:
            yield it


proc map*[T, G](iterable: Iterable[T], fn: (T) -> G): Finite[G] =
    ## Transforms single valuable in the stream
    result.it = iterator: G {.closure.} =
        iterate iterable:
            yield fn(it)


proc filter*[T](iterable: Iterable[T], val: T): Finite[T] =
    ## Filters elements stream by fn
    result.it = iterator: T {.closure.} =
        iterate iterable:
            if it == val:
                yield it


proc filter*[T](iterable: Iterable[T], fn: (T) -> bool): Finite[T] =
    ## Filters elements stream by fn
    result.it = iterator: T {.closure.} =
        iterate iterable:
            if fn(it):
                yield it


proc reject*[T](iterable: Iterable[T], fn: (T) -> bool): Finite[T] =
    ## Rejects elements in stream by fn
    result.it = iterator: T {.closure.} =
        iterate iterable:
            if not fn(it):
                yield it


proc reject*[T](iterable: Iterable[T], val: T): Finite[T] =
    ## Filters elements stream by fn
    result.it = iterator: T {.closure.} =
        iterate iterable:
            if not it == val:
                yield it


proc reduce*[T, G](iterable: Iterable[T], fn: (G, T) -> G, acc: G): G =
    ## Reduces stream with accumulator
    ## ``acc`` initial accumulator value
    result = acc
    iterate iterable:
        result = fn(result, it)


proc take*[T](iterable: Iterable[T], amount: int): Finite[T] =
    ## Takes ``amount`` of elements from the stream returnin a new iterator
    result.it = iterator: T {.closure.} =
        var value = amount
        iterate iterable:
            if value == 0:
                return
            else:
                dec value
                yield it


proc print*[T](iterable: Iterable[T]): Finite[T] =
    ## Prints all passing values in the stream
    result.it = iterator: T {.closure.} =
        iterate iterable:
            it.echo
            yield it


proc tap*[T](iterable: Iterable[T], fn: (T) -> void): Finite[T] =
    ## Allows to check on the immutable alues in the stream
    result.it = iterator: T {.closure.} =
        iterate iterable:
            fn(it)
            yield it


proc reverse*[T](iterable: Iterable[T]): iterator: T = quit "Not implemented yet"
proc unique*[T](iterable: Iterable[T]): iterator: T = quit "Not implemented yet"
proc head*[T](iterable: Iterable[T]): iterator: T = quit "Not implemented yet"
proc tail*[T](iterable: Iterable[T]): iterator: T = quit "Not implemented yet"
proc concat*[T](iterable: Iterable[T]): iterator: T = quit "Not implemented yet"
proc zipTable*[T](iterable: Iterable[T]): iterator: T = quit "Not implemented yet"
proc groupBy*[T](iterable: Iterable[T]): iterator: T = quit "Not implemented yet"
proc some*[T](iterable: Iterable[T]): iterator: T = quit "Not implemented yet"
proc all*[T](iterable: Iterable[T]): iterator: T = quit "Not implemented yet"
proc zip*[T](iterable: Iterable[T]): iterator: T = quit "Not implemented yet"
