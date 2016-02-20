Mangle
======

Attempt at a streaming lib

```nim
import mangle

infinity()
    .map((it) => it * it)
    .filter((it) => it %% 2 == 0)
    .take(715517)
    .reduce((acc: int, it) => acc + it, 0)
    .echo # 488424787335446984
```
