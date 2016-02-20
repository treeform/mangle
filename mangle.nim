import
    future


type Iterable*[T] = (iterator: T) | seq[T] | openarray[T]


template iterate[T](iterable: Iterable[T], body: expr): expr =
    while true:
        let it {.inject.} = iterable()
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


proc map*[T, G](iterable: Iterable[T], fn: (T) -> G): iterator: G =
    ## Transforms single valuable in the stream
    return iterator: G {.closure.} =
        iterate iterable:
            yield fn(it)


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


proc tap*[T](iterable: Iterable[T], fn: (T) -> T): iterator: T =
    ## Allows to check on the immutable alues in the stream
    return iterator: T {.closure.} =
        iterate iterable:
            discard fn(it)
            yield it
