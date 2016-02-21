Mangle [![Build Status](https://travis-ci.org/baabelfish/mangle.svg?branch=master)](https://travis-ci.org/baabelfish/mangle)
======

> to injure severely, disfigure, or mutilate by cutting, slashing, or crushing

Attempt at a streaming lib

```nim
import mangle

infinity()
    .map((it) => it * it)
    .filter((it) => it %% 2 == 0)
    .take(715517)
    .reduce(0, (acc, it) => acc + it) == 488424787335446984
```

# Documentation
[Generated nimdoc](https://htmlpreview.github.io/?https://raw.githubusercontent.com/baabelfish/mangle/master/mangle.html)
