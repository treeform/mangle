Mangle [![Build Status](https://travis-ci.org/baabelfish/mangle.svg?branch=master)](https://travis-ci.org/baabelfish/mangle)
======

> to injure severely, disfigure, or mutilate by cutting, slashing, or crushing

Attempt at a streaming lib

# Examples

- Simple playing around

```nim
import
    mangle

infinity()
    .drop(1337)
    .mapIt(it * it)
    .filterIt(it %% 2 == 0)
    .take(9999)
    .concat(infinity()
        .drop(2000)
        .mapIt(it * 2)
        .take(42))
    .unique
    .reduceIt(0, acc + it)
    .echo # 1618153964826
```

- Downloading football and hockey information and concatenating it

```nim
import
    httpclient,
    json,
    mangle,
    strutils


proc getTeamData(api: string): auto =
    api.getContent.parseJson


proc getFootballTeams(): auto =
    proc get(node: JsonNode, key: string): JsonNode = node[key] # This should really be in the json module
    getTeamData("http://api.football-data.org/v1/soccerseasons/351/teams")
        .get("teams")
        .getElems
        .mangle
        .mapIt((
            id: it["code"],
            name: it["shortName"]))


proc getIcehockeyTeams(): auto =
    const api = "http://www.nicetimeonice.com/api/teams"
    api.getTeamData
        .getElems
        .mangle
        .mapIt((
            id: it["teamID"].getStr,
            name: it["name"].getStr,
            seasons: (api & "/" & it["teamID"].getStr & "/seasons")
                .getContent
                .parseJson
                .getElems
                .mangle
                .mapIt(it["seasonID"].getStr)
                .collect
                .join(", ")))


# Make a lazy generator of team names
var idGenerator = infinity()
    .drop(1)
    .mapIt("Teams " & $it)


# Combine football and hockey
zip(getFootballTeams(), getIcehockeyTeams())
    .mapIt((
        id: idGenerator.invoke,
        football: it[0],
        hockey: it[1]))
    .eachIt(it.echo)


# Echoes:
# (id: Teams 1, football: (id: "FCB", name: "Bayern"), hockey: (id: ANA, name: Anaheim Ducks, seasons: 20112012, 20122013, 20132014, 20142015))          
# (id: Teams 2, football: (id: "WOB", name: "Wolfsburg"), hockey: (id: ARI, name: Arizona Coyotes, seasons: 20112012, 20122013, 20132014, 20142015))     
# (id: Teams 3, football: (id: "SGE", name: "Eintr. Frankfurt"), hockey: (id: BOS, name: Boston Bruins, seasons: 20112012, 20122013, 20132014, 20142015))
# ...
```

# Documentation
[Generated nimdoc](https://htmlpreview.github.io/?https://raw.githubusercontent.com/baabelfish/mangle/master/mangle.html)
