import
    algorithm,
    future


type Iterable*[T] = var (iterator: T) | var seq[T] | var openarray[T]


template iterate[T](iterable: Iterable[T], body: expr): expr =
    while true:
        var it {.inject.} = iterable()
        if finished(iterable): break
        body


proc stream*[T](iterable: Iterable[T]): iterator: T =
    ## Creates an iterator from possible sources
    when type(iterable) is seq[T]:
        result = iterator(): T =
            for it in iterable:
                yield it
    when type(iterable) is iterator: T:
        iterable


proc infinity*(start = 0): iterator: int =
    ## Returns an iterator starting from `start`
    return iterator: int {.closure.} =
        var idx: int = start
        while true:
            yield idx
            idx.inc


proc toSeq*[T](iterable: Iterable[T]): seq[T] =
    ## Collects iterator into a seq
    result = @[];
    iterate iterable:
        result.add it


proc sort*[T](iterable: Iterable[T], cmpfn: (T, T) -> int): iterator: T =
    ## Reads the stream into a seq, sorts it and returns an iterator
    ## TODO: Compile time check for inf stream
    var values: seq[T] = @[];
    iterate iterable:
        values.add it
    algorithm.sort(values, cmpfn)
    return iterator: T {.closure.} =
        for it in values:
            yield it


proc sort*[T](iterable: Iterable[T]): iterator: T =
    ## Reads the stream into a seq, sorts it and returns an iterator
    ## TODO: Compile time check for inf stream
    var values: seq[T] = @[];
    iterate iterable:
        values.add it
    algorithm.sort(values, cmp[T])
    return iterator: T {.closure.} =
        for it in values:
            yield it


proc each*[T](iterable: Iterable[var T], fn: proc(it: var T)): iterator: T =
    ## Allows manipulation of element in the stream
    return iterator: T {.closure.} =
        iterate iterable:
            fn(it)
            yield it


proc map*[T, G](iterable: Iterable[T], fn: (T) -> G): iterator: G =
    ## Transforms single valuable in the stream
    return iterator: G {.closure.} =
        iterate iterable:
            yield fn(it)


proc filter*[T](iterable: Iterable[T], val: T): iterator: T =
    ## Filters elements stream by fn
    return iterator: T {.closure.} =
        iterate iterable:
            if it == val:
                yield it


proc filter*[T](iterable: Iterable[T], fn: (T) -> bool): iterator: T =
    ## Filters elements stream by fn
    return iterator: T {.closure.} =
        iterate iterable:
            if fn(it):
                yield it


proc reject*[T](iterable: Iterable[T], fn: (T) -> bool): iterator: T =
    ## Rejects elements in stream by fn
    return iterator: T {.closure.} =
        iterate iterable:
            if not fn(it):
                yield it


proc reject*[T](iterable: Iterable[T], val: T): iterator: T =
    ## Filters elements stream by fn
    return iterator: T {.closure.} =
        iterate iterable:
            if not it == val:
                yield it


proc reduce*[T, G](iterable: Iterable[T], fn: (G, T) -> G, acc: G): G =
    ## Reduces stream with accumulator
    ## ``acc`` initial accumulator value
    result = acc
    iterate iterable:
        result = fn(result, it)


proc take*[T](iterable: Iterable[T], amount: int): iterator: T =
    ## Takes ``amount`` of elements from the stream returnin a new iterator
    return iterator: T {.closure.} =
        var value = amount
        iterate iterable:
            if value == 0:
                return
            else:
                dec value
                yield it


proc print*[T](iterable: Iterable[T]): iterator: T =
    ## Prints all passing values in the stream
    return iterator: T {.closure.} =
        iterate iterable:
            it.echo
            yield it


proc tap*[T](iterable: Iterable[T], fn: (T) -> void): iterator: T =
    ## Allows to check on the immutable alues in the stream
    return iterator: T {.closure.} =
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
