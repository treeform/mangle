import
    future


type Iterable*[T] = (iterator: T) | seq[T]


template iterate*[T](iterable: Iterable[T], body: expr): expr =
    while true:
        let it {.inject.} = iterable()
        if finished(iterable): break
        body


proc stream*[T](iterable: Iterable[T]): iterator: T =
    when type(iterable) is seq[T]:
        result = iterator(): T =
            for it in iterable:
                yield it
    when type(iterable) is iterator: T:
        iterable


proc infinity*(start = 0): iterator: int =
    return iterator: int {.closure.} =
        var idx: int = start
        while true:
            yield idx
            idx.inc


proc toSeq*[T](iterable: iterator: T): seq[T] =
    result = @[];
    iterate iterable:
        result.add it


proc map*[T, G](iterable: iterator: T, fn: (T) -> G): iterator: T =
    return iterator: G {.closure.} =
        iterate iterable:
            yield fn(it)


proc filter*[T](iterable: iterator: T, fn: (T) -> bool): iterator: T =
    return iterator: T {.closure.} =
        iterate iterable:
            if fn(it):
                yield it


proc reduce*[T, G](iterable: iterator: T, fn: (G, T) -> G, acc: G): G =
    result = acc
    iterate iterable:
        result = fn(result, it)


proc take*[T](iterable: iterator: T, amount: int): iterator: T =
    return iterator: T {.closure.} =
        var value = amount
        iterate iterable:
            if value == 0:
                return
            else:
                dec value
                yield it


proc print*[T](iterable: iterator: T): iterator: T =
    return iterator: T {.closure.} =
        iterate iterable:
            it.echo
            yield it


proc tap*[T](iterable: iterator: T, fn: (T) -> T): iterator: T =
    return iterator: T {.closure.} =
        iterate iterable:
            discard fn(it)
            yield it
