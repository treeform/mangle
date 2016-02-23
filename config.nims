task docs, "":
    exec "nim doc --threads:on mangle.nim"
    setCommand "nop"

task build, "":
    exec "nim c --threads:on -d:release mangle.nim"
    setCommand "nop"

task tests, "":
    exec "nim c --threads:on -d:releae -r mangle_test.nim"
    setCommand "nop"

task bench, "":
    exec "nim c --threads:on -d:release -r mangle_bench.nim"
    setCommand "nop"
