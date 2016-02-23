Mangle [![Build Status](https://travis-ci.org/baabelfish/mangle.svg?branch=master)](https://travis-ci.org/baabelfish/mangle)
======

> to injure severely, disfigure, or mutilate by cutting, slashing, or crushing

Attempt at a streaming lib

```nim
import mangle

infinity()
    .drop(1337)
    .map((it) => it * it)
    .filter((it) => it %% 2 == 0)
    .take(9999)
    .concat(infinity()
        .map((it) => it * 2)
        .take(42))
    .unique()
    .reduce(0, (acc, it) => acc + it)
    .echo # == 1618153795104
```

# Documentation
[Generated nimdoc](https://htmlpreview.github.io/?https://raw.githubusercontent.com/baabelfish/mangle/master/mangle.html)
