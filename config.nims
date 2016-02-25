task docs, "":
    exec "nim doc --threads:on mangle.nim"

task build, "":
    exec "nim c --threads:on -d:release mangle.nim"

task tests, "":
    exec "nim c --threads:on -d:releae -r mangle_test.nim"
    exec "nim c --threads:on -d:releae -r example.nim"

task bench, "":
    exec "nim c --threads:on -d:release -r mangle_bench.nim"
